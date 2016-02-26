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

#define HW_RESET_ADDR	(0X8000)

void reboot(void)
{
	//WWDG->CR = WWDG_CR_WDGA | (u8)0x30;
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
	return 0;
}

u8 get_ch3_profile(void)
{
	return 0;
}

void hw_led_swith(bool on)
{

}

void hw_beep_swith(bool on)
{

}
static void storage_make_writable(void *addr);
static void storage_make_readonly(void *addr);

void hw_storage_read(u8 *ee_addr, void *ram_addr, u16 length)
{
	memcpy(ram_addr, ee_addr, length);
}

void hw_storage_write(u8 *ee_addr, u8 *ram_addr, u16 length)
{
    storage_make_writable(ee_addr);
    // write only values, which are different, check and write at
    // Word mode (4 bytes)
    length /= 4;
    do {
	if (*(u16 *)ee_addr != *(u16 *)ram_addr ||
	    *(u16 *)(ee_addr + 2) != *(u16 *)(ram_addr + 2)) {
	    // enable Word programming
	    SetBit(FLASH->CR2, 6);
	    ClrBit(FLASH->NCR2, 6);
	    // write 4-byte value
	    ee_addr[0] = ram_addr[0];
	    ee_addr[1] = ram_addr[1];
	    ee_addr[2] = ram_addr[2];
	    ee_addr[3] = ram_addr[3];
	    // wait for EndOfProgramming flag
	    while (!ValBit(FLASH->IAPSR, 2));
	}
	ee_addr += 4;
	ram_addr += 4;
    } while (--length);
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
	    if (ValBit(FLASH->IAPSR, 3))  break;
	} while (--i);
    }
    else {
	// flash
	FLASH->PUKR = 0x56;
	FLASH->PUKR = 0xAE;
	// wait for Flash Program memory unlocked flag
	do {
	    if (ValBit(FLASH->IAPSR, 1))  break;
	} while (--i);
    }
}

static void storage_make_readonly(void *addr)
{
    if ((u16)addr < 0x8000)  ClrBit(FLASH->IAPSR, 3);
    else		     ClrBit(FLASH->IAPSR, 1);
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
	/* timer 1: PWM output */
#if 0	
	/* Set the Autoreload value */
	TIM1->ARRH = (uint8_t)(TIM1_Period >> 8);
	TIM1->ARRL = (uint8_t)(TIM1_Period);
	
	/* Set the Prescaler value */
	TIM1->PSCRH = (uint8_t)(TIM1_Prescaler >> 8);
	TIM1->PSCRL = (uint8_t)(TIM1_Prescaler);
	
	/* Select the Counter Mode */
	TIM1->CR1 = (uint8_t)((uint8_t)(TIM1->CR1 & (uint8_t)(~(TIM1_CR1_CMS | TIM1_CR1_DIR)))
						  | (uint8_t)(TIM1_CounterMode));
	
	/* Set the Repetition Counter value */
	TIM1->RCR = TIM1_RepetitionCounter;
#endif
	/* timer 2: RC channel monitor */
	
	/* Disable the Channel 1~3 */
	TIM2->CCER1 &= (u8)(~(TIM2_CCER1_CC1E | TIM2_CCER1_CC2E));	
	TIM2->CCER2 &= (u8)(~(TIM2_CCER2_CC3E));
	
	/* Set sampling rate, input */
	TIM2->CCMR1  = (u8)(0xa0<<4 | 0x01);
	TIM2->CCMR2  = (u8)(0xa0<<4 | 0x01);
	TIM2->CCMR3  = (u8)(0xa0<<4 | 0x01);
	
	/*Rising edge trigger*/
	TIM2->CCER1 &= (u8)(~(TIM2_CCER1_CC1P | TIM2_CCER1_CC2P)); 
	TIM2->CCER2 &= (u8)(~(TIM2_CCER2_CC3P)); 

	/* Enable the Channel 1  */
	TIM2->CCER1 |= TIM2_CCER1_CC1E | TIM2_CCER1_CC2E;
	TIM2->CCER2 |= TIM2_CCER2_CC3E;

	/* Start the counter(3ch share one EN)*/
	TIM2->CR1 |= (u8)TIM2_CR1_CEN;

	/* Clear interrupt flag */
	TIM2->SR1 &= (u8)(~(TIM2_SR1_CC1IF | TIM2_SR1_CC2IF | TIM2_SR1_CC3IF));

	/* enable the interrupt*/
	TIM2->IER |= (u8)(TIM2_IER_CC1IE | TIM2_IER_CC2IE | TIM2_IER_CC3IE);
	
	/* timer 4: systick */
	TIM4->PSCR = 7;				// init divider register /128		
	TIM4->ARR = 0;				// init auto reload register	
	TIM4->EGR = TIM4_EGR_UG;			// update registers	
	TIM4->CR1 |= TIM4_CR1_ARPE | TIM4_CR1_URS | TIM4_CR1_CEN;	// enable timer	
	TIM4->IER = TIM4_IER_UIE;		// enable TIM4 interrupt
}

@interrupt void timer4_systick_interrupt(void)
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

typedef struct{
	u8 *srx;
	u8 *ccrxh;
	u8 *ccrxl;
	u8 *ccerx;
	u8 srx_mask;
	u8 ccerx_mask;
} TIMER2_REG_T;

static const TIMER2_REG_T timer2_reg[RC_MAX] =
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
		&TIM2->SR1, &TIM2->CCR3H, &TIM2->CCR3L, &TIM2->CCER2,
		TIM2_SR1_CC3IF, TIM2_CCER2_CC3P
	}
};

@interrupt void timer23_rc_handler(void)
{
    static NEAR u16 start[RC_MAX] = {0, 0, 0};
    static NEAR u16 result[RC_MAX] = {0, 0, 0};
    static NEAR u8 channel_flags = 0;
    u16 capture_value;
	u8 low, high;
	u8 i;
	TIMER2_REG_T *p;


	for (i = 1; i <= RC_MAX; i++)
	{
		p = &timer2_reg[i-1];
		if (*p->srx & p->srx_mask)
		{
			high = *p->ccrxh;
			low = *p->ccrxl;
	
			capture_value = (u16)(low);
			capture_value |= (u16)((u16)high << 8);
	
			if (*p->ccerx & p->ccerx_mask)
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
	
			//Toggle the edge
			*p->ccerx ^= p->ccerx_mask;
	
			//Clear the interrupt
			*p->srx &= (u8)(~p->srx_mask);
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

/* UART driver, fully depends on platforms */
static void hw_uart_int(void)
{
	UART2->CR1 &= (u8)~(UART2_CR1_M);
	UART2->CR3 |= (0<<4) & UART2_CR3_STOP;	// 1 stop bit	
	UART2->BRR2 = 3 & UART2_BRR2_DIVF;		//57600 Bd	
	UART2->BRR1 = 2;	
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
	GPIOF->ODR &= ~0x10;

	GPIOC->DDR|=0xE0;
	GPIOC->CR1|=0xE0;
	GPIOC->CR2|=0xE0;
	GPIOC->ODR &= ~0xE0;
}

static void delay_ms(u16 nCount)
{
  /* Decrement nCount value */
  while (nCount != 0)
  {   
    nCount--;
  }
}
void board_int(void)
{
	int i,j, n = 0;
	u8 buffer[] = {'a', 'b'};
	//uart_int();
	spi_init();
	LED_Init();
	
	GPIOE->DDR|=0x20;
	GPIOE->CR1|=0x20;
	GPIOE->CR2|=0x00;
	
	while (1)
	{	
	LED_P8x16Str(0, 0, buffer);
	//LED_PrintShort(8, 16, 45);
	GPIOE->ODR^=0xf0;
	for(i=0;i<200;i++)
	for(j=0;j<200;j++);
	}
}
