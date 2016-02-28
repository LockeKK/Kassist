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
#include "board.h"
#include "oled.h"
#include "stm8s.h"

void uart_sendshort(u16 data);

void reboot(void)
{
	WWDG->CR |= (u8)(0x80);
	WWDG->CR &= (u8)(~0x40);
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
	return (u8)(GPIOB->IDR & 0X38 >> 3);
}

u8 get_ch3_profile(void)
{
	return 0;
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
    if ((u16)addr < 0x8000)  BRES(FLASH->IAPSR, 3);
    else		     BRES(FLASH->IAPSR, 1);
}

static void (*timer_callback)(u16 *);

/*
RC channels caputures: TM2, 16bit general timer, 3 channels.prescare: 16
PWM output: TM1, 16bit advanced timer, 4 channels.prescare: 16
20 systick: TM4, 8bit common timer, 1 channels, prescare: 128, counter 255, 2mS
*/
static void hw_timer_int(void);

void timer_int(void)
{
	hw_timer_int();
	timer_callback = output_raw_channels;
}

static void hw_timer_int(void)
{
	GPIOD->DDR &= (u8)~0X1C;	//PD3 输入模式
	GPIOD->CR1 |= (u8)0X1C;	//PD3,上拉
	GPIOD->CR2 &= (u8)~0X1C;		//PD3,不使用中断

	TIM2->PSCR = 4;		//2^psc次方分频
	TIM2->ARRH = 0XFF;	//必须先设置ARR的高字节
	TIM2->ARRL = 0XFF;	//再设置低字节

	TIM2->CCMR1 = 0x01; /*no prescale, no fliter, TI1FP1*/
	TIM2->CCMR2 = 0X01; /*no prescale, no fliter, TI2FP2*/
	TIM2->CCER1 = 0x11; /*Rising and enable capture*/

	TIM2->CR1 |= 0X80;	//预装载使能
	//TIM2->IER|=1<<0;	//使能更新中断
	TIM2->IER |= 0X06;	/* ISR, enable CH1 + CH2 */
	TIM2->CR1 |= 0x01;	/* Enable TIM2*/ 

	TIM3->PSCR = 4;		//2^psc次方分频
	TIM3->ARRH = 0XFF;	//必须先设置ARR的高字节
	TIM3->ARRL = 0XFF;	//再设置低字节

	TIM3->CCMR1 = 0x01; /*no prescale, no fliter, TI1FP1*/
	TIM3->CCER1 = 0x01; /*Rising and enable capture*/

	TIM3->CR1 |= 0X80;	//预装载使能
	//TIM2->IER|=1<<0;	//使能更新中断
	TIM3->IER |= 0X02;	/* ISR, enable CH1*/
	TIM3->CR1 |= 0x01;	/* Enable TIM3*/ 


	/* timer 4: systick */
	TIM4->PSCR = 7;				// init divider register /128		
	TIM4->ARR = 250;				// init auto reload register	
	TIM4->IER = TIM4_IER_UIE;		// enable TIM4 interrupt
	TIM4->CR1 |= TIM4_CR1_CEN;	// enable timer	
}

@interrupt void timer4_systick_interrupt(void)
{
	/*TODO: 20mS timer*/
	static u16 tm_count;
	if (++tm_count == 10)
	{
		++systick_count;
		tm_count = 0;
		//GPIOE->ODR^=0xf0;
	}
	TIM4->SR1 &= (u8)(~TIM4_SR1_UIF);
}

typedef struct{
	u8 *SRx;
	u8 *CCRHx;
	u8 *CCRLx;
	u8 *CCERx;
	u8 SR_MASK;
	u8 CCER_MASK;
} TIMER_REG_T;

static const TIMER_REG_T timer2_reg[RC_MAX] =
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
u8  TIM2CH2_CAPTURE_STA=0;
u16	TIM2CH2_CAPTURE_VAL;

@interrupt void timer23_rc_handler(void)
{
    static NEAR u16 start[RC_MAX] = {0, 0, 0};
    static NEAR u16 result[RC_MAX] = {0, 0, 0};
    static NEAR u8 channel_flags = 0;
    u16 capture_value;
	u8 low, high;
	u8 i;
	TIMER_REG_T *TIM;
	static u8 n;

	hw_led_swith(++n%2);

	for (i = 1; i <= 3; i++)
	{
		TIM = &timer2_reg[i-1];
		
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
				uart_sendshort(result[i-1]);
			}
			else 
			{
				// Rising edge triggered
				start[i-1] = capture_value;
				if (channel_flags & (1 << i))
				{
					timer_callback(result);
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

static void (*uart_rx_callback)(u8);
static void hw_uart_int(void);

void uart_int(void)
{
	hw_uart_int();
	uart_rx_callback = cmd_frame_decode;
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
	uart_sendbyte((u8)(data>>8));
	uart_sendbyte((u8)(data));
}

/* UART driver, fully depends on platforms */
static void hw_uart_int(void)
{
	UART2->CR1 &= (u8)~(UART2_CR1_M);
	UART2->CR3 |= (0<<4) & UART2_CR3_STOP;	// 1 stop bit	
	UART2->BRR2 = 0X0A;
	UART2->BRR1 = 0X08;
	UART2->CR2 |= UART2_CR2_TEN | UART2_CR2_REN |
				  UART2_CR2_RIEN;
}

@interrupt void hw_uart_rx_interrupt(void)
{
	u8 rx_data;
	
	if (UART2->SR & 0x0F)
		return;

	rx_data = UART2->DR;

	uart_rx_callback(rx_data);
}

static void (*adc_end_callback)(u16);
static void hw_adc_int(void)
{
}

void adc_int(void)
{
	hw_adc_int();
	adc_end_callback = get_vbat_samples;
}

void adc_onoff(bool enable)
{

}

@interrupt void adc_end_interrupt(void)
{
	u16 adc = 0;
	adc_end_callback(adc);
}

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
};

NEAR static pwm_t hw_pwm[PWM_MAX];

void pwm_int(void)
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
	//Priod：t=1/(fmaster)=1/1MHZ = 1us
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

void pwm_setup(pwm_t *p_pwm)
{
	hw_pwm[p_pwm->channel].channel = p_pwm->channel;
	hw_pwm[p_pwm->channel].cycle= p_pwm->cycle;	
	hw_pwm[p_pwm->channel].duty = p_pwm->duty;
}

void pwm_update(u8 channel, u16 duty)
{
	if(duty == 0)
	{
		/*stop output pwm*/
	}
	else
	{
	}
}

bool PA0 @0x5000:0;
bool PB0 @0x5005:0;
bool PC0 @0x500A:0;
bool PD0 @0x500F:0;
bool PE0 @0x5014:0;
bool PF0 @0x5019:0;

bool LCD_CS 	@0x5005:1; /*PB1*/
bool LCD_DC 	@0x500A:7; /*PC7*/
bool LCD_DIN 	@0x500A:6; /*PC6*/
bool LCD_CLK 	@0x500A:5; /*PC5*/
bool LCD_RST 	@0x5019:4; /*PF4*/

void spi_init(void)
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

void gpio_int(void)
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
	
	/* RC: PD4 */
	GPIOD->DDR &= (u8)~0x10;
	GPIOD->CR1 |= 0x10;
	GPIOD->CR2 &= (u8)~0x10;

}

void board_int(void)
{
	int i,j, n = 0;
	u8 m;
	u8 *buffer = "fuck your world";
	u16 pluse = 1250;
	u16 offset = 0;
	
	uart_int();
	system_clk_init();	
	gpio_int();
	spi_init();
	LED_Init();
	timer_int();
	//hw_uart_int();
	pwm_int();
	enableInterrupts();

	//uart_send("Hello", 5);
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

	if(1)//(TIM3->SR1&0x02)
	{
		//hw_led_swith(n%2);
		//TIM3->SR1&=~0x02;
	}

	//GPIOE->ODR^=0xf0;
	for(i=0;i<500;i++)
	for(j=0;j<500;j++);
	}
}
