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

#include "oled.h"

#if F6x8_MODE
const unsigned char F6x8[][6] =
{
    { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },   //sp0
    { 0x00, 0x00, 0x00, 0x2f, 0x00, 0x00 },   // !1
    { 0x00, 0x00, 0x07, 0x00, 0x07, 0x00 },   // "2
    { 0x00, 0x14, 0x7f, 0x14, 0x7f, 0x14 },   // #3
    { 0x00, 0x24, 0x2a, 0x7f, 0x2a, 0x12 },   // $4
    { 0x00, 0x62, 0x64, 0x08, 0x13, 0x23 },   // %5
    { 0x00, 0x36, 0x49, 0x55, 0x22, 0x50 },   // &6
    { 0x00, 0x00, 0x05, 0x03, 0x00, 0x00 },   // '7
    { 0x00, 0x00, 0x1c, 0x22, 0x41, 0x00 },   // (8
    { 0x00, 0x00, 0x41, 0x22, 0x1c, 0x00 },   // )9
    { 0x00, 0x14, 0x08, 0x3E, 0x08, 0x14 },   // *10
    { 0x00, 0x08, 0x08, 0x3E, 0x08, 0x08 },   // +11
    { 0x00, 0x00, 0x00, 0xA0, 0x60, 0x00 },   // ,12
    { 0x00, 0x08, 0x08, 0x08, 0x08, 0x08 },   // -13
    { 0x00, 0x00, 0x60, 0x60, 0x00, 0x00 },   // .14
    { 0x00, 0x20, 0x10, 0x08, 0x04, 0x02 },   // /15
    { 0x00, 0x3E, 0x51, 0x49, 0x45, 0x3E },   // 016
    { 0x00, 0x00, 0x42, 0x7F, 0x40, 0x00 },   // 117
    { 0x00, 0x42, 0x61, 0x51, 0x49, 0x46 },   // 218
    { 0x00, 0x21, 0x41, 0x45, 0x4B, 0x31 },   // 319
    { 0x00, 0x18, 0x14, 0x12, 0x7F, 0x10 },   // 420
    { 0x00, 0x27, 0x45, 0x45, 0x45, 0x39 },   // 521
    { 0x00, 0x3C, 0x4A, 0x49, 0x49, 0x30 },   // 622
    { 0x00, 0x01, 0x71, 0x09, 0x05, 0x03 },   // 723
    { 0x00, 0x36, 0x49, 0x49, 0x49, 0x36 },   // 824
    { 0x00, 0x06, 0x49, 0x49, 0x29, 0x1E },   // 925
    { 0x00, 0x00, 0x36, 0x36, 0x00, 0x00 },   // :26
    { 0x00, 0x00, 0x56, 0x36, 0x00, 0x00 },   // ;27
    { 0x00, 0x08, 0x14, 0x22, 0x41, 0x00 },   // <28
    { 0x00, 0x14, 0x14, 0x14, 0x14, 0x14 },   // =29
    { 0x00, 0x00, 0x41, 0x22, 0x14, 0x08 },   // >30
    { 0x00, 0x02, 0x01, 0x51, 0x09, 0x06 },   // ?31
    { 0x00, 0x32, 0x49, 0x59, 0x51, 0x3E },   // @32
    { 0x00, 0x7C, 0x12, 0x11, 0x12, 0x7C },   // A33
    { 0x00, 0x7F, 0x49, 0x49, 0x49, 0x36 },   // B34
    { 0x00, 0x3E, 0x41, 0x41, 0x41, 0x22 },   // C35
    { 0x00, 0x7F, 0x41, 0x41, 0x22, 0x1C },   // D36
    { 0x00, 0x7F, 0x49, 0x49, 0x49, 0x41 },   // E37
    { 0x00, 0x7F, 0x09, 0x09, 0x09, 0x01 },   // F38
    { 0x00, 0x3E, 0x41, 0x49, 0x49, 0x7A },   // G39
    { 0x00, 0x7F, 0x08, 0x08, 0x08, 0x7F },   // H40
    { 0x00, 0x00, 0x41, 0x7F, 0x41, 0x00 },   // I41
    { 0x00, 0x20, 0x40, 0x41, 0x3F, 0x01 },   // J42
    { 0x00, 0x7F, 0x08, 0x14, 0x22, 0x41 },   // K43
    { 0x00, 0x7F, 0x40, 0x40, 0x40, 0x40 },   // L44
    { 0x00, 0x7F, 0x02, 0x0C, 0x02, 0x7F },   // M45
    { 0x00, 0x7F, 0x04, 0x08, 0x10, 0x7F },   // N46
    { 0x00, 0x3E, 0x41, 0x41, 0x41, 0x3E },   // O47
    { 0x00, 0x7F, 0x09, 0x09, 0x09, 0x06 },   // P48
    { 0x00, 0x3E, 0x41, 0x51, 0x21, 0x5E },   // Q49
    { 0x00, 0x7F, 0x09, 0x19, 0x29, 0x46 },   // R50
    { 0x00, 0x46, 0x49, 0x49, 0x49, 0x31 },   // S51
    { 0x00, 0x01, 0x01, 0x7F, 0x01, 0x01 },   // T52
    { 0x00, 0x3F, 0x40, 0x40, 0x40, 0x3F },   // U53
    { 0x00, 0x1F, 0x20, 0x40, 0x20, 0x1F },   // V54
    { 0x00, 0x3F, 0x40, 0x38, 0x40, 0x3F },   // W55
    { 0x00, 0x63, 0x14, 0x08, 0x14, 0x63 },   // X56
    { 0x00, 0x07, 0x08, 0x70, 0x08, 0x07 },   // Y57
    { 0x00, 0x61, 0x51, 0x49, 0x45, 0x43 },   // Z58
    { 0x00, 0x00, 0x7F, 0x41, 0x41, 0x00 },   // [59
    { 0x00, 0x02, 0x04, 0x08, 0x10, 0x20 },   // \60
    { 0x00, 0x00, 0x41, 0x41, 0x7F, 0x00 },   // ]61
    { 0x00, 0x04, 0x02, 0x01, 0x02, 0x04 },   // ^62
    { 0x00, 0x40, 0x40, 0x40, 0x40, 0x40 },   // _63
    { 0x00, 0x00, 0x01, 0x02, 0x04, 0x00 },   // '64
    { 0x00, 0x20, 0x54, 0x54, 0x54, 0x78 },   // a65
    { 0x00, 0x7F, 0x48, 0x44, 0x44, 0x38 },   // b66
    { 0x00, 0x38, 0x44, 0x44, 0x44, 0x20 },   // c67
    { 0x00, 0x38, 0x44, 0x44, 0x48, 0x7F },   // d68
    { 0x00, 0x38, 0x54, 0x54, 0x54, 0x18 },   // e69
    { 0x00, 0x08, 0x7E, 0x09, 0x01, 0x02 },   // f70
    { 0x00, 0x18, 0xA4, 0xA4, 0xA4, 0x7C },   // g71
    { 0x00, 0x7F, 0x08, 0x04, 0x04, 0x78 },   // h72
    { 0x00, 0x00, 0x44, 0x7D, 0x40, 0x00 },   // i73
    { 0x00, 0x40, 0x80, 0x84, 0x7D, 0x00 },   // j74
    { 0x00, 0x7F, 0x10, 0x28, 0x44, 0x00 },   // k75
    { 0x00, 0x00, 0x41, 0x7F, 0x40, 0x00 },   // l76
    { 0x00, 0x7C, 0x04, 0x18, 0x04, 0x78 },   // m77
    { 0x00, 0x7C, 0x08, 0x04, 0x04, 0x78 },   // n78
    { 0x00, 0x38, 0x44, 0x44, 0x44, 0x38 },   // o79
    { 0x00, 0xFC, 0x24, 0x24, 0x24, 0x18 },   // p80
    { 0x00, 0x18, 0x24, 0x24, 0x18, 0xFC },   // q81
    { 0x00, 0x7C, 0x08, 0x04, 0x04, 0x08 },   // r82
    { 0x00, 0x48, 0x54, 0x54, 0x54, 0x20 },   // s83
    { 0x00, 0x04, 0x3F, 0x44, 0x40, 0x20 },   // t84
    { 0x00, 0x3C, 0x40, 0x40, 0x20, 0x7C },   // u85
    { 0x00, 0x1C, 0x20, 0x40, 0x20, 0x1C },   // v86
    { 0x00, 0x3C, 0x40, 0x30, 0x40, 0x3C },   // w87
    { 0x00, 0x44, 0x28, 0x10, 0x28, 0x44 },   // x88
    { 0x00, 0x1C, 0xA0, 0xA0, 0xA0, 0x7C },   // y89
    { 0x00, 0x44, 0x64, 0x54, 0x4C, 0x44 },   // z90
    { 0x14, 0x14, 0x14, 0x14, 0x14, 0x14 }    // horiz lines91
};
#endif

#if F14x16_MODE
const  unsigned char F14x16_Idx[] = 
{
};

const  unsigned char F14x16[] = 
{  

};
#endif


#if F8x16_MODE
const  unsigned char F8X16[]=
{
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,// 0
    0x00,0x00,0x00,0xF8,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x33,0x30,0x00,0x00,0x00,//!1
    0x00,0x10,0x0C,0x06,0x10,0x0C,0x06,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,//"2
    0x40,0xC0,0x78,0x40,0xC0,0x78,0x40,0x00,0x04,0x3F,0x04,0x04,0x3F,0x04,0x04,0x00,//#3
    0x00,0x70,0x88,0xFC,0x08,0x30,0x00,0x00,0x00,0x18,0x20,0xFF,0x21,0x1E,0x00,0x00,//$4
    0xF0,0x08,0xF0,0x00,0xE0,0x18,0x00,0x00,0x00,0x21,0x1C,0x03,0x1E,0x21,0x1E,0x00,//%5
    0x00,0xF0,0x08,0x88,0x70,0x00,0x00,0x00,0x1E,0x21,0x23,0x24,0x19,0x27,0x21,0x10,//&6
    0x10,0x16,0x0E,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,//'7
    0x00,0x00,0x00,0xE0,0x18,0x04,0x02,0x00,0x00,0x00,0x00,0x07,0x18,0x20,0x40,0x00,//(8
    0x00,0x02,0x04,0x18,0xE0,0x00,0x00,0x00,0x00,0x40,0x20,0x18,0x07,0x00,0x00,0x00,//)9
    0x40,0x40,0x80,0xF0,0x80,0x40,0x40,0x00,0x02,0x02,0x01,0x0F,0x01,0x02,0x02,0x00,//*10
    0x00,0x00,0x00,0xF0,0x00,0x00,0x00,0x00,0x01,0x01,0x01,0x1F,0x01,0x01,0x01,0x00,//+11
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xB0,0x70,0x00,0x00,0x00,0x00,0x00,//,12
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x01,0x01,0x01,0x01,0x01,0x01,//-13
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x30,0x30,0x00,0x00,0x00,0x00,0x00,//.14
    0x00,0x00,0x00,0x00,0x80,0x60,0x18,0x04,0x00,0x60,0x18,0x06,0x01,0x00,0x00,0x00,///15
    0x00,0xE0,0x10,0x08,0x08,0x10,0xE0,0x00,0x00,0x0F,0x10,0x20,0x20,0x10,0x0F,0x00,//016
    0x00,0x10,0x10,0xF8,0x00,0x00,0x00,0x00,0x00,0x20,0x20,0x3F,0x20,0x20,0x00,0x00,//117
    0x00,0x70,0x08,0x08,0x08,0x88,0x70,0x00,0x00,0x30,0x28,0x24,0x22,0x21,0x30,0x00,//218
    0x00,0x30,0x08,0x88,0x88,0x48,0x30,0x00,0x00,0x18,0x20,0x20,0x20,0x11,0x0E,0x00,//319
    0x00,0x00,0xC0,0x20,0x10,0xF8,0x00,0x00,0x00,0x07,0x04,0x24,0x24,0x3F,0x24,0x00,//420
    0x00,0xF8,0x08,0x88,0x88,0x08,0x08,0x00,0x00,0x19,0x21,0x20,0x20,0x11,0x0E,0x00,//521
    0x00,0xE0,0x10,0x88,0x88,0x18,0x00,0x00,0x00,0x0F,0x11,0x20,0x20,0x11,0x0E,0x00,//622
    0x00,0x38,0x08,0x08,0xC8,0x38,0x08,0x00,0x00,0x00,0x00,0x3F,0x00,0x00,0x00,0x00,//723
    0x00,0x70,0x88,0x08,0x08,0x88,0x70,0x00,0x00,0x1C,0x22,0x21,0x21,0x22,0x1C,0x00,//824
    0x00,0xE0,0x10,0x08,0x08,0x10,0xE0,0x00,0x00,0x00,0x31,0x22,0x22,0x11,0x0F,0x00,//925
    0x00,0x00,0x00,0xC0,0xC0,0x00,0x00,0x00,0x00,0x00,0x00,0x30,0x30,0x00,0x00,0x00,//:26
    0x00,0x00,0x00,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0x60,0x00,0x00,0x00,0x00,//;27
    0x00,0x00,0x80,0x40,0x20,0x10,0x08,0x00,0x00,0x01,0x02,0x04,0x08,0x10,0x20,0x00,//<28
    0x40,0x40,0x40,0x40,0x40,0x40,0x40,0x00,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x00,//=29
    0x00,0x08,0x10,0x20,0x40,0x80,0x00,0x00,0x00,0x20,0x10,0x08,0x04,0x02,0x01,0x00,//>30
    0x00,0x70,0x48,0x08,0x08,0x08,0xF0,0x00,0x00,0x00,0x00,0x30,0x36,0x01,0x00,0x00,//?31
    0xC0,0x30,0xC8,0x28,0xE8,0x10,0xE0,0x00,0x07,0x18,0x27,0x24,0x23,0x14,0x0B,0x00,//@32
    0x00,0x00,0xC0,0x38,0xE0,0x00,0x00,0x00,0x20,0x3C,0x23,0x02,0x02,0x27,0x38,0x20,//A33
    0x08,0xF8,0x88,0x88,0x88,0x70,0x00,0x00,0x20,0x3F,0x20,0x20,0x20,0x11,0x0E,0x00,//B34
    0xC0,0x30,0x08,0x08,0x08,0x08,0x38,0x00,0x07,0x18,0x20,0x20,0x20,0x10,0x08,0x00,//C35
    0x08,0xF8,0x08,0x08,0x08,0x10,0xE0,0x00,0x20,0x3F,0x20,0x20,0x20,0x10,0x0F,0x00,//D36
    0x08,0xF8,0x88,0x88,0xE8,0x08,0x10,0x00,0x20,0x3F,0x20,0x20,0x23,0x20,0x18,0x00,//E37
    0x08,0xF8,0x88,0x88,0xE8,0x08,0x10,0x00,0x20,0x3F,0x20,0x00,0x03,0x00,0x00,0x00,//F38
    0xC0,0x30,0x08,0x08,0x08,0x38,0x00,0x00,0x07,0x18,0x20,0x20,0x22,0x1E,0x02,0x00,//G39
    0x08,0xF8,0x08,0x00,0x00,0x08,0xF8,0x08,0x20,0x3F,0x21,0x01,0x01,0x21,0x3F,0x20,//H40
    0x00,0x08,0x08,0xF8,0x08,0x08,0x00,0x00,0x00,0x20,0x20,0x3F,0x20,0x20,0x00,0x00,//I41
    0x00,0x00,0x08,0x08,0xF8,0x08,0x08,0x00,0xC0,0x80,0x80,0x80,0x7F,0x00,0x00,0x00,//J42
    0x08,0xF8,0x88,0xC0,0x28,0x18,0x08,0x00,0x20,0x3F,0x20,0x01,0x26,0x38,0x20,0x00,//K43
    0x08,0xF8,0x08,0x00,0x00,0x00,0x00,0x00,0x20,0x3F,0x20,0x20,0x20,0x20,0x30,0x00,//L44
    0x08,0xF8,0xF8,0x00,0xF8,0xF8,0x08,0x00,0x20,0x3F,0x00,0x3F,0x00,0x3F,0x20,0x00,//M45
    0x08,0xF8,0x30,0xC0,0x00,0x08,0xF8,0x08,0x20,0x3F,0x20,0x00,0x07,0x18,0x3F,0x00,//N46
    0xE0,0x10,0x08,0x08,0x08,0x10,0xE0,0x00,0x0F,0x10,0x20,0x20,0x20,0x10,0x0F,0x00,//O47
    0x08,0xF8,0x08,0x08,0x08,0x08,0xF0,0x00,0x20,0x3F,0x21,0x01,0x01,0x01,0x00,0x00,//P48
    0xE0,0x10,0x08,0x08,0x08,0x10,0xE0,0x00,0x0F,0x18,0x24,0x24,0x38,0x50,0x4F,0x00,//Q49
    0x08,0xF8,0x88,0x88,0x88,0x88,0x70,0x00,0x20,0x3F,0x20,0x00,0x03,0x0C,0x30,0x20,//R50
    0x00,0x70,0x88,0x08,0x08,0x08,0x38,0x00,0x00,0x38,0x20,0x21,0x21,0x22,0x1C,0x00,//S51
    0x18,0x08,0x08,0xF8,0x08,0x08,0x18,0x00,0x00,0x00,0x20,0x3F,0x20,0x00,0x00,0x00,//T52
    0x08,0xF8,0x08,0x00,0x00,0x08,0xF8,0x08,0x00,0x1F,0x20,0x20,0x20,0x20,0x1F,0x00,//U53
    0x08,0x78,0x88,0x00,0x00,0xC8,0x38,0x08,0x00,0x00,0x07,0x38,0x0E,0x01,0x00,0x00,//V54
    0xF8,0x08,0x00,0xF8,0x00,0x08,0xF8,0x00,0x03,0x3C,0x07,0x00,0x07,0x3C,0x03,0x00,//W55
    0x08,0x18,0x68,0x80,0x80,0x68,0x18,0x08,0x20,0x30,0x2C,0x03,0x03,0x2C,0x30,0x20,//X56
    0x08,0x38,0xC8,0x00,0xC8,0x38,0x08,0x00,0x00,0x00,0x20,0x3F,0x20,0x00,0x00,0x00,//Y57
    0x10,0x08,0x08,0x08,0xC8,0x38,0x08,0x00,0x20,0x38,0x26,0x21,0x20,0x20,0x18,0x00,//Z58
    0x00,0x00,0x00,0xFE,0x02,0x02,0x02,0x00,0x00,0x00,0x00,0x7F,0x40,0x40,0x40,0x00,//[59
    0x00,0x0C,0x30,0xC0,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x06,0x38,0xC0,0x00,//\60
    0x00,0x02,0x02,0x02,0xFE,0x00,0x00,0x00,0x00,0x40,0x40,0x40,0x7F,0x00,0x00,0x00,//]61
    0x00,0x00,0x04,0x02,0x02,0x02,0x04,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,//^62
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,//_63
    0x00,0x02,0x02,0x04,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,//`64
    0x00,0x00,0x80,0x80,0x80,0x80,0x00,0x00,0x00,0x19,0x24,0x22,0x22,0x22,0x3F,0x20,//a65
    0x08,0xF8,0x00,0x80,0x80,0x00,0x00,0x00,0x00,0x3F,0x11,0x20,0x20,0x11,0x0E,0x00,//b66
    0x00,0x00,0x00,0x80,0x80,0x80,0x00,0x00,0x00,0x0E,0x11,0x20,0x20,0x20,0x11,0x00,//c67
    0x00,0x00,0x00,0x80,0x80,0x88,0xF8,0x00,0x00,0x0E,0x11,0x20,0x20,0x10,0x3F,0x20,//d68
    0x00,0x00,0x80,0x80,0x80,0x80,0x00,0x00,0x00,0x1F,0x22,0x22,0x22,0x22,0x13,0x00,//e69
    0x00,0x80,0x80,0xF0,0x88,0x88,0x88,0x18,0x00,0x20,0x20,0x3F,0x20,0x20,0x00,0x00,//f70
    0x00,0x00,0x80,0x80,0x80,0x80,0x80,0x00,0x00,0x6B,0x94,0x94,0x94,0x93,0x60,0x00,//g71
    0x08,0xF8,0x00,0x80,0x80,0x80,0x00,0x00,0x20,0x3F,0x21,0x00,0x00,0x20,0x3F,0x20,//h72
    0x00,0x80,0x98,0x98,0x00,0x00,0x00,0x00,0x00,0x20,0x20,0x3F,0x20,0x20,0x00,0x00,//i73
    0x00,0x00,0x00,0x80,0x98,0x98,0x00,0x00,0x00,0xC0,0x80,0x80,0x80,0x7F,0x00,0x00,//j74
    0x08,0xF8,0x00,0x00,0x80,0x80,0x80,0x00,0x20,0x3F,0x24,0x02,0x2D,0x30,0x20,0x00,//k75
    0x00,0x08,0x08,0xF8,0x00,0x00,0x00,0x00,0x00,0x20,0x20,0x3F,0x20,0x20,0x00,0x00,//l76
    0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x00,0x20,0x3F,0x20,0x00,0x3F,0x20,0x00,0x3F,//m77
    0x80,0x80,0x00,0x80,0x80,0x80,0x00,0x00,0x20,0x3F,0x21,0x00,0x00,0x20,0x3F,0x20,//n78
    0x00,0x00,0x80,0x80,0x80,0x80,0x00,0x00,0x00,0x1F,0x20,0x20,0x20,0x20,0x1F,0x00,//o79
    0x80,0x80,0x00,0x80,0x80,0x00,0x00,0x00,0x80,0xFF,0xA1,0x20,0x20,0x11,0x0E,0x00,//p80
    0x00,0x00,0x00,0x80,0x80,0x80,0x80,0x00,0x00,0x0E,0x11,0x20,0x20,0xA0,0xFF,0x80,//q81
    0x80,0x80,0x80,0x00,0x80,0x80,0x80,0x00,0x20,0x20,0x3F,0x21,0x20,0x00,0x01,0x00,//r82
    0x00,0x00,0x80,0x80,0x80,0x80,0x80,0x00,0x00,0x33,0x24,0x24,0x24,0x24,0x19,0x00,//s83
    0x00,0x80,0x80,0xE0,0x80,0x80,0x00,0x00,0x00,0x00,0x00,0x1F,0x20,0x20,0x00,0x00,//t84
    0x80,0x80,0x00,0x00,0x00,0x80,0x80,0x00,0x00,0x1F,0x20,0x20,0x20,0x10,0x3F,0x20,//u85
    0x80,0x80,0x80,0x00,0x00,0x80,0x80,0x80,0x00,0x01,0x0E,0x30,0x08,0x06,0x01,0x00,//v86
    0x80,0x80,0x00,0x80,0x00,0x80,0x80,0x80,0x0F,0x30,0x0C,0x03,0x0C,0x30,0x0F,0x00,//w87
    0x00,0x80,0x80,0x00,0x80,0x80,0x80,0x00,0x00,0x20,0x31,0x2E,0x0E,0x31,0x20,0x00,//x88
    0x80,0x80,0x80,0x00,0x00,0x80,0x80,0x80,0x80,0x81,0x8E,0x70,0x18,0x06,0x01,0x00,//y89
    0x00,0x80,0x80,0x80,0x80,0x80,0x80,0x00,0x00,0x21,0x30,0x2C,0x22,0x21,0x30,0x00,//z90
    0x00,0x00,0x00,0x00,0x80,0x7C,0x02,0x02,0x00,0x00,0x00,0x00,0x00,0x3F,0x40,0x40,//{91
    0x00,0x00,0x00,0x00,0xFF,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xFF,0x00,0x00,0x00,//|92
    0x00,0x02,0x02,0x7C,0x80,0x00,0x00,0x00,0x00,0x40,0x40,0x3F,0x00,0x00,0x00,0x00,//}93
    0x00,0x06,0x01,0x01,0x02,0x02,0x04,0x04,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,//~94
};
#endif



void LED_WrDat(u8 ucData);
void LED_WrCmd(u8 ucCmd);
void LED_SetPos(u8 ucIdxX, u8 ucIdxY);
void SetStartColumn(u8 ucData);
void SetAddressingMode(u8 ucData);
void SetColumnAddress(u8 a, u8 b);
void SetPageAddress(u8 a, u8 b);
void SetStartLine(u8 d);
void SetContrastControl(u8 d);
void SetChargePump(u8 d);
void SetSegmentRemap(u8 d);
void SetEntireDisplay(u8 d);
void SetInverseDisplay(u8 d);
void SetMultiplexRatio(u8 d);
void SetDisplayOnOff(u8 d);
void SetStartPage(u8 d);
void SetCommonRemap(u8 d);
void SetDisplayOffset(u8 d);
void SetDisplayClock(u8 d);
void SetPrechargePeriod(u8 d);
void SetCommonConfig(u8 d);
void SetVCOMH(u8 d);
void SetNop(void);


void LED_WrDat(u8 cData)
{
	LED_DC  = 1;
	spi_send(cData);
}

void LED_WrCmd(u8 ucCmd)
{
	LED_DC  = 0;
	spi_send(ucCmd);
}

void LED_SetPos(u8 ucIdxX, u8 ucIdxY)
{ 
    LED_WrCmd(0xb0 + ucIdxY);
    LED_WrCmd(((ucIdxX & 0xf0) >> 4) | 0x10);
    LED_WrCmd((ucIdxX & 0x0f) | 0x00); 
} 

void LED_Fill(u8 ucData)
{
    u8 ucPage,ucColumn;
    
    for(ucPage = 0; ucPage < 8; ucPage++)
    {
        LED_WrCmd(0xb0 + ucPage);  //0xb0+0~7表示页0~7
        LED_WrCmd(0x00);           //0x00+0~16表示将128列分成16组其地址在某组中的第几列
        LED_WrCmd(0x10);           //0x10+0~16表示将128列分成16组其地址所在第几组
        for(ucColumn = 0; ucColumn < 128; ucColumn++)
        {
            LED_WrDat(ucData);
        }
    }
} 



void SetStartColumn(u8 ucData)
{
    LED_WrCmd(0x00+ucData % 16);   // Set Lower Column Start Address for Page Addressing Mode
                                   // Default => 0x00
    LED_WrCmd(0x10+ucData / 16);   // Set Higher Column Start Address for Page Addressing Mode
                                   // Default => 0x10
}



void SetAddressingMode(u8 ucData)
{
    LED_WrCmd(0x20);        // Set Memory Addressing Mode
    LED_WrCmd(ucData);      // Default => 0x02
                            // 0x00 => Horizontal Addressing Mode
                            // 0x01 => Vertical Addressing Mode
                            // 0x02 => Page Addressing Mode
}



void SetColumnAddress(u8 a, u8 b)
{
    LED_WrCmd(0x21);        // Set Column Address
    LED_WrCmd(a);           // Default => 0x00 (Column Start Address)
    LED_WrCmd(b);           // Default => 0x7F (Column End Address)
}



void SetPageAddress(u8 a, u8 b)
{
    LED_WrCmd(0x22);        // Set Page Address
    LED_WrCmd(a);           // Default => 0x00 (Page Start Address)
    LED_WrCmd(b);           // Default => 0x07 (Page End Address)
}



void SetStartLine(u8 ucData)
{
    LED_WrCmd(0x40|ucData); // Set Display Start Line
                            // Default => 0x40 (0x00)
}

void SetContrastControl(u8 ucData)
{
    LED_WrCmd(0x81);        // Set Contrast Control
    LED_WrCmd(ucData);      // Default => 0x7F
}

void SetChargePump(u8 ucData)
{
    LED_WrCmd(0x8D);        // Set Charge Pump
    LED_WrCmd(0x10|ucData); // Default => 0x10
                            // 0x10 (0x00) => Disable Charge Pump
                            // 0x14 (0x04) => Enable Charge Pump
}



void SetSegmentRemap(u8 ucData)
{
    LED_WrCmd(0xA0|ucData); // Set Segment Re-Map
                            // Default => 0xA0
                            // 0xA0 (0x00) => Column Address 0 Mapped to SEG0
                            // 0xA1 (0x01) => Column Address 0 Mapped to SEG127
}

void SetEntireDisplay(u8 ucData)
{
    LED_WrCmd(0xA4|ucData); // Set Entire Display On / Off
                            // Default => 0xA4
                            // 0xA4 (0x00) => Normal Display
                            // 0xA5 (0x01) => Entire Display On
}

void SetInverseDisplay(u8 ucData)
{
    LED_WrCmd(0xA6|ucData); // Set Inverse Display On/Off
                            // Default => 0xA6
                            // 0xA6 (0x00) => Normal Display
                            // 0xA7 (0x01) => Inverse Display On
}



void SetMultiplexRatio(u8 ucData)
{
    LED_WrCmd(0xA8);        // Set Multiplex Ratio
    LED_WrCmd(ucData);      // Default => 0x3F (1/64 Duty)
}

void SetDisplayOnOff(u8 ucData)
{
    LED_WrCmd(0xAE|ucData); // Set Display On/Off
                            // Default => 0xAE
                            // 0xAE (0x00) => Display Off
                            // 0xAF (0x01) => Display On
}



void SetStartPage(u8 ucData)
{
    LED_WrCmd(0xB0|ucData); // Set Page Start Address for Page Addressing Mode
                            // Default => 0xB0 (0x00)
}

void SetCommonRemap(u8 ucData)
{
    LED_WrCmd(0xC0|ucData); // Set COM Output Scan Direction
                            // Default => 0xC0
                            // 0xC0 (0x00) => Scan from COM0 to 63
                            // 0xC8 (0x08) => Scan from COM63 to 0
}



void SetDisplayOffset(u8 ucData)
{
    LED_WrCmd(0xD3);        // Set Display Offset
    LED_WrCmd(ucData);      // Default => 0x00
}

void SetDisplayClock(u8 ucData)
{
    LED_WrCmd(0xD5);        // Set Display Clock Divide Ratio / Oscillator Frequency
    LED_WrCmd(ucData);      // Default => 0x80
                            // D[3:0] => Display Clock Divider
                            // D[7:4] => Oscillator Frequency
}

void SetPrechargePeriod(u8 ucData)
{
    LED_WrCmd(0xD9);        // Set Pre-Charge Period
    LED_WrCmd(ucData);      // Default => 0x22 (2 Display Clocks [Phase 2] / 2 Display Clocks [Phase 1])
                            // D[3:0] => Phase 1 Period in 1~15 Display Clocks
                            // D[7:4] => Phase 2 Period in 1~15 Display Clocks
}



void SetCommonConfig(u8 ucData)
{
    LED_WrCmd(0xDA);        // Set COM Pins Hardware Configuration
    LED_WrCmd(0x02|ucData); // Default => 0x12 (0x10)
                            // Alternative COM Pin Configuration
                            // Disable COM Left/Right Re-Map
}

void SetVCOMH(u8 ucData)
{
    LED_WrCmd(0xDB);        // Set VCOMH Deselect Level
    LED_WrCmd(ucData);      // Default => 0x20 (0.77*VCC)
}

void SetNop(void)
{
    LED_WrCmd(0xE3);        // Command for No Operation
}


void LED_Init(void)        
{
    LED_RST = 0;    
    _delay_ms(1);
    LED_RST = 1;
     _delay_ms(1);

    SetDisplayOnOff(0x00);     // Display Off (0x00/0x01)
    SetDisplayClock(0x80);     // Set Clock as 100 Frames/Sec
    SetMultiplexRatio(0x3F);   // 1/64 Duty (0x0F~0x3F)
    SetDisplayOffset(0x00);    // Shift Mapping RAM Counter (0x00~0x3F)
    SetStartLine(0x00);        // Set Mapping RAM Display Start Line (0x00~0x3F)
    SetChargePump(0x04);       // Enable Embedded DC/DC Converter (0x00/0x04)
    _delay_ms(100);
    SetAddressingMode(0x02);   // Set Page Addressing Mode (0x00/0x01/0x02)
    SetSegmentRemap(0x01);     // Set SEG/Column Mapping     0x00左右反置 0x01正常
    SetCommonRemap(0x08);      // Set COM/Row Scan Direction 0x00上下反置 0x08正常
    SetCommonConfig(0x10);     // Set Sequential Configuration (0x00/0x10)
    SetContrastControl(0xCF);  // Set SEG Output Current
    SetPrechargePeriod(0xF1);  // Set Pre-Charge as 15 Clocks & Discharge as 1 Clock
    SetVCOMH(0x40);            // Set VCOM Deselect Level
    SetEntireDisplay(0x00);    // Disable Entire Display On (0x00/0x01)
    SetInverseDisplay(0x00);   // Disable Inverse Display On (0x00/0x01)  
    SetDisplayOnOff(0x01);     // Display On (0x00/0x01)
    LED_Fill(0x00);            //clear the screen
    LED_SetPos(0,0);

    return;
} 

#if F6x8_MODE 
void LED_P6x8Char(u8 ucIdxX, u8 ucIdxY, u8 ucData)
{
    u8 i, ucDataTmp;     
       
    ucDataTmp = ucData-32;
    if(ucIdxX > 122)
    {
        ucIdxX = 0;
        ucIdxY++;
    }
    
    LED_SetPos(ucIdxX, ucIdxY);
    
    for(i = 0; i < 6; i++)
    {     
        LED_WrDat((&F6x8[ucDataTmp][i]));  
    }
}

void LED_P6x8Str(u8 ucIdxX, u8 ucIdxY, u8 ucDataStr[])
{
    u8 i, j, ucDataTmp; 

    for (j = 0; ucDataStr[j] != '\0'; j++)
    {    
        ucDataTmp = ucDataStr[j] - 32;
        if(ucIdxX > 122)
        {
            ucIdxX = 0;
            ucIdxY++;
        }
        
        LED_SetPos(ucIdxX,ucIdxY); 
        
        for(i = 0; i < 6; i++)
        {     
            LED_WrDat((&F6x8[ucDataTmp][i]));  
        }
        ucIdxX += 6;
    }

    return;
}
#endif

#if F8x16_MODE
/*x[0: 120], 8bit */
/*y[0: 3], 1 line*/
void LED_P8x16Str(u8 ucIdxX, u8 ucIdxY, u8 ucDataStr[])
{
    u8 i, j, ucDataTmp;

    ucIdxY <<= 1;
    
    for (j = 0; ucDataStr[j] != '\0'; j++)
    {    
        ucDataTmp = ucDataStr[j] - 32;
        if(ucIdxX > 120)
        {
            ucIdxX = 0;
            ucIdxY += 2;
        }
        LED_SetPos(ucIdxX, ucIdxY);   
        
        for(i = 0; i < 8; i++) 
        {
            LED_WrDat((&F8X16[(ucDataTmp << 4) + i]));
        }
        
        LED_SetPos(ucIdxX, ucIdxY + 1);   
        
        for(i = 0; i < 8; i++) 
        {
            LED_WrDat((&F8X16[(ucDataTmp << 4) + i + 8]));
        }
        ucIdxX += 8;
        
    }

    return;
}
#endif


#if F14x16_MODE
void LED_P14x16Str(u8 ucIdxX,u8 ucIdxY,u8 ucDataStr[])
{
    u8 i, j;
    u16 usAddress; 
    
    ucIdxY <<= 1;
    
    j = 0;
    while(ucDataStr[j] != '\0')
    {
        i = 0;
        usAddress = 1;
        while(F14x16_Idx[i] > 127)
        {
            if(F14x16_Idx[i] == ucDataStr[j])
            {
                if(F14x16_Idx[i + 1] == ucDataStr[j + 1])
                {
                    usAddress = i * 14;
                    break;
                }
            }
            i += 2;            
        }
        
        if(ucIdxX > 114)
        {
            ucIdxX = 0;
            ucIdxY += 2;
        }
        
        if(usAddress != 1)// 显示汉字                   
        {
            LED_SetPos(ucIdxX, ucIdxY);
            for(i = 0; i < 14; i++)               
            {
                LED_WrDat((&F14x16[usAddress]));   
                usAddress++;
            }
            
            LED_SetPos(ucIdxX,ucIdxY + 1); 
            for(i = 0;i < 14;i++)          
            {
                LED_WrDat((&F14x16[usAddress]));
                usAddress++;
            }
            
            j += 2;        
        }
        else              //显示空白字符            
        {
            LED_SetPos(ucIdxX,ucIdxY);
            for(i = 0;i < 14;i++)
            {
                LED_WrDat(0);
            }
            
            LED_SetPos(ucIdxX,ucIdxY + 1);
            for(i = 0;i < 14;i++)
            {           
                LED_WrDat(0);   
            }
            
            j++;
        }
        
        ucIdxX += 14;
    }

    return;
}
#endif


#if F14x16_MODE && F8x16_MODE
void LED_PXx16MixStr(u8 ucIdxX, u8 ucIdxY, u8 ucDataStr[])
{
    u8 ucTmpStr[3];
    u8 i = 0;    
    
    while(ucDataStr[i] != '\0')
    {
        if(ucDataStr[i] > 127)
        {
            ucTmpStr[0] = ucDataStr[i];
            ucTmpStr[1] = ucDataStr[i + 1];
            ucTmpStr[2] = '\0';          //???????
            LED_P14x16Str(ucIdxX, ucIdxY, ucTmpStr);  //????
            ucIdxX += 14;
            i += 2;
        }
        else
        {
            ucTmpStr[0] = ucDataStr[i];    
            ucTmpStr[1] = '\0';          //???????
            LED_P8x16Str(ucIdxX, ucIdxY, ucTmpStr);  //????
            ucIdxX += 8;
            i += 1;
        }
    }

    return;
} 
#endif

#if F6x8_MODE
void LED_PrintChar(u8 ucIdxX, u8 ucIdxY, s8 cData)
{
    u16 i, j, k, usData;

    if(cData < 0)
    {
        LED_P6x8Char(ucIdxX, ucIdxY, '-');
        usData = (u16)(-cData);  
    }
    else
    {
        LED_P6x8Char(ucIdxX, ucIdxY, '+');
        usData = (u16)cData;
    }
    i = usData / 100;
    j = (usData % 100) / 10;
    k = usData % 10;
    
    LED_P6x8Char(ucIdxX+6, ucIdxY, i+48);
    LED_P6x8Char(ucIdxX+12, ucIdxY, j+48);
    LED_P6x8Char(ucIdxX+18, ucIdxY, k+48);   

    return;
}

void LED_PrintShort(u8 ucIdxX, u8 ucIdxY, u16 sData)
{
    u16 i, j, k, l, m, usData;  
    if(sData < 0)
    {
        LED_P6x8Char(ucIdxX,ucIdxY,'-');
        usData = (u16)(-sData);  
    }
    else
    {
        LED_P6x8Char(ucIdxX,ucIdxY,'+');
        usData = (u16)sData;
    }
    
    l = usData / 10000;
    m = (usData % 10000) /1000;
    i = (usData % 1000) / 100;
    j = (usData % 100) / 10;
    k = usData % 10;
    LED_P6x8Char(ucIdxX+6, ucIdxY, l+48);
    LED_P6x8Char(ucIdxX+12, ucIdxY, m+48);
    LED_P6x8Char(ucIdxX+18, ucIdxY, i+48);
    LED_P6x8Char(ucIdxX+24, ucIdxY, j+48);
    LED_P6x8Char(ucIdxX+30, ucIdxY, k+48);  

    return;
}
#endif

void LED_PrintImage(u8 *pucTable, u16 usRowNum, u16 usColumnNum)
{
    u8 ucData;
    u16 i,j,k,m,n;
    u16 usRowTmp;

    m = usRowNum >> 3;
    n = usRowNum % 8;
    
    for(i = 0; i < m; i++)
    {
        LED_SetPos(0,(u8)i);
        usRowTmp = i << 3;
        for(j = 0; j < usColumnNum; j++)
        {
            ucData = 0;
            for(k = 0; k < 8; k++)
            {
                ucData = ucData >> 1;
                if((pucTable + (usRowTmp + k) * usColumnNum)[j] == LED_IMAGE_WHITE)
                {
                    ucData = ucData | 0x80;
                }
                
            }
            LED_WrDat(ucData);
        }
    }
    
    LED_SetPos(0,(u8)i);
    usRowTmp = i << 3;
    for(j = 0; j < usColumnNum; j++)
    {
        ucData = 0;
        for(k = 0; k < n; k++)
        {
            ucData = ucData >> 1;
            if((pucTable + (usRowTmp + k) * usColumnNum)[j] == LED_IMAGE_WHITE)
            {
                ucData = ucData | 0x80;
            }
            
        }
        ucData = ucData >> (8 - n);
        LED_WrDat(ucData);
    }

    return;
}
