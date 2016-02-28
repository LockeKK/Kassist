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

#include "globals.h"
#include "oled.h"

extern void board_int(void);
extern void uart_send(u8 *data, u8 length);
extern void uart_sendbyte(u8 data);
extern void uart_sendshort(s16 data);
extern void reboot(void);
extern void delay(u16 ms);
extern bool get_ch3_state(void);
extern void hw_beep_swith(bool on);
extern void hw_led_swith(bool on);
extern u8 get_dip_state(void);
extern void hw_storage_read(u8 *ee_addr, void *ram_addr, u16 length);
extern void hw_storage_write(u8 *ee_addr, void *ram_addr, u16 length);
extern void pwm_update(u8 channel, u16 duty);

