#ifndef _OLED_H_
#define _OLED_H_

#define F14x16_MODE		1
#define F8x16_MODE		0
#define F6x8_MODE		0

#include "board.h"
#include "stdint.h"

#define s8     char
#define u8    unsigned char
#define SHORT16   int
#define u16  unsigned int
#define uint      unsigned int


#define LED_RST PIOD6
#define LED_DC  PIOD7


#define LED_IMAGE_WHITE       1
#define LED_IMAGE_BLACK       0


#define LED_MAX_ROW_NUM      64
#define LED_MAX_COLUMN_NUM  128



/* OLED driver support */
extern void spi_send(char cData);


void LED_Init(void);
void LED_Fill(u8 ucData);
void LED_P8x16Str(u8 ucIdxX, u8 ucIdxY, u8 ucDataStr[]);
void LED_P14x16Str(u8 ucIdxX,u8 ucIdxY,u8 ucDataStr[]);
void LED_P6x8Str(u8 ucIdxX, u8 ucIdxY, u8 ucDataStr[]);
void SetDisplayOnOff(u8 ucData);
void SetChargePump(u8 d);

#endif
