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
#include <string.h>


static struct {
    u16 last_state : 1;
    u16 transitioned : 1;
    u16 initialized : 1;
} ch3_flags;

static u8 ch3_clicks;
static u16 ch3_click_counter;

static u8 ch3_clicks_decode(u8 ch3_clicks);
static void input_process_thread(u8 ch3_clicks);
static void process_ch3_click_timeout(void);
static void add_click(void);


void input_ch3_handler(void)
{
	if (global_flags.host_click)
		goto process;

    if (global_flags.systick) {
        if (ch3_click_counter) {
            --ch3_click_counter;
        }
    }

    if (dev_config.flags.ch3_is_local_switch) {
        rc_channel[CH3].normalized = get_ch3_state() ? -100 : 100;
    }

    if (global_flags.rc_is_initializing) {
        ch3_flags.initialized = false;
    }

    if (!global_flags.rc_update_event) {
        return;
    }

    if (!ch3_flags.initialized) {
        ch3_flags.initialized = true;
        ch3_flags.last_state = (rc_channel[CH3].normalized > 0) ? true : false;
        return;
    }

    if (dev_config.flags.ch3_is_momentary) {
        if ((rc_channel[CH3].normalized > 0)  !=  (ch3_flags.last_state)) {

            // Did we register this transition already?
            if (!ch3_flags.transitioned) {
                // No: Register transition and add click
                ch3_flags.transitioned = true;
                add_click();
            }
        }
        else {
            ch3_flags.transitioned = false;
        }
    }
    else {
        if ((rc_channel[CH3].normalized > 0)  !=  (ch3_flags.last_state)) {
            ch3_flags.last_state = (rc_channel[CH3].normalized > 0);
            add_click();
        }
    }
	
process:
    process_ch3_click_timeout();
}

void process_simulate_ch3_clicks(u8 clicks)
{
	ch3_clicks = clicks;
	ch3_click_counter = 0;
}
static void input_process_thread(u8 clicks)
{
	u8 action = NO_ACTION;
	u8 ch;
	u8 i, j, next, current;
	bool done;
	POS_CONFIG_T *pos_configs;
	SERVO_OUTPUTS_T *sout;
	EVENT_ACTIONS_T *ea;

	if (!global_flags.ready_to_go)
	{
		return;
	}
	
	ea = ch3_actions[global_flags.ch3_action_profile];
	clicks = ch3_clicks_decode(clicks);
	ch = ea[clicks].channel;
	action = ea[clicks].actions;
	pos_configs = &servo_outputs[ch].pos_config;
	sout = &servo_outputs[ch];
	current = (u8)pos_configs->current;
	beep_notify(ea[clicks].beep);
	
	switch (action)
	{
		case POS_INC:
			if (pos_configs->cycle_en)
			{
				next = (u8)pos_configs->current;
				/*jump the postions of exclude */				
				for (i = 0; i < sout->max_nb; i++)
				{
					done = true;
					next = (u8)((next + 1) % sout->max_nb);
					for (j = 0; j < MAX_EXMP; j++)
					{
						if (pos_configs->exclude[j] != NA &&
							pos_configs->exclude[j] == next)
						{
							done = false;
							break;
						}
					}
					if (done)
					{
						pos_configs->current = next;
						break;
					}
				}
			}
			else
			{
				if (pos_configs->current + 1 < sout->max_nb)
				{
					pos_configs->current += 1;
				}
			}
			break;

		case POS_DEC:			
			if (pos_configs->cycle_en)
			{
				next = (u8)pos_configs->current;
				/*jump the postions of exclude */				
				for (i = 0; i < sout->max_nb; i++)
				{
					done = true;
					next = (u8)((next + sout->max_nb - 1) %
							sout->max_nb);
					for (j = 0; j < MAX_EXMP; j++)
					{
						if (pos_configs->exclude[j] != NA &&
							pos_configs->exclude[j] == next)
						{
							done = false;
							break;
						}
					}
					if (done)
					{
						pos_configs->current = next;
						break;
					}
				}
			}
			else
			{
				if (pos_configs->current > 0)
				{
					pos_configs->current -= 1;
				}
			}
			break;

		case POS_DEFAULT:
			if(pos_configs->default_en)
				pos_configs->current = pos_configs->default_pos;
			break;

		case POS_SPEC:			
			if(pos_configs->specific_en)
				pos_configs->current = pos_configs->specific_pos;
			break;						

		case CH3_TOGGLE:
			toggle_it(sout[ch].pos_config.toggle);
			pos_configs->current = sout[ch].pos_config.toggle;
			break;

		case CH3_PRIFILE_TOGGLE:
			global_flags.ch3_action_profile = 
					(global_flags.ch3_action_profile + 1) %
					 MAX_CH3_PROFILE;

		case AG_PRIFILE_TOGGLE:
			global_flags.ag_action_profile = 
					(global_flags.ag_action_profile + 1) %
					 MAX_AG_PROFILE;

		default:
			break;
	}

	if (pos_configs->current != current)
		pos_configs->mp_update = true;

	return;
}

static u8 ch3_clicks_decode(u8 clicks)
{
	u8 actions;
	static u16 ch3_turnover_timeout;	
	static bool ch3_click_is_turnover;
	
	clicks -= 1;

	if (ch3_click_is_turnover == false)
	{
		if (clicks < CH3_TURNOVER)
		{
			actions = clicks;
		} 
		else if (clicks == CH3_TURNOVER)
		{
			ch3_click_is_turnover = true;
			actions = CH3_TURNOVER;
			ch3_turnover_timeout = dev_config.ch3_turnover_timeout;
		}
		else
		{
			actions = NOT_VAILD;
		}

	}
	else
	{
		if (clicks < CH3_TURNOVER)
		{
			actions = (u8)(clicks + CH3_TO_OFFSET);
		} 
		else if (clicks == CH3_TURNOVER)
		{
			ch3_click_is_turnover = false;
			actions = CH3_TO_OFF;
		}
		else
		{
			actions = NOT_VAILD;
		}
	}

	if(ch3_click_is_turnover && dev_config.ch3_turnover_timeout)
	{
		--ch3_turnover_timeout;
        if (ch3_turnover_timeout == 0) {
            ch3_click_is_turnover = false;
        }
	}

	return actions;
}

static void process_ch3_click_timeout(void)
{
	bool ret;
	
    if (ch3_clicks == 0) {          // Any clicks pending?
        return;                     // No: nothing to do
    }

    if (ch3_click_counter != 0) {   // Double-click timer expired?
        return;                     // No: wait for more buttons
    }

	ret = if_under_setup_actions();
	
	if (ret)
		input_user_acknowledge(ch3_clicks);
	else
    	input_process_thread(ch3_clicks);

    ch3_clicks = 0;
}

static void add_click(void)
{
    ++ch3_clicks;
    ch3_click_counter = dev_config.ch3_multi_click_timeout;
}



