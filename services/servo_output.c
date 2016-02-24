/*
    Copyright (C) 2016 Locke Huang(locke.huang@gmail.com)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "globals.h"
#include "board.h"

static bool user_confirmed;
static u16 servo_counter[CH_MAX];
static u8 servo_active[CH_MAX];

static void enter_setup_mode(u8 dip);
static void start_reversing_setup(void);
static void stop_reversing_setup(void);
static bool if_reversing_setup_done(void);
static void do_reversing_setup(void);
static void start_steel_setup(void);
static void stop_steel_setup(void);
static bool if_steel_setup_done(void);
static void do_steel_setup(void);
static void start_servo_output_setup(SERVO_OUTPUTS_T *sout);
static void stop_servo_output_setup(void);
static bool if_servo_output_setup_done(void);
static void do_servo_output_setup(SERVO_OUTPUTS_T *sout);
static u16 calculate_servo_pulse(s16 normalized);
static u16 calculate_servo_activeness(u8 ch);

/* Notes:
ST reversing setup is for wheel servo, indicator leds;
ST output setup is for wheel servo, indicator leds;
TH reversing setup is for gear, throttle icon UI;
*/
void init_servo_output(void)
{
	u8 i;
	u16 servo_pulse = 1500;
	u8 temp;

	/* Parameters initlization */
	for(i = 0; i < CH_MAX; i++)
	{
		if (servo_outputs[i].mp_setup_done)
		{
			switch (servo_outputs[i].type)
			{
				case SERVO_TYPE_MP:					
					temp = (u8)servo_outputs[i].pos_config.pos_default;
					servo_outputs[i].pos_config.current = temp;
					servo_pulse = servo_outputs[i].position[temp];

					servo_counter[i] = servo_outputs[i].sp.active_tmo;				
					servo_active[i] = true;
					servo_outputs[i].pos_config.mp_update = true;
					break;
					
				case SERVO_TYPE_SWITCH:					
					servo_outputs[i].position[0] = servo_output_endpoint.centre;					
					servo_outputs[i].position[1] = servo_output_endpoint.right;
					servo_outputs[i].pos_config.toggle = 0;
					servo_outputs[i].pos_config.current;
					temp = (u8)servo_outputs[i].pos_config.pos_default;
					servo_outputs[i].pos_config.current = temp;
					servo_pulse = servo_outputs[i].position[temp];
					break;
					
			}
		}
		pwm_update(i, servo_pulse);
	}


}

void update_servo_output(void)
{
	u8 ch;
	u16 servo_pulse;
	POS_CONFIG_T *pos_configs;
	SERVO_OUTPUTS_T *sout;

	if (!global_flags.ready_to_go)
	{
		return;
	}

	for (ch = 0; ch < CH_MAX; ch++)
	{
		sout = &servo_outputs[ch];			
		pos_configs = &servo_outputs[ch].pos_config;

		if (sout->mp_setup_done == false)
			continue;

		if (sout->enabled == false)
			continue;
		
		switch (ch)
		{
			case SERVO_TYPE_MP:
				servo_pulse = calculate_servo_activeness(ch);
				break;
			case SERVO_TYPE_SWITCH:
				servo_pulse = sout->position[pos_configs->current];
				break;
			case SERVO_TYPE_WHEEL:
				servo_pulse = calculate_servo_pulse(rc_channel[ST].normalized);
				break;
			default:
				return;
		}		
		pwm_update(ch, servo_pulse);
	}
}

bool if_under_setup_actions(void)
{
	return (if_reversing_setup_done() ||
			if_steel_setup_done() ||
			if_servo_output_setup_done());
}

void input_user_acknowledge(u8 ch3_clicks)
{
	if (ch3_clicks == 1)
		user_confirmed = true;
	else
		user_confirmed = false;
}

void setup_mode_service(void)
{
	static u8 dip_switch_value = NORMAL_MODE;
	static u32 dip_switch_counter = 0;
	u8 dip;
	
    if (!global_flags.systick) 
	{
		return;
    }

	if (global_flags.host_config)
	{		
		enter_setup_mode(global_flags.host_config);
		return;
	}

	dip = get_dip_state();

	if (dip_switch_value != dip)
	{
		dip_switch_counter = 0;
		dip_switch_value = dip;
	}
	else
	{
		dip_switch_counter++;
	}

	/* dip_switch_counter is extremely large enough */
	if (dip_switch_counter > dev_config.dip_state_timeout)
	{
		enter_setup_mode(dip_switch_value);
	}

}

static void enter_setup_mode(u8 dip)
{
	static u8 last_dip = 0xff;

	if (dip == last_dip)
	{
		goto setup_phase;
	}

	beep_notify(DIP_SWITHED);
	
	/* Users break out during the setup */
	if (if_reversing_setup_done() == false)
	{
		stop_reversing_setup();
		load_system_configs(REVERSING_ST);
		load_system_configs(REVERSING_TH);		
	}
	if (if_steel_setup_done() == false)
	{
		stop_steel_setup();
		load_system_configs(SERVO_ENDPOINTS);		
	}
	if (if_servo_output_setup_done() == false)
	{
		stop_servo_output_setup();
		load_system_configs((u8)(SERVO_OUTPUT_BASE + last_dip));		
	}

	switch (dip)
	{
		case NORMAL_MODE:
			break;
	
		case REVERSING_SETUP:
			start_reversing_setup();
			break;
		case STEEL_SETUP:
			start_steel_setup();
			break;			
		case PWM0_SETUP:
		case PWM1_SETUP:
		case PWM2_SETUP:
		case PWM3_SETUP:
			start_servo_output_setup(&servo_outputs[dip]);
			break;
			
		default:
			break;
	}

setup_phase:
	last_dip = dip;
	do_reversing_setup();
	do_steel_setup();
	do_servo_output_setup(&servo_outputs[dip]);
}


static void start_reversing_setup(void)
{
	global_flags.reversing_setup = REVERSING_SETUP_STEERING |
								   REVERSING_SETUP_THROTTLE;
	user_confirmed = false;
	
	update_rtr_status(REVERSING_ST, DEFAULT, true);		
	update_rtr_status(REVERSING_TH, DEFAULT, true);
}

static void stop_reversing_setup(void)
{
	global_flags.reversing_setup = REVERSING_SETUP_OFF;	
	beep_notify(TASK_NG);
	user_confirmed = false;
}

static bool if_reversing_setup_done(void)
{
	return global_flags.reversing_setup == REVERSING_SETUP_OFF;
}

static void do_reversing_setup(void)
{
    if (!global_flags.rc_update_event) {
        return;
    }

    if (global_flags.reversing_setup == REVERSING_SETUP_OFF) {
        return;
    }

    if (global_flags.reversing_setup & REVERSING_SETUP_STEERING) {
        if (rc_channel[ST].absolute > 50) {
            if (rc_channel[ST].normalized > 0) {
                rc_channel[ST].reversed = (u8)!!rc_channel[ST].reversed;

            }
            global_flags.reversing_setup -= REVERSING_SETUP_STEERING;
        }
    }

    if (global_flags.reversing_setup & REVERSING_SETUP_THROTTLE) {
        if (rc_channel[TH].absolute > 20) {
            if (rc_channel[TH].normalized < 0) {
                rc_channel[TH].reversed = (u8)!!rc_channel[TH].reversed;
            }
            global_flags.reversing_setup -= REVERSING_SETUP_THROTTLE;
        }
    }

    if (global_flags.reversing_setup == REVERSING_SETUP_OFF) {
        save_system_configs(REVERSING_ST);
        save_system_configs(REVERSING_TH);
		update_rtr_status(REVERSING_ST, CONFIGED, true);		
		update_rtr_status(REVERSING_TH, CONFIGED, true);
		beep_notify(TASK_DONE);
		if (global_flags.host_config)
		{
			global_flags.host_config = 0;
		}
    }
}

static void start_steel_setup(void)
{
	/* Set as default firstly */
	servo_output_endpoint.left = 900;
	servo_output_endpoint.centre = 1500;
	servo_output_endpoint.right = 2100;
    global_flags.steel_setup = STEEL_SETUP_LEFT;	
	user_confirmed = false;
	update_rtr_status(SERVO_ENDPOINTS, DEFAULT, true);
}

static void stop_steel_setup(void)
{
    global_flags.steel_setup = STEEL_SETUP_OFF;	
	beep_notify(TASK_NG);
	user_confirmed = false;
}

static bool if_steel_setup_done(void)
{
    return global_flags.steel_setup == STEEL_SETUP_OFF;	
}

static void do_steel_setup(void)
{
	u16 servo_pulse;	
	static SERVO_ENDPOINTS_T steel_setup_ep;

    if (global_flags.steel_setup == STEEL_SETUP_OFF) 
    {
		return;
	}
	
    servo_pulse = calculate_servo_pulse(rc_channel[ST].normalized);

	if (!user_confirmed)
	{
		return;
	}

	switch (global_flags.steel_setup)
	{
		case STEEL_SETUP_LEFT:
			steel_setup_ep.left = servo_pulse;
			global_flags.steel_setup = STEEL_SETUP_CENTRE;
			break;
	
		case STEEL_SETUP_CENTRE:
			steel_setup_ep.centre = servo_pulse;
			global_flags.steel_setup = STEEL_SETUP_RIGHT;
			break;
	
		case STEEL_SETUP_RIGHT:
			steel_setup_ep.right = servo_pulse;
	
			servo_output_endpoint.right = steel_setup_ep.right;
			servo_output_endpoint.centre = steel_setup_ep.centre;
			servo_output_endpoint.left = steel_setup_ep.left;
			save_system_configs(SERVO_ENDPOINTS);
			update_rtr_status(SERVO_ENDPOINTS, CONFIGED, true);
			global_flags.steel_setup = STEEL_SETUP_OFF;			
			if (global_flags.host_config)
			{
				global_flags.host_config = 0;
			}
			break;
	
		default:
			break;
	}
	
	user_confirmed = false;
}

static void start_servo_output_setup(SERVO_OUTPUTS_T *sout)
{
	u8 target;

	if (sout->enabled == false || global_flags.ready_for_mp == false)
		return;
	
	target = (u8)(SERVO_POSITION_BASE + sout->channel);
	
	/* wheel/switch will use steel parameters */
	if(sout->type == SERVO_TYPE_WHEEL || sout->type == SERVO_TYPE_SWITCH)
	{
		beep_notify(TASK_DONE);
		sout->mp_setup_done = true;		
		update_attr_status(target, MANDATORY, true);

		return;
	}
	
	sout->mp_setup_done = false;
    sout->index = 0;
    global_flags.servo_output_setup = SERVO_OUTPUT_SETUP_START;	
	user_confirmed = false;	
	update_rtr_status(target, DEFAULT, true);
}

static void stop_servo_output_setup(void)
{
    global_flags.servo_output_setup = SERVO_OUTPUT_SETUP_OFF;	
	beep_notify(TASK_NG);
	user_confirmed = false;
}

static bool if_servo_output_setup_done(void)
{
    return global_flags.servo_output_setup == SERVO_OUTPUT_SETUP_OFF;	
}

static void do_servo_output_setup(SERVO_OUTPUTS_T *sout)
{
	u16 servo_pulse;
	u8 chn, target;

    if (global_flags.servo_output_setup == SERVO_OUTPUT_SETUP_OFF) 
    {
		return;
	}
	
    servo_pulse = calculate_servo_pulse(rc_channel[ST].normalized);
	pwm_update(sout->channel, servo_pulse);

	if (!user_confirmed)
	{
		return;
	}

	if (global_flags.servo_output_setup == SERVO_OUTPUT_SETUP_START)
	{
		sout->position[sout->index++] = servo_pulse;
		/*TODO: need user pre-define max_nb*/
		if (sout->index == sout->max_nb)
		{
			sout->mp_setup_done = true;
			global_flags.servo_output_setup = SERVO_OUTPUT_SETUP_OFF;
			chn = sout->channel;
			target = (u8)(SERVO_POSITION_BASE + chn);
			save_system_configs(target);
			update_rtr_status(target, CONFIGED, true);
			beep_notify(TASK_DONE);
		}
	}
	
	user_confirmed = false;
}

static u16 calculate_servo_pulse(s16 normalized)
{
	u16 servo_pulse;

    if (normalized < 0) {
        servo_pulse = servo_output_endpoint.centre -
            (((servo_output_endpoint.centre - servo_output_endpoint.left) *
                (-normalized)) / 100);
    }
    else {
        servo_pulse = servo_output_endpoint.centre +
            (((servo_output_endpoint.right - servo_output_endpoint.centre) *
                (normalized)) / 100);
    }

	return servo_pulse;
}

static u16 calculate_servo_activeness(u8 ch)
{
	u16 servo_pulse;
	POS_CONFIG_T *pos_configs;
	SERVO_OUTPUTS_T *sout;

	sout = &servo_outputs[ch];			
	pos_configs = &servo_outputs[ch].pos_config;
	servo_pulse = sout->position[pos_configs->current];

	if (sout->type != SERVO_TYPE_MP)
	{
		return servo_pulse;
	}

	if (pos_configs->mp_update)
	{
		pos_configs->mp_update = false;
		servo_counter[ch] = sout->sp.active_tmo;				
		servo_active[ch] = true;		
	}
	
	if (sout->sp.idle_tmo && global_flags.systick) 
	{
		if (--servo_counter[ch] == 0)
		{
			if (servo_active[ch]) 
			{
				servo_counter[ch] = sout->sp.idle_tmo;
				servo_active[ch] = false;				
				servo_pulse = 0;
			}
			else
			{
				servo_counter[ch] = sout->sp.active_tmo;				
				servo_active[ch] = true;
			}
		}
	}

	return servo_pulse;
}

void servo_output_manually(u8 channel, s16 normalized)
{
	u16 servo_pulse;

	servo_pulse = calculate_servo_pulse(normalized);
	pwm_update(channel, servo_pulse);
}

