   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
   4                     ; Optimizer V4.3.3 - 10 Feb 2010
  34                     ; 31 void init_servo_output(void)
  34                     ; 32 {
  35                     	scross	off
  36  0000               _init_servo_output:
  37  0000 5206          	subw	sp,#6
  38       00000006      OFST:	set	6
  40                     ; 34 	u16 servo_pulse = 0;
  41                     ; 66 	for(i = 0; i < CH_MAX; i++)
  42  0002 4f            	clr	a
  43  0003 6b06          	ld	(OFST+0,sp),a
  44  0005               L35:
  45                     ; 68 		if (servo_outputs[i].mp_setup_done)
  46  0005 97            	ld	xl,a
  47  0006 a618          	ld	a,#24
  48  0008 42            	mul	x,a
  49  0009 d6000d        	ld	a,(_servo_outputs+13,x)
  50  000c 2603cc009a    	jreq	L16
  51                     ; 70 			switch (servo_outputs[i].type)
  52  0011 d60004        	ld	a,(_servo_outputs+4,x)
  54                     ; 90 					break;
  55  0014 4a            	dec	a
  56  0015 2705          	jreq	L74
  57  0017 4a            	dec	a
  58  0018 274b          	jreq	L15
  59  001a 207e          	jra	L16
  60  001c               L74:
  61                     ; 72 				case SERVO_TYPE_MP:					
  61                     ; 73 					temp = (u8)servo_outputs[i].pos_config.pos_default;
  62  001c d6000f        	ld	a,(_servo_outputs+15,x)
  63  001f a478          	and	a,#120
  64  0021 44            	srl	a
  65  0022 44            	srl	a
  66  0023 44            	srl	a
  67  0024 6b05          	ld	(OFST-1,sp),a
  68                     ; 74 					servo_outputs[i].pos_config.current = temp;
  69  0026 48            	sll	a
  70  0027 48            	sll	a
  71  0028 48            	sll	a
  72  0029 d8000e        	xor	a,(_servo_outputs+14,x)
  73  002c a478          	and	a,#120
  74  002e d8000e        	xor	a,(_servo_outputs+14,x)
  75  0031 d7000e        	ld	(_servo_outputs+14,x),a
  76                     ; 75 					servo_pulse = servo_outputs[i].position[temp];
  77  0034 5f            	clrw	x
  78  0035 7b05          	ld	a,(OFST-1,sp)
  79  0037 97            	ld	xl,a
  80  0038 58            	sllw	x
  81  0039 1f01          	ldw	(OFST-5,sp),x
  82                     ; 77 					servo_counter[i] = servo_outputs[i].sp.active_tmo;				
  83  003b 7b06          	ld	a,(OFST+0,sp)
  84  003d 97            	ld	xl,a
  85  003e a618          	ld	a,#24
  86  0040 42            	mul	x,a
  87  0041 7b06          	ld	a,(OFST+0,sp)
  88  0043 905f          	clrw	y
  89  0045 9097          	ld	yl,a
  90  0047 9058          	sllw	y
  91  0049 de0014        	ldw	x,(_servo_outputs+20,x)
  92  004c 90ef0a        	ldw	(L5_servo_counter,y),x
  93                     ; 78 					servo_active[i] = true;
  94  004f 5f            	clrw	x
  95  0050 97            	ld	xl,a
  96  0051 a601          	ld	a,#1
  97  0053 e706          	ld	(L7_servo_active,x),a
  98                     ; 79 					servo_outputs[i].pos_config.mp_update = true;
  99  0055 7b06          	ld	a,(OFST+0,sp)
 100  0057 97            	ld	xl,a
 101  0058 a618          	ld	a,#24
 102  005a 42            	mul	x,a
 103  005b d60011        	ld	a,(_servo_outputs+17,x)
 104  005e aa01          	or	a,#1
 105  0060 d70011        	ld	(_servo_outputs+17,x),a
 106                     ; 80 					break;
 107  0063 2035          	jra	L16
 108  0065               L15:
 109                     ; 82 				case SERVO_TYPE_SWITCH:					
 109                     ; 83 					servo_outputs[i].position[0] = servo_output_endpoint.centre;					
 110  0065 90ce0002      	ldw	y,_servo_output_endpoint+2
 111  0069 df0005        	ldw	(_servo_outputs+5,x),y
 112                     ; 84 					servo_outputs[i].position[1] = servo_output_endpoint.right;
 113  006c 90ce0004      	ldw	y,_servo_output_endpoint+4
 114  0070 df0007        	ldw	(_servo_outputs+7,x),y
 115                     ; 85 					servo_outputs[i].pos_config.toggle = 0;
 116  0073 d6000e        	ld	a,(_servo_outputs+14,x)
 117  0076 a47f          	and	a,#127
 118  0078 d7000e        	ld	(_servo_outputs+14,x),a
 119                     ; 86 					servo_outputs[i].pos_config.current;
 120                     ; 87 					temp = (u8)servo_outputs[i].pos_config.pos_default;
 121  007b d6000f        	ld	a,(_servo_outputs+15,x)
 122  007e a478          	and	a,#120
 123  0080 44            	srl	a
 124  0081 44            	srl	a
 125  0082 44            	srl	a
 126  0083 6b05          	ld	(OFST-1,sp),a
 127                     ; 88 					servo_outputs[i].pos_config.current = temp;
 128  0085 48            	sll	a
 129  0086 48            	sll	a
 130  0087 48            	sll	a
 131  0088 d8000e        	xor	a,(_servo_outputs+14,x)
 132  008b a478          	and	a,#120
 133  008d d8000e        	xor	a,(_servo_outputs+14,x)
 134  0090 d7000e        	ld	(_servo_outputs+14,x),a
 135                     ; 89 					servo_pulse = servo_outputs[i].position[temp];
 136  0093 5f            	clrw	x
 137  0094 7b05          	ld	a,(OFST-1,sp)
 138  0096 97            	ld	xl,a
 139  0097 58            	sllw	x
 140  0098 1f01          	ldw	(OFST-5,sp),x
 141                     ; 90 					break;
 142  009a               L16:
 143                     ; 66 	for(i = 0; i < CH_MAX; i++)
 144  009a 0c06          	inc	(OFST+0,sp)
 146  009c 7b06          	ld	a,(OFST+0,sp)
 147  009e a104          	cp	a,#4
 148  00a0 2403cc0005    	jrult	L35
 149                     ; 98 }
 150  00a5 5b06          	addw	sp,#6
 151  00a7 81            	ret	
 153                     ; 100 void update_servo_output(void)
 153                     ; 101 {
 154  00a8               _update_servo_output:
 155  00a8 5207          	subw	sp,#7
 156       00000007      OFST:	set	7
 158                     ; 107 	if (!global_flags.ready_to_go)
 159  00aa 720b00012b    	btjf	_global_flags+1,#5,L21
 160                     ; 109 		return;
 161                     ; 112 	for (ch = 0; ch < CH_MAX; ch++)
 162  00af 4f            	clr	a
 163  00b0 6b07          	ld	(OFST+0,sp),a
 164  00b2               L101:
 165                     ; 114 		sout = &servo_outputs[ch];			
 166  00b2 97            	ld	xl,a
 167  00b3 a618          	ld	a,#24
 168  00b5 42            	mul	x,a
 169  00b6 1c0000        	addw	x,#_servo_outputs
 170  00b9 1f05          	ldw	(OFST-2,sp),x
 171                     ; 115 		pos_configs = &servo_outputs[ch].pos_config;
 172  00bb 7b07          	ld	a,(OFST+0,sp)
 173  00bd 97            	ld	xl,a
 174  00be a618          	ld	a,#24
 175  00c0 42            	mul	x,a
 176  00c1 1c000e        	addw	x,#_servo_outputs+14
 177  00c4 1f01          	ldw	(OFST-6,sp),x
 178                     ; 117 		if (sout->mp_setup_done == false)
 179  00c6 1e05          	ldw	x,(OFST-2,sp)
 180  00c8 e60d          	ld	a,(13,x)
 181  00ca 271e          	jreq	L301
 182                     ; 118 			continue;
 183                     ; 120 		if (sout->enabled == false)
 184  00cc e601          	ld	a,(1,x)
 185  00ce 271a          	jreq	L301
 186                     ; 121 			continue;
 187                     ; 123 		switch (ch)
 188  00d0 7b07          	ld	a,(OFST+0,sp)
 190                     ; 134 			default:
 190                     ; 135 				return;
 191  00d2 2710          	jreq	L37
 192  00d4 4a            	dec	a
 193  00d5 2706          	jreq	L76
 194  00d7 4a            	dec	a
 195  00d8 2710          	jreq	L301
 197  00da               L21:
 198  00da 5b07          	addw	sp,#7
 199  00dc 81            	ret	
 200  00dd               L76:
 201                     ; 125 			case SERVO_TYPE_MP:
 201                     ; 126 				servo_pulse = calculate_servo_activeness(ch);
 202  00dd 7b07          	ld	a,(OFST+0,sp)
 203  00df cd0458        	call	L54_calculate_servo_activeness
 205                     ; 127 				break;
 206  00e2 2006          	jra	L301
 207                     ; 128 			case SERVO_TYPE_SWITCH:
 207                     ; 129 				servo_pulse = sout->position[pos_configs->current];
 208                     ; 130 				break;
 209  00e4               L37:
 210                     ; 131 			case SERVO_TYPE_WHEEL:
 210                     ; 132 				servo_pulse = calculate_servo_pulse(rc_channel[ST].normalized);
 211  00e4 ce0002        	ldw	x,_rc_channel+2
 212  00e7 cd041d        	call	L34_calculate_servo_pulse
 214                     ; 133 				break;
 215  00ea               L301:
 216                     ; 112 	for (ch = 0; ch < CH_MAX; ch++)
 217  00ea 0c07          	inc	(OFST+0,sp)
 219  00ec 7b07          	ld	a,(OFST+0,sp)
 220  00ee a104          	cp	a,#4
 221  00f0 25c0          	jrult	L101
 222                     ; 139 }
 223  00f2 20e6          	jra	L21
 225                     ; 141 bool if_under_setup_actions(void)
 225                     ; 142 {
 226  00f4               _if_under_setup_actions:
 228                     ; 143 	return (if_reversing_setup_done() ||
 228                     ; 144 			if_steel_setup_done() ||
 228                     ; 145 			if_servo_output_setup_done());
 229  00f4 cd01fd        	call	L71_if_reversing_setup_done
 231  00f7 4d            	tnz	a
 232  00f8 260c          	jrne	L02
 233  00fa cd02ce        	call	L72_if_steel_setup_done
 235  00fd 4d            	tnz	a
 236  00fe 2606          	jrne	L02
 237  0100 cd03b3        	call	L73_if_servo_output_setup_done
 239  0103 4d            	tnz	a
 240  0104 2702          	jreq	L61
 241  0106               L02:
 242  0106 a601          	ld	a,#1
 243  0108               L61:
 245  0108 81            	ret	
 247                     ; 148 void input_user_acknowledge(u8 ch3_clicks)
 247                     ; 149 {
 248  0109               _input_user_acknowledge:
 250                     ; 150 	if (ch3_clicks == 1)
 251  0109 4a            	dec	a
 252  010a 2605          	jrne	L711
 253                     ; 151 		user_confirmed = true;
 254  010c 72100000      	bset	L3_user_confirmed
 256  0110 81            	ret	
 257  0111               L711:
 258                     ; 153 		user_confirmed = false;
 259  0111 72110000      	bres	L3_user_confirmed
 260                     ; 154 }
 261  0115 81            	ret	
 263                     	bsct
 264  0000               L321_dip_switch_value:
 265  0000 07            	dc.b	7
 266  0001               L521_dip_switch_counter:
 267  0001 00000000      	dc.l	0
 268                     ; 156 void check_setup_mode(void)
 268                     ; 157 {
 269                     	switch	.text
 270  0116               _check_setup_mode:
 271  0116 88            	push	a
 272       00000001      OFST:	set	1
 274                     ; 162     if (!global_flags.systick) 
 275  0117 7200000102    	btjt	_global_flags+1,#0,L721
 276                     ; 164 		return;
 277  011c 84            	pop	a
 278  011d 81            	ret	
 279  011e               L721:
 280                     ; 167 	dip = get_dip_state();
 281  011e cd0000        	call	_get_dip_state
 283  0121 6b01          	ld	(OFST+0,sp),a
 284                     ; 169 	if (dip_switch_value != dip)
 285  0123 b600          	ld	a,L321_dip_switch_value
 286  0125 1101          	cp	a,(OFST+0,sp)
 287  0127 270b          	jreq	L131
 288                     ; 171 		dip_switch_counter = 0;
 289  0129 5f            	clrw	x
 290  012a bf03          	ldw	L521_dip_switch_counter+2,x
 291  012c bf01          	ldw	L521_dip_switch_counter,x
 292                     ; 172 		dip_switch_value = dip;
 293  012e 7b01          	ld	a,(OFST+0,sp)
 294  0130 b700          	ld	L321_dip_switch_value,a
 296  0132 2008          	jra	L331
 297  0134               L131:
 298                     ; 176 		dip_switch_counter++;
 299  0134 ae0001        	ldw	x,#L521_dip_switch_counter
 300  0137 a601          	ld	a,#1
 301  0139 cd0000        	call	c_lgadc
 303  013c               L331:
 304                     ; 180 	if (dip_switch_counter > dev_config.dip_state_timeout)
 305  013c ce0006        	ldw	x,_dev_config+6
 306  013f cd0000        	call	c_uitolx
 308  0142 ae0001        	ldw	x,#L521_dip_switch_counter
 309  0145 cd0000        	call	c_lcmp
 311  0148 2404          	jruge	L531
 312                     ; 182 		enter_setup_mode(dip_switch_value);
 313  014a b600          	ld	a,L321_dip_switch_value
 314  014c ad02          	call	L11_enter_setup_mode
 316  014e               L531:
 317                     ; 185 }
 318  014e 84            	pop	a
 319  014f 81            	ret	
 321                     	bsct
 322  0005               L731_last_dip:
 323  0005 ff            	dc.b	255
 324                     ; 187 static void enter_setup_mode(u8 dip)
 324                     ; 188 {
 325                     	switch	.text
 326  0150               L11_enter_setup_mode:
 327  0150 88            	push	a
 328       00000000      OFST:	set	0
 330                     ; 191 	if (dip == last_dip)
 331  0151 b105          	cp	a,L731_last_dip
 332  0153 275a          	jreq	L351
 333                     ; 193 		goto setup_phase;
 334                     ; 197 	if (if_reversing_setup_done() == false)
 335  0155 cd01fd        	call	L71_if_reversing_setup_done
 337  0158 4d            	tnz	a
 338  0159 260d          	jrne	L751
 339                     ; 199 		stop_reversing_setup();
 340  015b cd01eb        	call	L51_stop_reversing_setup
 342                     ; 200 		load_system_configs(REVERSING_ST);
 343  015e a60a          	ld	a,#10
 344  0160 cd0000        	call	_load_system_configs
 346                     ; 201 		load_system_configs(REVERSING_TH);		
 347  0163 a60b          	ld	a,#11
 348  0165 cd0000        	call	_load_system_configs
 350  0168               L751:
 351                     ; 203 	if (if_steel_setup_done() == false)
 352  0168 cd02ce        	call	L72_if_steel_setup_done
 354  016b 4d            	tnz	a
 355  016c 2608          	jrne	L161
 356                     ; 205 		stop_steel_setup();
 357  016e cd02be        	call	L52_stop_steel_setup
 359                     ; 206 		load_system_configs(SERVO_ENDPOINTS);		
 360  0171 a609          	ld	a,#9
 361  0173 cd0000        	call	_load_system_configs
 363  0176               L161:
 364                     ; 208 	if (if_servo_output_setup_done() == false)
 365  0176 cd03b3        	call	L73_if_servo_output_setup_done
 367  0179 4d            	tnz	a
 368  017a 260a          	jrne	L361
 369                     ; 210 		stop_servo_output_setup();
 370  017c cd03a3        	call	L53_stop_servo_output_setup
 372                     ; 211 		load_system_configs((u8)(SERVO_OUTPUT_BASE + last_dip));		
 373  017f b605          	ld	a,L731_last_dip
 374  0181 ab05          	add	a,#5
 375  0183 cd0000        	call	_load_system_configs
 377  0186               L361:
 378                     ; 214 	switch (dip)
 379  0186 7b01          	ld	a,(OFST+1,sp)
 381                     ; 232 		default:
 381                     ; 233 			break;
 382  0188 2719          	jreq	L741
 383  018a 4a            	dec	a
 384  018b 2716          	jreq	L741
 385  018d 4a            	dec	a
 386  018e 2713          	jreq	L741
 387  0190 4a            	dec	a
 388  0191 2710          	jreq	L741
 389  0193 4a            	dec	a
 390  0194 2708          	jreq	L541
 391  0196 a002          	sub	a,#2
 392  0198 2615          	jrne	L351
 393                     ; 216 		case NORMAL_MODE:
 393                     ; 217 			break;
 394                     ; 219 		case REVERSING_SETUP:
 394                     ; 220 			start_reversing_setup();
 395  019a ad2a          	call	L31_start_reversing_setup
 397                     ; 221 			break;
 398  019c 2011          	jra	L351
 399  019e               L541:
 400                     ; 222 		case STEEL_SETUP:
 400                     ; 223 			start_steel_setup();
 401  019e cd028f        	call	L32_start_steel_setup
 403                     ; 224 			break;			
 404  01a1 200c          	jra	L351
 405  01a3               L741:
 406                     ; 225 		case PWM0_SETUP:
 406                     ; 226 		case PWM1_SETUP:
 406                     ; 227 		case PWM2_SETUP:
 406                     ; 228 		case PWM3_SETUP:
 406                     ; 229 			start_servo_output_setup(&servo_outputs[dip]);
 407  01a3 7b01          	ld	a,(OFST+1,sp)
 408  01a5 97            	ld	xl,a
 409  01a6 a618          	ld	a,#24
 410  01a8 42            	mul	x,a
 411  01a9 1c0000        	addw	x,#_servo_outputs
 412  01ac cd034d        	call	L33_start_servo_output_setup
 414                     ; 230 			break;
 415  01af               L351:
 416                     ; 236 setup_phase:
 416                     ; 237 	last_dip = dip;
 417  01af 7b01          	ld	a,(OFST+1,sp)
 418  01b1 b705          	ld	L731_last_dip,a
 419                     ; 238 	do_reversing_setup();
 420  01b3 ad53          	call	L12_do_reversing_setup
 422                     ; 239 	do_steel_setup();
 423  01b5 cd02d9        	call	L13_do_steel_setup
 425                     ; 240 	do_servo_output_setup(&servo_outputs[dip]);
 426  01b8 7b01          	ld	a,(OFST+1,sp)
 427  01ba 97            	ld	xl,a
 428  01bb a618          	ld	a,#24
 429  01bd 42            	mul	x,a
 430  01be 1c0000        	addw	x,#_servo_outputs
 431  01c1 cd03be        	call	L14_do_servo_output_setup
 433                     ; 241 }
 434  01c4 84            	pop	a
 435  01c5 81            	ret	
 436                     ; 232 		default:
 436                     ; 233 			break;
 438                     ; 244 static void start_reversing_setup(void)
 438                     ; 245 {
 439  01c6               L31_start_reversing_setup:
 441                     ; 246 	global_flags.reversing_setup = REVERSING_SETUP_STEERING |
 441                     ; 247 								   REVERSING_SETUP_THROTTLE;
 442  01c6 72160000      	bset	_global_flags,#3
 443  01ca 72180000      	bset	_global_flags,#4
 444                     ; 248 	user_confirmed = false;
 445                     ; 250 	update_rtr_status(REVERSING_ST, DEFAULT, true);		
 446  01ce 4b01          	push	#1
 447  01d0 72110000      	bres	L3_user_confirmed
 448  01d4 ae0049        	ldw	x,#73
 449  01d7 a60a          	ld	a,#10
 450  01d9 95            	ld	xh,a
 451  01da cd0000        	call	_update_rtr_status
 453  01dd 84            	pop	a
 454                     ; 251 	update_rtr_status(REVERSING_TH, DEFAULT, true);
 455  01de 4b01          	push	#1
 456  01e0 ae0049        	ldw	x,#73
 457  01e3 a60b          	ld	a,#11
 458  01e5 95            	ld	xh,a
 459  01e6 cd0000        	call	_update_rtr_status
 461  01e9 84            	pop	a
 462                     ; 252 }
 463  01ea 81            	ret	
 465                     ; 254 static void stop_reversing_setup(void)
 465                     ; 255 {
 466  01eb               L51_stop_reversing_setup:
 468                     ; 256 	global_flags.reversing_setup = REVERSING_SETUP_OFF;	
 469  01eb 72170000      	bres	_global_flags,#3
 470                     ; 257 	beep_notify(TASK_NG);
 471  01ef a601          	ld	a,#1
 472  01f1 72190000      	bres	_global_flags,#4
 473  01f5 cd0000        	call	_beep_notify
 475                     ; 258 	user_confirmed = false;
 476  01f8 72110000      	bres	L3_user_confirmed
 477                     ; 259 }
 478  01fc 81            	ret	
 480                     ; 261 static bool if_reversing_setup_done(void)
 480                     ; 262 {
 481  01fd               L71_if_reversing_setup_done:
 483                     ; 263 	return global_flags.reversing_setup == REVERSING_SETUP_OFF;
 484  01fd b600          	ld	a,_global_flags
 485  01ff a518          	bcp	a,#24
 486  0201 2603          	jrne	L021
 487  0203 a601          	ld	a,#1
 488  0205 81            	ret	
 489  0206               L021:
 490  0206 4f            	clr	a
 492  0207 81            	ret	
 494                     ; 266 static void do_reversing_setup(void)
 494                     ; 267 {
 495  0208               L12_do_reversing_setup:
 497                     ; 268     if (!global_flags.rc_update_event) {
 498  0208 7202000101    	btjt	_global_flags+1,#1,L171
 499                     ; 269         return;
 500  020d 81            	ret	
 501  020e               L171:
 502                     ; 272     if (global_flags.reversing_setup == REVERSING_SETUP_OFF) {
 503  020e b600          	ld	a,_global_flags
 504  0210 a518          	bcp	a,#24
 505  0212 2601          	jrne	L371
 506                     ; 273         return;
 507  0214 81            	ret	
 508  0215               L371:
 509                     ; 276     if (global_flags.reversing_setup & REVERSING_SETUP_STEERING) {
 510  0215 a508          	bcp	a,#8
 511  0217 2724          	jreq	L571
 512                     ; 277         if (rc_channel[ST].absolute > 50) {
 513  0219 ce0004        	ldw	x,_rc_channel+4
 514  021c a30033        	cpw	x,#51
 515  021f 251c          	jrult	L571
 516                     ; 283             if (rc_channel[ST].normalized > 0) {
 517  0221 9c            	rvf	
 518  0222 ce0002        	ldw	x,_rc_channel+2
 519  0225 2d0c          	jrsle	L102
 520                     ; 284                 rc_channel[ST].reversed = (u8)!!rc_channel[ST].reversed;
 521  0227 c60006        	ld	a,_rc_channel+6
 522  022a 2702          	jreq	L621
 523  022c a601          	ld	a,#1
 524  022e               L621:
 525  022e c70006        	ld	_rc_channel+6,a
 526  0231 b600          	ld	a,_global_flags
 527  0233               L102:
 528                     ; 287             global_flags.reversing_setup -= REVERSING_SETUP_STEERING;
 529  0233 a008          	sub	a,#8
 530  0235 b800          	xor	a,_global_flags
 531  0237 a41f          	and	a,#31
 532  0239 b800          	xor	a,_global_flags
 533  023b b700          	ld	_global_flags,a
 534                     
 535  023d               L571:
 536                     ; 291     if (global_flags.reversing_setup & REVERSING_SETUP_THROTTLE) {
 537  023d a510          	bcp	a,#16
 538  023f 2723          	jreq	L302
 539                     ; 292         if (rc_channel[TH].absolute > 20) {
 540  0241 ce0011        	ldw	x,_rc_channel+17
 541  0244 a30015        	cpw	x,#21
 542  0247 251b          	jrult	L302
 543                     ; 298             if (rc_channel[TH].normalized < 0) {
 544  0249 ce000f        	ldw	x,_rc_channel+15
 545  024c 2a0c          	jrpl	L702
 546                     ; 299                 rc_channel[TH].reversed = (u8)!!rc_channel[TH].reversed;
 547  024e c60013        	ld	a,_rc_channel+19
 548  0251 2702          	jreq	L231
 549  0253 a601          	ld	a,#1
 550  0255               L231:
 551  0255 c70013        	ld	_rc_channel+19,a
 552  0258 b600          	ld	a,_global_flags
 553  025a               L702:
 554                     ; 301             global_flags.reversing_setup -= REVERSING_SETUP_THROTTLE;
 555  025a a010          	sub	a,#16
 556  025c b800          	xor	a,_global_flags
 557  025e a41f          	and	a,#31
 558  0260 b800          	xor	a,_global_flags
 559  0262 b700          	ld	_global_flags,a
 560                     
 561  0264               L302:
 562                     ; 305     if (global_flags.reversing_setup == REVERSING_SETUP_OFF) {
 563  0264 a518          	bcp	a,#24
 564  0266 2626          	jrne	L112
 565                     ; 306         save_system_configs(REVERSING_ST);
 566  0268 a60a          	ld	a,#10
 567  026a cd0000        	call	_save_system_configs
 569                     ; 307         save_system_configs(REVERSING_TH);
 570  026d a60b          	ld	a,#11
 571  026f cd0000        	call	_save_system_configs
 573                     ; 308 		update_rtr_status(REVERSING_ST, CONFIGED, true);		
 574  0272 4b01          	push	#1
 575  0274 ae0044        	ldw	x,#68
 576  0277 a60a          	ld	a,#10
 577  0279 95            	ld	xh,a
 578  027a cd0000        	call	_update_rtr_status
 580  027d 84            	pop	a
 581                     ; 309 		update_rtr_status(REVERSING_TH, CONFIGED, true);
 582  027e 4b01          	push	#1
 583  0280 ae0044        	ldw	x,#68
 584  0283 a60b          	ld	a,#11
 585  0285 95            	ld	xh,a
 586  0286 cd0000        	call	_update_rtr_status
 588  0289 84            	pop	a
 589                     ; 310 		beep_notify(TASK_DONE);
 590  028a 4f            	clr	a
 591  028b cd0000        	call	_beep_notify
 593  028e               L112:
 594                     ; 312 }
 595  028e 81            	ret	
 597                     ; 314 static void start_steel_setup(void)
 597                     ; 315 {
 598  028f               L32_start_steel_setup:
 600                     ; 317 	servo_output_endpoint.left = 900;
 601  028f ae0384        	ldw	x,#900
 602  0292 cf0000        	ldw	_servo_output_endpoint,x
 603                     ; 318 	servo_output_endpoint.centre = 1500;
 604  0295 ae05dc        	ldw	x,#1500
 605  0298 cf0002        	ldw	_servo_output_endpoint+2,x
 606                     ; 319 	servo_output_endpoint.right = 2100;
 607  029b ae0834        	ldw	x,#2100
 608  029e cf0004        	ldw	_servo_output_endpoint+4,x
 609                     ; 320     global_flags.steel_setup = STEEL_SETUP_LEFT;	
 610  02a1 721b0000      	bres	_global_flags,#5
 611  02a5 721c0000      	bset	_global_flags,#6
 612  02a9 721f0000      	bres	_global_flags,#7
 613                     ; 321 	user_confirmed = false;
 614                     ; 322 	update_rtr_status(SERVO_ENDPOINTS, DEFAULT, true);
 615  02ad 4b01          	push	#1
 616  02af 72110000      	bres	L3_user_confirmed
 617  02b3 ae0049        	ldw	x,#73
 618  02b6 a609          	ld	a,#9
 619  02b8 95            	ld	xh,a
 620  02b9 cd0000        	call	_update_rtr_status
 622  02bc 84            	pop	a
 623                     ; 323 }
 624  02bd 81            	ret	
 626                     ; 325 static void stop_steel_setup(void)
 626                     ; 326 {
 627  02be               L52_stop_steel_setup:
 629                     ; 327     global_flags.steel_setup = STEEL_SETUP_OFF;	
 630  02be b600          	ld	a,_global_flags
 631  02c0 a41f          	and	a,#31
 632  02c2 b700          	ld	_global_flags,a
 633                     ; 328 	beep_notify(TASK_NG);
 634  02c4 a601          	ld	a,#1
 635  02c6 cd0000        	call	_beep_notify
 637                     ; 329 	user_confirmed = false;
 638  02c9 72110000      	bres	L3_user_confirmed
 639                     ; 330 }
 640  02cd 81            	ret	
 642                     ; 332 static bool if_steel_setup_done(void)
 642                     ; 333 {
 643  02ce               L72_if_steel_setup_done:
 645                     ; 334     return global_flags.steel_setup == STEEL_SETUP_OFF;	
 646  02ce b600          	ld	a,_global_flags
 647  02d0 a5e0          	bcp	a,#224
 648  02d2 2603          	jrne	L261
 649  02d4 a601          	ld	a,#1
 650  02d6 81            	ret	
 651  02d7               L261:
 652  02d7 4f            	clr	a
 654  02d8 81            	ret	
 656                     	switch	.ubsct
 657  0000               L312_steel_setup_ep:
 658  0000 000000000000  	ds.b	6
 659                     ; 337 static void do_steel_setup(void)
 659                     ; 338 {
 660                     	switch	.text
 661  02d9               L13_do_steel_setup:
 662  02d9 89            	pushw	x
 663       00000002      OFST:	set	2
 665                     ; 342     if (global_flags.steel_setup == STEEL_SETUP_OFF) 
 666  02da b600          	ld	a,_global_flags
 667  02dc a5e0          	bcp	a,#224
 668  02de 270d          	jreq	L671
 669                     ; 344 		return;
 670                     ; 347     servo_pulse = calculate_servo_pulse(rc_channel[ST].normalized);
 671  02e0 ce0002        	ldw	x,_rc_channel+2
 672  02e3 cd041d        	call	L34_calculate_servo_pulse
 674  02e6 1f01          	ldw	(OFST-1,sp),x
 675                     ; 349 	if (!user_confirmed)
 676  02e8 7200000002    	btjt	L3_user_confirmed,L722
 677                     ; 351 		return;
 678  02ed               L671:
 679  02ed 85            	popw	x
 680  02ee 81            	ret	
 681  02ef               L722:
 682                     ; 354 	switch (global_flags.steel_setup)
 683  02ef b600          	ld	a,_global_flags
 684  02f1 4e            	swap	a
 685  02f2 a40e          	and	a,#14
 686  02f4 44            	srl	a
 688                     ; 377 		default:
 688                     ; 378 			break;
 689  02f5 4a            	dec	a
 690  02f6 2719          	jreq	L712
 691  02f8 4a            	dec	a
 692  02f9 2706          	jreq	L512
 693  02fb a002          	sub	a,#2
 694  02fd 2722          	jreq	L122
 695  02ff 2046          	jra	L332
 696  0301               L512:
 697                     ; 356 		case STEEL_SETUP_LEFT:
 697                     ; 357 			steel_setup_ep.left = servo_pulse;
 698  0301 bf00          	ldw	L312_steel_setup_ep,x
 699                     ; 358 			global_flags.steel_setup = STEEL_SETUP_CENTRE;
 700  0303 721a0000      	bset	_global_flags,#5
 701  0307 721d0000      	bres	_global_flags,#6
 702  030b 721f0000      	bres	_global_flags,#7
 703                     ; 359 			break;
 704  030f 2036          	jra	L332
 705  0311               L712:
 706                     ; 361 		case STEEL_SETUP_CENTRE:
 706                     ; 362 			steel_setup_ep.centre = servo_pulse;
 707  0311 bf02          	ldw	L312_steel_setup_ep+2,x
 708                     ; 363 			global_flags.steel_setup = STEEL_SETUP_RIGHT;
 709  0313 721b0000      	bres	_global_flags,#5
 710  0317 721d0000      	bres	_global_flags,#6
 711  031b 721e0000      	bset	_global_flags,#7
 712                     ; 364 			break;
 713  031f 2026          	jra	L332
 714  0321               L122:
 715                     ; 366 		case STEEL_SETUP_RIGHT:
 715                     ; 367 			steel_setup_ep.right = servo_pulse;
 716  0321 bf04          	ldw	L312_steel_setup_ep+4,x
 717                     ; 369 			servo_output_endpoint.right = steel_setup_ep.right;
 718  0323 cf0004        	ldw	_servo_output_endpoint+4,x
 719                     ; 370 			servo_output_endpoint.centre = steel_setup_ep.centre;
 720  0326 be02          	ldw	x,L312_steel_setup_ep+2
 721  0328 cf0002        	ldw	_servo_output_endpoint+2,x
 722                     ; 371 			servo_output_endpoint.left = steel_setup_ep.left;
 723  032b be00          	ldw	x,L312_steel_setup_ep
 724  032d cf0000        	ldw	_servo_output_endpoint,x
 725                     ; 372 			save_system_configs(SERVO_ENDPOINTS);
 726  0330 a609          	ld	a,#9
 727  0332 cd0000        	call	_save_system_configs
 729                     ; 373 			update_rtr_status(SERVO_ENDPOINTS, CONFIGED, true);
 730  0335 4b01          	push	#1
 731  0337 ae0044        	ldw	x,#68
 732  033a a609          	ld	a,#9
 733  033c 95            	ld	xh,a
 734  033d cd0000        	call	_update_rtr_status
 736  0340 84            	pop	a
 737                     ; 374 			global_flags.steel_setup = STEEL_SETUP_OFF;
 738  0341 b600          	ld	a,_global_flags
 739  0343 a41f          	and	a,#31
 740  0345 b700          	ld	_global_flags,a
 741                     ; 375 			break;
 742                     ; 377 		default:
 742                     ; 378 			break;
 743  0347               L332:
 744                     ; 381 	user_confirmed = false;
 745  0347 72110000      	bres	L3_user_confirmed
 746                     ; 382 }
 747  034b 20a0          	jra	L671
 749                     ; 384 static void start_servo_output_setup(SERVO_OUTPUTS_T *sout)
 749                     ; 385 {
 750  034d               L33_start_servo_output_setup:
 751  034d 89            	pushw	x
 752  034e 88            	push	a
 753       00000001      OFST:	set	1
 755                     ; 388 	if (sout->enabled == false || global_flags.ready_for_mp == false)
 756  034f e601          	ld	a,(1,x)
 757  0351 272c          	jreq	L012
 759  0353 720c000102    	btjt	_global_flags+1,#6,L532
 760                     ; 389 		return;
 761  0358 2025          	jra	L012
 762  035a               L532:
 763                     ; 391 	target = (u8)(SERVO_POSITION_BASE + sout->channel);
 764  035a 1e02          	ldw	x,(OFST+1,sp)
 765  035c f6            	ld	a,(x)
 766  035d ab0c          	add	a,#12
 767  035f 6b01          	ld	(OFST+0,sp),a
 768                     ; 394 	if(sout->type == SERVO_TYPE_WHEEL || sout->type == SERVO_TYPE_SWITCH)
 769  0361 e604          	ld	a,(4,x)
 770  0363 2704          	jreq	L342
 772  0365 a102          	cp	a,#2
 773  0367 2619          	jrne	L142
 774  0369               L342:
 775                     ; 396 		beep_notify(TASK_DONE);
 776  0369 4f            	clr	a
 777  036a cd0000        	call	_beep_notify
 779                     ; 397 		sout->mp_setup_done = true;		
 780  036d 1e02          	ldw	x,(OFST+1,sp)
 781  036f a601          	ld	a,#1
 782  0371 e70d          	ld	(13,x),a
 783                     ; 398 		update_attr_status(target, MANDATORY, true);
 784  0373 4b01          	push	#1
 785  0375 ae004d        	ldw	x,#77
 786  0378 7b02          	ld	a,(OFST+1,sp)
 787  037a 95            	ld	xh,a
 788  037b cd0000        	call	_update_attr_status
 790  037e               LC001:
 791  037e 84            	pop	a
 792                     ; 400 		return;
 793  037f               L012:
 794  037f 5b03          	addw	sp,#3
 795  0381 81            	ret	
 796  0382               L142:
 797                     ; 403 	sout->mp_setup_done = false;
 798  0382 6f0d          	clr	(13,x)
 799                     ; 404     sout->index = 0;
 800  0384 6f03          	clr	(3,x)
 801                     ; 405     global_flags.servo_output_setup = SERVO_OUTPUT_SETUP_START;	
 802  0386 72100000      	bset	_global_flags,#0
 803  038a 72130000      	bres	_global_flags,#1
 804  038e 72150000      	bres	_global_flags,#2
 805                     ; 406 	user_confirmed = false;	
 806                     ; 407 	update_rtr_status(target, DEFAULT, true);
 807  0392 4b01          	push	#1
 808  0394 72110000      	bres	L3_user_confirmed
 809  0398 ae0049        	ldw	x,#73
 810  039b 7b02          	ld	a,(OFST+1,sp)
 811  039d 95            	ld	xh,a
 812  039e cd0000        	call	_update_rtr_status
 814                     ; 408 }
 815  03a1 20db          	jp	LC001
 817                     ; 410 static void stop_servo_output_setup(void)
 817                     ; 411 {
 818  03a3               L53_stop_servo_output_setup:
 820                     ; 412     global_flags.servo_output_setup = SERVO_OUTPUT_SETUP_OFF;	
 821  03a3 b600          	ld	a,_global_flags
 822  03a5 a4f8          	and	a,#248
 823  03a7 b700          	ld	_global_flags,a
 824                     ; 413 	beep_notify(TASK_NG);
 825  03a9 a601          	ld	a,#1
 826  03ab cd0000        	call	_beep_notify
 828                     ; 414 	user_confirmed = false;
 829  03ae 72110000      	bres	L3_user_confirmed
 830                     ; 415 }
 831  03b2 81            	ret	
 833                     ; 417 static bool if_servo_output_setup_done(void)
 833                     ; 418 {
 834  03b3               L73_if_servo_output_setup_done:
 836                     ; 419     return global_flags.servo_output_setup == SERVO_OUTPUT_SETUP_OFF;	
 837  03b3 b600          	ld	a,_global_flags
 838  03b5 a507          	bcp	a,#7
 839  03b7 2603          	jrne	L022
 840  03b9 a601          	ld	a,#1
 841  03bb 81            	ret	
 842  03bc               L022:
 843  03bc 4f            	clr	a
 845  03bd 81            	ret	
 847                     ; 422 static void do_servo_output_setup(SERVO_OUTPUTS_T *sout)
 847                     ; 423 {
 848  03be               L14_do_servo_output_setup:
 849  03be 89            	pushw	x
 850  03bf 5203          	subw	sp,#3
 851       00000003      OFST:	set	3
 853                     ; 427     if (global_flags.servo_output_setup == SERVO_OUTPUT_SETUP_OFF) 
 854  03c1 b600          	ld	a,_global_flags
 855  03c3 a507          	bcp	a,#7
 856  03c5 270c          	jreq	L632
 857                     ; 429 		return;
 858                     ; 432     servo_pulse = calculate_servo_pulse(rc_channel[ST].normalized);
 859  03c7 ce0002        	ldw	x,_rc_channel+2
 860  03ca ad51          	call	L34_calculate_servo_pulse
 862  03cc 1f01          	ldw	(OFST-2,sp),x
 863                     ; 435 	if (!user_confirmed)
 864  03ce 7200000003    	btjt	L3_user_confirmed,L742
 865                     ; 437 		return;
 866  03d3               L632:
 867  03d3 5b05          	addw	sp,#5
 868  03d5 81            	ret	
 869  03d6               L742:
 870                     ; 440 	if (global_flags.servo_output_setup == SERVO_OUTPUT_SETUP_START)
 871  03d6 b600          	ld	a,_global_flags
 872  03d8 a407          	and	a,#7
 873  03da 4a            	dec	a
 874  03db 263a          	jrne	L152
 875                     ; 442 		sout->position[sout->index++] = servo_pulse;
 876  03dd 1e04          	ldw	x,(OFST+1,sp)
 877  03df e603          	ld	a,(3,x)
 878  03e1 6c03          	inc	(3,x)
 879  03e3 5f            	clrw	x
 880  03e4 97            	ld	xl,a
 881  03e5 58            	sllw	x
 882  03e6 72fb04        	addw	x,(OFST+1,sp)
 883  03e9 1601          	ldw	y,(OFST-2,sp)
 884  03eb ef05          	ldw	(5,x),y
 885                     ; 444 		if (sout->index == sout->max_nb)
 886  03ed 1e04          	ldw	x,(OFST+1,sp)
 887  03ef e603          	ld	a,(3,x)
 888  03f1 e102          	cp	a,(2,x)
 889  03f3 2622          	jrne	L152
 890                     ; 446 			sout->mp_setup_done = true;
 891  03f5 a601          	ld	a,#1
 892  03f7 e70d          	ld	(13,x),a
 893                     ; 447 			global_flags.servo_output_setup = SERVO_OUTPUT_SETUP_OFF;
 894  03f9 b600          	ld	a,_global_flags
 895  03fb a4f8          	and	a,#248
 896  03fd b700          	ld	_global_flags,a
 897                     ; 448 			chn = sout->channel;
 898  03ff f6            	ld	a,(x)
 899                     ; 449 			target = (u8)(SERVO_POSITION_BASE + chn);
 900  0400 ab0c          	add	a,#12
 901  0402 6b03          	ld	(OFST+0,sp),a
 902                     ; 450 			save_system_configs(target);
 903  0404 cd0000        	call	_save_system_configs
 905                     ; 451 			update_rtr_status(target, CONFIGED, true);
 906  0407 4b01          	push	#1
 907  0409 ae0044        	ldw	x,#68
 908  040c 7b04          	ld	a,(OFST+1,sp)
 909  040e 95            	ld	xh,a
 910  040f cd0000        	call	_update_rtr_status
 912  0412 84            	pop	a
 913                     ; 452 			beep_notify(TASK_DONE);
 914  0413 4f            	clr	a
 915  0414 cd0000        	call	_beep_notify
 917  0417               L152:
 918                     ; 456 	user_confirmed = false;
 919  0417 72110000      	bres	L3_user_confirmed
 920                     ; 457 }
 921  041b 20b6          	jra	L632
 923                     ; 459 static u16 calculate_servo_pulse(s16 normalized)
 923                     ; 460 {
 924  041d               L34_calculate_servo_pulse:
 925  041d 89            	pushw	x
 926  041e 5204          	subw	sp,#4
 927       00000004      OFST:	set	4
 929                     ; 463     if (normalized < 0) {
 930  0420 5d            	tnzw	x
 931  0421 2a1d          	jrpl	L552
 932                     ; 464         servo_pulse = servo_output_endpoint.centre -
 932                     ; 465             (((servo_output_endpoint.centre - servo_output_endpoint.left) *
 932                     ; 466                 (-normalized)) / 100);
 933  0423 ce0002        	ldw	x,_servo_output_endpoint+2
 934  0426 72b00000      	subw	x,_servo_output_endpoint
 935  042a 1605          	ldw	y,(OFST+1,sp)
 936  042c 9050          	negw	y
 937  042e cd0000        	call	c_imul
 939  0431 90ae0064      	ldw	y,#100
 940  0435 65            	divw	x,y
 941  0436 1f01          	ldw	(OFST-3,sp),x
 942  0438 ce0002        	ldw	x,_servo_output_endpoint+2
 943  043b 72f001        	subw	x,(OFST-3,sp)
 945  043e 2015          	jra	L752
 946  0440               L552:
 947                     ; 469         servo_pulse = servo_output_endpoint.centre +
 947                     ; 470             (((servo_output_endpoint.right - servo_output_endpoint.centre) *
 947                     ; 471                 (normalized)) / 100);
 948  0440 ce0004        	ldw	x,_servo_output_endpoint+4
 949  0443 72b00002      	subw	x,_servo_output_endpoint+2
 950  0447 1605          	ldw	y,(OFST+1,sp)
 951  0449 cd0000        	call	c_imul
 953  044c 90ae0064      	ldw	y,#100
 954  0450 65            	divw	x,y
 955  0451 72bb0002      	addw	x,_servo_output_endpoint+2
 956  0455               L752:
 957                     ; 474 	return servo_pulse;
 959  0455 5b06          	addw	sp,#6
 960  0457 81            	ret	
 962                     ; 477 static u16 calculate_servo_activeness(u8 ch)
 962                     ; 478 {
 963  0458               L54_calculate_servo_activeness:
 964  0458 88            	push	a
 965  0459 5206          	subw	sp,#6
 966       00000006      OFST:	set	6
 968                     ; 483 	sout = &servo_outputs[ch];			
 969  045b 97            	ld	xl,a
 970  045c a618          	ld	a,#24
 971  045e 42            	mul	x,a
 972  045f 1c0000        	addw	x,#_servo_outputs
 973  0462 1f05          	ldw	(OFST-1,sp),x
 974                     ; 484 	pos_configs = &servo_outputs[ch].pos_config;
 975  0464 7b07          	ld	a,(OFST+1,sp)
 976  0466 97            	ld	xl,a
 977  0467 a618          	ld	a,#24
 978  0469 42            	mul	x,a
 979  046a 1c000e        	addw	x,#_servo_outputs+14
 980  046d 1f03          	ldw	(OFST-3,sp),x
 981                     ; 485 	servo_pulse = sout->position[pos_configs->current];
 982  046f f6            	ld	a,(x)
 983  0470 a478          	and	a,#120
 984  0472 44            	srl	a
 985  0473 44            	srl	a
 986  0474 44            	srl	a
 987  0475 5f            	clrw	x
 988  0476 02            	rlwa	x,a
 989  0477 58            	sllw	x
 990  0478 72fb05        	addw	x,(OFST-1,sp)
 991  047b ee05          	ldw	x,(5,x)
 992  047d 1f01          	ldw	(OFST-5,sp),x
 993                     ; 487 	if (sout->type != SERVO_TYPE_MP)
 994  047f 1e05          	ldw	x,(OFST-1,sp)
 995  0481 e604          	ld	a,(4,x)
 996  0483 4a            	dec	a
 997                     ; 489 		return servo_pulse;
 999  0484 266c          	jrne	L562
1000                     ; 492 	if (pos_configs->mp_update)
1001  0486 1e03          	ldw	x,(OFST-3,sp)
1002  0488 e603          	ld	a,(3,x)
1003  048a a501          	bcp	a,#1
1004  048c 2719          	jreq	L362
1005                     ; 494 		pos_configs->mp_update = false;
1006  048e a4fe          	and	a,#254
1007  0490 e703          	ld	(3,x),a
1008                     ; 495 		servo_counter[ch] = sout->sp.active_tmo;				
1009  0492 7b07          	ld	a,(OFST+1,sp)
1010  0494 1e05          	ldw	x,(OFST-1,sp)
1011  0496 905f          	clrw	y
1012  0498 9097          	ld	yl,a
1013  049a 9058          	sllw	y
1014  049c ee14          	ldw	x,(20,x)
1015  049e 90ef0a        	ldw	(L5_servo_counter,y),x
1016                     ; 496 		servo_active[ch] = true;		
1017  04a1 5f            	clrw	x
1018  04a2 97            	ld	xl,a
1019  04a3 a601          	ld	a,#1
1020  04a5 e706          	ld	(L7_servo_active,x),a
1021  04a7               L362:
1022                     ; 499 	if (sout->sp.idle_tmo && global_flags.systick) 
1023  04a7 1e05          	ldw	x,(OFST-1,sp)
1024  04a9 e617          	ld	a,(23,x)
1025  04ab ea16          	or	a,(22,x)
1026  04ad 2743          	jreq	L562
1028  04af 720100013e    	btjf	_global_flags+1,#0,L562
1029                     ; 501 		if (--servo_counter[ch] == 0)
1030  04b4 7b07          	ld	a,(OFST+1,sp)
1031  04b6 5f            	clrw	x
1032  04b7 97            	ld	xl,a
1033  04b8 58            	sllw	x
1034  04b9 9093          	ldw	y,x
1035  04bb ee0a          	ldw	x,(L5_servo_counter,x)
1036  04bd 5a            	decw	x
1037  04be 90ef0a        	ldw	(L5_servo_counter,y),x
1038  04c1 262f          	jrne	L562
1039                     ; 503 			if (servo_active[ch]) 
1040  04c3 5f            	clrw	x
1041  04c4 97            	ld	xl,a
1042  04c5 6d06          	tnz	(L7_servo_active,x)
1043  04c7 2716          	jreq	L172
1044                     ; 505 				servo_counter[ch] = sout->sp.idle_tmo;
1045  04c9 1e05          	ldw	x,(OFST-1,sp)
1046  04cb 905f          	clrw	y
1047  04cd 9097          	ld	yl,a
1048  04cf 9058          	sllw	y
1049  04d1 ee16          	ldw	x,(22,x)
1050  04d3 90ef0a        	ldw	(L5_servo_counter,y),x
1051                     ; 506 				servo_active[ch] = false;				
1052  04d6 5f            	clrw	x
1053  04d7 97            	ld	xl,a
1054  04d8 6f06          	clr	(L7_servo_active,x)
1055                     ; 507 				servo_pulse = 0;
1056  04da 5f            	clrw	x
1057  04db 1f01          	ldw	(OFST-5,sp),x
1059  04dd 2013          	jra	L562
1060  04df               L172:
1061                     ; 511 				servo_counter[ch] = sout->sp.active_tmo;				
1062  04df 1e05          	ldw	x,(OFST-1,sp)
1063  04e1 905f          	clrw	y
1064  04e3 9097          	ld	yl,a
1065  04e5 9058          	sllw	y
1066  04e7 ee14          	ldw	x,(20,x)
1067  04e9 90ef0a        	ldw	(L5_servo_counter,y),x
1068                     ; 512 				servo_active[ch] = true;
1069  04ec 5f            	clrw	x
1070  04ed 97            	ld	xl,a
1071  04ee a601          	ld	a,#1
1072  04f0 e706          	ld	(L7_servo_active,x),a
1073  04f2               L562:
1074                     ; 517 	return servo_pulse;
1076  04f2 1e01          	ldw	x,(OFST-5,sp)
1077  04f4 5b07          	addw	sp,#7
1078  04f6 81            	ret	
1080                     ; 520 static void servo_output_manually(u8 channel, s16 normalized)
1080                     ; 521 {
1081  04f7               L572_servo_output_manually:
1082  04f7 88            	push	a
1083  04f8 89            	pushw	x
1084       00000002      OFST:	set	2
1086                     ; 524 	servo_pulse = calculate_servo_pulse(normalized);
1087  04f9 1e06          	ldw	x,(OFST+4,sp)
1088  04fb cd041d        	call	L34_calculate_servo_pulse
1090                     ; 526 }
1091  04fe 5b03          	addw	sp,#3
1092  0500 81            	ret	
1094                     	switch	.ubsct
1095  0006               L7_servo_active:
1096  0006 00000000      	ds.b	4
1097  000a               L5_servo_counter:
1098  000a 000000000000  	ds.b	8
1099                     .bit:	section	.data,bit
1100  0000               L3_user_confirmed:
1101  0000 00            	ds.b	1
1102                     	xref	_get_dip_state
1103                     	xref	_beep_notify
1104                     	xref	_save_system_configs
1105                     	xref	_load_system_configs
1106                     	xref	_update_attr_status
1107                     	xref	_update_rtr_status
1108                     	xdef	_check_setup_mode
1109                     	xdef	_input_user_acknowledge
1110                     	xdef	_if_under_setup_actions
1111                     	xdef	_update_servo_output
1112                     	xdef	_init_servo_output
1113                     	xref	_servo_output_endpoint
1114                     	xref	_rc_channel
1115                     	xref	_servo_outputs
1116                     	xref	_dev_config
1117                     	xref.b	_global_flags
1118                     	xref.b	c_x
1119                     	xref	c_imul
1120                     	xref	c_lcmp
1121                     	xref	c_uitolx
1122                     	xref	c_lgadc
1123                     	end

Symbol table:

L012                             0000037f    Defined
                                   793   757   761
L02                              00000106    Defined
                                   241   232   236
L021                             00000206    Defined
                                   489   486
L022                             000003bc    Defined
                                   842   839
L101                             000000b2    Defined
                                   164   221
L102                             00000233    Defined
                                   527   519
L112                             0000028e    Defined
                                   593   564
L11_enter_setup_mode             00000150    Defined
                                   326   314   437
L122                             00000321    Defined
                                   714   694
L12_do_reversing_setup           00000208    Defined
                                   495   420   596
L131                             00000134    Defined
                                   297   287
L13_do_steel_setup               000002d9    Defined
                                   661   423   748
L142                             00000382    Defined
                                   796   773
L14_do_servo_output_setup        000003be    Defined
                                   848   431   922
L15                              00000065    Defined
                                   108    58
L152                             00000417    Defined
                                   917   874   889
L16                              0000009a    Defined
                                   142    50    59   107
L161                             00000176    Defined
                                   363   355
L171                             0000020e    Defined
                                   501   498
L172                             000004df    Defined
                                  1060  1043
L21                              000000da    Defined
                                   197   159   223
L231                             00000255    Defined
                                   550   548
L261                             000002d7    Defined
                                   651   648
L301                             000000ea    Defined
                                   215   181   185   195   206
L302                             00000264    Defined
                                   561   538   542
L312_steel_setup_ep              00000000    Defined, Zero Page
                                   657   698   707   716   720   723
L31_start_reversing_setup        000001c6    Defined
                                   439   395   464
L321_dip_switch_value            00000000    Defined, Zero Page
                                   264   285   294   313
L32_start_steel_setup            0000028f    Defined
                                   598   401   625
L331                             0000013c    Defined
                                   303   296
L332                             00000347    Defined
                                   743   695   704   713
L33_start_servo_output_setup     0000034d    Defined
                                   750   412   816
L342                             00000369    Defined
                                   774   770
L34_calculate_servo_pulse        0000041d    Defined
                                   924   212   672   860   961  1088
L35                              00000005    Defined
                                    44   148
L351                             000001af    Defined
                                   415   332   392   398   404
L361                             00000186    Defined
                                   377   368
L362                             000004a7    Defined
                                  1021  1004
L37                              000000e4    Defined
                                   209   191
L371                             00000215    Defined
                                   508   505
L3_user_confirmed                00000000    Defined
                                  1100   254   259   447   476   616   638   676   745   808
                                   829   864   919
L512                             00000301    Defined
                                   696   692
L51_stop_reversing_setup         000001eb    Defined
                                   466   340   479
L521_dip_switch_counter          00000001    Defined, Zero Page
                                   266   290   291   299   308
L52_stop_steel_setup             000002be    Defined
                                   627   357   641
L531                             0000014e    Defined
                                   316   311
L532                             0000035a    Defined
                                   762   759
L53_stop_servo_output_setup      000003a3    Defined
                                   818   370   832
L541                             0000019e    Defined
                                   399   390
L54_calculate_servo_activeness   00000458    Defined
                                   963   203  1079
L552                             00000440    Defined
                                   946   931
L562                             000004f2    Defined
                                  1073   999  1026  1028  1038  1059
L571                             0000023d    Defined
                                   535   511   515
L572_servo_output_manually       000004f7    Defined
                                  1081  1093
L5_servo_counter                 0000000a    Defined, Zero Page
                                  1097    92  1015  1035  1037  1050  1067
L61                              00000108    Defined
                                   243   240
L621                             0000022e    Defined
                                   524   522
L632                             000003d3    Defined
                                   866   856   921
L671                             000002ed    Defined
                                   678   668   747
L702                             0000025a    Defined
                                   553   545
L711                             00000111    Defined
                                   257   252
L712                             00000311    Defined
                                   705   690
L71_if_reversing_setup_done      000001fd    Defined
                                   481   229   335   493
L721                             0000011e    Defined
                                   279   275
L722                             000002ef    Defined
                                   681   676
L72_if_steel_setup_done          000002ce    Defined
                                   643   233   352   655
L731_last_dip                    00000005    Defined, Zero Page
                                   322   331   373   418
L73_if_servo_output_setup_done   000003b3    Defined
                                   834   237   365   846
L74                              0000001c    Defined
                                    60    56
L741                             000001a3    Defined
                                   405   382   384   386   388
L742                             000003d6    Defined
                                   869   864
L751                             00000168    Defined
                                   350   338
L752                             00000455    Defined
                                   956   945
L76                              000000dd    Defined
                                   200   193
L7_servo_active                  00000006    Defined, Zero Page
                                  1095    97  1020  1042  1054  1072
LC001                            0000037e    Defined
                                   790   815
OFST                             00000002    Defined, Absolute
                                    38    43    67    78    81    83    87    99   126   137
                                   140   144   146   163   170   172   177   179   188   202
                                   217   219   283   286   293   379   407   417   426   674
                                   764   767   780   786   810   862   876   882   883   886
                                   901   908   935   941   943   950   973   975   980   990
                                   992   994  1001  1009  1010  1023  1030  1045  1057  1062
                                  1076  1087
_beep_notify                     00000000    Public
                                  1103   473   591   635   777   826   915
_check_setup_mode                00000116    Defined, Public
                                   270   320
_dev_config                      00000000    Public
                                  1116   305
_get_dip_state                   00000000    Public
                                  1102   281
_global_flags                    00000000    Public, Zero Page
                                  1117   159   275   442   443   469   472   484   498   503
                                   526   530   532   533   552   556   558   559   610   611
                                   612   630   632   646   666   683   700   701   702   709
                                   710   711   738   740   759   802   803   804   821   823
                                   837   854   871   894   896  1028
_if_under_setup_actions          000000f4    Defined, Public
                                   226   246
_init_servo_output               00000000    Defined, Public
                                    36   152
_input_user_acknowledge          00000109    Defined, Public
                                   248   262
_load_system_configs             00000000    Public
                                  1105   344   348   361   375
_rc_channel                      00000000    Public
                                  1114   211   513   518   521   525   540   544   547   551
                                   671   859
_save_system_configs             00000000    Public
                                  1104   567   571   727   903
_servo_output_endpoint           00000000    Public
                                  1113   110   113   602   605   608   718   721   724   933
                                   934   942   948   949   955
_servo_outputs                   00000000    Public
                                  1115    49    52    62    72    74    75    91   103   105
                                   111   114   116   118   121   131   133   134   169   176
                                   411   430   972   979
_update_attr_status              00000000    Public
                                  1106   788
_update_rtr_status               00000000    Public
                                  1107   451   459   578   586   620   734   812   910
_update_servo_output             000000a8    Defined, Public
                                   154   224
c_imul                           00000000    Public
                                  1119   937   951
c_lcmp                           00000000    Public
                                  1120   309
c_lgadc                          00000000    Public
                                  1122   301
c_uitolx                         00000000    Public
                                  1121   306
c_x                              00000000    Not Referenced, Public, Zero Page
                                  1118
