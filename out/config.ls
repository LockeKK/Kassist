   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
   4                     ; Optimizer V4.3.3 - 10 Feb 2010
  34                     	bsct
  35  0000               _copy_right:
  36  0000 0063          	dc.w	L5
  37                     .const:	section	.text
  38  0000               _product_info:
  39  0000 01            	dc.b	1
  40  0001 01            	dc.b	1
  41  0002 01            	dc.b	1
  42                     	switch	.data
  43  0000               _ch3_actions:
  44  0000 00            	dc.b	0
  45  0001 01            	dc.b	1
  46  0002 00            	dc.b	0
  47  0003 01            	dc.b	1
  48  0004 01            	dc.b	1
  49  0005 02            	dc.b	2
  50  0006 00            	dc.b	0
  51  0007 02            	dc.b	2
  52  0008 02            	dc.b	2
  53  0009 01            	dc.b	1
  54  000a 01            	dc.b	1
  55  000b 03            	dc.b	3
  56  000c 03            	dc.b	3
  57  000d 00            	dc.b	0
  58  000e ff            	dc.b	255
  59  000f 10            	dc.b	16
  60  0010 04            	dc.b	4
  61  0011 20            	dc.b	32
  62  0012 02            	dc.b	2
  63  0013 11            	dc.b	17
  64  0014 05            	dc.b	5
  65  0015 20            	dc.b	32
  66  0016 03            	dc.b	3
  67  0017 12            	dc.b	18
  68  0018 06            	dc.b	6
  69  0019 40            	dc.b	64
  70  001a 05            	dc.b	5
  71  001b 13            	dc.b	19
  72  001c 07            	dc.b	7
  73  001d 00            	dc.b	0
  74  001e ff            	dc.b	255
  75  001f 11            	dc.b	17
  76  0020 00            	dc.b	0
  77  0021 01            	dc.b	1
  78  0022 00            	dc.b	0
  79  0023 01            	dc.b	1
  80  0024 01            	dc.b	1
  81  0025 02            	dc.b	2
  82  0026 00            	dc.b	0
  83  0027 02            	dc.b	2
  84  0028 02            	dc.b	2
  85  0029 01            	dc.b	1
  86  002a 01            	dc.b	1
  87  002b 03            	dc.b	3
  88  002c 03            	dc.b	3
  89  002d 00            	dc.b	0
  90  002e ff            	dc.b	255
  91  002f 10            	dc.b	16
  92  0030 04            	dc.b	4
  93  0031 20            	dc.b	32
  94  0032 02            	dc.b	2
  95  0033 11            	dc.b	17
  96  0034 05            	dc.b	5
  97  0035 20            	dc.b	32
  98  0036 03            	dc.b	3
  99  0037 12            	dc.b	18
 100  0038 06            	dc.b	6
 101  0039 40            	dc.b	64
 102  003a 05            	dc.b	5
 103  003b 13            	dc.b	19
 104  003c 07            	dc.b	7
 105  003d 00            	dc.b	0
 106  003e ff            	dc.b	255
 107  003f 11            	dc.b	17
 108  0040               _servo_outputs:
 109  0040 00            	dc.b	0
 110  0041 00            	dc.b	0
 111  0042 04            	dc.b	4
 112  0043 00            	dc.b	0
 113  0044 01            	dc.b	1
 114  0045 05dc          	dc.w	1500
 115  0047 0708          	dc.w	1800
 116  0049 07d0          	dc.w	2000
 117  004b 0000          	ds.b	2
 118  004d 00            	dc.b	0
 119  004e 0003          	dc.w	3
 120  0050 0000          	dc.w	0
 121  0052 00            	dc.b	0
 122  0053 00            	ds.b	1
 123  0054 03e8          	dc.w	1000
 124  0056 2328          	dc.w	9000
 125  0058 01            	dc.b	1
 126  0059 00            	dc.b	0
 127  005a 02            	dc.b	2
 128  005b 00            	dc.b	0
 129  005c 01            	dc.b	1
 130  005d 05dc          	dc.w	1500
 131  005f 0708          	dc.w	1800
 132  0061 00000000      	ds.b	4
 133  0065 00            	dc.b	0
 134  0066 0003          	dc.w	3
 135  0068 0000          	dc.w	0
 136  006a ff            	dc.b	255
 137  006b 00            	ds.b	1
 138  006c 03e8          	dc.w	1000
 139  006e 0000          	dc.w	0
 140  0070 02            	dc.b	2
 141  0071 00            	dc.b	0
 142  0072 00            	dc.b	0
 143  0073 00            	dc.b	0
 144  0074 02            	dc.b	2
 145  0075 05dc          	dc.w	1500
 146  0077 000000000000  	ds.b	6
 147  007d 00            	dc.b	0
 148  007e 0000          	dc.w	0
 149  0080 0000          	dc.w	0
 150  0082 ff            	dc.b	255
 151  0083 00            	ds.b	1
 152  0084 0000          	dc.w	0
 153  0086 0000          	dc.w	0
 154  0088 03            	dc.b	3
 155  0089 00            	dc.b	0
 156  008a 00            	dc.b	0
 157  008b 00            	dc.b	0
 158  008c 00            	dc.b	0
 159  008d 05dc          	dc.w	1500
 160  008f 000000000000  	ds.b	6
 161  0095 00            	dc.b	0
 162  0096 0000          	dc.w	0
 163  0098 0000          	dc.w	0
 164  009a ff            	dc.b	255
 165  009b 00            	ds.b	1
 166  009c 0000          	dc.w	0
 167  009e 0000          	dc.w	0
 168  00a0               _rc_channel:
 169  00a0 0000          	dc.w	0
 170  00a2 0000          	dc.w	0
 171  00a4 0000          	dc.w	0
 172  00a6 00            	dc.b	0
 173  00a7 04e2          	dc.w	1250
 174  00a9 05dc          	dc.w	1500
 175  00ab 05aa          	dc.w	1450
 176  00ad 0000          	dc.w	0
 177  00af 0000          	dc.w	0
 178  00b1 0000          	dc.w	0
 179  00b3 00            	dc.b	0
 180  00b4 04e2          	dc.w	1250
 181  00b6 05dc          	dc.w	1500
 182  00b8 05aa          	dc.w	1450
 183  00ba 0000          	dc.w	0
 184  00bc 0000          	dc.w	0
 185  00be 0000          	dc.w	0
 186  00c0 00            	dc.b	0
 187  00c1 04e2          	dc.w	1250
 188  00c3 05dc          	dc.w	1500
 189  00c5 05aa          	dc.w	1450
 190  00c7               _dev_config:
 191  00c7 000c          	dc.w	12
 192  00c9 0064          	dc.w	100
 193  00cb 0019          	dc.w	25
 194  00cd 00fa          	dc.w	250
 195  00cf 000f          	dc.w	15
 196  00d1 0064          	dc.w	100
 197  00d3 0258          	dc.w	600
 198  00d5 09c4          	dc.w	2500
 199  00d7 00fa          	dc.w	250
 200  00d9               L7_config_check:
 201  00d9 00            	dc.b	0
 202  00da 4e            	dc.b	78
 203  00db 4e            	dc.b	78
 204  00dc 01            	dc.b	1
 205  00dd 4e            	dc.b	78
 206  00de 4e            	dc.b	78
 207  00df 02            	dc.b	2
 208  00e0 4d            	dc.b	77
 209  00e1 49            	dc.b	73
 210  00e2 03            	dc.b	3
 211  00e3 4d            	dc.b	77
 212  00e4 49            	dc.b	73
 213  00e5 04            	dc.b	4
 214  00e6 4d            	dc.b	77
 215  00e7 49            	dc.b	73
 216  00e8 05            	dc.b	5
 217  00e9 4d            	dc.b	77
 218  00ea 49            	dc.b	73
 219  00eb 06            	dc.b	6
 220  00ec 4d            	dc.b	77
 221  00ed 49            	dc.b	73
 222  00ee 07            	dc.b	7
 223  00ef 4d            	dc.b	77
 224  00f0 49            	dc.b	73
 225  00f1 08            	dc.b	8
 226  00f2 4d            	dc.b	77
 227  00f3 49            	dc.b	73
 228  00f4 09            	dc.b	9
 229  00f5 4d            	dc.b	77
 230  00f6 49            	dc.b	73
 231  00f7 0a            	dc.b	10
 232  00f8 4d            	dc.b	77
 233  00f9 49            	dc.b	73
 234  00fa 0b            	dc.b	11
 235  00fb 4d            	dc.b	77
 236  00fc 49            	dc.b	73
 237  00fd 0c            	dc.b	12
 238  00fe 43            	dc.b	67
 239  00ff 49            	dc.b	73
 240  0100 0d            	dc.b	13
 241  0101 43            	dc.b	67
 242  0102 49            	dc.b	73
 243  0103 0e            	dc.b	14
 244  0104 43            	dc.b	67
 245  0105 49            	dc.b	73
 246  0106 0f            	dc.b	15
 247  0107 43            	dc.b	67
 248  0108 49            	dc.b	73
 249                     	switch	.const
 250  0003               L11_sys_info:
 251  0003 00            	dc.b	0
 252  0004 52            	dc.b	82
 253  0005 0003          	dc.w	3
 254  0007 0000          	dc.w	0
 255  0009 0000          	dc.w	0
 256  000b 01            	dc.b	1
 257  000c 52            	dc.b	82
 258  000d 0030          	dc.w	48
 259  000f 4000          	dc.w	16384
 260  0011 00d9          	dc.w	L7_config_check
 261  0013 02            	dc.b	2
 262  0014 57            	dc.b	87
 263  0015 0012          	dc.w	18
 264  0017 4030          	dc.w	16432
 265  0019 00c7          	dc.w	_dev_config
 266  001b 03            	dc.b	3
 267  001c 57            	dc.b	87
 268  001d 0040          	dc.w	64
 269  001f 4060          	dc.w	16480
 270  0021 0000          	dc.w	_ch3_actions
 271  0023 04            	dc.b	4
 272  0024 57            	dc.b	87
 273  0025 0020          	dc.w	32
 274  0027 40b0          	dc.w	16560
 275  0029 0006          	dc.w	_th_actions
 276  002b 05            	dc.b	5
 277  002c 57            	dc.b	87
 278  002d 0002          	dc.w	2
 279  002f 4100          	dc.w	16640
 280  0031 0040          	dc.w	_servo_outputs
 281  0033 06            	dc.b	6
 282  0034 57            	dc.b	87
 283  0035 0002          	dc.w	2
 284  0037 4118          	dc.w	16664
 285  0039 0058          	dc.w	_servo_outputs+24
 286  003b 07            	dc.b	7
 287  003c 57            	dc.b	87
 288  003d 0002          	dc.w	2
 289  003f 4130          	dc.w	16688
 290  0041 0070          	dc.w	_servo_outputs+48
 291  0043 08            	dc.b	8
 292  0044 57            	dc.b	87
 293  0045 0002          	dc.w	2
 294  0047 4148          	dc.w	16712
 295  0049 0088          	dc.w	_servo_outputs+72
 296  004b 09            	dc.b	9
 297  004c 00            	dc.b	0
 298  004d 0006          	dc.w	6
 299  004f 4052          	dc.w	16466
 300  0051 0000          	dc.w	_servo_output_endpoint
 301  0053 0a            	dc.b	10
 302  0054 00            	dc.b	0
 303  0055 0001          	dc.w	1
 304  0057 4050          	dc.w	16464
 305  0059 00a6          	dc.w	_rc_channel+6
 306  005b 0b            	dc.b	11
 307  005c 00            	dc.b	0
 308  005d 0001          	dc.w	1
 309  005f 4051          	dc.w	16465
 310  0061 00b3          	dc.w	_rc_channel+19
 311                     	bsct
 312  0002               _global_flags:
 313  0002 0090          	dc.w	144
 314  0004 0003          	dc.w	L11_sys_info
 315                     ; 196 void update_rtr_status(u8 index, u8 tag, bool save)
 315                     ; 197 {
 316                     	scross	off
 317                     	switch	.text
 318  0000               _update_rtr_status:
 319  0000 89            	pushw	x
 320       00000000      OFST:	set	0
 322                     ; 198 	config_check[index].state = tag;
 323  0001 9e            	ld	a,xh
 324  0002 97            	ld	xl,a
 325  0003 a603          	ld	a,#3
 326  0005 42            	mul	x,a
 327  0006 7b02          	ld	a,(OFST+2,sp)
 328  0008 d700db        	ld	(L7_config_check+2,x),a
 329                     ; 199 	fresh_config_check();
 330  000b cd00aa        	call	L3_fresh_config_check
 332                     ; 200 	if (save)	
 333  000e 7b05          	ld	a,(OFST+5,sp)
 334  0010 a501          	bcp	a,#1
 335  0012 2704          	jreq	L31
 336                     ; 201 		save_system_configs(CONFIG_CHECK);
 337  0014 a601          	ld	a,#1
 338  0016 ad45          	call	_save_system_configs
 340  0018               L31:
 341                     ; 202 }
 342  0018 85            	popw	x
 343  0019 81            	ret	
 345                     ; 205 void update_attr_status(u8 index, u8 tag, bool save)
 345                     ; 206 {
 346  001a               _update_attr_status:
 347  001a 89            	pushw	x
 348       00000000      OFST:	set	0
 350                     ; 207 	config_check[index].attr = tag;
 351  001b 9e            	ld	a,xh
 352  001c 97            	ld	xl,a
 353  001d a603          	ld	a,#3
 354  001f 42            	mul	x,a
 355  0020 7b02          	ld	a,(OFST+2,sp)
 356  0022 d700da        	ld	(L7_config_check+1,x),a
 357                     ; 208 	fresh_config_check();
 358  0025 cd00aa        	call	L3_fresh_config_check
 360                     ; 209 	if (save)	
 361  0028 7b05          	ld	a,(OFST+5,sp)
 362  002a a501          	bcp	a,#1
 363  002c 2704          	jreq	L51
 364                     ; 210 		save_system_configs(CONFIG_CHECK);
 365  002e a601          	ld	a,#1
 366  0030 ad2b          	call	_save_system_configs
 368  0032               L51:
 369                     ; 211 }
 370  0032 85            	popw	x
 371  0033 81            	ret	
 373                     ; 213 void load_system_configs(u8 index)
 373                     ; 214 {
 374  0034               _load_system_configs:
 375  0034 88            	push	a
 376  0035 89            	pushw	x
 377       00000002      OFST:	set	2
 379                     ; 217 	if (index >= VAILD_SYS_INFO_MAX)
 380  0036 a10c          	cp	a,#12
 381  0038 2404          	jruge	L22
 382                     ; 218 		return;
 383                     ; 220 	if (index == PRODUCT_INFO)
 384  003a 7b03          	ld	a,(OFST+1,sp)
 385  003c 2603          	jrne	L12
 386                     ; 221 		return;
 387  003e               L22:
 388  003e 5b03          	addw	sp,#3
 389  0040 81            	ret	
 390  0041               L12:
 391                     ; 223 	p = &sys_info[index];
 392  0041 97            	ld	xl,a
 393  0042 a608          	ld	a,#8
 394  0044 42            	mul	x,a
 395  0045 1c0003        	addw	x,#L11_sys_info
 396  0048 1f01          	ldw	(OFST-1,sp),x
 397                     ; 224 	hw_storage_read(p->ram, p->mem, p->size);	
 398  004a ee02          	ldw	x,(2,x)
 399  004c 89            	pushw	x
 400  004d 1e03          	ldw	x,(OFST+1,sp)
 401  004f ee04          	ldw	x,(4,x)
 402  0051 89            	pushw	x
 403  0052 1e05          	ldw	x,(OFST+3,sp)
 404  0054 ee06          	ldw	x,(6,x)
 405  0056 cd0000        	call	_hw_storage_read
 407  0059 5b04          	addw	sp,#4
 408                     ; 225 }
 409  005b 20e1          	jra	L22
 411                     ; 227 void save_system_configs(u8 index)
 411                     ; 228 {
 412  005d               _save_system_configs:
 413  005d 88            	push	a
 414  005e 89            	pushw	x
 415       00000002      OFST:	set	2
 417                     ; 231 	if (index >= VAILD_SYS_INFO_MAX)
 418  005f a10c          	cp	a,#12
 419  0061 2404          	jruge	L03
 420                     ; 232 		return;
 421                     ; 234 	if (index == PRODUCT_INFO)
 422  0063 7b03          	ld	a,(OFST+1,sp)
 423  0065 2603          	jrne	L52
 424                     ; 235 		return;
 425  0067               L03:
 426  0067 5b03          	addw	sp,#3
 427  0069 81            	ret	
 428  006a               L52:
 429                     ; 237 	p = &sys_info[index];
 430  006a 97            	ld	xl,a
 431  006b a608          	ld	a,#8
 432  006d 42            	mul	x,a
 433  006e 1c0003        	addw	x,#L11_sys_info
 434  0071 1f01          	ldw	(OFST-1,sp),x
 435                     ; 238 	hw_storage_write(p->ram, p->mem, p->size);	
 436  0073 ee02          	ldw	x,(2,x)
 437  0075 89            	pushw	x
 438  0076 1e03          	ldw	x,(OFST+1,sp)
 439  0078 ee04          	ldw	x,(4,x)
 440  007a 89            	pushw	x
 441  007b 1e05          	ldw	x,(OFST+3,sp)
 442  007d ee06          	ldw	x,(6,x)
 443  007f cd0000        	call	_hw_storage_write
 445  0082 5b04          	addw	sp,#4
 446                     ; 239 }
 447  0084 20e1          	jra	L03
 449                     ; 241 void load_all_parameters(void)
 449                     ; 242 {
 450  0086               _load_all_parameters:
 451  0086 88            	push	a
 452       00000001      OFST:	set	1
 454                     ; 245 	load_system_configs(CONFIG_CHECK);
 455  0087 a601          	ld	a,#1
 456  0089 ada9          	call	_load_system_configs
 458                     ; 247 	for (i = DEVICE_CONFIG; i < VAILD_SYS_INFO_MAX; i++)
 459  008b a602          	ld	a,#2
 460  008d 6b01          	ld	(OFST+0,sp),a
 461  008f               L72:
 462                     ; 249 		if (config_check[i].state == CONFIGED)
 463  008f 97            	ld	xl,a
 464  0090 a603          	ld	a,#3
 465  0092 42            	mul	x,a
 466  0093 d600db        	ld	a,(L7_config_check+2,x)
 467  0096 a144          	cp	a,#68
 468  0098 2604          	jrne	L53
 469                     ; 251 			load_system_configs(i);
 470  009a 7b01          	ld	a,(OFST+0,sp)
 471  009c ad96          	call	_load_system_configs
 473  009e               L53:
 474                     ; 247 	for (i = DEVICE_CONFIG; i < VAILD_SYS_INFO_MAX; i++)
 475  009e 0c01          	inc	(OFST+0,sp)
 477  00a0 7b01          	ld	a,(OFST+0,sp)
 478  00a2 a10c          	cp	a,#12
 479  00a4 25e9          	jrult	L72
 480                     ; 254 	fresh_config_check();
 481  00a6 ad02          	call	L3_fresh_config_check
 483                     ; 255 }
 484  00a8 84            	pop	a
 485  00a9 81            	ret	
 487                     ; 257 static void fresh_config_check(void)
 487                     ; 258 {
 488  00aa               L3_fresh_config_check:
 489  00aa 89            	pushw	x
 490       00000002      OFST:	set	2
 492                     ; 260 	bool ready_to_go = true;
 493  00ab 7b01          	ld	a,(OFST-1,sp)
 494                     ; 261 	bool ready_for_mp = true;
 495  00ad aa03          	or	a,#3
 496  00af 6b01          	ld	(OFST-1,sp),a
 497                     ; 263 	for (i = 0; i < CONFIG_ITEMS_MAX; i++)
 498  00b1 4f            	clr	a
 499  00b2 6b02          	ld	(OFST+0,sp),a
 500  00b4               L73:
 501                     ; 265 		if (config_check[i].attr == IGNORE)
 502  00b4 97            	ld	xl,a
 503  00b5 a603          	ld	a,#3
 504  00b7 42            	mul	x,a
 505  00b8 d600da        	ld	a,(L7_config_check+1,x)
 506  00bb a14e          	cp	a,#78
 507  00bd 2724          	jreq	L14
 508                     ; 266 			continue;
 509                     ; 268 		if ((config_check[i].attr == MANDATORY) &&
 509                     ; 269 			(config_check[i].state == DEFAULT))
 510  00bf a14d          	cp	a,#77
 511  00c1 260d          	jrne	L74
 513  00c3 d600db        	ld	a,(L7_config_check+2,x)
 514  00c6 a149          	cp	a,#73
 515  00c8 2606          	jrne	L74
 516                     ; 271 			ready_to_go = false;
 517  00ca 7b01          	ld	a,(OFST-1,sp)
 518  00cc a4fe          	and	a,#254
 519  00ce 6b01          	ld	(OFST-1,sp),a
 520  00d0               L74:
 521                     ; 274 		if (i < VAILD_SYS_INFO_MAX)
 522  00d0 7b02          	ld	a,(OFST+0,sp)
 523  00d2 a10c          	cp	a,#12
 524  00d4 240d          	jruge	L14
 525                     ; 276 			ready_for_mp = ready_to_go;
 526  00d6 7b01          	ld	a,(OFST-1,sp)
 527  00d8 a401          	and	a,#1
 528  00da 48            	sll	a
 529  00db 1801          	xor	a,(OFST-1,sp)
 530  00dd a402          	and	a,#2
 531  00df 1801          	xor	a,(OFST-1,sp)
 532  00e1 6b01          	ld	(OFST-1,sp),a
 533  00e3               L14:
 534                     ; 263 	for (i = 0; i < CONFIG_ITEMS_MAX; i++)
 535  00e3 0c02          	inc	(OFST+0,sp)
 537  00e5 7b02          	ld	a,(OFST+0,sp)
 538  00e7 a110          	cp	a,#16
 539  00e9 25c9          	jrult	L73
 540                     ; 280 	global_flags.ready_to_go = ready_to_go; 
 541  00eb 7b01          	ld	a,(OFST-1,sp)
 542  00ed 44            	srl	a
 543  00ee 901b0003      	bccm	_global_flags+1,#5
 544                     ; 281 	global_flags.ready_for_mp = ready_for_mp;
 545  00f2 7b01          	ld	a,(OFST-1,sp)
 546  00f4 44            	srl	a
 547  00f5 44            	srl	a
 548  00f6 901d0003      	bccm	_global_flags+1,#6
 549                     ; 282 }
 550  00fa 85            	popw	x
 551  00fb 81            	ret	
 553                     	xdef	_copy_right
 554                     	xref	_hw_storage_write
 555                     	xref	_hw_storage_read
 556                     	xdef	_save_system_configs
 557                     	xdef	_load_system_configs
 558                     	xdef	_load_all_parameters
 559                     	xdef	_update_attr_status
 560                     	xdef	_update_rtr_status
 561                     	switch	.bss
 562  0000               _servo_output_endpoint:
 563  0000 000000000000  	ds.b	6
 564                     	xdef	_servo_output_endpoint
 565                     	xdef	_rc_channel
 566                     	xdef	_servo_outputs
 567  0006               _th_actions:
 568  0006 000000000000  	ds.b	32
 569                     	xdef	_th_actions
 570                     	xdef	_ch3_actions
 571                     	xdef	_dev_config
 572                     	xdef	_product_info
 573                     	xdef	_global_flags
 574                     	switch	.const
 575  0063               L5:
 576  0063 6c6f636b652e  	dc.b	"locke.huang@gmail."
 577  0075 636f6d00      	dc.b	"com",0
 578                     	end

Symbol table:

L03                      00000067    Defined
                           425   419   447
L11_sys_info             00000003    Defined
                           250   314   395   433
L12                      00000041    Defined
                           390   385
L14                      000000e3    Defined
                           533   507   524
L22                      0000003e    Defined
                           387   381   409
L31                      00000018    Defined
                           340   335
L3_fresh_config_check    000000aa    Defined
                           488   330   358   481   552
L5                       00000063    Defined
                           575    36
L51                      00000032    Defined
                           368   363
L52                      0000006a    Defined
                           428   423
L53                      0000009e    Defined
                           473   468
L72                      0000008f    Defined
                           461   479
L73                      000000b4    Defined
                           500   539
L74                      000000d0    Defined
                           520   511   515
L7_config_check          000000d9    Defined
                           200   260   328   356   466   505   513
OFST                     00000002    Defined, Absolute
                           320   327   333   355   361   384   396   400   403   422
                           434   438   441   460   470   475   477   493   496   499
                           517   519   522   526   529   531   532   535   537   541
                           545
_ch3_actions             00000000    Defined, Public
                            43   270
_copy_right              00000000    Defined, Not Referenced, Public, Zero Page
                            35
_dev_config              000000c7    Defined, Public
                           190   265
_global_flags            00000002    Defined, Public, Zero Page
                           312   543   548
_hw_storage_read         00000000    Public
                           555   405
_hw_storage_write        00000000    Public
                           554   443
_load_all_parameters     00000086    Defined, Public
                           450   486
_load_system_configs     00000034    Defined, Public
                           374   410   456   471
_product_info            00000000    Defined, Not Referenced, Public
                            38
_rc_channel              000000a0    Defined, Public
                           168   305   310
_save_system_configs     0000005d    Defined, Public
                           412   338   366   448
_servo_output_endpoint   00000000    Defined, Public
                           562   300
_servo_outputs           00000040    Defined, Public
                           108   280   285   290   295
_th_actions              00000006    Defined, Public
                           567   275
_update_attr_status      0000001a    Defined, Public
                           346   372
_update_rtr_status       00000000    Defined, Public
                           318   344
