   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
   4                     ; Optimizer V4.3.3 - 10 Feb 2010
  34                     	switch	.ubsct
  35  0000               L32_decode_stage:
  36  0000 00            	ds.b	1
  37  0001               L52_chksum:
  38  0001 00            	ds.b	1
  39  0002               L13_rx_length:
  40  0002 00            	ds.b	1
  41  0003               L72_total_length:
  42  0003 00            	ds.b	1
  43                     ; 18 void cmd_frame_decode(u8 data)
  43                     ; 19 {
  44                     	scross	off
  45                     	switch	.text
  46  0000               _cmd_frame_decode:
  47  0000 88            	push	a
  48       00000000      OFST:	set	0
  50                     ; 26 	if (cmd_frame_received)
  51  0001 7201000102    	btjf	L3_cmd_frame_received,L15
  52                     ; 28 		return;
  53  0006 84            	pop	a
  54  0007 81            	ret	
  55  0008               L15:
  56                     ; 31 	switch (decode_stage)
  57  0008 b600          	ld	a,L32_decode_stage
  59                     ; 92 		default:
  59                     ; 93 			break;
  60  000a 2711          	jreq	L33
  61  000c 4a            	dec	a
  62  000d 271c          	jreq	L53
  63  000f 4a            	dec	a
  64  0010 272b          	jreq	L73
  65  0012 4a            	dec	a
  66  0013 273a          	jreq	L14
  67  0015 4a            	dec	a
  68  0016 274d          	jreq	L34
  69  0018 4a            	dec	a
  70  0019 2766          	jreq	L54
  71  001b 2070          	jra	L55
  72  001d               L33:
  73                     ; 33 		case FRAME_BOF0:
  73                     ; 34 			if (data == FRAME_BOF0_KEY)
  74  001d 7b01          	ld	a,(OFST+1,sp)
  75  001f a124          	cp	a,#36
  76  0021 266a          	jrne	L55
  77                     ; 36 				decode_stage = FRAME_BOF1;
  78  0023 35010000      	mov	L32_decode_stage,#1
  79                     ; 37 				chksum = data;
  80  0027 b701          	ld	L52_chksum,a
  81  0029 2062          	jra	L55
  82  002b               L53:
  83                     ; 41 		case FRAME_BOF1:
  83                     ; 42 			if (data == FRAME_BOF1_KEY)
  84  002b 7b01          	ld	a,(OFST+1,sp)
  85  002d a140          	cp	a,#64
  86  002f 265a          	jrne	L77
  87                     ; 44 				decode_stage = FRAME_ADDR;
  88  0031 35020000      	mov	L32_decode_stage,#2
  89                     ; 45 				chksum += data;
  90  0035 b601          	ld	a,L52_chksum
  91  0037 1b01          	add	a,(OFST+1,sp)
  92  0039 b701          	ld	L52_chksum,a
  94  003b 2050          	jra	L55
  95                     ; 47 				decode_stage = FRAME_BOF0;
  96  003d               L73:
  97                     ; 51 		case FRAME_ADDR:
  97                     ; 52 			if (FRAME_TO_ME(data))
  98  003d 7b01          	ld	a,(OFST+1,sp)
  99  003f a50f          	bcp	a,#15
 100  0041 2748          	jreq	L77
 101                     ; 54 				decode_stage = FRAME_LENGTH;
 102  0043 35030000      	mov	L32_decode_stage,#3
 103                     ; 55 				chksum += data;
 104  0047 b601          	ld	a,L52_chksum
 105  0049 1b01          	add	a,(OFST+1,sp)
 106  004b b701          	ld	L52_chksum,a
 108  004d 203e          	jra	L55
 109                     ; 58 				decode_stage = FRAME_BOF0;
 110  004f               L14:
 111                     ; 62 		case FRAME_LENGTH:
 111                     ; 63 			if (data < MAX_FRAME_SIZE)
 112  004f 7b01          	ld	a,(OFST+1,sp)
 113  0051 a150          	cp	a,#80
 114  0053 2436          	jruge	L77
 115                     ; 65 				decode_stage = FRAME_DATA;
 116  0055 35040000      	mov	L32_decode_stage,#4
 117                     ; 66 				total_length = data;
 118  0059 b703          	ld	L72_total_length,a
 119                     ; 67 				chksum += data;
 120  005b b601          	ld	a,L52_chksum
 121  005d 1b01          	add	a,(OFST+1,sp)
 122  005f b701          	ld	L52_chksum,a
 123                     ; 68 				rx_length = 0;
 124  0061 3f02          	clr	L13_rx_length
 126  0063 2028          	jra	L55
 127                     ; 71 				decode_stage = FRAME_BOF0;
 128  0065               L34:
 129                     ; 75 		case FRAME_DATA:
 129                     ; 76 			chksum += data;
 130  0065 b601          	ld	a,L52_chksum
 131  0067 1b01          	add	a,(OFST+1,sp)
 132  0069 b701          	ld	L52_chksum,a
 133                     ; 77 			cmd_frame_buffer[rx_length++] = data;
 134  006b b602          	ld	a,L13_rx_length
 135  006d 3c02          	inc	L13_rx_length
 136  006f 5f            	clrw	x
 137  0070 97            	ld	xl,a
 138  0071 7b01          	ld	a,(OFST+1,sp)
 139  0073 e754          	ld	(L7_cmd_frame_buffer,x),a
 140                     ; 78 			if (rx_length == total_length)
 141  0075 b602          	ld	a,L13_rx_length
 142  0077 b103          	cp	a,L72_total_length
 143  0079 2612          	jrne	L55
 144                     ; 80 				decode_stage = FRAME_CHKSUM;
 145  007b 35050000      	mov	L32_decode_stage,#5
 146  007f 200c          	jra	L55
 147  0081               L54:
 148                     ; 84 		case FRAME_CHKSUM:
 148                     ; 85 			if (chksum == data)
 149  0081 b601          	ld	a,L52_chksum
 150  0083 1101          	cp	a,(OFST+1,sp)
 151  0085 2604          	jrne	L77
 152                     ; 87 				cmd_frame_received = true;
 153  0087 72100001      	bset	L3_cmd_frame_received
 154  008b               L77:
 155                     ; 89 			decode_stage = FRAME_BOF0;
 156  008b 3f00          	clr	L32_decode_stage
 157                     ; 90 			break;
 158                     ; 92 		default:
 158                     ; 93 			break;
 159  008d               L55:
 160                     ; 96 }
 161  008d 84            	pop	a
 162  008e 81            	ret	
 164                     	bsct
 165  0000               L101_cmd_process:
 167  0000 00e1          	dc.w	L31_get_sys_info
 169  0002 0234          	dc.w	L71_get_device_sn
 171  0004 019d          	dc.w	L51_reset_to_factroy
 173  0006 0235          	dc.w	L12_set_attr_flag
 174                     ; 105 void cmd_execution_done(void)
 174                     ; 106 {
 175                     	switch	.text
 176  008f               _cmd_execution_done:
 177  008f 5203          	subw	sp,#3
 178       00000003      OFST:	set	3
 180                     ; 107 	u8 index = 0;	
 181  0091 4f            	clr	a
 182  0092 6b01          	ld	(OFST-2,sp),a
 183                     ; 108 	u8 *buf = HEAD_OF_ACK;
 184                     ; 110 	buf[index++] = NM_OF_BOF + 1;
 185  0094 5f            	clrw	x
 186  0095 0c01          	inc	(OFST-2,sp)
 187  0097 97            	ld	xl,a
 188  0098 a603          	ld	a,#3
 189  009a e707          	ld	(L11_ack_frame_buffer+3,x),a
 190                     ; 111 	buf[index++] = CMD_ACK;
 191  009c 7b01          	ld	a,(OFST-2,sp)
 192  009e 0c01          	inc	(OFST-2,sp)
 193  00a0 5f            	clrw	x
 194  00a1 97            	ld	xl,a
 195  00a2 b654          	ld	a,L7_cmd_frame_buffer
 196  00a4 ab80          	add	a,#128
 197  00a6 e707          	ld	(L11_ack_frame_buffer+3,x),a
 198                     ; 112 	buf[index++] = CMD_ACK_OK;
 199  00a8 7b01          	ld	a,(OFST-2,sp)
 200  00aa 0c01          	inc	(OFST-2,sp)
 201  00ac 5f            	clrw	x
 202  00ad 97            	ld	xl,a
 203  00ae a655          	ld	a,#85
 204  00b0 e707          	ld	(L11_ack_frame_buffer+3,x),a
 205                     ; 114 	set_event_ack_ready();
 206  00b2 cd0270        	call	_set_event_ack_ready
 208                     ; 116 }
 209  00b5 5b03          	addw	sp,#3
 210  00b7 81            	ret	
 212                     ; 118 void cmd_execution_ng(void)
 212                     ; 119 {
 213  00b8               _cmd_execution_ng:
 214  00b8 5203          	subw	sp,#3
 215       00000003      OFST:	set	3
 217                     ; 120 	u8 index = 0;	
 218  00ba 4f            	clr	a
 219  00bb 6b01          	ld	(OFST-2,sp),a
 220                     ; 121 	u8 *buf = HEAD_OF_ACK;
 221                     ; 123 	buf[index++] = NM_OF_BOF + 1;
 222  00bd 5f            	clrw	x
 223  00be 0c01          	inc	(OFST-2,sp)
 224  00c0 97            	ld	xl,a
 225  00c1 a603          	ld	a,#3
 226  00c3 e707          	ld	(L11_ack_frame_buffer+3,x),a
 227                     ; 124 	buf[index++] = CMD_ACK;
 228  00c5 7b01          	ld	a,(OFST-2,sp)
 229  00c7 0c01          	inc	(OFST-2,sp)
 230  00c9 5f            	clrw	x
 231  00ca 97            	ld	xl,a
 232  00cb b654          	ld	a,L7_cmd_frame_buffer
 233  00cd ab80          	add	a,#128
 234  00cf e707          	ld	(L11_ack_frame_buffer+3,x),a
 235                     ; 125 	buf[index++] = CMD_ACK_NG;
 236  00d1 7b01          	ld	a,(OFST-2,sp)
 237  00d3 0c01          	inc	(OFST-2,sp)
 238  00d5 5f            	clrw	x
 239  00d6 97            	ld	xl,a
 240  00d7 a677          	ld	a,#119
 241  00d9 e707          	ld	(L11_ack_frame_buffer+3,x),a
 242                     ; 127 	set_event_ack_ready();
 243  00db cd0270        	call	_set_event_ack_ready
 245                     ; 129 }
 246  00de 5b03          	addw	sp,#3
 247  00e0 81            	ret	
 249                     ; 138 static void get_sys_info(void)
 249                     ; 139 {
 250  00e1               L31_get_sys_info:
 251  00e1 520b          	subw	sp,#11
 252       0000000b      OFST:	set	11
 254                     ; 140 	u8 index = 0;	
 255  00e3 0f05          	clr	(OFST-6,sp)
 256                     ; 142 	u8 *tx_buf = HEAD_OF_ACK;
 257                     ; 143 	u8 *rx_buf = &cmd_frame_buffer[7];
 258                     ; 144 	u8 wr = cmd_frame_buffer[6];
 259  00e5 b65a          	ld	a,L7_cmd_frame_buffer+6
 260  00e7 6b08          	ld	(OFST-3,sp),a
 261                     ; 145 	u8 target = cmd_frame_buffer[5];
 262  00e9 b659          	ld	a,L7_cmd_frame_buffer+5
 263  00eb 6b09          	ld	(OFST-2,sp),a
 264                     ; 146 	SYS_INFO_T *si = global_flags.si;
 265  00ed be02          	ldw	x,_global_flags+2
 266  00ef 1f0a          	ldw	(OFST-1,sp),x
 267                     ; 148 	if (CMD_TYPE != 0)
 268  00f1 3d54          	tnz	L7_cmd_frame_buffer
 269  00f3 2703cc0197    	jrne	L301
 270                     ; 149 		goto out;
 271                     ; 151 	if (target >= CONFIG_ITEMS_MAX)
 272  00f8 a110          	cp	a,#16
 273  00fa 24f9          	jruge	L301
 274                     ; 152 		goto out;
 275                     ; 154 	if (wr & si->attr == false)
 276  00fc 7b08          	ld	a,(OFST-3,sp)
 277  00fe 5f            	clrw	x
 278  00ff 97            	ld	xl,a
 279  0100 1f01          	ldw	(OFST-10,sp),x
 280  0102 1e0a          	ldw	x,(OFST-1,sp)
 281  0104 6d01          	tnz	(1,x)
 282  0106 2605          	jrne	L61
 283  0108 ae0001        	ldw	x,#1
 284  010b 2001          	jra	L02
 285  010d               L61:
 286  010d 5f            	clrw	x
 287  010e               L02:
 288  010e 01            	rrwa	x,a
 289  010f 1402          	and	a,(OFST-9,sp)
 290  0111 01            	rrwa	x,a
 291  0112 1401          	and	a,(OFST-10,sp)
 292  0114 01            	rrwa	x,a
 293  0115 5d            	tnzw	x
 294  0116 267f          	jrne	L301
 295                     ; 155 		goto out;
 296                     ; 157 	if (wr == CMD_GET)
 297  0118 7b08          	ld	a,(OFST-3,sp)
 298  011a a152          	cp	a,#82
 299  011c 264a          	jrne	L311
 300                     ; 159 		si += target;
 301  011e 7b09          	ld	a,(OFST-2,sp)
 302  0120 97            	ld	xl,a
 303  0121 a608          	ld	a,#8
 304  0123 42            	mul	x,a
 305  0124 72fb0a        	addw	x,(OFST-1,sp)
 306  0127 1f0a          	ldw	(OFST-1,sp),x
 307                     ; 160 		tx_buf[index++] = (u8)(2 + si->size); 		
 308  0129 7b05          	ld	a,(OFST-6,sp)
 309  012b 0c05          	inc	(OFST-6,sp)
 310  012d 5f            	clrw	x
 311  012e 160a          	ldw	y,(OFST-1,sp)
 312  0130 97            	ld	xl,a
 313  0131 90e603        	ld	a,(3,y)
 314  0134 ab02          	add	a,#2
 315  0136 e707          	ld	(L11_ack_frame_buffer+3,x),a
 316                     ; 161 		tx_buf[index++] = CMD_ACK;
 317  0138 7b05          	ld	a,(OFST-6,sp)
 318  013a 0c05          	inc	(OFST-6,sp)
 319  013c 5f            	clrw	x
 320  013d 97            	ld	xl,a
 321  013e b654          	ld	a,L7_cmd_frame_buffer
 322  0140 ab80          	add	a,#128
 323  0142 e707          	ld	(L11_ack_frame_buffer+3,x),a
 324                     ; 162 		memcpy((u8 *)(tx_buf + index), si->ram, si->size);				
 325  0144 5f            	clrw	x
 326  0145 7b05          	ld	a,(OFST-6,sp)
 327  0147 97            	ld	xl,a
 328  0148 1c0007        	addw	x,#L11_ack_frame_buffer+3
 329  014b bf00          	ldw	c_x,x
 330  014d 90ee06        	ldw	y,(6,y)
 331  0150 90bf00        	ldw	c_y,y
 332  0153 1e0a          	ldw	x,(OFST-1,sp)
 333  0155 ee02          	ldw	x,(2,x)
 334  0157 270a          	jreq	L22
 335  0159               L42:
 336  0159 5a            	decw	x
 337  015a 92d600        	ld	a,([c_y.w],x)
 338  015d 92d700        	ld	([c_x.w],x),a
 339  0160 5d            	tnzw	x
 340  0161 26f6          	jrne	L42
 341  0163               L22:
 342                     ; 163 		set_event_ack_ready();				
 343  0163 cd0270        	call	_set_event_ack_ready
 346  0166 2032          	jra	L511
 347  0168               L311:
 348                     ; 165 	else if (wr == CMD_SET)
 349  0168 a157          	cp	a,#87
 350  016a 262b          	jrne	L301
 351                     ; 167 		memcpy(si->ram, rx_buf, si->size);
 352  016c 1e0a          	ldw	x,(OFST-1,sp)
 353  016e ee06          	ldw	x,(6,x)
 354  0170 bf00          	ldw	c_x,x
 355  0172 1e0a          	ldw	x,(OFST-1,sp)
 356  0174 ee02          	ldw	x,(2,x)
 357  0176 2709          	jreq	L03
 358  0178               L23:
 359  0178 5a            	decw	x
 360  0179 e65b          	ld	a,(L7_cmd_frame_buffer+7,x)
 361  017b 92d700        	ld	([c_x.w],x),a
 362  017e 5d            	tnzw	x
 363  017f 26f7          	jrne	L23
 364  0181               L03:
 365                     ; 168 		save_system_configs(target);
 366  0181 7b09          	ld	a,(OFST-2,sp)
 367  0183 cd0000        	call	_save_system_configs
 369                     ; 169 		update_rtr_status(target, CONFIGED, true);
 370  0186 4b01          	push	#1
 371  0188 ae0044        	ldw	x,#68
 372  018b 7b0a          	ld	a,(OFST-1,sp)
 373  018d 95            	ld	xh,a
 374  018e cd0000        	call	_update_rtr_status
 376  0191 84            	pop	a
 377                     ; 170 		cmd_execution_done();
 378  0192 cd008f        	call	_cmd_execution_done
 381  0195 2003          	jra	L511
 382  0197               L301:
 383                     ; 174 out:
 383                     ; 175 		cmd_execution_ng();
 384  0197 cd00b8        	call	_cmd_execution_ng
 386  019a               L511:
 387                     ; 178 }
 388  019a 5b0b          	addw	sp,#11
 389  019c 81            	ret	
 391                     ; 188 static void reset_to_factroy(void)
 391                     ; 189 {
 392  019d               L51_reset_to_factroy:
 393  019d 520b          	subw	sp,#11
 394       0000000b      OFST:	set	11
 396                     ; 190 	u8 index = 0;	
 397  019f 0f07          	clr	(OFST-4,sp)
 398                     ; 192 	u8 *tx_buf = HEAD_OF_ACK;
 399                     ; 193 	u8 *rx_buf = &cmd_frame_buffer[7];
 400  01a1 ae005b        	ldw	x,#L7_cmd_frame_buffer+7
 401  01a4 1f03          	ldw	(OFST-8,sp),x
 402                     ; 194 	u8 wr = cmd_frame_buffer[6];
 403  01a6 b65a          	ld	a,L7_cmd_frame_buffer+6
 404  01a8 6b05          	ld	(OFST-6,sp),a
 405                     ; 195 	u8 target = cmd_frame_buffer[5];
 406  01aa b659          	ld	a,L7_cmd_frame_buffer+5
 407  01ac 6b06          	ld	(OFST-5,sp),a
 408                     ; 196 	SYS_INFO_T *si = global_flags.si;
 409  01ae be02          	ldw	x,_global_flags+2
 410  01b0 1f0a          	ldw	(OFST-1,sp),x
 411                     ; 198 	if (CMD_TYPE != 0)
 412  01b2 3d54          	tnz	L7_cmd_frame_buffer
 413  01b4 2678          	jrne	L321
 414                     ; 199 		goto out;
 415                     ; 201 	if (target >= CONFIG_ITEMS_MAX)
 416  01b6 a110          	cp	a,#16
 417  01b8 2474          	jruge	L321
 418                     ; 202 		goto out;
 419                     ; 204 	if (wr & si->attr == false)
 420  01ba 7b05          	ld	a,(OFST-6,sp)
 421  01bc 5f            	clrw	x
 422  01bd 97            	ld	xl,a
 423  01be 1f01          	ldw	(OFST-10,sp),x
 424  01c0 1e0a          	ldw	x,(OFST-1,sp)
 425  01c2 6d01          	tnz	(1,x)
 426  01c4 2605          	jrne	L64
 427  01c6 ae0001        	ldw	x,#1
 428  01c9 2001          	jra	L05
 429  01cb               L64:
 430  01cb 5f            	clrw	x
 431  01cc               L05:
 432  01cc 01            	rrwa	x,a
 433  01cd 1402          	and	a,(OFST-9,sp)
 434  01cf 01            	rrwa	x,a
 435  01d0 1401          	and	a,(OFST-10,sp)
 436  01d2 01            	rrwa	x,a
 437  01d3 5d            	tnzw	x
 438  01d4 2658          	jrne	L321
 439                     ; 205 		goto out;
 440                     ; 207 	if (wr == CMD_GET)
 441  01d6 7b05          	ld	a,(OFST-6,sp)
 442  01d8 a152          	cp	a,#82
 443  01da 2652          	jrne	L321
 444                     ; 209 		si += target;
 445  01dc 7b06          	ld	a,(OFST-5,sp)
 446  01de 97            	ld	xl,a
 447  01df a608          	ld	a,#8
 448  01e1 42            	mul	x,a
 449  01e2 72fb0a        	addw	x,(OFST-1,sp)
 450  01e5 1f0a          	ldw	(OFST-1,sp),x
 451                     ; 210 		tx_buf[index++] = (u8)(2 + si->size); 		
 452  01e7 7b07          	ld	a,(OFST-4,sp)
 453  01e9 0c07          	inc	(OFST-4,sp)
 454  01eb 5f            	clrw	x
 455  01ec 160a          	ldw	y,(OFST-1,sp)
 456  01ee 97            	ld	xl,a
 457  01ef 90e603        	ld	a,(3,y)
 458  01f2 ab02          	add	a,#2
 459  01f4 e707          	ld	(L11_ack_frame_buffer+3,x),a
 460                     ; 211 		tx_buf[index++] = CMD_ACK;
 461  01f6 7b07          	ld	a,(OFST-4,sp)
 462  01f8 0c07          	inc	(OFST-4,sp)
 463  01fa 5f            	clrw	x
 464  01fb 97            	ld	xl,a
 465  01fc b654          	ld	a,L7_cmd_frame_buffer
 466  01fe ab80          	add	a,#128
 467  0200 e707          	ld	(L11_ack_frame_buffer+3,x),a
 468                     ; 212 		memcpy((u8 *)(tx_buf + index), si->ram, si->size);				
 469  0202 5f            	clrw	x
 470  0203 7b07          	ld	a,(OFST-4,sp)
 471  0205 97            	ld	xl,a
 472  0206 1c0007        	addw	x,#L11_ack_frame_buffer+3
 473  0209 bf00          	ldw	c_x,x
 474  020b 90ee06        	ldw	y,(6,y)
 475  020e 90bf00        	ldw	c_y,y
 476  0211 1e0a          	ldw	x,(OFST-1,sp)
 477  0213 ee02          	ldw	x,(2,x)
 478  0215 270a          	jreq	L25
 479  0217               L45:
 480  0217 5a            	decw	x
 481  0218 92d600        	ld	a,([c_y.w],x)
 482  021b 92d700        	ld	([c_x.w],x),a
 483  021e 5d            	tnzw	x
 484  021f 26f6          	jrne	L45
 485  0221               L25:
 486                     ; 213 		set_event_ack_ready();
 487  0221 ad4d          	call	_set_event_ack_ready
 489                     ; 214 		delay(100);
 490  0223 ae0064        	ldw	x,#100
 491  0226 cd0000        	call	_delay
 493                     ; 215 		reboot();
 494  0229 cd0000        	call	_reboot
 497  022c 2003          	jra	L531
 498  022e               L321:
 499                     ; 219 out:
 499                     ; 220 		cmd_execution_ng();
 500  022e cd00b8        	call	_cmd_execution_ng
 502  0231               L531:
 503                     ; 223 }
 504  0231 5b0b          	addw	sp,#11
 505  0233 81            	ret	
 507                     ; 225 static void get_device_sn(void)
 507                     ; 226 {
 508  0234               L71_get_device_sn:
 510                     ; 228 }
 511  0234 81            	ret	
 513                     ; 231 static void set_attr_flag(void)
 513                     ; 232 {
 514  0235               L12_set_attr_flag:
 515  0235 5205          	subw	sp,#5
 516       00000005      OFST:	set	5
 518                     ; 234 	u8 *target = &cmd_frame_buffer[5];
 519  0237 ae0059        	ldw	x,#L7_cmd_frame_buffer+5
 520  023a 1f01          	ldw	(OFST-4,sp),x
 521                     ; 235 	u8 *tag = &cmd_frame_buffer[9];
 522  023c ae005d        	ldw	x,#L7_cmd_frame_buffer+9
 523  023f 1f03          	ldw	(OFST-2,sp),x
 524                     ; 237 	for (i=0; i < CH_MAX; i++)
 525  0241 0f05          	clr	(OFST+0,sp)
 526  0243               L731:
 527                     ; 238 		update_attr_status(target[i], tag[i], true);
 528  0243 4b01          	push	#1
 529  0245 7b04          	ld	a,(OFST-1,sp)
 530  0247 97            	ld	xl,a
 531  0248 7b05          	ld	a,(OFST+0,sp)
 532  024a 1b06          	add	a,(OFST+1,sp)
 533  024c 2401          	jrnc	L47
 534  024e 5c            	incw	x
 535  024f               L47:
 536  024f 02            	rlwa	x,a
 537  0250 f6            	ld	a,(x)
 538  0251 97            	ld	xl,a
 539  0252 89            	pushw	x
 540  0253 7b04          	ld	a,(OFST-1,sp)
 541  0255 97            	ld	xl,a
 542  0256 7b05          	ld	a,(OFST+0,sp)
 543  0258 1b08          	add	a,(OFST+3,sp)
 544  025a 2401          	jrnc	L67
 545  025c 5c            	incw	x
 546  025d               L67:
 547  025d 02            	rlwa	x,a
 548  025e f6            	ld	a,(x)
 549  025f 85            	popw	x
 550  0260 95            	ld	xh,a
 551  0261 cd0000        	call	_update_attr_status
 553  0264 84            	pop	a
 554                     ; 237 	for (i=0; i < CH_MAX; i++)
 555  0265 0c05          	inc	(OFST+0,sp)
 557  0267 7b05          	ld	a,(OFST+0,sp)
 558  0269 a104          	cp	a,#4
 559  026b 25d6          	jrult	L731
 560                     ; 239 }
 561  026d 5b05          	addw	sp,#5
 562  026f 81            	ret	
 564                     ; 241 void set_event_ack_ready(void)
 564                     ; 242 {
 565  0270               _set_event_ack_ready:
 567                     ; 243 	ack_frame_ready = true;
 568  0270 72100000      	bset	L5_ack_frame_ready
 569                     ; 244 }
 570  0274 81            	ret	
 572                     ; 246 void host_cmd_init(void)
 572                     ; 247 {
 573  0275               _host_cmd_init:
 574  0275 88            	push	a
 575       00000001      OFST:	set	1
 577                     ; 248 	u8 index = 0;
 578  0276 4f            	clr	a
 579  0277 6b01          	ld	(OFST+0,sp),a
 580                     ; 250 	ack_frame_buffer[index++] = FRAME_BOF0_KEY;
 581  0279 5f            	clrw	x
 582  027a 0c01          	inc	(OFST+0,sp)
 583  027c 97            	ld	xl,a
 584  027d a624          	ld	a,#36
 585  027f e704          	ld	(L11_ack_frame_buffer,x),a
 586                     ; 251 	ack_frame_buffer[index++] = FRAME_BOF1_KEY;
 587  0281 7b01          	ld	a,(OFST+0,sp)
 588  0283 0c01          	inc	(OFST+0,sp)
 589  0285 5f            	clrw	x
 590  0286 97            	ld	xl,a
 591  0287 a640          	ld	a,#64
 592  0289 e704          	ld	(L11_ack_frame_buffer,x),a
 593                     ; 252 	ack_frame_buffer[index++] = ACK_HOST;
 594  028b 7b01          	ld	a,(OFST+0,sp)
 595  028d 0c01          	inc	(OFST+0,sp)
 596  028f 5f            	clrw	x
 597  0290 97            	ld	xl,a
 598                     ; 254 }
 599  0291 84            	pop	a
 600  0292 6f04          	clr	(L11_ack_frame_buffer,x)
 601  0294 81            	ret	
 603                     ; 256 void send_ack_frame(u8 ack_length)
 603                     ; 257 {
 604  0295               _send_ack_frame:
 605  0295 88            	push	a
 606  0296 89            	pushw	x
 607       00000002      OFST:	set	2
 609                     ; 258 	u8 chksum = 0;
 610  0297 0f01          	clr	(OFST-1,sp)
 611                     ; 261 	for (i=0; i<4+ack_length; i++)
 612  0299 0f02          	clr	(OFST+0,sp)
 614  029b 200c          	jra	L151
 615  029d               L541:
 616                     ; 262 		chksum += ack_frame_buffer[i];
 617  029d 7b02          	ld	a,(OFST+0,sp)
 618  029f 5f            	clrw	x
 619  02a0 97            	ld	xl,a
 620  02a1 7b01          	ld	a,(OFST-1,sp)
 621  02a3 eb04          	add	a,(L11_ack_frame_buffer,x)
 622  02a5 6b01          	ld	(OFST-1,sp),a
 623                     ; 261 	for (i=0; i<4+ack_length; i++)
 624  02a7 0c02          	inc	(OFST+0,sp)
 625  02a9               L151:
 627  02a9 7b02          	ld	a,(OFST+0,sp)
 628  02ab 5f            	clrw	x
 629  02ac 97            	ld	xl,a
 630  02ad 7b03          	ld	a,(OFST+1,sp)
 631  02af 905f          	clrw	y
 632  02b1 9097          	ld	yl,a
 633  02b3 bf00          	ldw	c_x,x
 634  02b5 72a90004      	addw	y,#4
 635  02b9 90b300        	cpw	y,c_x
 636  02bc 2cdf          	jrsgt	L541
 637                     ; 264 	ack_frame_buffer[i] = chksum;
 638  02be 7b02          	ld	a,(OFST+0,sp)
 639  02c0 5f            	clrw	x
 640  02c1 97            	ld	xl,a
 641  02c2 7b01          	ld	a,(OFST-1,sp)
 642  02c4 e704          	ld	(L11_ack_frame_buffer,x),a
 643                     ; 266 }
 644  02c6 5b03          	addw	sp,#3
 645  02c8 81            	ret	
 647                     ; 268 void host_cmd_process(void)
 647                     ; 269 {
 648  02c9               _host_cmd_process:
 650                     ; 270 	if (cmd_frame_received )
 651  02c9 720100010c    	btjf	L3_cmd_frame_received,L551
 652                     ; 272 		cmd_process[CMD_TYPE]();
 653  02ce b654          	ld	a,L7_cmd_frame_buffer
 654  02d0 5f            	clrw	x
 655  02d1 97            	ld	xl,a
 656  02d2 58            	sllw	x
 657  02d3 ee00          	ldw	x,(L101_cmd_process,x)
 658  02d5 fd            	call	(x)
 660                     ; 273 		cmd_frame_received = false;
 661  02d6 72110001      	bres	L3_cmd_frame_received
 662  02da               L551:
 663                     ; 276 	if (ack_frame_ready)
 664  02da 7201000008    	btjf	L5_ack_frame_ready,L751
 665                     ; 278 		send_ack_frame(1);
 666  02df a601          	ld	a,#1
 667  02e1 adb2          	call	_send_ack_frame
 669                     ; 279 		ack_frame_ready = false;
 670  02e3 72110000      	bres	L5_ack_frame_ready
 671  02e7               L751:
 672                     ; 281 }
 673  02e7 81            	ret	
 675                     	xdef	_cmd_execution_ng
 676                     	xdef	_cmd_frame_decode
 677                     	switch	.ubsct
 678  0004               L11_ack_frame_buffer:
 679  0004 000000000000  	ds.b	80
 680  0054               L7_cmd_frame_buffer:
 681  0054 000000000000  	ds.b	80
 682                     .bit:	section	.data,bit
 683  0000               L5_ack_frame_ready:
 684  0000 00            	ds.b	1
 685  0001               L3_cmd_frame_received:
 686  0001 00            	ds.b	1
 687                     	xref	_delay
 688                     	xref	_reboot
 689                     	xdef	_host_cmd_process
 690                     	xdef	_send_ack_frame
 691                     	xdef	_host_cmd_init
 692                     	xdef	_set_event_ack_ready
 693                     	xdef	_cmd_execution_done
 694                     	xref	_save_system_configs
 695                     	xref	_update_attr_status
 696                     	xref	_update_rtr_status
 697                     	xref.b	_global_flags
 698                     	xref.b	c_x
 699                     	xref.b	c_y
 700                     	end

Symbol table:

L02                     0000010e    Defined
                          287   284
L03                     00000181    Defined
                          364   357
L05                     000001cc    Defined
                          431   428
L101_cmd_process        00000000    Defined, Zero Page
                          165   657
L11_ack_frame_buffer    00000004    Defined, Zero Page
                          678   189   197   204   226   234   241   315   323   328
                          459   467   472   585   592   600   621   642
L12_set_attr_flag       00000235    Defined
                          514   173   563
L13_rx_length           00000002    Defined, Zero Page
                           39   124   134   135   141
L14                     0000004f    Defined
                          110    66
L15                     00000008    Defined
                           55    51
L151                    000002a9    Defined
                          625   614
L22                     00000163    Defined
                          341   334
L23                     00000178    Defined
                          358   363
L25                     00000221    Defined
                          485   478
L301                    00000197    Defined
                          382   269   273   294   350
L311                    00000168    Defined
                          347   299
L31_get_sys_info        000000e1    Defined
                          250   167   390
L321                    0000022e    Defined
                          498   413   417   438   443
L32_decode_stage        00000000    Defined, Zero Page
                           35    57    78    88   102   116   145   156
L33                     0000001d    Defined
                           72    60
L34                     00000065    Defined
                          128    68
L3_cmd_frame_received   00000001    Defined
                          685    51   153   651   661
L42                     00000159    Defined
                          335   340
L45                     00000217    Defined
                          479   484
L47                     0000024f    Defined
                          535   533
L511                    0000019a    Defined
                          386   346   381
L51_reset_to_factroy    0000019d    Defined
                          392   171   506
L52_chksum              00000001    Defined, Zero Page
                           37    80    90    92   104   106   120   122   130   132
                          149
L53                     0000002b    Defined
                           82    62
L531                    00000231    Defined
                          502   497
L54                     00000081    Defined
                          147    70
L541                    0000029d    Defined
                          615   636
L55                     0000008d    Defined
                          159    71    76    81    94   108   126   143   146
L551                    000002da    Defined
                          662   651
L5_ack_frame_ready      00000000    Defined
                          683   568   664   670
L61                     0000010d    Defined
                          285   282
L64                     000001cb    Defined
                          429   426
L67                     0000025d    Defined
                          546   544
L71_get_device_sn       00000234    Defined
                          508   169   512
L72_total_length        00000003    Defined, Zero Page
                           41   118   142
L73                     0000003d    Defined
                           96    64
L731                    00000243    Defined
                          526   559
L751                    000002e7    Defined
                          671   664
L77                     0000008b    Defined
                          154    86   100   114   151
L7_cmd_frame_buffer     00000054    Defined, Zero Page
                          680   139   195   232   259   262   268   321   360   400
                          403   406   412   465   519   522   653
OFST                    00000002    Defined, Absolute
                           48    74    84    91    98   105   112   121   131   138
                          150   182   186   191   192   199   200   219   223   228
                          229   236   237   255   260   263   266   276   279   280
                          289   291   297   301   305   306   308   309   311   317
                          318   326   332   352   355   366   372   397   401   404
                          407   410   420   423   424   433   435   441   445   449
                          450   452   453   455   461   462   470   476   520   523
                          525   529   531   532   540   542   543   555   557   579
                          582   587   588   594   595   610   612   617   620   622
                          624   627   630   638   641
_cmd_execution_done     0000008f    Defined, Public
                          176   211   378
_cmd_execution_ng       000000b8    Defined, Public
                          213   248   384   500
_cmd_frame_decode       00000000    Defined, Public
                           46   163
_delay                  00000000    Public
                          687   491
_global_flags           00000000    Public, Zero Page
                          697   265   409
_host_cmd_init          00000275    Defined, Public
                          573   602
_host_cmd_process       000002c9    Defined, Public
                          648   674
_reboot                 00000000    Public
                          688   494
_save_system_configs    00000000    Public
                          694   367
_send_ack_frame         00000295    Defined, Public
                          604   646   667
_set_event_ack_ready    00000270    Defined, Public
                          565   206   243   343   487   571
_update_attr_status     00000000    Public
                          695   551
_update_rtr_status      00000000    Public
                          696   374
c_x                     00000000    Public, Zero Page
                          698   329   338   354   361   473   482   633   635
c_y                     00000000    Public, Zero Page
                          699   331   337   475   481
