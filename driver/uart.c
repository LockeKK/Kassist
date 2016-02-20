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



#include "stm8s.h"
#include "globals.h"

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
	UART2->CR1 &= ~(UART2_CR1_M);
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
