   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
   4                     ; Optimizer V4.3.3 - 10 Feb 2010
  34                     ; 31 @interrupt void DefaultInterrupt (void) {
  35                     	scross	off
  36  0000               _DefaultInterrupt:
  38                     ; 32 	return;
  39  0000 80            	iret	
  41                     .const:	section	.text
  42  0000               __vectab:
  43  0000 82            	dc.b	130
  45  0001 00            	dc.b	page(__stext)
  46  0002 0000          	dc.w	__stext
  47  0004 82            	dc.b	130
  49  0005 00            	dc.b	page(_DefaultInterrupt)
  50  0006 0000          	dc.w	_DefaultInterrupt
  51  0008 82            	dc.b	130
  53  0009 00            	dc.b	page(_DefaultInterrupt)
  54  000a 0000          	dc.w	_DefaultInterrupt
  55  000c 82            	dc.b	130
  57  000d 00            	dc.b	page(_DefaultInterrupt)
  58  000e 0000          	dc.w	_DefaultInterrupt
  59  0010 82            	dc.b	130
  61  0011 00            	dc.b	page(_DefaultInterrupt)
  62  0012 0000          	dc.w	_DefaultInterrupt
  63  0014 82            	dc.b	130
  65  0015 00            	dc.b	page(_DefaultInterrupt)
  66  0016 0000          	dc.w	_DefaultInterrupt
  67  0018 82            	dc.b	130
  69  0019 00            	dc.b	page(_DefaultInterrupt)
  70  001a 0000          	dc.w	_DefaultInterrupt
  71  001c 82            	dc.b	130
  73  001d 00            	dc.b	page(_DefaultInterrupt)
  74  001e 0000          	dc.w	_DefaultInterrupt
  75  0020 82            	dc.b	130
  77  0021 00            	dc.b	page(_DefaultInterrupt)
  78  0022 0000          	dc.w	_DefaultInterrupt
  79  0024 82            	dc.b	130
  81  0025 00            	dc.b	page(_DefaultInterrupt)
  82  0026 0000          	dc.w	_DefaultInterrupt
  83  0028 82            	dc.b	130
  85  0029 00            	dc.b	page(_DefaultInterrupt)
  86  002a 0000          	dc.w	_DefaultInterrupt
  87  002c 82            	dc.b	130
  89  002d 00            	dc.b	page(_DefaultInterrupt)
  90  002e 0000          	dc.w	_DefaultInterrupt
  91  0030 82            	dc.b	130
  93  0031 00            	dc.b	page(_DefaultInterrupt)
  94  0032 0000          	dc.w	_DefaultInterrupt
  95  0034 82            	dc.b	130
  97  0035 00            	dc.b	page(_DefaultInterrupt)
  98  0036 0000          	dc.w	_DefaultInterrupt
  99  0038 82            	dc.b	130
 101  0039 00            	dc.b	page(_DefaultInterrupt)
 102  003a 0000          	dc.w	_DefaultInterrupt
 103  003c 82            	dc.b	130
 105  003d 00            	dc.b	page(_DefaultInterrupt)
 106  003e 0000          	dc.w	_DefaultInterrupt
 107  0040 82            	dc.b	130
 109  0041 00            	dc.b	page(_DefaultInterrupt)
 110  0042 0000          	dc.w	_DefaultInterrupt
 111  0044 82            	dc.b	130
 113  0045 00            	dc.b	page(_DefaultInterrupt)
 114  0046 0000          	dc.w	_DefaultInterrupt
 115  0048 82            	dc.b	130
 117  0049 00            	dc.b	page(_DefaultInterrupt)
 118  004a 0000          	dc.w	_DefaultInterrupt
 119  004c 82            	dc.b	130
 121  004d 00            	dc.b	page(_DefaultInterrupt)
 122  004e 0000          	dc.w	_DefaultInterrupt
 123  0050 82            	dc.b	130
 125  0051 00            	dc.b	page(_DefaultInterrupt)
 126  0052 0000          	dc.w	_DefaultInterrupt
 127  0054 82            	dc.b	130
 129  0055 00            	dc.b	page(_DefaultInterrupt)
 130  0056 0000          	dc.w	_DefaultInterrupt
 131  0058 82            	dc.b	130
 133  0059 00            	dc.b	page(_DefaultInterrupt)
 134  005a 0000          	dc.w	_DefaultInterrupt
 135  005c 82            	dc.b	130
 137  005d 00            	dc.b	page(_DefaultInterrupt)
 138  005e 0000          	dc.w	_DefaultInterrupt
 139  0060 82            	dc.b	130
 141  0061 00            	dc.b	page(_DefaultInterrupt)
 142  0062 0000          	dc.w	_DefaultInterrupt
 143  0064 82            	dc.b	130
 145  0065 00            	dc.b	page(_DefaultInterrupt)
 146  0066 0000          	dc.w	_DefaultInterrupt
 147  0068 82            	dc.b	130
 149  0069 00            	dc.b	page(_DefaultInterrupt)
 150  006a 0000          	dc.w	_DefaultInterrupt
 151  006c 82            	dc.b	130
 153  006d 00            	dc.b	page(_DefaultInterrupt)
 154  006e 0000          	dc.w	_DefaultInterrupt
 155  0070 82            	dc.b	130
 157  0071 00            	dc.b	page(_DefaultInterrupt)
 158  0072 0000          	dc.w	_DefaultInterrupt
 159  0074 82            	dc.b	130
 161  0075 00            	dc.b	page(_DefaultInterrupt)
 162  0076 0000          	dc.w	_DefaultInterrupt
 163  0078 82            	dc.b	130
 165  0079 00            	dc.b	page(_DefaultInterrupt)
 166  007a 0000          	dc.w	_DefaultInterrupt
 167  007c 82            	dc.b	130
 169  007d 00            	dc.b	page(_DefaultInterrupt)
 170  007e 0000          	dc.w	_DefaultInterrupt
 171                     	xdef	__vectab
 172                     	xref	__stext
 173                     	xdef	_DefaultInterrupt
 174                     	end

Symbol table:

_DefaultInterrupt   00000000    Defined, Public
                       36    40    49    50    53    54    57    58    61    62
                       65    66    69    70    73    74    77    78    81    82
                       85    86    89    90    93    94    97    98   101   102
                      105   106   109   110   113   114   117   118   121   122
                      125   126   129   130   133   134   137   138   141   142
                      145   146   149   150   153   154   157   158   161   162
                      165   166   169   170
__stext             00000000    Public
                      172    45    46
__vectab            00000000    Defined, Not Referenced, Public
                       42
