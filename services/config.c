#include "globals.h"
#include "board.h"
#include <string.h>

static void fresh_config_items(void);

const u8 *copy_right = "locke.huang@gmail.com";
const PRODUCT_INFO_T product_info = {
/* protype */	1,
/* hw_ver */	1,
/* sw_ver */	1,
};

#ifdef COSMIC
@near EVENT_ACTIONS_T ch3_actions[MAX_CH3_PROFILE][CH3_CLICKS_MAX] = {
#else
EVENT_ACTIONS_T ch3_actions[MAX_CH3_PROFILE][CH3_CLICKS_MAX] = {
#endif
	{
		{CH3_SINGLE, 		POS_INC,			CH_PWM0,	BEEP(0, 0, 1)	},
		{CH3_DOUBLE, 		POS_DEC,			CH_PWM0,	BEEP(0, 0, 2)	},
		{CH3_TRIPLE, 		POS_INC,			CH_PWM1,	BEEP(0, 0, 3)	},
		{CH3_TURNOVER, 		NO_ACTION,			CH_NONE,	BEEP(0, 1, 0)	},
		{CH3_TO_SINGLE,		CH3_TOGGLE,			CH_PWM2,	BEEP(0, 1, 1)	},
		{CH3_TO_DOUBLE,		CH3_TOGGLE,			CH_PWM3,	BEEP(0, 1, 2)	},
		{CH3_TO_TRIPLE,		AUTOGEAR_TOGGLE,	CH_EVENT0,	BEEP(0, 1, 3)	},	
		{CH3_TO_OFF,		NO_ACTION,			CH_NONE,	BEEP(0, 1, 1)	}
	},

	{
		{CH3_SINGLE, 		POS_INC,			CH_PWM0,	BEEP(0, 0, 1)	},
		{CH3_DOUBLE, 		POS_DEC,			CH_PWM0,	BEEP(0, 0, 2)	},
		{CH3_TRIPLE, 		POS_INC,			CH_PWM1,	BEEP(0, 0, 3)	},
		{CH3_TURNOVER, 		NO_ACTION,			CH_NONE,	BEEP(0, 1, 0)	},
		{CH3_TO_SINGLE,		CH3_TOGGLE,			CH_PWM2,	BEEP(0, 1, 1)	},
		{CH3_TO_DOUBLE,		CH3_TOGGLE,			CH_PWM3,	BEEP(0, 1, 2)	},
		{CH3_TO_TRIPLE,		AUTOGEAR_TOGGLE,	CH_EVENT0,	BEEP(0, 1, 3)	},	
		{CH3_TO_OFF,		NO_ACTION,			CH_NONE,	BEEP(0, 1, 1)	}
	}
};
#ifdef COSMIC
@near EVENT_ACTIONS_T th_actions[MAX_AG_PROFILE][TH_KEY_MAX];// = {
#else
EVENT_ACTIONS_T th_actions[MAX_AG_PROFILE][TH_KEY_MAX];// = {
#endif
	//{TH_KEY0, POS_INC},
	//{TH_KEY1, POS_DEC},
	//{TH_KEY2, NO_ACTION},
	//{TH_KEY3, NO_ACTION}
//};
#ifdef COSMIC
@near SERVO_OUTPUTS_T servo_outputs[CH_MAX] = {
#else
SERVO_OUTPUTS_T servo_outputs[CH_MAX] = {
#endif
	{CH_PWM0, false, 4, 0, SERVO_TYPE_MP, 		{1500, 1800, 2000}, false, 
		{1, 1, 0, 0, 0, 0, 0, 0, {0}}, 	{1000, 9000}
	},

	{CH_PWM1,  false, 2, 0, SERVO_TYPE_MP, 		{1500, 1800}, false, 
		{1, 1, 0, 0, 0, 0, 0, 0, {NA}}, {1000, 0	}
	},

	{CH_PWM2,  false, 0, 0, SERVO_TYPE_SWITCH, 	{1500}, false, 
		{0, 0, 0, 0, 0, 0, 0, 0, {NA}}, {0, 0}
	},

	{CH_PWM3,  false, 0, 0, SERVO_TYPE_WHEEL, 	{1500}, false, 
		{0, 0, 0, 0, 0, 0, 0, 0, {NA}},	{0, 0}
	}
};

#ifdef COSMIC
@near RC_CHANNEL_T rc_channel[RC_MAX] = {
#else
RC_CHANNEL_T rc_channel[RC_MAX] = {
#endif
    {0, 0, 0, false, {1250, 1500, 1450}},
	{0, 0, 0, false, {1250, 1500, 1450}},
    {0, 0, 0, false, {1250, 1500, 1450}}
};

/*saved in eeprom*/
#ifdef COSMIC
@near DEVICE_CONFIG_T dev_config = {
#else
DEVICE_CONFIG_T dev_config = {
#endif
/* flags */ 	{
/* ch3_is_local_switch */		false,
/* ch3_is_momentary */			false,
/* turnover_tmo_en */			true,
/* action_beep_en */			true,
    			},
/* startup_time */ 				(2000 / SYSTICK_IN_MS),
/* no_signal_timeout */ 		(500  / SYSTICK_IN_MS),
/* dip_state_change_timeout */	(5000 / SYSTICK_IN_MS),
/* ch3_turnover_timeout */		(2000 / SYSTICK_IN_MS),
/* ch3_multi_click_timeout */	(300  / SYSTICK_IN_MS),
/* host_disconnect_timeout */	(15000),
/* servo_pulse_min */			(600),
/* servo_pulse_max */			(2500),
/* initial_endpoint_delta */	(250),
};

#ifdef COSMIC
@near SERVO_ENDPOINTS_T servo_output_endpoint;
#else
SERVO_ENDPOINTS_T servo_output_endpoint;
#endif
/* 'D'-> Done, 'I'-> Default, 'N' -> Ingore */
#ifdef COSMIC
@near static CONFIG_CHECK_T config_check[] ={
#else
static CONFIG_CHECK_T config_check[] ={
#endif
/*
ready_rtr_mp: all mandatory items are configed except positions
all_config_done: all mandatory items are configed
if attr==mandatory, state should be CONFIGED.
if attr==conditional, attr depends on related items.
*/
{	PRODUCT_INFO,		IGNORE,			IGNORE		},
{	CONFIG_CHECK,		IGNORE, 		IGNORE		},
{	DEVICE_CONFIG,		MANDATORY,		DEFAULT		},
{	CH3_ACTIONS,		MANDATORY,		DEFAULT		},
{	TH_ACTIONS,			MANDATORY,		DEFAULT		},
{	SERVO_OUTPUT0,		MANDATORY,		DEFAULT		}, /* user must specfic enable or not*/
{	SERVO_OUTPUT1,		MANDATORY,		DEFAULT		},
{	SERVO_OUTPUT2,		MANDATORY,		DEFAULT		},
{	SERVO_OUTPUT3,		MANDATORY,		DEFAULT		},
{	SERVO_ENDPOINTS,	MANDATORY,		DEFAULT 	},
{	REVERSING_ST,		MANDATORY,		DEFAULT 	},
{	REVERSING_TH,		MANDATORY,		DEFAULT 	},
{	SERVO_POSITION0,	CONDITIONAL,	DEFAULT 	}, /* depends on channel enabled */
{	SERVO_POSITION1,	CONDITIONAL,	DEFAULT 	},
{	SERVO_POSITION2,	CONDITIONAL,	DEFAULT 	},
{	SERVO_POSITION3,	CONDITIONAL,	DEFAULT 	}
};

static const SYS_INFO_T sys_info[] = {
{	
	PRODUCT_INFO,	'R',			sizeof(product_info),
	((void *)(0)), 					((void *)(0)) 	
},	
{
	CONFIG_CHECK,	'R',			sizeof(config_check),
	(void *)EEPROM_CONFIG_CHECK, 	(void *)(&config_check), 
},
{
	DEVICE_CONFIG,	'R'|'W', 		sizeof(dev_config),
	(void *)EEPROM_DEV_CONFIG, 		(void *)(&dev_config)
},
{
	CH3_ACTIONS,	'R'|'W', 		sizeof(ch3_actions),
	(void *)EEPROM_CH3_ACTIONS,		(void *)(ch3_actions)
},
{
	TH_ACTIONS, 	'R'|'W',		sizeof(th_actions),
	(void *)EEPROM_TH_ACTIONS, 		(void *)(th_actions)
},
{
	SERVO_OUTPUT0,	'R'|'W',		sizeof(&servo_outputs[CH_PWM0]),
	(void *)EEPROM_SERVO_OUTPUT0,	(void *)(servo_outputs + CH_PWM0)
},
{
	SERVO_OUTPUT1,	'R'|'W',		sizeof(&servo_outputs[CH_PWM1]),
	(void *)EEPROM_SERVO_OUTPUT1,	(void *)(servo_outputs + CH_PWM1)
},
{
	SERVO_OUTPUT2,	'R'|'W',		sizeof(&servo_outputs[CH_PWM2]),
	(void *)EEPROM_SERVO_OUTPUT2,	(void *)(servo_outputs + CH_PWM2)
},
{
	SERVO_OUTPUT3,	'R'|'W',		sizeof(&servo_outputs[CH_PWM3]),
	(void *)EEPROM_SERVO_OUTPUT3,	(void *)(servo_outputs + CH_PWM3)
},
{
	SERVO_ENDPOINTS,0,				sizeof(servo_output_endpoint),
	(void *)EEPROM_SERVO_ENDPOINTS,	(void *)(&servo_output_endpoint)
},
{
	REVERSING_ST,	0,				sizeof(rc_channel[ST].reversed),
	(void *)EEPROM_REVERSING_ST, 	(void *)(&rc_channel[ST].reversed)
},
{
	REVERSING_TH,	0,				sizeof(rc_channel[TH].reversed),
	(void *)EEPROM_REVERSING_TH,	(void *)(&rc_channel[TH].reversed)
}
};

GLOBAL_FLAGS_T global_flags = {
0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, sys_info
};

void update_rtr_status(u8 index, u8 tag, bool save)
{
	config_check[index].state = tag;
	fresh_config_items();
	if (save)	
		save_system_configs(CONFIG_CHECK);
}


void update_attr_status(u8 index, u8 tag, bool save)
{
	config_check[index].attr = tag;
	fresh_config_items();
	if (save)	
		save_system_configs(CONFIG_CHECK);
}

void load_system_configs(u8 index)
{
	SYS_INFO_T *p;

	if (index >= VAILD_SYS_INFO_MAX)
		return;

	if (index == PRODUCT_INFO)
		return;

	p = &sys_info[index];
	hw_storage_read(p->ram, p->mem, p->size);	
}

void save_system_configs(u8 index)
{
	SYS_INFO_T *p;

	if (index >= VAILD_SYS_INFO_MAX)
		return;

	if (index == PRODUCT_INFO)
		return;
	
	p = &sys_info[index];
	hw_storage_write(p->ram, p->mem, p->size);	
}

void load_all_parameters(void)
{
	u8 i;

	load_system_configs(CONFIG_CHECK);

	for (i = DEVICE_CONFIG; i < VAILD_SYS_INFO_MAX; i++)
	{
		if (config_check[i].state == CONFIGED)
		{
			load_system_configs(i);
		}
	}
	fresh_config_items();
}

static void fresh_config_items(void)
{
	u8 i;
	bool ready_to_go = true;
	bool ready_for_mp = true;

	for (i = 0; i < CONFIG_ITEMS_MAX; i++)
	{
		if (config_check[i].attr == IGNORE)
			continue;

		if ((config_check[i].attr == MANDATORY) &&
			(config_check[i].state == DEFAULT))
		{
			ready_to_go = false;
		}

		if (i < VAILD_SYS_INFO_MAX)
		{
			ready_for_mp = ready_to_go;
		}
	}

	global_flags.ready_to_go = ready_to_go; 
	global_flags.ready_for_mp = ready_for_mp;

	if (global_flags.ready_to_go)
		led_notify(READY_TO_GO);
	else if (global_flags.ready_for_mp)
		led_notify(POSITION_NOT_READY);
	else
		led_notify(CONFIG_NOT_READY);
}

#if 0
const GAMMA_TABLE_T gamma_table = {
    .gamma_value = "1.8",
    .gamma_table = {
        0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3,
        4, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 8, 8, 8, 9, 9, 10, 10, 10, 11, 11,
        12, 12, 13, 13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 18, 19, 19, 20, 21,
        21, 22, 22, 23, 24, 24, 25, 26, 26, 27, 28, 28, 29, 30, 30, 31, 32, 32,
        33, 34, 35, 35, 36, 37, 38, 38, 39, 40, 41, 41, 42, 43, 44, 45, 46, 46,
        47, 48, 49, 50, 51, 52, 53, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
        64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81,
        82, 83, 84, 86, 87, 88, 89, 90, 91, 92, 93, 95, 96, 97, 98, 99, 100,
        102, 103, 104, 105, 107, 108, 109, 110, 111, 113, 114, 115, 116, 118,
        119, 120, 122, 123, 124, 126, 127, 128, 129, 131, 132, 134, 135, 136,
        138, 139, 140, 142, 143, 145, 146, 147, 149, 150, 152, 153, 154, 156,
        157, 159, 160, 162, 163, 165, 166, 168, 169, 171, 172, 174, 175, 177,
        178, 180, 181, 183, 184, 186, 188, 189, 191, 192, 194, 195, 197, 199,
        200, 202, 204, 205, 207, 208, 210, 212, 213, 215, 217, 218, 220, 222,
        224, 225, 227, 229, 230, 232, 234, 236, 237, 239, 241, 243, 244, 246,
        248, 250, 251, 253, 255
    }
};
#endif
