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

#define FIVE_MINUTES			(u8)(3000 / SYSTICK_IN_MS)
#define VBAT_SAMPLING			(u8)(5000 / SYSTICK_IN_MS)
#define VBAT_SAMPLES			(u8)(5)

NEAR static u8 five_minutes_tick;
NEAR static u8 vbat_reader_timer;
NEAR volatile static u16 vbat_buffer[VBAT_SAMPLES];

void battery_guard_init(void)
{


}

void get_vbat_samples(u16 vbat)
{
	NEAR static u8 index;

	vbat_buffer[index++ % VBAT_SAMPLES] = vbat;

}

void battery_guard_service(void)
{
	
    if ((!dev_config.flags.battery_guard_en) ||
		(!global_flags.systick) ||
		(global_flags.rc_is_initializing))
	{
		return;
    }

	if (vbat_reader_timer)
	{

	}

	//adc_onoff();
	global_flags.vbat = 0;

}


