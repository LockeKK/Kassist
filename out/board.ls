   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
   4                     ; Optimizer V4.3.3 - 10 Feb 2010
  34                     ; 24 void board_int(void)
  34                     ; 25 {
  35                     	scross	off
  36  0000               _board_int:
  38                     ; 27 }
  39  0000 81            	ret	
  41                     ; 29 void reboot(void)
  41                     ; 30 {
  42  0001               _reboot:
  44                     ; 32 }
  45  0001 81            	ret	
  47                     ; 34 void delay(u16 ms)
  47                     ; 35 {
  48  0002               _delay:
  50                     ; 37 }
  51  0002 81            	ret	
  53                     ; 39 bool get_ch3_state(void)
  53                     ; 40 {
  54  0003               _get_ch3_state:
  56                     ; 41 	return 0;
  57  0003 4f            	clr	a
  59  0004 81            	ret	
  61                     ; 44 u8 get_dip_state(void)
  61                     ; 45 {
  62  0005               _get_dip_state:
  64                     ; 46 	return 0;
  65  0005 4f            	clr	a
  67  0006 81            	ret	
  69                     ; 49 u8 get_ch3_profile(void)
  69                     ; 50 {
  70  0007               _get_ch3_profile:
  72                     ; 51 	return 0;
  73  0007 4f            	clr	a
  75  0008 81            	ret	
  77                     ; 54 u8 beep_notify(u8 beep)
  77                     ; 55 {
  78  0009               _beep_notify:
  80                     ; 56 	return 0;
  81  0009 4f            	clr	a
  83  000a 81            	ret	
  85                     ; 59 void led(u8 led)
  85                     ; 60 {
  86  000b               _led:
  88                     ; 62 }
  89  000b 81            	ret	
  91                     	xdef	_led
  92                     	xdef	_beep_notify
  93                     	xdef	_get_ch3_profile
  94                     	xdef	_get_dip_state
  95                     	xdef	_get_ch3_state
  96                     	xdef	_delay
  97                     	xdef	_reboot
  98                     	xdef	_board_int
  99                     	end

Symbol table:

_beep_notify       00000009    Defined, Public
                      78    84
_board_int         00000000    Defined, Public
                      36    40
_delay             00000002    Defined, Public
                      48    52
_get_ch3_profile   00000007    Defined, Public
                      70    76
_get_ch3_state     00000003    Defined, Public
                      54    60
_get_dip_state     00000005    Defined, Public
                      62    68
_led               0000000b    Defined, Public
                      86    90
_reboot            00000001    Defined, Public
                      42    46
