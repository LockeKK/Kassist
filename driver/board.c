/*
    timer - system timer used to count time
    Copyright (C) 2011 Pavel Semerad

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
#include ".\services\globals.h"


#define HW_RESET_ADDR	(0X8000)


void board_int(void)
{
	//uart_int();
}

void reboot(void)
{
	//WWDG_CR, T6;
}

void delay(u16 ms)
{
	//WWDG_CR, T6;
}

bool get_ch3_state(void)
{
	return 0;
}

u8 get_dip_state(void)
{
	return 0;
}

u8 get_ch3_profile(void)
{
	return 0;
}

u8 beep_notify(u8 beep)
{
	return 0;
}

void led(u8 led)
{

}
