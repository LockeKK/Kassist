#include "globals.h"
#include "board.h"


typedef enum {
	BEEP_START0,		
	BEEP_START1,
	BEEP_DASH,
	BEEP_DOT,
	BEEP_BLANK,
	BEEP_END
} BEEP_STATE_T;

#define	DASH_TMO 			(600  / SYSTICK_IN_MS)
#define	DOT_TMO 			(300  / SYSTICK_IN_MS)
#define	BLANK_TMO 			(500  / SYSTICK_IN_MS)

typedef struct {
	u16 enabled	: 1;
	u16 state	: 4;
	u16 ls_order	: 1;
	u16 dash	: 3;
	u16 dot		: 3;
	u16 counter;
} BEEP_T;

BEEP_T beep;

void beep_ctrl(bool on)
{
	beep.enabled = on;
}


void beep_notify(u8 tick)
{
	if (!beep.enabled)
		return;

	beep.ls_order = tick&0x80;
	beep.dash = tick>>3;
	beep.dot = tick&0x07;
	beep.state = beep.ls_order ? BEEP_START0 : BEEP_START1;
	
}

void beep_management(void)
{
	if (!beep.enabled)
		return;

    if (!global_flags.systick)
	{
		return;
    }

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
				beep.state = beep.ls_order ? BEEP_START0 : BEEP_START1;
			}
			break;
		case BEEP_END:
			break;
	}
}

#if 0
typedef enum {
    TASK_DONE = 0,
    TASK_NG = 0x01,
	UNCONFIGED,
	READY_TO_GO,
	READY_FOR_MP,
	



	
} LED_BLIND_T;

#endif





