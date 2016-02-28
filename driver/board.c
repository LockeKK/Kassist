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

#include <string.h>
#include <stdlib.h>

#include "board.h"
#include "oled.h"
#include "stm8s.h"

void uart_sendshort(u16 data);

void reboot(void)
{
	WWDG->CR |= (u8)(0x80);
	WWDG->CR &= (u8)(~0x40);
}

bool get_ch3_state(void)
{
	bool  ch3_state @0x500F:2; /*PD2*/

	return ch3_state;
}

u8 get_dip_state(void)
{
	return (u8)(GPIOB->IDR & 0X38 >> 3);
}

u8 get_ch3_profile(void)
{
	return (u8)(GPIOB->IDR & 0X38 >> 3);
}

void hw_led_swith(bool on)
{
	bool led_switch @0x5014:5;

	//led_switch = on;
	led_switch = ~led_switch;
}

void hw_beep_swith(bool on)
{
	bool beep_switch @0x500F:7;

	//beep_switch = on;
	beep_switch = ~beep_switch;
}
static void storage_make_writable(void *addr);
static void storage_make_readonly(void *addr);

void hw_storage_read(u8 *ee_addr, void *ram_addr, u16 length)
{
	memcpy(ram_addr, ee_addr, length);
}

void hw_storage_write(u8 *ee_addr, u8 *ram_addr, u16 length)
{
	u16 i;
	
    storage_make_writable(ee_addr);

	for(i=0;i<length;i++)
	{	
		BSET(FLASH->CR2, 7);
		BRES(FLASH->NCR2, 7);
		ee_addr[i] = ram_addr[i];
		while (!BCHK(FLASH->IAPSR, 2));
	}
    storage_make_readonly(ee_addr);
}

static void storage_make_writable(void *addr)
{
    u8 i = 10;
    // enable write to eeprom/flash
    if ((u16)addr < 0x8000) {
	// eeprom
	FLASH->DUKR = 0xAE;
	FLASH->DUKR = 0x56;
	// wait for Data EEPROM area unlocked flag
	do {
	    if (BCHK(FLASH->IAPSR, 3))  break;
	} while (--i);
    }
    else {
	// flash
	FLASH->PUKR = 0x56;
	FLASH->PUKR = 0xAE;
	// wait for Flash Program memory unlocked flag
	do {
	    if (BCHK(FLASH->IAPSR, 1))  break;
	} while (--i);
    }
}

static void storage_make_readonly(void *addr)
{
    if ((u16)addr < 0x8000)
		BRES(FLASH->IAPSR, 3);
    else
		BRES(FLASH->IAPSR, 1);
}

/*
RC channels caputures: TM2, 16bit general timer, 3 channels.prescare: 16
PWM output: TM1, 16bit advanced timer, 4 channels.prescare: 16
20 systick: TM4, 8bit common timer, 1 channels, prescare: 128, counter 255, 2mS
*/
static void systick_timer_init(void)
{	
	TIM4->PSCR = 7;
	TIM4->ARR = 250;
	TIM4->IER = TIM4_IER_UIE;
	TIM4->CR1 |= TIM4_CR1_CEN;
}

@interrupt void systick_timer_interrupt(void)
{
	/*TODO: 20mS timer*/
	static u16 tm_count;
	if (++tm_count == 10)
	{
		++systick_count;
		tm_count = 0;
	}
	TIM4->SR1 &= (u8)(~TIM4_SR1_UIF);
}

static void capture_timer_int(void)
{
	GPIOD->DDR &= (u8)~0X1C;
	GPIOD->CR1 |= (u8)0X1C;
	GPIOD->CR2 &= (u8)~0X1C;

	TIM2->PSCR = 4;
	TIM2->ARRH = 0XFF;
	TIM2->ARRL = 0XFF;

	TIM2->CCMR1 = 0x01;
	TIM2->CCMR2 = 0X01;
	TIM2->CCER1 = 0x11;

	TIM2->CR1 |= 0X80;
	//TIM2->IER|=1<<0;
	TIM2->IER |= 0X06;
	TIM2->CR1 |= 0x01;

	TIM3->PSCR = 4;
	TIM3->ARRH = 0XFF;
	TIM3->ARRL = 0XFF;

	TIM3->CCMR1 = 0x01;
	TIM3->CCER1 = 0x01;

	TIM3->CR1 |= 0X80;
	//TIM2->IER|=1<<0;
	TIM3->IER |= 0X02;
	TIM3->CR1 |= 0x01;
}

typedef struct{
	u8 *SRx;
	u8 *CCRHx;
	u8 *CCRLx;
	u8 *CCERx;
	u8 SR_MASK;
	u8 CCER_MASK;
} TIMER_REG_T;

static const TIMER_REG_T timer_reg[RC_MAX] =
{
	{
		&TIM2->SR1, &TIM2->CCR1H, &TIM2->CCR1L, &TIM2->CCER1,
		TIM2_SR1_CC1IF, TIM2_CCER1_CC1P
	},
	{
		&TIM2->SR1, &TIM2->CCR2H, &TIM2->CCR2L, &TIM2->CCER1,
		TIM2_SR1_CC2IF, TIM2_CCER1_CC2P
	},
	{
		&TIM3->SR1, &TIM3->CCR1H, &TIM3->CCR1L, &TIM3->CCER1,
		TIM3_SR1_CC1IF, TIM3_CCER1_CC1P
	}
};

@interrupt void rc_capture_handler(void)
{
    static NEAR u16 start[RC_MAX] = {0, 0, 0};
    static NEAR u16 result[RC_MAX] = {0, 0, 0};
    static NEAR u8 channel_flags = 0;
    u16 capture_value;
	u8 low, high;
	u8 i;
	TIMER_REG_T *TIM;
	static u8 n;

	for (i = 1; i <= 3; i++)
	{
		TIM = &timer_reg[i-1];
		
		if (*TIM->SRx & TIM->SR_MASK)
		{
			high = *TIM->CCRHx;
			low = *TIM->CCRLx;
	
			capture_value = (u16)(low);
			capture_value |= (u16)((u16)high << 8);
	
			if (*TIM->CCERx & TIM->CCER_MASK)
			{
				// Falling edge triggered
				if (start[i-1] > capture_value)
				{
					// Compensate for wrap-around
					result[i-1] = U16_MAX - start[i-1] + capture_value;
				}
				else
				{
					result[i-1] = capture_value - start[i-1];
				}
				if (i==2)
				uart_sendshort(result[i-1]);
			}
			else 
			{
				// Rising edge triggered
				start[i-1] = capture_value;
				if (channel_flags & (1 << i))
				{
					output_raw_channels(result);
					channel_flags = (u8)(1 << i);
				}
				channel_flags |= (u8)(1 << i);
			}
	
			//Toggle the trigger edge
			*TIM->CCERx ^= TIM->CCER_MASK;
	
			//Clear the interrupt
			*TIM->SRx &= (u8)(~TIM->SR_MASK);
		}
	}
}

void uart_send(u8 *data, u8 length)
{
	while(length--)
	{
		while(!(UART2->SR & UART2_SR_TXE));
		UART2->DR = *data++;
	}
}

void uart_sendbyte(u8 data)
{
	while(!(UART2->SR & UART2_SR_TXE));
	UART2->DR = data;

}

void uart_sendshort(u16 data)
{
#if 1
	u8 n;
	static u16 last = 0;

	if ((data/10)==(last/10))
		return;

	last = data;

	n = data/1000;
	uart_sendbyte(n + 0x30);

	data = data - n*1000;
	n = data/100;
	uart_sendbyte(n + 0x30);

	data = data - n*100;
	n = data/10;
	uart_sendbyte(n + 0x30);

	uart_sendbyte(data%10 + 0x30);
#endif	
}

static void uart_int(void)
{
	UART2->CR1 &= (u8)~(UART2_CR1_M);
	UART2->CR3 |= (0<<4) & UART2_CR3_STOP;
	UART2->BRR2 = 0X0A;
	UART2->BRR1 = 0X08;
	UART2->CR2 |= UART2_CR2_TEN | UART2_CR2_REN |
				  UART2_CR2_RIEN;
}

@interrupt void uart_rx_interrupt(void)
{
	u8 rx_data;
	
	if (UART2->SR & 0x0F)
		return;

	rx_data = UART2->DR;

	cmd_frame_decode(rx_data);
}

void adc_int(void)
{
}

void adc_onoff(bool enable)
{

}

@interrupt void adc_end_interrupt(void)
{
	u16 adc = 0;
	get_vbat_samples(adc);
}

static void pwm_int(void)
{
	TIM1->CCMR1 = 0x60;
	TIM1->CCMR2 = 0x60;
	TIM1->CCMR3 = 0x60;
	TIM1->CCMR4 = 0x60;

	TIM1->CCER1 = 0x11;
	TIM1->CCER2 = 0x11;

	TIM1->BKR = 0x80;
	
	TIM1->PSCRH = 0;		  
	TIM1->PSCRL = 15;

	//PWM: f=50HZ, T=20, 000us
	//Priod£ºt=1/(fmaster)=1/1MHZ = 1us
	//ARR = T/t = 20000us/1us = 20 000
	TIM1->ARRH = (u8)(20000>>8);	  
	TIM1->ARRL = (u8)200000;

	//Duty
	TIM1->CCR1H = (u8)(1500>>8);
	TIM1->CCR1L = (u8)(1500);

	TIM1->CCR2H = (u8)(1500>>8);
	TIM1->CCR2L = (u8)(1500);

	TIM1->CCR3H = (u8)(1500>>8);
	TIM1->CCR3L = (u8)(1500);

	TIM1->CCR4H = (u8)(1500>>8);
	TIM1->CCR4L = (u8)(1500);

	TIM1->CR1 = 0x01;
}

void pwm_switch(u8 channel, bool on)
{		
	u16 offset;
	
	if (channel >= CH_MAX)
		return;
	
	switch (channel)
	{
		case CH_PWM0:
			if (on)
				TIM1->CCER1 |= (u8)0x01;
			else
				TIM1->CCER1 &= (u8)~0x01;
			break;
		case CH_PWM1:
			if (on)
				TIM1->CCER1 |= (u8)0x10;
			else
				TIM1->CCER1 &= (u8)~0x10;
			break;
		case CH_PWM2:
			if (on)
				TIM1->CCER2 |= (u8)0x01;
			else
				TIM1->CCER2 &= (u8)~0x01;
			break;
		case CH_PWM3:
			if (on)
				TIM1->CCER2 |= (u8)0x10;
			else
				TIM1->CCER2 &= (u8)~0x10;
			break;
	}
}

#define CCRH		(0x5265)
#define CCRL		(0x5266)

void pwm_update(u8 channel, u16 duty)
{
	u16 offset;

	if (channel >= CH_MAX)
		return;

	offset = channel * 2;

	if(duty == 0)
	{
		*(volatile u8 *)(CCRH + offset) = (u8)(duty>>8);
		*(volatile u8 *)(CCRL + offset) = (u8)(duty);
	}
	else
	{
		if (duty > SERVO_PULSE_CLAMP_LOW &&
			duty < SERVO_PULSE_CLAMP_HIGH)
		{
			*(volatile u8 *)(CCRH + offset) = (u8)(duty>>8);
			*(volatile u8 *)(CCRL + offset) = (u8)(duty);
		}
	}
}

static void spi_init(void)
{
	GPIOB->DDR|=0x02;
	GPIOB->CR1|=0x02;
	GPIOB->CR2|=0x02;
	GPIOB->ODR|=0x02;

	GPIOF->DDR|=0x10;
	GPIOF->CR1|=0x10;
	GPIOF->CR2|=0x10;
	GPIOF->ODR &= (u8)(~0x10);

	GPIOC->DDR|=0xE0;
	GPIOC->CR1|=0xE0;
	GPIOC->CR2|=0xE0;
	GPIOC->ODR &= (u8)(~0xE0);
}

static void delay_ms(u16 nCount)
{
  /* Decrement nCount value */
  while (nCount != 0)
  {   
    nCount--;
  }
}

static void system_clk_init(void)
{
    CLK->ICKR = 0;                       //  Reset the Internal Clock Register.
    CLK->ICKR |= CLK_ICKR_HSIEN;         //  Enable the HSI.
    CLK->ECKR = 0;                       //  Disable the external clock.
    while (CLK->ICKR & CLK_ICKR_HSIRDY == 0);       //  Wait for the HSI to be ready for use.
    CLK->CKDIVR = 0;                     //  Ensure the clocks are running at full speed.
    CLK->PCKENR1 = 0xff;                 //  Enable all peripheral clocks.
    CLK->PCKENR2 = 0xff;                 //  Ditto.
    //CLK->CCOR = 1;                       //  Turn on CCO.
    CLK->HSITRIMR = 0;                   //  Turn off any HSIU trimming.
    CLK->SWR = 0xe1;                     //  Use HSI as the clock source.
    CLK->SWCR = 0;                       //  Reset the clock switch control register.
    CLK->SWCR |= CLK_SWCR_SWEN;                  //  Enable switching.
    while (CLK->SWCR & CLK_SWCR_SWBSY != 0);        //  Pause while the clock switch is busy.
}

static void gpio_int(void)
{
	/* LED: PE5 */
	GPIOE->DDR|=0x20;
	GPIOE->CR1|=0x20;
	GPIOE->CR2|=0x20;
	GPIOE->ODR|=0x20;

	/* BEEP: PD7 */
	GPIOD->DDR|=0x80;
	GPIOD->CR1|=0x80;
	GPIOD->CR2|=0x80;
	GPIOD->ODR|=0x80;

	/* DIP: PB[5:3] */
	GPIOD->DDR &= (u8)~0x38;
	GPIOD->CR1|= 0x38;
	GPIOD->CR2&= (u8)~0x38;
}

void board_int(void)
{
	int i,j, n = 0;
	u8 m;
	u8 *buffer = "fuck your world";
	u16 pluse = 1250;
	u16 offset = 0;
	
	system_clk_init();	
	gpio_int();
	spi_init();
	LED_Init();
	systick_timer_init();
	capture_timer_int();
	uart_int();
	pwm_int();
	adc_int();
	enableInterrupts();

	uart_send("Hello", 5);
	systick_count = 0;
	while (1)
	{	
	//LED_P8x16Str(0, 0, buffer);
	//m=n++%10+0x30;
	//uart_send(&m, 1);
	//hw_storage_write((u8 *)EEPROM_ADDR_BASE+m, &m, 1);
	//offset += 10;
	//pluse = 1250 + offset%300;
	//TIM1->CCR1H = (u8)(pluse>>8);
	//TIM1->CCR1L = (u8)(pluse);
	pwm_update(0, 1?0:1500);

	if(1)
	{
		hw_led_swith(n%2);
	}

	for(i=0;i<500;i++)
	for(j=0;j<500;j++);
	}
}
