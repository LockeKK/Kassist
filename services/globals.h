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

#ifndef __COMMAND_H
#define __COMMAND_H

#include "stm8s_type.h"
#if 0
typedef unsigned char 			u8;
typedef unsigned short 			u16;
typedef short 					s16;
typedef unsigned long 			u32;
typedef _Bool 					bool;
#define	true					(1)
#define false					(0)
#endif
#define SYSTICK_IN_MS 			(20)

// Suppress unused parameter or variable warning
#ifndef UNUSED
#define UNUSED(x) ((void)(x))
#endif


// ****************************************************************************
// IO pins: (LPC812 in TSSOP16 package)
//
// PIO0_0   (16, TDO, ISP-Rx)   Steering input / Rx
// PIO0_1   (9,  TDI)           TLC5940 GSCLK
// PIO0_2   (6,  TMS, SWDIO)    TLC5940 SCLK
// PIO0_3   (5,  TCK, SWCLK)    TLC5940 XLAT
// PIO0_4   (4,  TRST, ISP-Tx)  Throttle input / Tx
// PIO0_5   (3,  RESET)         NC (test point)
// PIO0_6   (15)                TLC5940 BLANK
// PIO0_7   (14)                TLC5940 SIN
// PIO0_8   (11, XTALIN)        NC
// PIO0_9   (10, XTALOUT)       Switched light output (for driving a load via a MOSFET)
// PIO0_10  (8,  Open drain)    NC
// PIO0_11  (7,  Open drain)    NC
// PIO0_12  (2,  ISP-entry)     OUT / ISP
// PIO0_13  (1)                 CH3 input
//
// GND      (13)
// 3.3V     (12)
// ****************************************************************************

// Number of positions of our virtual light switch. Includes the "off"
// position 0.
// NOTE: if you change this value you need to adjust CAR_LIGHT_FUNCTION_T
// accordingly!
#define LIGHT_SWITCH_POSITIONS 9

#define MAX_LIGHT_PROGRAMS 25
#define MAX_LIGHT_PROGRAM_VARIABLES 100
#define COSMIC


// Convenience functions for min/max
#define MIN(x, y) ((x) < (y) ? x : (y))
#define MAX(x, y) ((x) > (y) ? x : (y))

#define MAX_MP 			(4)
#define MAX_EXMP 		((MAX_MP+1)>>1)
#define NA 				(0XFF)
#define toggle_it(a)	(a=a?0:1)
#define MAX_CH3_PROFILE (2)
#define MAX_AG_PROFILE 	(2)


typedef enum {
	FRAME_BOF0,
	FRAME_BOF1,
	FRAME_ADDR,
	FRAME_LENGTH,
	FRAME_DATA,
	FRAME_CHKSUM
} frame_decode_stage_t;
/*
[#][@][ADDR][Length][CMD][...][CHKSUM]
[0][1]  [2]   [3]    [4]  [5]
*/
#define FRAME_BOF0_KEY				('$')
#define FRAME_BOF1_KEY				('@')
#define FRAME_TO_ME(data)			(!!(data&0x0f)==0x01)
#define ACK_HOST					(0)
#define MAX_FRAME_SIZE				(80)
#define NM_OF_BOF					(2)
#define CMD_TYPE					((u8)(cmd_frame_buffer[0]))
#define CMD_ACK						((u8)(cmd_frame_buffer[0]+0X80))
#define CMD_ACK_OK					((u8)0x55)
#define CMD_ACK_NA					((u8)0x66)
#define CMD_ACK_NG					((u8)0x77)
#define HEAD_OF_ACK					(&ack_frame_buffer[3])
#define HEAD_OF_CMD					(&cmd_frame_buffer[4])
#define CMD_GET						('R')
#define CMD_SET						('W')

typedef struct {
    u8 protype;
    u8 hw_ver;
	u8 sw_ver;
} PRODUCT_INFO_T;

typedef struct {
    u16 bof;
    u8 dst:4;
	u8 src:4;	
	u8 length;
	u8 *buf;
	u8 chksum;
} cmd_frame;

typedef struct {
    u8 gamma_value[4];
    u8 gamma_table[256];
} GAMMA_TABLE_T;

enum {
	ST = 0,
	TH,
	CH3,
	RC_MAX
};

enum {
	CH3_SINGLE 		= 0,
	CH3_DOUBLE,
	CH3_TRIPLE,	
	CH3_TURNOVER,
	CH3_TO_OFFSET,
	CH3_TO_SINGLE 	= CH3_TO_OFFSET,
	CH3_TO_DOUBLE,	
	CH3_TO_TRIPLE,
	CH3_TO_OFF,
	CH3_CLICKS_MAX,
	NOT_VAILD
};

enum {
	TH_KEY0,
	TH_KEY1,
	TH_KEY2,
	TH_KEY3,
	TH_KEY_MAX
};

enum {
	NO_ACTION 				= 0X00,
	POS_INC					= 0X01,
	POS_DEC					= 0X02,
	POS_DEFAULT				= 0X04,
	POS_SPEC				= 0X08,
	CH3_TOGGLE				= 0X20,
	AUTOGEAR_TOGGLE			= 0X40,	
	CH3_PRIFILE_TOGGLE		= 0X50,	
	AG_PRIFILE_TOGGLE		= 0X60
};

enum {
    NORMAL_MODE		= 0b111,
    REVERSING_SETUP	= 0b110,
    STEEL_SETUP		= 0b100,
    PWM0_SETUP		= 0b000, /*Must be 0*/
    PWM1_SETUP 		= 0b001,
    PWM2_SETUP 		= 0b010,
    PWM3_SETUP 		= 0b011
};

enum {
    CH_PWM0			= PWM0_SETUP,
    CH_PWM1 		= PWM1_SETUP,
    CH_PWM2 		= PWM2_SETUP,
    CH_PWM3 		= PWM3_SETUP,
	CH_MAX,
	CH_EVENT0 		= CH_MAX + 1,
	CH_EVENT1,
	CH_EVENT2,
	CH_EVENT3,
	CH_NONE			= 0xff
};

typedef struct {
	u8 event;
	u8 actions;
	u8 channel;
	u8 beep;
} EVENT_ACTIONS_T;

typedef struct {
	u16 cycle_en		: 1; /*User*/
	u16 default_en 		: 1; /*User*/	
	u16 specific_en 	: 1; /*User*/
	u16 pos_default 	: 4; /*User*/
	u16 pos_spec 		: 4; /*User*/	
	u16 current	 		: 4; /* init to default*/
	u16 toggle	 		: 1; /* init to 0 */
	u16 mp_update	 	: 1; /* init, only for mp */
	u8 exclude[MAX_EXMP]; /*User*/
} POS_CONFIG_T;

typedef struct {
	u16 active_tmo;
	u16 idle_tmo;	
} SERVO_PULSE_T;

typedef struct {
	u8 channel; /*fixed*/
	u8 enabled; /*user*/
	u8 max_nb;  /* user */
    u8 index;	/* only being used in setup session */
	u8 type;	/* user*/
    u16 position[MAX_MP]; /*must hide to user*/
	u8 mp_setup_done;     /*internal use, OR of user config and mp calibration*/
	POS_CONFIG_T pos_config;
	SERVO_PULSE_T sp; /*user*/
} SERVO_OUTPUTS_T;

typedef struct {
    u16 left;
    u16 centre;
    u16 right;
} SERVO_ENDPOINTS_T;

typedef struct {
    u16 raw_data;
    s16 normalized;
    u16 absolute;
    u8 reversed;	
    SERVO_ENDPOINTS_T endpoint;
} RC_CHANNEL_T;

typedef enum {
    SERVO_OUTPUT_SETUP_OFF = 0,
    SERVO_OUTPUT_SETUP_START = 0x01,
    SERVO_OUTPUT_SETUP_DONE = 0x02
} SERVO_OUTPUT_T;

typedef enum {
    SERVO_TYPE_WHEEL = 0,
    SERVO_TYPE_MP = 0x01,
    SERVO_TYPE_SWITCH = 0x02
} SERVO_TYPE_T;

typedef enum {
    STEEL_SETUP_OFF = 0,
    STEEL_SETUP_CENTRE = 0x01,
    STEEL_SETUP_LEFT = 0x02,
    STEEL_SETUP_RIGHT = 0x04
} STEEL_SETUP_T;

#define BEEP_T(order, dash, dot)		(order<<7|dash<<3|dot)

typedef enum {
	BEEP_OFF = BEEP_T(0, 0, 0),
    TASK_DONE = BEEP_T(0, 1, 0),    
    TASK_NG = BEEP_T(0, 2, 0),
	DIP_SWITHED = BEEP_T(0, 0, 2),
	BATTERY_LOW = BEEP_T(0, 3, 0),	
	POWER_ON = BEEP_T(0, 0, 3),	
	SIGN_DONE = BEEP_T(0, 3, 3)
} BEEP_TYPE_T;

typedef enum {
	SWITCH_ON = 0X01,
	SWITCH_OFF = 0X02,
	CONFIG_NOT_READY = 0X03,
	POSITION_NOT_READY = 0X04,
	READY_TO_GO = 0X05
} LED_TYPE_T;

typedef enum {
    REVERSING_SETUP_OFF = 0,
    REVERSING_SETUP_STEERING = 0x01,
    REVERSING_SETUP_THROTTLE = 0x02
} REVERSING_SETUP_T;

typedef struct {
	u16 light_control_en 		: 1;
	u16 lcd_display_en 			: 1;
	u16 auto_gearbox_en 		: 1;	
	u16 reserved0 				: 1;
	u16 multi_ch3_profile_en 	: 1;	
	u16 reserved1 				: 3;
	u16 multi_ag_profile_en 	: 1;
	u16 wifi_module_en 			: 1;	
	u16 pwm_extend_en 			: 1;	
} FEATURE_LIST_T;

typedef struct {
    struct {
        u16 ch3_is_local_switch : 1;
        u16 ch3_is_momentary : 1;
		u16 action_beep_en : 1;	
    } flags;
    u16 startup_time;
    u16 no_signal_timeout;
	u16 dip_state_timeout;
	u16 ch3_turnover_timeout;
    u16 ch3_multi_click_timeout;	
    u16 host_disconnect_timeout;
    u16 servo_pulse_min;
    u16 servo_pulse_max;
    u16 initial_endpoint_delta;
} DEVICE_CONFIG_T;

typedef enum {
	IGNORE = 'N',
    DEFAULT = 'I',
    CONFIGED = 'D',    
    CONDITIONAL = 'C',
    MANDATORY = 'M' 
} INIT_CONFIG_STATE_T;

typedef struct {
	u8 index;
	u8 attr;	
	u8 state;
} CONFIG_CHECK_T;

typedef enum {
    PRODUCT_INFO = 0,
    CONFIG_CHECK,
    DEVICE_CONFIG,
	CH3_ACTIONS,
	TH_ACTIONS,
	SERVO_OUTPUT_BASE,
	SERVO_OUTPUT0 = SERVO_OUTPUT_BASE,
	SERVO_OUTPUT1,
	SERVO_OUTPUT2,
	SERVO_OUTPUT3,
	SERVO_ENDPOINTS,
	REVERSING_ST,	
	REVERSING_TH,
	VAILD_SYS_INFO_MAX,
	SERVO_POSITION_BASE = VAILD_SYS_INFO_MAX,
	SERVO_POSITION0 = SERVO_POSITION_BASE,
	SERVO_POSITION1,
	SERVO_POSITION2,
	SERVO_POSITION3,
	CONFIG_ITEMS_MAX
} SYS_INFO_INDEX_T;

typedef struct{
	u8 index;	
	u8 	attr;
	u16 size;
	void *mem;	
	void *ram;
} SYS_INFO_T;

typedef struct {
    u16 systick : 1;               // Set for one mainloop every 20 ms
    u16 rc_update_event : 1;      // Set for one mainloop every time servo pulses were received
    u16 ch3_action_profile : 1;		// dip setting ,only read at boot, command could select ontime
    u16 ag_action_profile : 1;		// only command could select ontime
    u16 no_signal : 1;
	u16 ready_to_go : 1;
	u16 ready_for_mp : 1;
    u16 rc_is_initializing : 1;
    u16 servo_output_setup : 3;
    u16 reversing_setup : 2;
    u16 steel_setup : 3;	
    u16 host_click : 1;	
    u8 host_config;
	SYS_INFO_T *si;
} GLOBAL_FLAGS_T;

extern GLOBAL_FLAGS_T global_flags;
extern const PRODUCT_INFO_T product_info;
extern volatile u32 systick_count;

#ifdef COSMIC
@near extern DEVICE_CONFIG_T dev_config;
@near extern EVENT_ACTIONS_T ch3_actions[MAX_CH3_PROFILE][CH3_CLICKS_MAX];
@near extern EVENT_ACTIONS_T th_actions[MAX_AG_PROFILE][TH_KEY_MAX];
@near extern SERVO_OUTPUTS_T servo_outputs[CH_MAX];
@near volatile extern RC_CHANNEL_T rc_channel[RC_MAX];
@near extern SERVO_ENDPOINTS_T servo_output_endpoint;
#else
extern DEVICE_CONFIG_T dev_config;
extern EVENT_ACTIONS_T ch3_actions[MAX_CH3_PROFILE][CH3_CLICKS_MAX];
extern EVENT_ACTIONS_T th_actions[MAX_AG_PROFILE][TH_KEY_MAX];
extern SERVO_OUTPUTS_T servo_outputs[CH_MAX];
extern volatile RC_CHANNEL_T rc_channel[RC_MAX];
extern SERVO_ENDPOINTS_T servo_output_endpoint;
#endif
#define SERVO_OUTPUT_SIZE		(sizeof(servo_outputs)/CH_MAX)




extern void init_servo_output(void);
extern void update_servo_output(void);
extern bool if_under_setup_actions(void);
extern void input_user_acknowledge(u8 ch3_clicks);
extern void setup_mode_service(void);
extern void init_servo_reader(void);
extern void output_raw_channels(u16 result[3]);
extern void read_rc_channels(void);
extern void input_ch3_handler(void);
extern void process_simulate_ch3_clicks(u8 clicks);
extern void update_rtr_status(u8 index, u8 tag, bool save);
extern void update_attr_status(u8 index, u8 tag, bool save);
extern void load_all_parameters(void);
extern void load_system_configs(u8 index);
extern void save_system_configs(u8 index);
extern void cmd_execution_done(void);
extern void set_event_ack_ready(void);
extern void host_cmd_init(void);
extern void send_ack_frame(u8 ack_length);
extern void host_cmd_process(void);
extern void security_init(void);
extern void verify_encrypted_uid(void);
extern void notification_service(void);
extern void beep_notify(u8 beep);
extern void led_notify(u8 mode);
extern void cmd_frame_decode(u8 data);
extern void servo_output_manually(u8 channel, s16 normalized);



#define EEPROM_ADDR_BASE				(0x4000)
#define EEPROM_RESERVED					(0x10)

#define EEPROM_CONFIG_CHECK				(0x4000) /* 34 Bytes*/
#define EEPROM_DEV_CONFIG				(0x4030) /* 18 Bytes */
#define EEPROM_REVERSING_ST				(0x4050) /* 2 Bytes */
#define EEPROM_REVERSING_TH				(0x4051) /* 2 Bytes */
#define EEPROM_SERVO_ENDPOINTS			(0x4052) /* 6 Bytes */
#define EEPROM_CH3_ACTIONS				(0x4060) /* 64 Bytes */
#define EEPROM_TH_ACTIONS				(0x40B0) /* 64 */
#define EEPROM_SERVO_OUTPUTS			(0x4100) /* 33*4 */
#define EEPROM_SERVO_OUTPUT0			(EEPROM_SERVO_OUTPUTS) /* 33*4 */
#define EEPROM_SERVO_OUTPUT1			(EEPROM_SERVO_OUTPUT0 + SERVO_OUTPUT_SIZE) /* 33*4 */
#define EEPROM_SERVO_OUTPUT2			(EEPROM_SERVO_OUTPUT1 + SERVO_OUTPUT_SIZE) /* 33*4 */
#define EEPROM_SERVO_OUTPUT3			(EEPROM_SERVO_OUTPUT2 + SERVO_OUTPUT_SIZE) /* 33*4 */
#define EEPROM_NEXT						(0x41C0)
#endif
