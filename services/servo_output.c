/******************************************************************************
******************************************************************************/
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
	u16 servo_pulse = 0;
	u8 temp;
#if 0	
	LPC_SCT->CONFIG |= (1 << 18);			// Auto-limit on counter H
	LPC_SCT->CTRL_H |= (1 << 3) |			// Clear the counter H
					   (11 << 5);			// PRE_H[12:5] = 12-1 (SCTimer H clock 1 MHz)
	LPC_SCT->MATCHREL[0].H = 20000 - 1; 	// 20 ms per overflow (50 Hz)
	LPC_SCT->MATCHREL[4].H = 1500;			// Servo pulse 1.5 ms intially

	LPC_SCT->EVENT[0].STATE = 0xFFFF;		// Event 0 happens in all states
	LPC_SCT->EVENT[0].CTRL = (0 << 0) | 	// Match register 0
							 (1 << 4) | 	// Select H counter
							 (0x1 << 12);	// Match condition only

	LPC_SCT->EVENT[4].STATE = 0xFFFF;		// Event 4 happens in all states
	LPC_SCT->EVENT[4].CTRL = (4 << 0) | 	// Match register 4
							 (1 << 4) | 	// Select H counter
							 (0x1 << 12);	// Match condition only

	// We've chosen CTOUT_1 because CTOUT_0 resides in PINASSIGN6, which
	// changing may affect CTIN_1..3 that we need.
	// CTOUT_1 is in PINASSIGN7, where no other function is needed for our
	// application.
	LPC_SCT->OUT[1].SET = (1 << 0); 	   // Event 0 will set CTOUT_1
	LPC_SCT->OUT[1].CLR = (1 << 4); 	   // Event 4 will clear CTOUT_1

	// CTOUT_1 = PIO0_12
	LPC_SWM->PINASSIGN7 = 0xffffff0c;

	LPC_SCT->CTRL_H &= ~(1 << 2);		   // Start the SCTimer H
#endif
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
		//pwm_update(i, servo_pulse);
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
		//pwm_update(ch, servo_pulse);
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
            // 50% or more steering input: terminate the steering reversing setup.
            // We were expecting the user to turn 'left', which should give us a
            // negative reading if the 'reversed' flag is correct. If we are
            // getting a positive reading we therefore have to reverse the
            // steering rc_channel.
            if (rc_channel[ST].normalized > 0) {
                rc_channel[ST].reversed = (u8)!!rc_channel[ST].reversed;

            }
            global_flags.reversing_setup -= REVERSING_SETUP_STEERING;
        }
    }

    if (global_flags.reversing_setup & REVERSING_SETUP_THROTTLE) {
        if (rc_channel[TH].absolute > 20) {
            // 20% or more throttle input: terminate the throttle reversing setup.
            // We were expecting the user to push the throttle 'forward', which
            // should give a positive reading if the 'reversed' flag is correct.
            // If we are reading a negative value we therefore have to reverse
            // the throttle rc_channel.
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
	//pwm_update(sout->channel, servo_pulse);

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

static void servo_output_manually(u8 channel, s16 normalized)
{
	u16 servo_pulse;

	servo_pulse = calculate_servo_pulse(normalized);
	//pwm_update(channel, servo_pulse);
}

