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

/* UART Configuration
Baudrate: 115200bps
Frame: 1+8+1
*/

/* UART HAL */

typedef struct {
	u8 channel;
	u16 cycle;
	u16 duty;
} pwm_t;

typedef enum {
	PWM_GEARBOX,
	PWM_WHEEL,
	PWM_LED,
	PWM_WINCH,
	PWM_CH3,
	PWM_MAX
} frame_decode_stage_t;


static pwm_t hw_pwm[PWM_MAX];

void pwm_int(void)
{
	hw_uart_int();
	uart_rx_callback = cmd_frame_decode;
}

void pwm_setup(pwm_t *p_pwm)
{
	hw_pwm[p_pwm->channel].channel = p_pwm->channel;
	hw_pwm[p_pwm->channel].cycle= p_pwm->cycle;	
	hw_pwm[p_pwm->channel].duty = p_pwm->duty;
}

void pwm_update(u8 channel, u16 duty)
{

}
