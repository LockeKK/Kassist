#include "stm8s.h"
#include "globals.h"


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

@interrupt void timer2_rc_handler(void)
{
    static @near u16 start[3] = {0, 0, 0};
    static @near u16 result[3] = {0, 0, 0};
    static @near u8 channel_flags = 0;
    u16 capture_value;
	u8 low, high;

#if 1
    if (TIM2->SR1 & TIM2_SR1_CC1IF) 
	{
		high = TIM2->CCR1H;
		low = TIM2->CCR1L;

		capture_value = (u16)(low);
		capture_value |= (u16)((u16)high << 8);

        if (TIM2->CCER1 & TIM2_CCER1_CC1P)
		{
            // Falling edge triggered
			if (start[0] > capture_value)
			{
				// Compensate for wrap-around
				//capture_value += LPC_SCT->MATCHREL[0].L + 1;
			}
            result[0] = capture_value - start[0];
        }
        else 
		{
			// Rising edge triggered
			start[0] = capture_value;
			if (channel_flags & (1 << 0))
			{
				timer_callback(result);
				channel_flags = (1 << 0);
			}
			channel_flags |= (1 << 0);
		}

		//Toggle the edge
        TIM2->CCER1 ^= TIM2_CCER1_CC1P;

		//Clear the interrupt
        TIM2->SR1 &= (u8)(~TIM2_SR1_CC1IF);
    }
#endif
}

