   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
   4                     ; Optimizer V4.3.3 - 10 Feb 2010
  34                     ; 31 void input_ch3_handler(void)
  34                     ; 32 {
  35                     	scross	off
  36  0000               _input_ch3_handler:
  37  0000 89            	pushw	x
  38       00000002      OFST:	set	2
  40                     ; 33     if (global_flags.systick) {
  41  0001 7201000107    	btjf	_global_flags+1,#0,L12
  42                     ; 34         if (ch3_click_counter) {
  43  0006 be02          	ldw	x,L7_ch3_click_counter
  44  0008 2703          	jreq	L12
  45                     ; 35             --ch3_click_counter;
  46  000a 5a            	decw	x
  47  000b bf02          	ldw	L7_ch3_click_counter,x
  48  000d               L12:
  49                     ; 39     if (dev_config.flags.ch3_is_local_switch) {
  50  000d 7201000111    	btjf	_dev_config+1,#0,L52
  51                     ; 40         rc_channel[CH3].normalized = get_ch3_state() ? -100 : 100;
  52  0012 cd0000        	call	_get_ch3_state
  54  0015 4d            	tnz	a
  55  0016 2705          	jreq	L4
  56  0018 aeff9c        	ldw	x,#65436
  57  001b 2003          	jra	L01
  58  001d               L4:
  59  001d ae0064        	ldw	x,#100
  60  0020               L01:
  61  0020 cf001c        	ldw	_rc_channel+28,x
  62  0023               L52:
  63                     ; 43     if (global_flags.rc_is_initializing) {
  64  0023 720f000104    	btjf	_global_flags+1,#7,L72
  65                     ; 44         ch3_flags.initialized = false;
  66  0028 72150006      	bres	L3_ch3_flags+1,#2
  67  002c               L72:
  68                     ; 47     if (!global_flags.rc_update_event) {
  69  002c 7203000119    	btjf	_global_flags+1,#1,L41
  70                     ; 48         return;
  71                     ; 51     if (!ch3_flags.initialized) {
  72  0031 7204000616    	btjt	L3_ch3_flags+1,#2,L33
  73                     ; 52         ch3_flags.initialized = true;
  74  0036 72140006      	bset	L3_ch3_flags+1,#2
  75                     ; 53         ch3_flags.last_state = (rc_channel[CH3].normalized > 0) ? true : false;
  76  003a 9c            	rvf	
  77  003b ce001c        	ldw	x,_rc_channel+28
  78  003e 2d06          	jrsle	L21
  79  0040 72100006      	bset	L3_ch3_flags+1,#0
  80  0044 2004          	jra	L41
  81  0046               L21:
  82  0046 72110006      	bres	L3_ch3_flags+1,#0
  83  004a               L41:
  84                     ; 54         return;
  85  004a 85            	popw	x
  86  004b 81            	ret	
  87  004c               L33:
  88                     ; 57     if (dev_config.flags.ch3_is_momentary) {
  89  004c b606          	ld	a,L3_ch3_flags+1
  90  004e a401          	and	a,#1
  91  0050 5f            	clrw	x
  92  0051 02            	rlwa	x,a
  93  0052 7203000123    	btjf	_dev_config+1,#1,L53
  94                     ; 58         if ((rc_channel[CH3].normalized > 0)  !=  (ch3_flags.last_state)) {
  95  0057 1f01          	ldw	(OFST-1,sp),x
  96  0059 9c            	rvf	
  97  005a ce001c        	ldw	x,_rc_channel+28
  98  005d 2d05          	jrsle	L61
  99  005f ae0001        	ldw	x,#1
 100  0062 2001          	jra	L02
 101  0064               L61:
 102  0064 5f            	clrw	x
 103  0065               L02:
 104  0065 1301          	cpw	x,(OFST-1,sp)
 105  0067 270b          	jreq	L73
 106                     ; 61             if (!ch3_flags.transitioned) {
 107  0069 7202000631    	btjt	L3_ch3_flags+1,#1,L54
 108                     ; 63                 ch3_flags.transitioned = true;
 109  006e 72120006      	bset	L3_ch3_flags+1,#1
 110                     ; 64                 add_click();
 112  0072 2028          	jp	L23
 113  0074               L73:
 114                     ; 68             ch3_flags.transitioned = false;
 115  0074 72130006      	bres	L3_ch3_flags+1,#1
 116  0078 2025          	jra	L54
 117  007a               L53:
 118                     ; 72         if ((rc_channel[CH3].normalized > 0)  !=  (ch3_flags.last_state)) {
 119  007a 1f01          	ldw	(OFST-1,sp),x
 120  007c 9c            	rvf	
 121  007d ce001c        	ldw	x,_rc_channel+28
 122  0080 2d05          	jrsle	L42
 123  0082 ae0001        	ldw	x,#1
 124  0085 2001          	jra	L62
 125  0087               L42:
 126  0087 5f            	clrw	x
 127  0088               L62:
 128  0088 1301          	cpw	x,(OFST-1,sp)
 129  008a 2713          	jreq	L54
 130                     ; 73             ch3_flags.last_state = (rc_channel[CH3].normalized > 0);
 131  008c 9c            	rvf	
 132  008d ce001c        	ldw	x,_rc_channel+28
 133  0090 2d06          	jrsle	L03
 134  0092 72100006      	bset	L3_ch3_flags+1,#0
 135  0096 2004          	jra	L23
 136  0098               L03:
 137  0098 72110006      	bres	L3_ch3_flags+1,#0
 138  009c               L23:
 139                     ; 74             add_click();
 140  009c cd037c        	call	L71_add_click
 142  009f               L54:
 143                     ; 78     process_ch3_click_timeout();
 144  009f cd0358        	call	L51_process_ch3_click_timeout
 146                     ; 79 }
 147  00a2 20a6          	jra	L41
 149                     ; 81 static void input_process_thread(u8 ch3_clicks)
 149                     ; 82 {
 150  00a4               L31_input_process_thread:
 151  00a4 88            	push	a
 152  00a5 520c          	subw	sp,#12
 153       0000000c      OFST:	set	12
 155                     ; 83 	u8 action = NO_ACTION;
 156                     ; 86 	bool done = false;
 157  00a7 4f            	clr	a
 158  00a8 6b05          	ld	(OFST-7,sp),a
 159                     ; 91 	if (!global_flags.ready_to_go)
 160  00aa 720a000103cc  	btjf	_global_flags+1,#5,L361
 161                     ; 93 		return;
 162                     ; 96 	ea = ch3_actions[global_flags.ch3_action_profile];
 163                     	btst	_global_flags+1,#2
 170  00b7 49            	rlc	a
 171  00b8 5f            	clrw	x
 172  00b9 02            	rlwa	x,a
 173  00ba 58            	sllw	x
 174  00bb 58            	sllw	x
 175  00bc 58            	sllw	x
 176  00bd 58            	sllw	x
 177  00be 58            	sllw	x
 178  00bf 1c0000        	addw	x,#_ch3_actions
 179  00c2 1f03          	ldw	(OFST-9,sp),x
 180                     ; 97 	ch3_clicks = ch3_clicks_decode(ch3_clicks);
 181  00c4 7b0d          	ld	a,(OFST+1,sp)
 182  00c6 cd0309        	call	L11_ch3_clicks_decode
 184  00c9 6b0d          	ld	(OFST+1,sp),a
 185                     ; 98 	ch = ea[ch3_clicks].channel;
 186  00cb 97            	ld	xl,a
 187  00cc a604          	ld	a,#4
 188  00ce 42            	mul	x,a
 189  00cf 72fb03        	addw	x,(OFST-9,sp)
 190  00d2 e602          	ld	a,(2,x)
 191  00d4 6b06          	ld	(OFST-6,sp),a
 192                     ; 99 	action = ea[ch3_clicks].actions;
 193  00d6 e601          	ld	a,(1,x)
 194  00d8 6b09          	ld	(OFST-3,sp),a
 195                     ; 100 	pos_configs = &servo_outputs[ch].pos_config;
 196  00da 7b06          	ld	a,(OFST-6,sp)
 197  00dc 97            	ld	xl,a
 198  00dd a618          	ld	a,#24
 199  00df 42            	mul	x,a
 200  00e0 1c000e        	addw	x,#_servo_outputs+14
 201  00e3 1f0b          	ldw	(OFST-1,sp),x
 202                     ; 101 	sout = &servo_outputs[ch];
 203  00e5 7b06          	ld	a,(OFST-6,sp)
 204  00e7 97            	ld	xl,a
 205  00e8 a618          	ld	a,#24
 206  00ea 42            	mul	x,a
 207  00eb 1c0000        	addw	x,#_servo_outputs
 208  00ee 1f07          	ldw	(OFST-5,sp),x
 209                     ; 102 	current = (u8)pos_configs->current;
 210  00f0 1e0b          	ldw	x,(OFST-1,sp)
 211  00f2 f6            	ld	a,(x)
 212  00f3 a478          	and	a,#120
 213  00f5 44            	srl	a
 214  00f6 44            	srl	a
 215  00f7 44            	srl	a
 216  00f8 6b02          	ld	(OFST-10,sp),a
 217                     ; 103 	beep_notify(ea[ch3_clicks].beep);
 218  00fa 7b0d          	ld	a,(OFST+1,sp)
 219  00fc 97            	ld	xl,a
 220  00fd a604          	ld	a,#4
 221  00ff 42            	mul	x,a
 222  0100 72fb03        	addw	x,(OFST-9,sp)
 223  0103 e603          	ld	a,(3,x)
 224  0105 cd0000        	call	_beep_notify
 226                     ; 105 	switch (action)
 227  0108 7b09          	ld	a,(OFST-3,sp)
 229                     ; 197 		default:
 229                     ; 198 			break;
 230  010a 4a            	dec	a
 231  010b 272c          	jreq	L15
 232  010d 4a            	dec	a
 233  010e 2603cc01cf    	jreq	L35
 234  0113 a002          	sub	a,#2
 235  0115 2603cc025c    	jreq	L55
 236  011a a004          	sub	a,#4
 237  011c 2603cc026b    	jreq	L75
 238  0121 a018          	sub	a,#24
 239  0123 2603cc028a    	jreq	L16
 240  0128 a030          	sub	a,#48
 241  012a 2603cc02cb    	jreq	L36
 242  012f a010          	sub	a,#16
 243  0131 2603cc02df    	jreq	L56
 244  0136 cc02f4        	jra	L57
 245  0139               L15:
 246                     ; 107 		case POS_INC:
 246                     ; 108 			if (pos_configs->cycle_en)
 247  0139 1e0b          	ldw	x,(OFST-1,sp)
 248  013b e601          	ld	a,(1,x)
 249  013d a501          	bcp	a,#1
 250  013f 276d          	jreq	L77
 251                     ; 111 				for (i = 0; i < sout->max_nb; i++)
 252  0141 0f06          	clr	(OFST-6,sp)
 254  0143 205e          	jra	L501
 255  0145               L101:
 256                     ; 113 					next = (u8)(((u8)pos_configs->current + (u8)1) % sout->max_nb);
 257  0145 1e0b          	ldw	x,(OFST-1,sp)
 258  0147 f6            	ld	a,(x)
 259  0148 a478          	and	a,#120
 260  014a 44            	srl	a
 261  014b 44            	srl	a
 262  014c 44            	srl	a
 263  014d 5f            	clrw	x
 264  014e 97            	ld	xl,a
 265  014f 1607          	ldw	y,(OFST-5,sp)
 266  0151 5c            	incw	x
 267  0152 90e602        	ld	a,(2,y)
 268  0155 905f          	clrw	y
 269  0157 9097          	ld	yl,a
 270  0159 cd0000        	call	c_idiv
 272  015c 93            	ldw	x,y
 273  015d 9f            	ld	a,xl
 274  015e 6b09          	ld	(OFST-3,sp),a
 275                     ; 114 					for (j = 0; j < MAX_EXMP; j++)
 276  0160 0f0a          	clr	(OFST-2,sp)
 277  0162               L111:
 278                     ; 116 						if (pos_configs->exclude[j] != NA &&
 278                     ; 117 							pos_configs->exclude[j] != next)
 279  0162 7b0b          	ld	a,(OFST-1,sp)
 280  0164 97            	ld	xl,a
 281  0165 7b0c          	ld	a,(OFST+0,sp)
 282  0167 1b0a          	add	a,(OFST-2,sp)
 283  0169 2401          	jrnc	L05
 284  016b 5c            	incw	x
 285  016c               L05:
 286  016c 02            	rlwa	x,a
 287  016d e604          	ld	a,(4,x)
 288  016f 4c            	inc	a
 289  0170 2723          	jreq	L711
 291  0172 7b0b          	ld	a,(OFST-1,sp)
 292  0174 97            	ld	xl,a
 293  0175 7b0c          	ld	a,(OFST+0,sp)
 294  0177 1b0a          	add	a,(OFST-2,sp)
 295  0179 2401          	jrnc	L25
 296  017b 5c            	incw	x
 297  017c               L25:
 298  017c 02            	rlwa	x,a
 299  017d e604          	ld	a,(4,x)
 300  017f 1109          	cp	a,(OFST-3,sp)
 301  0181 2712          	jreq	L711
 302                     ; 119 							pos_configs->current = next;
 303  0183 7b09          	ld	a,(OFST-3,sp)
 304  0185 1e0b          	ldw	x,(OFST-1,sp)
 305  0187 48            	sll	a
 306  0188 48            	sll	a
 307  0189 48            	sll	a
 308  018a f8            	xor	a,(x)
 309  018b a478          	and	a,#120
 310  018d f8            	xor	a,(x)
 311  018e f7            	ld	(x),a
 312                     ; 120 							done = true;
 313  018f a601          	ld	a,#1
 314  0191 6b05          	ld	(OFST-7,sp),a
 315                     ; 121 							break;
 316  0193 2008          	jra	L511
 317  0195               L711:
 318                     ; 114 					for (j = 0; j < MAX_EXMP; j++)
 319  0195 0c0a          	inc	(OFST-2,sp)
 321  0197 7b0a          	ld	a,(OFST-2,sp)
 322  0199 a102          	cp	a,#2
 323  019b 25c5          	jrult	L111
 324  019d               L511:
 325                     ; 124 					if (done)
 326  019d 7b05          	ld	a,(OFST-7,sp)
 327  019f 2695          	jrne	L57
 328                     ; 126 						break;
 329                     ; 111 				for (i = 0; i < sout->max_nb; i++)
 330  01a1 0c06          	inc	(OFST-6,sp)
 331  01a3               L501:
 333  01a3 1e07          	ldw	x,(OFST-5,sp)
 334  01a5 e602          	ld	a,(2,x)
 335  01a7 1106          	cp	a,(OFST-6,sp)
 336  01a9 229a          	jrugt	L101
 337  01ab cc02f4        	jra	L57
 338  01ae               L77:
 339                     ; 132 				if (pos_configs->current + 1 < sout->max_nb)
 340  01ae f6            	ld	a,(x)
 341  01af a478          	and	a,#120
 342  01b1 44            	srl	a
 343  01b2 44            	srl	a
 344  01b3 44            	srl	a
 345  01b4 5f            	clrw	x
 346  01b5 02            	rlwa	x,a
 347  01b6 1607          	ldw	y,(OFST-5,sp)
 348  01b8 5c            	incw	x
 349  01b9 90e602        	ld	a,(2,y)
 350  01bc 905f          	clrw	y
 351  01be 9097          	ld	yl,a
 352  01c0 90bf00        	ldw	c_y,y
 353  01c3 b300          	cpw	x,c_y
 354  01c5 2ee4          	jrsge	L57
 355                     ; 134 					pos_configs->current += 1;
 356  01c7 1e0b          	ldw	x,(OFST-1,sp)
 357  01c9 f6            	ld	a,(x)
 358  01ca ab08          	add	a,#8
 359                     
 360  01cc cc0257        	jp	LC004
 361  01cf               L35:
 362                     ; 139 		case POS_DEC:			
 362                     ; 140 			if (pos_configs->cycle_en)
 363  01cf 1e0b          	ldw	x,(OFST-1,sp)
 364  01d1 e601          	ld	a,(1,x)
 365  01d3 a501          	bcp	a,#1
 366  01d5 2779          	jreq	L721
 367                     ; 143 				for (i = 0; i < sout->max_nb; i++)
 368  01d7 0f06          	clr	(OFST-6,sp)
 370  01d9 206a          	jra	L531
 371  01db               L131:
 372                     ; 145 					next = (u8)((pos_configs->current + sout->max_nb - 1) %
 372                     ; 146 							sout->max_nb);
 373  01db 1e0b          	ldw	x,(OFST-1,sp)
 374  01dd f6            	ld	a,(x)
 375  01de a478          	and	a,#120
 376  01e0 44            	srl	a
 377  01e1 44            	srl	a
 378  01e2 44            	srl	a
 379  01e3 6b01          	ld	(OFST-11,sp),a
 380  01e5 1e07          	ldw	x,(OFST-5,sp)
 381  01e7 e602          	ld	a,(2,x)
 382  01e9 5f            	clrw	x
 383  01ea 1b01          	add	a,(OFST-11,sp)
 384  01ec 59            	rlcw	x
 385  01ed 02            	rlwa	x,a
 386  01ee 1607          	ldw	y,(OFST-5,sp)
 387  01f0 5a            	decw	x
 388  01f1 90e602        	ld	a,(2,y)
 389  01f4 905f          	clrw	y
 390  01f6 9097          	ld	yl,a
 391  01f8 cd0000        	call	c_idiv
 393  01fb 93            	ldw	x,y
 394  01fc 9f            	ld	a,xl
 395  01fd 6b09          	ld	(OFST-3,sp),a
 396                     ; 147 					for (j = 0; j < MAX_EXMP; j++)
 397  01ff 0f0a          	clr	(OFST-2,sp)
 398  0201               L141:
 399                     ; 149 						if (pos_configs->exclude[j] != NA &&
 399                     ; 150 							pos_configs->exclude[j] != next)
 400  0201 7b0b          	ld	a,(OFST-1,sp)
 401  0203 97            	ld	xl,a
 402  0204 7b0c          	ld	a,(OFST+0,sp)
 403  0206 1b0a          	add	a,(OFST-2,sp)
 404  0208 2401          	jrnc	L65
 405  020a 5c            	incw	x
 406  020b               L65:
 407  020b 02            	rlwa	x,a
 408  020c e604          	ld	a,(4,x)
 409  020e 4c            	inc	a
 410  020f 2723          	jreq	L741
 412  0211 7b0b          	ld	a,(OFST-1,sp)
 413  0213 97            	ld	xl,a
 414  0214 7b0c          	ld	a,(OFST+0,sp)
 415  0216 1b0a          	add	a,(OFST-2,sp)
 416  0218 2401          	jrnc	L06
 417  021a 5c            	incw	x
 418  021b               L06:
 419  021b 02            	rlwa	x,a
 420  021c e604          	ld	a,(4,x)
 421  021e 1109          	cp	a,(OFST-3,sp)
 422  0220 2712          	jreq	L741
 423                     ; 152 							pos_configs->current = next;
 424  0222 7b09          	ld	a,(OFST-3,sp)
 425  0224 1e0b          	ldw	x,(OFST-1,sp)
 426  0226 48            	sll	a
 427  0227 48            	sll	a
 428  0228 48            	sll	a
 429  0229 f8            	xor	a,(x)
 430  022a a478          	and	a,#120
 431  022c f8            	xor	a,(x)
 432  022d f7            	ld	(x),a
 433                     ; 153 							done = true;
 434  022e a601          	ld	a,#1
 435  0230 6b05          	ld	(OFST-7,sp),a
 436                     ; 154 							break;
 437  0232 2008          	jra	L541
 438  0234               L741:
 439                     ; 147 					for (j = 0; j < MAX_EXMP; j++)
 440  0234 0c0a          	inc	(OFST-2,sp)
 442  0236 7b0a          	ld	a,(OFST-2,sp)
 443  0238 a102          	cp	a,#2
 444  023a 25c5          	jrult	L141
 445  023c               L541:
 446                     ; 157 					if (done)
 447  023c 7b05          	ld	a,(OFST-7,sp)
 448  023e 2703cc02f4    	jrne	L57
 449                     ; 159 						break;
 450                     ; 143 				for (i = 0; i < sout->max_nb; i++)
 451  0243 0c06          	inc	(OFST-6,sp)
 452  0245               L531:
 454  0245 1e07          	ldw	x,(OFST-5,sp)
 455  0247 e602          	ld	a,(2,x)
 456  0249 1106          	cp	a,(OFST-6,sp)
 457  024b 228e          	jrugt	L131
 458  024d cc02f4        	jra	L57
 459  0250               L721:
 460                     ; 165 				if (pos_configs->current > 0)
 461  0250 f6            	ld	a,(x)
 462  0251 a578          	bcp	a,#120
 463  0253 27f8          	jreq	L57
 464                     ; 167 					pos_configs->current -= 1;
 465  0255 a008          	sub	a,#8
 466  0257               LC004:
 467  0257 f8            	xor	a,(x)
 468  0258 a47f          	and	a,#127
 469                     
 470  025a 206b          	jp	LC002
 471  025c               L55:
 472                     ; 172 		case POS_DEFAULT:
 472                     ; 173 			if(pos_configs->default_en)
 473  025c 1e0b          	ldw	x,(OFST-1,sp)
 474  025e e601          	ld	a,(1,x)
 475  0260 a502          	bcp	a,#2
 476  0262 27e9          	jreq	L57
 477                     ; 174 				pos_configs->current = pos_configs->pos_default;
 478  0264 a478          	and	a,#120
 479  0266 44            	srl	a
 480  0267 44            	srl	a
 481  0268 44            	srl	a
 482  0269 2056          	jp	LC003
 483  026b               L75:
 484                     ; 177 		case POS_SPEC:			
 484                     ; 178 			if(pos_configs->specific_en)
 485  026b 1e0b          	ldw	x,(OFST-1,sp)
 486  026d e601          	ld	a,(1,x)
 487  026f a504          	bcp	a,#4
 488  0271 27da          	jreq	L57
 489                     ; 179 				pos_configs->current = pos_configs->pos_spec;
 490  0273 fe            	ldw	x,(x)
 491  0274 54            	srlw	x
 492  0275 54            	srlw	x
 493  0276 54            	srlw	x
 494  0277 9f            	ld	a,xl
 495  0278 4e            	swap	a
 496  0279 a40f          	and	a,#15
 497  027b 160b          	ldw	y,(OFST-1,sp)
 498  027d 48            	sll	a
 499  027e 48            	sll	a
 500  027f 48            	sll	a
 501  0280 90f8          	xor	a,(y)
 502  0282 a478          	and	a,#120
 503  0284 90f8          	xor	a,(y)
 504  0286 90f7          	ld	(y),a
 505  0288 206a          	jra	L57
 506  028a               L16:
 507                     ; 182 		case CH3_TOGGLE:
 507                     ; 183 			toggle_it(sout[ch].pos_config.toggle);
 508  028a 7b06          	ld	a,(OFST-6,sp)
 509  028c 97            	ld	xl,a
 510  028d a618          	ld	a,#24
 511  028f 42            	mul	x,a
 512  0290 72fb07        	addw	x,(OFST-5,sp)
 513  0293 89            	pushw	x
 514  0294 7b08          	ld	a,(OFST-4,sp)
 515  0296 97            	ld	xl,a
 516  0297 a618          	ld	a,#24
 517  0299 42            	mul	x,a
 518  029a 72fb09        	addw	x,(OFST-3,sp)
 519  029d e60e          	ld	a,(14,x)
 520  029f 2a03          	jrpl	L26
 521  02a1 4f            	clr	a
 522  02a2 2002          	jra	L46
 523  02a4               L26:
 524  02a4 a601          	ld	a,#1
 525  02a6               L46:
 526  02a6 46            	rrc	a
 527  02a7 85            	popw	x
 528  02a8 46            	rrc	a
 529  02a9 e80e          	xor	a,(14,x)
 530  02ab a480          	and	a,#128
 531  02ad e80e          	xor	a,(14,x)
 532  02af e70e          	ld	(14,x),a
 533                     ; 184 			pos_configs->current = sout[ch].pos_config.toggle;
 534  02b1 7b06          	ld	a,(OFST-6,sp)
 535  02b3 97            	ld	xl,a
 536  02b4 a618          	ld	a,#24
 537  02b6 42            	mul	x,a
 538  02b7 72fb07        	addw	x,(OFST-5,sp)
 539  02ba e60e          	ld	a,(14,x)
 540  02bc 49            	rlc	a
 541  02bd 4f            	clr	a
 542  02be 49            	rlc	a
 543  02bf 1e0b          	ldw	x,(OFST-1,sp)
 544  02c1               LC003:
 545  02c1 48            	sll	a
 546  02c2 48            	sll	a
 547  02c3 48            	sll	a
 548  02c4 f8            	xor	a,(x)
 549  02c5 a478          	and	a,#120
 550  02c7               LC002:
 551  02c7 f8            	xor	a,(x)
 552  02c8 f7            	ld	(x),a
 553                     ; 185 			break;
 554  02c9 2029          	jra	L57
 555  02cb               L36:
 556                     ; 187 		case CH3_PRIFILE_TOGGLE:
 556                     ; 188 			global_flags.ch3_action_profile = 
 556                     ; 189 					(global_flags.ch3_action_profile + 1) %
 556                     ; 190 					 MAX_CH3_PROFILE;
 557                     	btst	_global_flags+1,#2
 564  02d0 49            	rlc	a
 565  02d1 5f            	clrw	x
 566  02d2 02            	rlwa	x,a
 567  02d3 5c            	incw	x
 568  02d4 a602          	ld	a,#2
 569  02d6 cd0000        	call	c_smodx
 571  02d9 01            	rrwa	x,a
 572  02da 44            	srl	a
 573  02db 90150001      	bccm	_global_flags+1,#2
 574  02df               L56:
 575                     ; 192 		case AG_PRIFILE_TOGGLE:
 575                     ; 193 			global_flags.ag_action_profile = 
 575                     ; 194 					(global_flags.ag_action_profile + 1) %
 575                     ; 195 					 MAX_AG_PROFILE;
 576  02df 4f            	clr	a
 577                     	btst	_global_flags+1,#3
 584  02e5 49            	rlc	a
 585  02e6 5f            	clrw	x
 586  02e7 02            	rlwa	x,a
 587  02e8 5c            	incw	x
 588  02e9 a602          	ld	a,#2
 589  02eb cd0000        	call	c_smodx
 591  02ee 01            	rrwa	x,a
 592  02ef 44            	srl	a
 593  02f0 90170001      	bccm	_global_flags+1,#3
 594                     ; 197 		default:
 594                     ; 198 			break;
 595  02f4               L57:
 596                     ; 201 	if (pos_configs->current != current)
 597  02f4 1e0b          	ldw	x,(OFST-1,sp)
 598  02f6 f6            	ld	a,(x)
 599  02f7 a478          	and	a,#120
 600  02f9 44            	srl	a
 601  02fa 44            	srl	a
 602  02fb 44            	srl	a
 603  02fc 1102          	cp	a,(OFST-10,sp)
 604  02fe 2706          	jreq	L361
 605                     ; 202 		pos_configs->mp_update = true;
 606  0300 e603          	ld	a,(3,x)
 607  0302 aa01          	or	a,#1
 608  0304 e703          	ld	(3,x),a
 609  0306               L361:
 610                     ; 204 	return;
 611  0306 5b0d          	addw	sp,#13
 612  0308 81            	ret	
 614                     .bit:	section	.data,bit
 615  0000               L761_ch3_click_is_turnover:
 616  0000 00            	ds.b	1
 617                     	switch	.ubsct
 618  0000               L561_ch3_turnover_timeout:
 619  0000 0000          	ds.b	2
 620                     ; 207 static u8 ch3_clicks_decode(u8 ch3_clicks)
 620                     ; 208 {
 621                     	switch	.text
 622  0309               L11_ch3_clicks_decode:
 623  0309 88            	push	a
 624  030a 88            	push	a
 625       00000001      OFST:	set	1
 627                     ; 213 	ch3_clicks -= 1;
 628  030b 0a02          	dec	(OFST+1,sp)
 629                     ; 215 	if (ch3_click_is_turnover == false)
 630  030d 7b02          	ld	a,(OFST+1,sp)
 631  030f 7200000015    	btjt	L761_ch3_click_is_turnover,L171
 632                     ; 217 		if (ch3_clicks < CH3_TURNOVER)
 633  0314 a103          	cp	a,#3
 634                     ; 219 			actions = ch3_clicks;
 636  0316 2527          	jrult	LC005
 637                     ; 221 		else if (ch3_clicks == CH3_TURNOVER)
 638  0318 2623          	jrne	L112
 639                     ; 223 			ch3_click_is_turnover = true;
 640  031a 72100000      	bset	L761_ch3_click_is_turnover
 641                     ; 224 			actions = CH3_TURNOVER;
 642  031e a603          	ld	a,#3
 643  0320 6b01          	ld	(OFST+0,sp),a
 644                     ; 225 			ch3_turnover_timeout = dev_config.ch3_turnover_timeout;
 645  0322 ce0008        	ldw	x,_dev_config+8
 646  0325 bf00          	ldw	L561_ch3_turnover_timeout,x
 648  0327 2018          	jra	L302
 649                     ; 229 			actions = NOT_VAILD;
 650  0329               L171:
 651                     ; 235 		if (ch3_clicks < CH3_TURNOVER)
 652  0329 a103          	cp	a,#3
 653  032b 2404          	jruge	L502
 654                     ; 237 			actions = (u8)(ch3_clicks + CH3_TO_OFFSET);
 655  032d ab04          	add	a,#4
 657  032f 200e          	jp	LC005
 658  0331               L502:
 659                     ; 239 		else if (ch3_clicks == CH3_TURNOVER)
 660  0331 a103          	cp	a,#3
 661  0333 2608          	jrne	L112
 662                     ; 241 			ch3_click_is_turnover = false;
 663  0335 72110000      	bres	L761_ch3_click_is_turnover
 664                     ; 242 			actions = CH3_TO_OFF;
 665  0339 a607          	ld	a,#7
 667  033b 2002          	jp	LC005
 668  033d               L112:
 669                     ; 246 			actions = NOT_VAILD;
 670  033d a609          	ld	a,#9
 671  033f               LC005:
 672  033f 6b01          	ld	(OFST+0,sp),a
 673  0341               L302:
 674                     ; 250 	if(ch3_click_is_turnover && dev_config.flags.turnover_tmo_en)
 675  0341 7201000010    	btjf	L761_ch3_click_is_turnover,L512
 677  0346 720500010b    	btjf	_dev_config+1,#2,L512
 678                     ; 252 		--ch3_turnover_timeout;
 679  034b be00          	ldw	x,L561_ch3_turnover_timeout
 680  034d 5a            	decw	x
 681  034e bf00          	ldw	L561_ch3_turnover_timeout,x
 682                     ; 253         if (ch3_turnover_timeout == 0) {
 683  0350 2604          	jrne	L512
 684                     ; 254             ch3_click_is_turnover = false;
 685  0352 72110000      	bres	L761_ch3_click_is_turnover
 686  0356               L512:
 687                     ; 258 	return actions;
 689  0356 85            	popw	x
 690  0357 81            	ret	
 692                     ; 261 static void process_ch3_click_timeout(void)
 692                     ; 262 {
 693  0358               L51_process_ch3_click_timeout:
 694  0358 88            	push	a
 695       00000001      OFST:	set	1
 697                     ; 265     if (ch3_clicks == 0) {          // Any clicks pending?
 698  0359 b604          	ld	a,L5_ch3_clicks
 699  035b 2602          	jrne	L122
 700                     ; 266         return;                     // No: nothing to do
 701  035d 84            	pop	a
 702  035e 81            	ret	
 703  035f               L122:
 704                     ; 269     if (ch3_click_counter != 0) {   // Double-click timer expired?
 705  035f be02          	ldw	x,L7_ch3_click_counter
 706  0361 2702          	jreq	L322
 707                     ; 270         return;                     // No: wait for more buttons
 708  0363 84            	pop	a
 709  0364 81            	ret	
 710  0365               L322:
 711                     ; 273 	ret = if_under_setup_actions();
 712  0365 cd0000        	call	_if_under_setup_actions
 714  0368 6b01          	ld	(OFST+0,sp),a
 715                     ; 275 	if (ret)
 716  036a 2707          	jreq	L522
 717                     ; 276 		input_user_acknowledge(ch3_clicks);
 718  036c b604          	ld	a,L5_ch3_clicks
 719  036e cd0000        	call	_input_user_acknowledge
 722  0371 2005          	jra	L722
 723  0373               L522:
 724                     ; 278     	input_process_thread(ch3_clicks);
 725  0373 b604          	ld	a,L5_ch3_clicks
 726  0375 cd00a4        	call	L31_input_process_thread
 728  0378               L722:
 729                     ; 280     ch3_clicks = 0;
 730  0378 3f04          	clr	L5_ch3_clicks
 731                     ; 281 }
 732  037a 84            	pop	a
 733  037b 81            	ret	
 735                     ; 283 static void add_click(void)
 735                     ; 284 {
 736  037c               L71_add_click:
 738                     ; 285     ++ch3_clicks;
 739  037c 3c04          	inc	L5_ch3_clicks
 740                     ; 286     ch3_click_counter = dev_config.ch3_multi_click_timeout;
 741  037e ce000a        	ldw	x,_dev_config+10
 742  0381 bf02          	ldw	L7_ch3_click_counter,x
 743                     ; 287 }
 744  0383 81            	ret	
 746                     	switch	.ubsct
 747  0002               L7_ch3_click_counter:
 748  0002 0000          	ds.b	2
 749  0004               L5_ch3_clicks:
 750  0004 00            	ds.b	1
 751  0005               L3_ch3_flags:
 752  0005 0000          	ds.b	2
 753                     	xref	_beep_notify
 754                     	xref	_get_ch3_state
 755                     	xdef	_input_ch3_handler
 756                     	xref	_input_user_acknowledge
 757                     	xref	_if_under_setup_actions
 758                     	xref	_rc_channel
 759                     	xref	_servo_outputs
 760                     	xref	_ch3_actions
 761                     	xref	_dev_config
 762                     	xref.b	_global_flags
 763                     	xref.b	c_x
 764                     	xref.b	c_y
 765                     	xref	c_smodx
 766                     	xref	c_idiv
 767                     	end

Symbol table:

.1here                          000000b7    Defined
                                  169   165
.2here                          000002d0    Defined
                                  563   559
.3here                          000002e5    Defined
                                  583   579
L01                             00000020    Defined
                                   60    57
L02                             00000065    Defined
                                  103   100
L03                             00000098    Defined
                                  136   133
L05                             0000016c    Defined
                                  285   283
L06                             0000021b    Defined
                                  418   416
L101                            00000145    Defined
                                  255   336
L111                            00000162    Defined
                                  277   323
L112                            0000033d    Defined
                                  668   638   661
L11_ch3_clicks_decode           00000309    Defined
                                  622   182   691
L12                             0000000d    Defined
                                   48    41    44
L122                            0000035f    Defined
                                  703   699
L131                            000001db    Defined
                                  371   457
L141                            00000201    Defined
                                  398   444
L15                             00000139    Defined
                                  245   231
L16                             0000028a    Defined
                                  506   239
L171                            00000329    Defined
                                  650   631
L21                             00000046    Defined
                                   81    78
L23                             0000009c    Defined
                                  138   112   135
L25                             0000017c    Defined
                                  297   295
L26                             000002a4    Defined
                                  523   520
L302                            00000341    Defined
                                  673   648
L31_input_process_thread        000000a4    Defined
                                  150   613   726
L322                            00000365    Defined
                                  710   706
L33                             0000004c    Defined
                                   87    72
L35                             000001cf    Defined
                                  361   233
L36                             000002cb    Defined
                                  555   241
L361                            00000306    Defined
                                  609   160   604
L3_ch3_flags                    00000005    Defined, Zero Page
                                  751    66    72    74    79    82    89   107   109   115
                                  134   137
L4                              0000001d    Defined
                                   58    55
L41                             0000004a    Defined
                                   83    69    80   147
L42                             00000087    Defined
                                  125   122
L46                             000002a6    Defined
                                  525   522
L501                            000001a3    Defined
                                  331   254
L502                            00000331    Defined
                                  658   653
L511                            0000019d    Defined
                                  324   316
L512                            00000356    Defined
                                  686   675   677   683
L51_process_ch3_click_timeout   00000358    Defined
                                  693   144   734
L52                             00000023    Defined
                                   62    50
L522                            00000373    Defined
                                  723   716
L53                             0000007a    Defined
                                  117    93
L531                            00000245    Defined
                                  452   370
L54                             0000009f    Defined
                                  142   107   116   129
L541                            0000023c    Defined
                                  445   437
L55                             0000025c    Defined
                                  471   235
L56                             000002df    Defined
                                  574   243
L561_ch3_turnover_timeout       00000000    Defined, Zero Page
                                  618   646   679   681
L57                             000002f4    Defined
                                  595   244   327   337   354   448   458   463   476   488
                                  505   554
L5_ch3_clicks                   00000004    Defined, Zero Page
                                  749   698   718   725   730   739
L61                             00000064    Defined
                                  101    98
L62                             00000088    Defined
                                  127   124
L65                             0000020b    Defined
                                  406   404
L711                            00000195    Defined
                                  317   289   301
L71_add_click                   0000037c    Defined
                                  736   140   745
L72                             0000002c    Defined
                                   67    64
L721                            00000250    Defined
                                  459   366
L722                            00000378    Defined
                                  728   722
L73                             00000074    Defined
                                  113   105
L741                            00000234    Defined
                                  438   410   422
L75                             0000026b    Defined
                                  483   237
L761_ch3_click_is_turnover      00000000    Defined
                                  615   631   640   663   675   685
L77                             000001ae    Defined
                                  338   250
L7_ch3_click_counter            00000002    Defined, Zero Page
                                  747    43    47   705   742
LC002                           000002c7    Defined
                                  550   470
LC003                           000002c1    Defined
                                  544   482
LC004                           00000257    Defined
                                  466   360
LC005                           0000033f    Defined
                                  671   636   657   667
OFST                            00000001    Defined, Absolute
                                   38    95   104   119   128   158   179   181   184   189
                                  191   194   196   201   203   208   210   216   218   222
                                  227   247   252   257   265   274   276   279   281   282
                                  291   293   294   300   303   304   314   319   321   326
                                  330   333   335   347   356   363   368   373   379   380
                                  383   386   395   397   400   402   403   412   414   415
                                  421   424   425   435   440   442   447   451   454   456
                                  473   485   497   508   512   514   518   534   538   543
                                  597   603   628   630   643   672   714
_beep_notify                    00000000    Public
                                  753   224
_ch3_actions                    00000000    Public
                                  760   178
_dev_config                     00000000    Public
                                  761    50    93   645   677   741
_get_ch3_state                  00000000    Public
                                  754    52
_global_flags                   00000000    Public, Zero Page
                                  762    41    64    69   160   165   559   573   579   593
_if_under_setup_actions         00000000    Public
                                  757   712
_input_ch3_handler              00000000    Defined, Public
                                   36   148
_input_user_acknowledge         00000000    Public
                                  756   719
_rc_channel                     00000000    Public
                                  758    61    77    97   121   132
_servo_outputs                  00000000    Public
                                  759   200   207
c_idiv                          00000000    Public
                                  766   270   391
c_smodx                         00000000    Public
                                  765   569   589
c_x                             00000000    Not Referenced, Public, Zero Page
                                  763
c_y                             00000000    Public, Zero Page
                                  764   352   353
