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



#include "timer.h"
#include "lcd.h"

/* UART Configuration
Baudrate: 115200bps
Frame: 1+8+1
*/

/* UART HAL */

static void (*uart_rx_callback)(char);

void uart_int(void)
{
	hw_uart_int();
	uart_rx_callback = cmd_frame_decode;
}

void uart_send(u8 *data, u8 length)
{
	while(hw_uart_tx_ready);
	hw_uart_tx(data, length);
}

/* UART driver, fully depends on platforms */
static void hw_uart_int()
{

}

static bool hw_uart_tx_ready(void)
{

}

static void hw_uart_tx(u8 *data, u8 length)
{

}

@interrupt void hw_uart_tx_interrupt(void)
{

}

@interrupt void hw_uart_rx_interrupt(void)
{
	u8 rxdata;
	uart_rx_callback(rxdata);
}

