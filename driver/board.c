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
	//WWDG_CR, T6;
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

@interrupt void timer2_rc_handler(void)
{
    static @near u16 start[RC_MAX] = {0, 0, 0};
    static @near u16 result[RC_MAX] = {0, 0, 0};
    static @near u8 channel_flags = 0;
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

#ifdef COSMIC
@near static pwm_t hw_pwm[PWM_MAX];
#else
static pwm_t hw_pwm[PWM_MAX];
#endif
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

/** @addtogroup GPIO_Exported_Types
  * @{
  */

/**
  * @brief  GPIO modes
  *
  * Bits definitions:
  * - Bit 7: 0 = INPUT mode
  *          1 = OUTPUT mode
  *          1 = PULL-UP (input) or PUSH-PULL (output)
  * - Bit 5: 0 = No external interrupt (input) or No slope control (output)
  *          1 = External interrupt (input) or Slow control enabled (output)
  * - Bit 4: 0 = Low level (output)
  *          1 = High level (output push-pull) or HI-Z (output open-drain)
  */
typedef enum
{
  GPIO_MODE_IN_FL_NO_IT      = (uint8_t)0x00,  /*!< Input floating, no external interrupt */
  GPIO_MODE_IN_PU_NO_IT      = (uint8_t)0x40,  /*!< Input pull-up, no external interrupt */
  GPIO_MODE_IN_FL_IT         = (uint8_t)0x20,  /*!< Input floating, external interrupt */
  GPIO_MODE_IN_PU_IT         = (uint8_t)0x60,  /*!< Input pull-up, external interrupt */
  GPIO_MODE_OUT_OD_LOW_FAST  = (uint8_t)0xA0,  /*!< Output open-drain, low level, 10MHz */
  GPIO_MODE_OUT_PP_LOW_FAST  = (uint8_t)0xE0,  /*!< Output push-pull, low level, 10MHz */
  GPIO_MODE_OUT_OD_LOW_SLOW  = (uint8_t)0x80,  /*!< Output open-drain, low level, 2MHz */
  GPIO_MODE_OUT_PP_LOW_SLOW  = (uint8_t)0xC0,  /*!< Output push-pull, low level, 2MHz */
  GPIO_MODE_OUT_OD_HIZ_FAST  = (uint8_t)0xB0,  /*!< Output open-drain, high-impedance level,10MHz */
  GPIO_MODE_OUT_PP_HIGH_FAST = (uint8_t)0xF0,  /*!< Output push-pull, high level, 10MHz */
  GPIO_MODE_OUT_OD_HIZ_SLOW  = (uint8_t)0x90,  /*!< Output open-drain, high-impedance level, 2MHz */
  GPIO_MODE_OUT_PP_HIGH_SLOW = (uint8_t)0xD0   /*!< Output push-pull, high level, 2MHz */
}GPIO_Mode_TypeDef;

/**
  * @brief  Definition of the GPIO pins. Used by the @ref GPIO_Init function in
  * order to select the pins to be initialized.
  */

typedef enum
{
  GPIO_PIN_0    = ((uint8_t)0x01),  /*!< Pin 0 selected */
  GPIO_PIN_1    = ((uint8_t)0x02),  /*!< Pin 1 selected */
  GPIO_PIN_2    = ((uint8_t)0x04),  /*!< Pin 2 selected */
  GPIO_PIN_3    = ((uint8_t)0x08),   /*!< Pin 3 selected */
  GPIO_PIN_4    = ((uint8_t)0x10),  /*!< Pin 4 selected */
  GPIO_PIN_5    = ((uint8_t)0x20),  /*!< Pin 5 selected */
  GPIO_PIN_6    = ((uint8_t)0x40),  /*!< Pin 6 selected */
  GPIO_PIN_7    = ((uint8_t)0x80),  /*!< Pin 7 selected */
  GPIO_PIN_LNIB = ((uint8_t)0x0F),  /*!< Low nibble pins selected */
  GPIO_PIN_HNIB = ((uint8_t)0xF0),  /*!< High nibble pins selected */
  GPIO_PIN_ALL  = ((uint8_t)0xFF)   /*!< All pins selected */
}GPIO_Pin_TypeDef;

/**
  * @}
  */

/* Exported constants --------------------------------------------------------*/
/* Exported macros -----------------------------------------------------------*/
/* Private macros ------------------------------------------------------------*/

/** @addtogroup GPIO_Private_Macros
  * @{
  */

/**
  * @brief  Macro used by the assert function to check the different functions parameters.
  */

/**
  * @brief  Macro used by the assert function in order to check the different
  * values of GPIOMode_TypeDef.
  */
#define IS_GPIO_MODE_OK(MODE) \
  (((MODE) == GPIO_MODE_IN_FL_NO_IT)    || \
   ((MODE) == GPIO_MODE_IN_PU_NO_IT)    || \
   ((MODE) == GPIO_MODE_IN_FL_IT)       || \
   ((MODE) == GPIO_MODE_IN_PU_IT)       || \
   ((MODE) == GPIO_MODE_OUT_OD_LOW_FAST)  || \
   ((MODE) == GPIO_MODE_OUT_PP_LOW_FAST)  || \
   ((MODE) == GPIO_MODE_OUT_OD_LOW_SLOW)  || \
   ((MODE) == GPIO_MODE_OUT_PP_LOW_SLOW)  || \
   ((MODE) == GPIO_MODE_OUT_OD_HIZ_FAST)  || \
   ((MODE) == GPIO_MODE_OUT_PP_HIGH_FAST)  || \
   ((MODE) == GPIO_MODE_OUT_OD_HIZ_SLOW)  || \
   ((MODE) == GPIO_MODE_OUT_PP_HIGH_SLOW))

/**
  * @brief  Macro used by the assert function in order to check the different
  * values of GPIO_Pins.
  */
#define IS_GPIO_PIN_OK(PIN)  ((PIN) != (uint8_t)0x00)

void GPIO_DeInit(GPIO_TypeDef* GPIOx)
{
  GPIOx->ODR = GPIO_ODR_RESET_VALUE; /* Reset Output Data Register */
  GPIOx->DDR = GPIO_DDR_RESET_VALUE; /* Reset Data Direction Register */
  GPIOx->CR1 = GPIO_CR1_RESET_VALUE; /* Reset Control Register 1 */
  GPIOx->CR2 = GPIO_CR2_RESET_VALUE; /* Reset Control Register 2 */
}

/**
  * @brief  Initializes the GPIOx according to the specified parameters.
  * @param  GPIOx : Select the GPIO peripheral number (x = A to I).
  * @param  GPIO_Pin : This parameter contains the pin number, it can be any value
  *         of the @ref GPIO_Pin_TypeDef enumeration.
  * @param  GPIO_Mode : This parameter can be a value of the
  *         @Ref GPIO_Mode_TypeDef enumeration.
  * @retval None
  */

void GPIO_Init(GPIO_TypeDef* GPIOx, GPIO_Pin_TypeDef GPIO_Pin, GPIO_Mode_TypeDef GPIO_Mode)
{  
  /* Reset corresponding bit to GPIO_Pin in CR2 register */
  GPIOx->CR2 &= (uint8_t)(~(GPIO_Pin));
  
  /*-----------------------------*/
  /* Input/Output mode selection */
  /*-----------------------------*/
  
  if ((((uint8_t)(GPIO_Mode)) & (uint8_t)0x80) != (uint8_t)0x00) /* Output mode */
  {
    if ((((uint8_t)(GPIO_Mode)) & (uint8_t)0x10) != (uint8_t)0x00) /* High level */
    {
      GPIOx->ODR |= (uint8_t)GPIO_Pin;
    } 
    else /* Low level */
    {
      GPIOx->ODR &= (uint8_t)(~(GPIO_Pin));
    }
    /* Set Output mode */
    GPIOx->DDR |= (uint8_t)GPIO_Pin;
  } 
  else /* Input mode */
  {
    /* Set Input mode */
    GPIOx->DDR &= (uint8_t)(~(GPIO_Pin));
  }
  
  /*------------------------------------------------------------------------*/
  /* Pull-Up/Float (Input) or Push-Pull/Open-Drain (Output) modes selection */
  /*------------------------------------------------------------------------*/
  
  if ((((uint8_t)(GPIO_Mode)) & (uint8_t)0x40) != (uint8_t)0x00) /* Pull-Up or Push-Pull */
  {
    GPIOx->CR1 |= (uint8_t)GPIO_Pin;
  } 
  else /* Float or Open-Drain */
  {
    GPIOx->CR1 &= (uint8_t)(~(GPIO_Pin));
  }
  
  /*-----------------------------------------------------*/
  /* Interrupt (Input) or Slope (Output) modes selection */
  /*-----------------------------------------------------*/
  
  if ((((uint8_t)(GPIO_Mode)) & (uint8_t)0x20) != (uint8_t)0x00) /* Interrupt or Slow slope */
  {
    GPIOx->CR2 |= (uint8_t)GPIO_Pin;
  } 
  else /* No external interrupt or No slope control */
  {
    GPIOx->CR2 &= (uint8_t)(~(GPIO_Pin));
  }
}

/**
  * @brief  Writes data to the specified GPIO data port.
  * @note   The port must be configured in output mode.
  * @param  GPIOx : Select the GPIO peripheral number (x = A to I).
  * @param  GPIO_PortVal : Specifies the value to be written to the port output
  *         data register.
  * @retval None
  */
void GPIO_Write(GPIO_TypeDef* GPIOx, uint8_t PortVal)
{
  GPIOx->ODR = PortVal;
}

/**
  * @brief  Writes high level to the specified GPIO pins.
  * @note   The port must be configured in output mode.  
  * @param  GPIOx : Select the GPIO peripheral number (x = A to I).
  * @param  PortPins : Specifies the pins to be turned high to the port output.
  *         data register.
  * @retval None
  */
void GPIO_WriteHigh(GPIO_TypeDef* GPIOx, GPIO_Pin_TypeDef PortPins)
{
  GPIOx->ODR |= (uint8_t)PortPins;
}

/**
  * @brief  Writes low level to the specified GPIO pins.
  * @note   The port must be configured in output mode.  
  * @param  GPIOx : Select the GPIO peripheral number (x = A to I).
  * @param  PortPins : Specifies the pins to be turned low to the port output.
  *         data register.
  * @retval None
  */
void GPIO_WriteLow(GPIO_TypeDef* GPIOx, GPIO_Pin_TypeDef PortPins)
{
  GPIOx->ODR &= (uint8_t)(~PortPins);
}

/**
  * @brief  Writes reverse level to the specified GPIO pins.
  * @note   The port must be configured in output mode.
  * @param  GPIOx : Select the GPIO peripheral number (x = A to I).
  * @param  PortPins : Specifies the pins to be reversed to the port output.
  *         data register.
  * @retval None
  */
void GPIO_WriteReverse(GPIO_TypeDef* GPIOx, GPIO_Pin_TypeDef PortPins)
{
  GPIOx->ODR ^= (uint8_t)PortPins;
}

/**
  * @brief  Reads the specified GPIO output data port.
  * @note   The port must be configured in input mode.  
  * @param  GPIOx : Select the GPIO peripheral number (x = A to I).
  * @retval GPIO output data port value.
  */
uint8_t GPIO_ReadOutputData(GPIO_TypeDef* GPIOx)
{
  return ((uint8_t)GPIOx->ODR);
}

/**
  * @brief  Reads the specified GPIO input data port.
  * @note   The port must be configured in input mode.   
  * @param  GPIOx : Select the GPIO peripheral number (x = A to I).
  * @retval GPIO input data port value.
  */
uint8_t GPIO_ReadInputData(GPIO_TypeDef* GPIOx)
{
  return ((uint8_t)GPIOx->IDR);
}

/**
  * @brief  Reads the specified GPIO input data pin.
  * @param  GPIOx : Select the GPIO peripheral number (x = A to I).
  * @param  GPIO_Pin : Specifies the pin number.
  * @retval BitStatus : GPIO input pin status.
  */
BitStatus GPIO_ReadInputPin(GPIO_TypeDef* GPIOx, GPIO_Pin_TypeDef GPIO_Pin)
{
  return ((BitStatus)(GPIOx->IDR & (uint8_t)GPIO_Pin));
}

/**
  * @brief  Configures the external pull-up on GPIOx pins.
  * @param  GPIOx : Select the GPIO peripheral number (x = A to I).
  * @param  GPIO_Pin : Specifies the pin number
  * @param  NewState : The new state of the pull up pin.
  * @retval None
  */
void GPIO_ExternalPullUpConfig(GPIO_TypeDef* GPIOx, GPIO_Pin_TypeDef GPIO_Pin, FunctionalState NewState)
{  
  if (NewState != DISABLE) /* External Pull-Up Set*/
  {
    GPIOx->CR1 |= (uint8_t)GPIO_Pin;
  } else /* External Pull-Up Reset*/
  {
    GPIOx->CR1 &= (uint8_t)(~(GPIO_Pin));
  }
}

/* LCD Chip Select I/O definition */
#define LCD_CS_PORT (GPIOF)
#define LCD_CS_PIN  (GPIO_PIN_0)

/* LCD Backlight I/O definition */
#define LCD_BACKLIGHT_PORT (GPIOF)
#define LCD_BACKLIGHT_PIN  (GPIO_PIN_4)

void spi_init(void)
{
	/* Set LCD ChipSelect pin in Output push-pull low level (chip select disabled) */
	GPIO_Init(LCD_CS_PORT, LCD_CS_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
	
	/* Set LCD backlight pin in Output push-pull low level (backlight off) */
	GPIO_Init(LCD_BACKLIGHT_PORT, LCD_BACKLIGHT_PIN, GPIO_MODE_OUT_PP_LOW_FAST);

}

void spi_send(u8 cData)
{
	/*MSB first*/
	GPIO_WriteHigh(LCD_CS_PORT, LCD_CS_PIN);
	SPI->DR = cData;
	while ((SPI->SR & SPI_SR_TXE) == 0);
	GPIO_WriteLow(LCD_CS_PORT, LCD_CS_PIN);

}
void board_int(void)
{
	uart_int();
	spi_init();
	LED_Init();
}
