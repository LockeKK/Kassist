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

volatile u32 systick_count;

static void service_systick(void)
{
    if (!systick_count) {
        global_flags.systick = 0;
        return;
    }

    global_flags.systick = 1;

    //SysTick->CTRL &= ~(1 << 1);
    --systick_count;
    //SysTick->CTRL |= (1 << 1);      // Re-enable the system tick interrupt
}

static void check_no_signal(void)
{
    static u16 no_signal_timeout = 0;

    if (global_flags.rc_update_event) {
        global_flags.no_signal = false;
        no_signal_timeout = dev_config.no_signal_timeout;
    }

    if (global_flags.systick) {
        --no_signal_timeout;
        if (no_signal_timeout == 0) {
            global_flags.no_signal = true;
        }
    }
}

void diagnostics_service(void)
{
	if (!global_flags.ready_to_go)
	{
		//led(CONFIG_NOT_VAILD);
	}
	LED_P8x16Str(0, 0, (u8 *)&systick_count);
}
void main(void) 
{
	board_int();
#if 1	
	host_cmd_init();
	security_init();	
	load_all_parameters();	
	init_servo_reader();
	verify_encrypted_uid();
	beep_notify(POWER_ON);
	
	while(1)
	{
		service_systick();
		read_rc_channels();
		host_cmd_process();		
		setup_mode_service();
		input_ch3_handler();
		update_servo_output();
		check_no_signal();
		diagnostics_service();
		notification_service();
	}
#endif	
}

