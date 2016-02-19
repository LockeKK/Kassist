#include "globals.h"
#include "board.h"
#include <string.h>

static volatile bool cmd_frame_received;
static bool ack_frame_ready;
static volatile u8 cmd_frame_buffer[MAX_FRAME_SIZE];
static volatile u8 ack_frame_buffer[MAX_FRAME_SIZE];

static void get_sys_info(void);
static void reset_to_factroy(void);
static void get_device_sn(void);
static void set_attr_flag(void);

void cmd_frame_decode(u8 data)
{
	static frame_decode_stage_t decode_stage;
	static u8 chksum;
	static u8 total_length;
	static u8 rx_length;

	/* Ingore Rx data during command process phase */
	if (cmd_frame_received)
	{
		return;
	}

	switch (decode_stage)
	{
		case FRAME_BOF0:
			if (data == FRAME_BOF0_KEY)
			{
				decode_stage = FRAME_BOF1;
				chksum = data;
			}
			break;
			
		case FRAME_BOF1:
			if (data == FRAME_BOF1_KEY)
			{
				decode_stage = FRAME_ADDR;
				chksum += data;
			} else {
				decode_stage = FRAME_BOF0;
			}
			break;
			
		case FRAME_ADDR:
			if (FRAME_TO_ME(data))
			{
				decode_stage = FRAME_LENGTH;
				chksum += data;
			}
			else {
				decode_stage = FRAME_BOF0;
			}
			break;

		case FRAME_LENGTH:
			if (data < MAX_FRAME_SIZE)
			{
				decode_stage = FRAME_DATA;
				total_length = data;
				chksum += data;
				rx_length = 0;
			}
			else {
				decode_stage = FRAME_BOF0;
			}
			break;

		case FRAME_DATA:
			chksum += data;
			cmd_frame_buffer[rx_length++] = data;
			if (rx_length == total_length)
			{
				decode_stage = FRAME_CHKSUM;
			}
			break;

		case FRAME_CHKSUM:
			if (chksum == data)
			{
				cmd_frame_received = true;
			}
			decode_stage = FRAME_BOF0;
			break;

		default:
			break;
		}

}

static void (*cmd_process[])(void) = {
/*0x00*/	get_sys_info,
			get_device_sn,
			reset_to_factroy,
			set_attr_flag
};

void cmd_execution_done(void)
{
	u8 index = 0;	
	u8 *buf = HEAD_OF_ACK;
	
	buf[index++] = NM_OF_BOF + 1;
	buf[index++] = CMD_ACK;
	buf[index++] = CMD_ACK_OK;
	
	set_event_ack_ready();
}

void cmd_execution_ng(void)
{
	u8 index = 0;	
	u8 *buf = HEAD_OF_ACK;
	
	buf[index++] = NM_OF_BOF + 1;
	buf[index++] = CMD_ACK;
	buf[index++] = CMD_ACK_NG;
	
	set_event_ack_ready();
}

/*
TxBuf:
[4]: Command type;
[5]: config info index
[6]: Get(0) or set(1)
[7]: Head of data
*/
static void get_sys_info(void)
{
	u8 index = 0;	
	u8 length;
	u8 *tx_buf = HEAD_OF_ACK;
	u8 *rx_buf = &cmd_frame_buffer[7];
	u8 wr = cmd_frame_buffer[6];
	u8 target = cmd_frame_buffer[5];
	SYS_INFO_T *si = global_flags.si;
	
	if (CMD_TYPE != 0)
		goto out;

	if (target >= CONFIG_ITEMS_MAX)
		goto out;

	if (wr & si->attr == false)
		goto out;

	if (wr == CMD_GET)
	{
		si += target;
		tx_buf[index++] = (u8)(2 + si->size); 		
		tx_buf[index++] = CMD_ACK;
		memcpy((u8 *)(tx_buf + index), si->ram, si->size);				
		set_event_ack_ready();				
	} 
	else if (wr == CMD_SET)
	{
		memcpy(si->ram, rx_buf, si->size);
		save_system_configs(target);
		update_rtr_status(target, CONFIGED, true);
		cmd_execution_done();
	}
	else
	{
out:
		cmd_execution_ng();
	}

}


/*
TxBuf:
[4]: Command type;
[5]: config info index
[6]: Get(0) or set(1)
[7]: Head of data
*/
static void reset_to_factroy(void)
{
	u8 index = 0;	
	u8 length;
	u8 *tx_buf = HEAD_OF_ACK;
	u8 *rx_buf = &cmd_frame_buffer[7];
	u8 wr = cmd_frame_buffer[6];
	u8 target = cmd_frame_buffer[5];
	SYS_INFO_T *si = global_flags.si;
	
	if (CMD_TYPE != 0)
		goto out;

	if (target >= CONFIG_ITEMS_MAX)
		goto out;

	if (wr & si->attr == false)
		goto out;

	if (wr == CMD_GET)
	{
		si += target;
		tx_buf[index++] = (u8)(2 + si->size); 		
		tx_buf[index++] = CMD_ACK;
		memcpy((u8 *)(tx_buf + index), si->ram, si->size);				
		set_event_ack_ready();
		delay(100);
		reboot();
	} 
	else
	{
out:
		cmd_execution_ng();
	}

}

static void get_device_sn(void)
{

}

/*
TxBuf:
[4]: Command type;
[5]: 1, enable, 0, disable
[6]: clicks number
*/
static void simulate_ch3_click(void)
{
	global_flags.host_click = cmd_frame_buffer[5];
	if (global_flags.host_click)
	{
		process_simulate_ch3_clicks(cmd_frame_buffer[6]);
		cmd_execution_done();
	}
	else
	{
		cmd_execution_ng();
	}
}

/*
TxBuf:
[4]: Command type;
[5]: REVERSING_SETUP/STEEL_SETUP
*/
static void start_reversing_steel_setup(void)
{
	if (cmd_frame_buffer[5] == REVERSING_SETUP ||
		cmd_frame_buffer[5] == STEEL_SETUP)
	{
		global_flags.host_config = cmd_frame_buffer[5];
		cmd_execution_done();
	}
	else
	{
		cmd_execution_ng();
	}
}


/* NOTE: Must be used after PWM0~3 setting before postion setting*/
/*
TxBuf:
[4]: Command type;
[5~8]: pwm0~3's position
[9~12]: mandatroy or ingore
*/
static void set_attr_flag(void)
{
	u8 i;
	u8 *target = &cmd_frame_buffer[5];
	u8 *tag = &cmd_frame_buffer[9];
	
	for (i=0; i < CH_MAX; i++)
		update_attr_status(target[i], tag[i], 
						   i == (CH_MAX - 1));
}

void set_event_ack_ready(void)
{
	ack_frame_ready = true;
}

void host_cmd_init(void)
{
	u8 index = 0;
	
	ack_frame_buffer[index++] = FRAME_BOF0_KEY;
	ack_frame_buffer[index++] = FRAME_BOF1_KEY;
	ack_frame_buffer[index++] = ACK_HOST;

}

void send_ack_frame(u8 ack_length)
{
	u8 chksum = 0;
	u8 i;

	for (i=0; i<4+ack_length; i++)
		chksum += ack_frame_buffer[i];

	ack_frame_buffer[i] = chksum;
	//uart_send(ack_frame_buffer, i);
}

void host_cmd_process(void)
{
	static u16 host_disconnect_counter;

    if (global_flags.systick)
	{
        if (host_disconnect_counter++ ==
			dev_config.host_disconnect_timeout)
		{
            global_flags.host_click = false;
        }
    }
	
	if (cmd_frame_received )
	{
		cmd_process[CMD_TYPE]();
		cmd_frame_received = false;
		host_disconnect_counter = 0;
	}

	if (ack_frame_ready)
	{
		send_ack_frame(1);
		ack_frame_ready = false;
	}
}
