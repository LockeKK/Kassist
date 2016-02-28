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


typedef enum {
	BEEP_START0 = 0,		
	BEEP_START1,
	BEEP_DASH,
	BEEP_DOT,
	BEEP_BLANK,
	BEEP_END
} BEEP_STATE_T;

#define	DASH_TMO 			(600 / SYSTICK_IN_MS)
#define	DOT_TMO 			(300 / SYSTICK_IN_MS)
#define	BLANK_TMO 			(500 / SYSTICK_IN_MS)

typedef struct {
	u16 enabled	: 1;
	u16 state	: 3;
	u16 sl_order: 1;
	
	u8 dash;
	u8 dot;
	u16 counter;
} BEEP_T;

static BEEP_T beep;

void beep_ctrl(bool on)
{
	//beep.enabled = on;
}

void beep_notify(u8 tick)
{
	//if (!beep.enabled)
		//return;

	beep.sl_order = tick&0x80;
	beep.dash = (u8)(tick>>3);
	beep.dot = (u8)(tick&0x07);
	beep.state = beep.sl_order ? BEEP_START0 : BEEP_START1;
}

void beep_management(void)
{
	//if (!beep.enabled)
		//return;

	switch (beep.state)
	{
		case BEEP_START0:
			if (beep.dash)
			{
				beep.state = BEEP_DASH;
				beep.counter = DASH_TMO;				
				hw_beep_swith(true);
			}
			else if (beep.dot)
			{
				beep.state = BEEP_DOT;
				beep.counter = DOT_TMO;				
				hw_beep_swith(true);
			}
			else				
				beep.state = BEEP_END;
			break;
			
		case BEEP_START1:
			if (beep.dot)
			{
				beep.state = BEEP_DOT;
				beep.counter = DOT_TMO; 			
				hw_beep_swith(true);
			}
			else if (beep.dash)
			{
				beep.state = BEEP_DASH;
				beep.counter = DASH_TMO;				
				hw_beep_swith(true);
			}
			else				
				beep.state = BEEP_END;
			break;

		case BEEP_DASH:
			if (--beep.counter == 0)
			{
				beep.dash--;				
				beep.state = BEEP_BLANK;
				beep.counter = BLANK_TMO; 			
				hw_beep_swith(false);
			}
			break;
		case BEEP_DOT:
			if (--beep.counter == 0)
			{
				beep.dot--;				
				beep.state = BEEP_BLANK;
				beep.counter = BLANK_TMO; 			
				hw_beep_swith(false);
			}
			break;
		case BEEP_BLANK:
			if (--beep.counter == 0)
			{
				beep.state = beep.sl_order ? BEEP_START0 : BEEP_START1;
			}
			break;
		case BEEP_END:
			break;
	}
}

typedef enum {
	LED_START = 0,
	LED_ON,
	LED_OFF,
	LED_BLANK,
	LED_END
} LED_STATE_T;

#define	LED_TMO 				(100 / SYSTICK_IN_MS)
typedef struct {
	u8 enabled : 1;
	u8 state : 3;
	u8 on;
	u8 off;
	u8 cycle;
	u8 blank;
	u16 counter;
} LED_T;

static LED_T led;

void led_ctrl(bool on)
{
	//led.enabled = on;
}

void led_notify(u8 mode)
{
	//if (!led.enabled)
		//return;

	switch (mode)
	{
	case SWITCH_ON:
		led.on = 1;
		led.off = 0;
		led.cycle = 0;
		led.blank = 0;
		led.state = LED_START;
		break;
	case SWITCH_OFF:
		led.on = 0;
		led.off = 1;
		led.cycle = 0;
		led.blank = 0;
		led.state = LED_START;
		break;
	case CONFIG_NOT_READY:
		led.on = 3;
		led.off = 3;
		led.cycle = 3;
		led.blank = 6;
		led.state = LED_START;
		break;
	case POSITION_NOT_READY:
		led.on = 3;
		led.off = 3;
		led.cycle = 2;
		led.blank = 6;
		led.state = LED_START;
		break;
	case READY_TO_GO:
		led.on = 3;
		led.off = 3;
		led.cycle = 1;
		led.blank = 0;
		led.state = LED_START;
		break;
	}

}

void led_management(void)
{
	static u8 cycle;

	//if (!led.enabled)
		//return;

	switch (led.state)
	{
		case LED_START:
			if (led.on)
			{
				led.state = LED_ON;
				led.counter = led.on * LED_TMO;
				cycle = led.cycle;
				hw_led_swith(true);
			}
			else if (led.off)
			{
				led.state = LED_END;
				hw_led_swith(false);
			}
			else
				led.state = LED_END;
			break;

		case LED_ON:
			if (--led.counter == 0)
			{
				if (led.off)
				{
					led.state = LED_OFF;
					led.counter = led.off * LED_TMO;
					hw_led_swith(false);
				}
				else
				{
					led.state = LED_END;
				}
			}
			break;

		case LED_OFF:
			if (--led.counter == 0)
			{
				if (--cycle)
				{
					led.state = LED_ON;
					led.counter = led.on * LED_TMO;
					hw_led_swith(true);
				}
				else
				{
					if (led.blank)
					{
						led.state = LED_BLANK;
						led.counter = led.blank* LED_TMO;
					}
					else
					{
						led.state = LED_START;
					}
				}
			}
			break;

		case LED_BLANK:
			if (--led.counter == 0)
			{
				led.state = LED_START;
			}
			break;

		case LED_END:
			break;
	}
}


void notification_service(void)
{
    if (!global_flags.systick)
	{
		return;
    }
	beep_management();
	led_management();
}
