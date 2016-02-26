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

#ifndef _OLED_H_
#define _OLED_H_

#include "stm8s_type.h"
#include "board.h"

#define F8x16_MODE		1
#define F6x8_MODE		1

#define LED_IMAGE_WHITE       1
#define LED_IMAGE_BLACK       0


#define LED_MAX_ROW_NUM      64
#define LED_MAX_COLUMN_NUM  128

/* OLED driver support */
void LED_Init(void);
void LED_Fill(u8 ucData);
void LED_P8x16Str(u8 ucIdxX, u8 ucIdxY, u8 ucDataStr[]);
void LED_P6x8Str(u8 ucIdxX, u8 ucIdxY, u8 ucDataStr[]);
void LED_PrintShort(u8 ucIdxX, u8 ucIdxY, s16 sData);
void SetDisplayOnOff(u8 ucData);
void SetChargePump(u8 d);

#endif
