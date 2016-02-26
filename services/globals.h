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

#define COSMIC

// Suppress unused parameter or variable warning
#ifndef UNUSED
#define UNUSED(x) ((void)(x))
#endif

#ifdef COSMIC
#define NEAR	@near
#else
#define NEAR
#endif

// ****************************************************************************
// IO pins: (STM8S105 in LQFP32 package) [XX] is alternate function
//
// 1		(NRST)									ISP
// 2		(OSCIN/PA1)								TLC5940 GSCLK
// 3		(OSCOUT/PA2)							TLC5940 XLAT
// 4		(VSS)									GND
// 5		(VCAP)									Power
// 6		(VDD)									Power
// 7		(VDDIO)									Power
// 8		(AIN12/PF4)								LCD Reset
// 9		(VDDA)									Power
// 10		(VSSA)									Power
// 11		(AIN5/PB5, [SDA])						DIP2
// 12		(AIN4/PB4, [SCL])						DIP1
// 13		(AIN3/PB3, [TIM1_ETR])					DIP0
// 14		(AIN2/PB2, [TIM1_CH3N])					TLC5940 BLANK
// 15		(AIN1/PB1, [TIM1_CH2N])					LCD CS
// 16		(AIN0/PB0, [TIM1_CH1N])					Vbat
// 17		(PE5, SPI_NSS)							LED
// 18		(PC1/TIM1_CH1/UART2_CK)					PWM0 output
// 19		(PC2/TIM1_CH2)							PWM1 output
// 20		(PC3/TIM1_CH3)							PWM2 output
// 21		(PC4/TIM1_CH4)							PWM3 output
// 22		(PC5/SPI_SCK)							LCD SCK/TLC5940 SCLK
// 23		(PC6/SPI_MOSI)							LCD SIN/TLC5940 SIN
// 24		(PC7/SPI_MISO)							LCD DC
// 25		(PD0/TIM3_CH2, [TIM1_BKIN, CLK_CCO])	KEY
// 26		(PD1/SWIM)								ISP
// 27		(PD2/TIM3_CH1, [TIM2_CH3])				RC CH3 input
// 28		(PD3/TIM2_CH2, [ADC_ETR])				RC Throttle input
// 29		(PD4/TIM2_CH1, [BEEP])					RC Steel input
// 30		(PD5/UART_TX)							UART/WIFI TX
// 31		(PD6/UART_RX)							UART/WIFI RX
// 32		(PD7/TLI, [TIM1_CH4])					BEEP
//
// GND      (13)
// 5V     	(12)
// ****************************************************************************

// Number of positions of our virtual light switch. Includes the "off"
// position 0.
// NOTE: if you change this value you need to adjust CAR_LIGHT_FUNCTION_T
// accordingly!
#define LIGHT_SWITCH_POSITIONS 9

#define MAX_LIGHT_PROGRAMS 25
#define MAX_LIGHT_PROGRAM_VARIABLES 100

#define SYSTICK_IN_MS 			(20)


// Convenience functions for min/max
#define MIN(x, y) ((x) < (y) ? x : (y))
#define MAX(x, y) ((x) > (y) ? x : (y))

#define MAX_MP 			(4)
#define MAX_EXMP 		((MAX_MP+1)>>1)
#define NA 				(0XFF)
#define toggle_it(a)	(a=a?0:1)
#define MAX_CH3_PROFILE (2)
#define MAX_AG_PROFILE 	(2)

typedef struct {
    u8 protype;
    u8 hw_ver;
	u8 sw_ver;
} PRODUCT_INFO_T;

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
	u16 default_pos 	: 4; /*User*/
	u16 specific_pos 	: 4; /*User*/
	u16 current	 		: 4; /* init to default*/
	u16 toggle	 		: 1; /* init to 0 */
	u16 mp_update	 	: 1; /* init, only for mp, mp has changed */
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
	BEEP_OFF 	= BEEP_T(0, 0, 0),
    TASK_DONE 	= BEEP_T(0, 1, 0),
    TASK_NG 	= BEEP_T(0, 2, 0),
	DIP_SWITHED = BEEP_T(0, 0, 2),
	BATTERY_LOW = BEEP_T(0, 3, 0),
	IDLE_TMO 	= BEEP_T(0, 2, 2),
	POWER_ON 	= BEEP_T(0, 0, 3),
	SIGN_DONE 	= BEEP_T(0, 3, 3)
} BEEP_TYPE_T;

typedef enum {
	SWITCH_ON 			= 0X01,
	SWITCH_OFF 			= 0X02,
	CONFIG_NOT_READY 	= 0X03,
	POSITION_NOT_READY 	= 0X04,
	READY_TO_GO 		= 0X05
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
		u16 battery_guard_en : 1;
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
	u8 low_vbat_threshold; /* 64->6.4V */
	u8 idle_timeout; /* unit: 5 minutes  */		
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
	u16 host_click : 1;	
	u16 sys_idle : 1;
	u8 servo_output_setup : 3;
	u8 reversing_setup : 2;
	u8 steel_setup : 3;
	u8 host_config;
	u8 vbat;
	SYS_INFO_T *si;
} GLOBAL_FLAGS_T;

extern GLOBAL_FLAGS_T global_flags;
extern const PRODUCT_INFO_T product_info;
extern volatile u32 systick_count;

NEAR extern DEVICE_CONFIG_T dev_config;
NEAR extern EVENT_ACTIONS_T ch3_actions[MAX_CH3_PROFILE][CH3_CLICKS_MAX];
NEAR extern EVENT_ACTIONS_T th_actions[MAX_AG_PROFILE][TH_KEY_MAX];
NEAR extern SERVO_OUTPUTS_T servo_outputs[CH_MAX];
NEAR volatile extern RC_CHANNEL_T rc_channel[RC_MAX];
NEAR extern SERVO_ENDPOINTS_T servo_output_endpoint;

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
extern void reset_all_parameters(void);
extern void load_system_configs(u8 index);
extern void save_system_configs(u8 index);
extern void host_cmd_init(void);
extern void host_cmd_process(void);
extern void security_init(void);
extern void verify_encrypted_uid(void);
extern void notification_service(void);
extern void beep_notify(u8 beep);
extern void led_notify(u8 mode);
extern void cmd_frame_decode(u8 data);
extern u16 servo_output_manually(u8 channel, s16 normalized);
extern void battery_guard_init(void);
extern void battery_guard_service(void);
extern void get_vbat_samples(u16 vbat);

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
