   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
   4                     ; Optimizer V4.3.3 - 10 Feb 2010
  34                     	bsct
  35  0000               L3_servo_reader_state:
  36  0000 00            	dc.b	0
  37                     .bit:	section	.data,bit
  38  0000               L5_report_rc_actions:
  39  0000 00            	dc.b	0
  40                     ; 90 void init_servo_reader(void)
  40                     ; 91 {
  41                     	scross	off
  42                     	switch	.text
  43  0000               _init_servo_reader:
  45                     ; 92     global_flags.rc_is_initializing = 1;
  46  0000 721e0001      	bset	_global_flags+1,#7
  47                     ; 95 }
  48  0004 81            	ret	
  50                     ; 97 void read_rc_channels(void)
  50                     ; 98 {
  51  0005               _read_rc_channels:
  53                     ; 99     if (global_flags.systick) {
  54  0005 720100010d    	btjf	_global_flags+1,#0,L52
  55                     ; 100         if (servo_reader_timer) {
  56  000a ae0000        	ldw	x,#L7_servo_reader_timer
  57  000d cd0000        	call	c_lzmp
  59  0010 2705          	jreq	L52
  60                     ; 101             --servo_reader_timer;
  61  0012 a601          	ld	a,#1
  62  0014 cd0000        	call	c_lgsbc
  64  0017               L52:
  65                     ; 105     global_flags.rc_update_event = false;
  66  0017 72130001      	bres	_global_flags+1,#1
  67                     ; 107     if (!report_rc_actions) {
  68  001b 7200000001    	btjt	L5_report_rc_actions,L13
  69                     ; 108         return;
  70  0020 81            	ret	
  71  0021               L13:
  72                     ; 110     report_rc_actions = false;
  73  0021 72110000      	bres	L5_report_rc_actions
  74                     ; 112     switch (servo_reader_state) {
  75  0025 b600          	ld	a,L3_servo_reader_state
  77                     ; 141             break;
  78  0027 2709          	jreq	L51
  79  0029 4a            	dec	a
  80  002a 2717          	jreq	L71
  81  002c 4a            	dec	a
  82  002d 2737          	jreq	L12
  83                     ; 139         default:
  83                     ; 140             servo_reader_state = WAIT_FOR_FIRST_PULSE;
  84  002f 3f00          	clr	L3_servo_reader_state
  85                     ; 141             break;
  86  0031 81            	ret	
  87  0032               L51:
  88                     ; 113         case WAIT_FOR_FIRST_PULSE:
  88                     ; 114             servo_reader_timer = dev_config.startup_time;
  89  0032 ce0002        	ldw	x,_dev_config+2
  90  0035 cd0000        	call	c_uitolx
  92  0038 ae0000        	ldw	x,#L7_servo_reader_timer
  93  003b cd0000        	call	c_rtol
  95                     ; 115             servo_reader_state = WAIT_FOR_TIMEOUT;
  96  003e 35010000      	mov	L3_servo_reader_state,#1
  97                     ; 116             break;
  98  0042 81            	ret	
  99  0043               L71:
 100                     ; 118         case WAIT_FOR_TIMEOUT:
 100                     ; 119             if (servo_reader_timer == 0) {
 101  0043 ae0000        	ldw	x,#L7_servo_reader_timer
 102  0046 cd0000        	call	c_lzmp
 104  0049 262f          	jrne	L14
 105                     ; 120                 initialize_channel(&rc_channel[ST]);
 106  004b ae0000        	ldw	x,#_rc_channel
 107  004e cd01c0        	call	L31_initialize_channel
 109                     ; 121                 initialize_channel(&rc_channel[TH]);
 110  0051 ae000d        	ldw	x,#_rc_channel+13
 111  0054 cd01c0        	call	L31_initialize_channel
 113                     ; 122                 normalize_channel(&rc_channel[CH3]);
 114  0057 ae001a        	ldw	x,#_rc_channel+26
 115  005a ad4d          	call	L11_normalize_channel
 117                     ; 124                 servo_reader_state = NORMAL_OPERATION;
 118  005c 35020000      	mov	L3_servo_reader_state,#2
 119                     ; 125                 global_flags.rc_is_initializing = 0;
 120  0060 721f0001      	bres	_global_flags+1,#7
 121                     ; 127             global_flags.rc_update_event = true;
 122                     ; 128             break;
 123  0064 2014          	jp	L14
 124  0066               L12:
 125                     ; 130         case NORMAL_OPERATION:
 125                     ; 131             normalize_channel(&rc_channel[ST]);
 126  0066 ae0000        	ldw	x,#_rc_channel
 127  0069 ad3e          	call	L11_normalize_channel
 129                     ; 132             normalize_channel(&rc_channel[TH]);
 130  006b ae000d        	ldw	x,#_rc_channel+13
 131  006e ad39          	call	L11_normalize_channel
 133                     ; 133             if (!dev_config.flags.ch3_is_local_switch) {
 134  0070 7200000105    	btjt	_dev_config+1,#0,L14
 135                     ; 134                 normalize_channel(&rc_channel[CH3]);
 136  0075 ae001a        	ldw	x,#_rc_channel+26
 137  0078 ad2f          	call	L11_normalize_channel
 139  007a               L14:
 140                     ; 136             global_flags.rc_update_event = true;
 141  007a 72120001      	bset	_global_flags+1,#1
 142                     ; 137             break;
 143                     ; 143 }
 144  007e 81            	ret	
 146                     ; 145 void output_raw_channels(u16 result[3])
 146                     ; 146 {
 147  007f               _output_raw_channels:
 148  007f 89            	pushw	x
 149       00000000      OFST:	set	0
 151                     ; 147     rc_channel[ST].raw_data = result[0] >> 1;
 152  0080 fe            	ldw	x,(x)
 153  0081 54            	srlw	x
 154  0082 cf0000        	ldw	_rc_channel,x
 155                     ; 148     rc_channel[TH].raw_data = result[1] >> 1;
 156  0085 1e01          	ldw	x,(OFST+1,sp)
 157  0087 ee02          	ldw	x,(2,x)
 158  0089 54            	srlw	x
 159  008a cf000d        	ldw	_rc_channel+13,x
 160                     ; 149     if (!dev_config.flags.ch3_is_local_switch) {
 161  008d 7200000108    	btjt	_dev_config+1,#0,L34
 162                     ; 150         rc_channel[CH3].raw_data = result[2] >> 1;
 163  0092 1e01          	ldw	x,(OFST+1,sp)
 164  0094 ee04          	ldw	x,(4,x)
 165  0096 54            	srlw	x
 166  0097 cf001a        	ldw	_rc_channel+26,x
 167  009a               L34:
 168                     ; 153     result[0] = result[1] = result[2] = 0;
 169  009a 1e01          	ldw	x,(OFST+1,sp)
 170  009c 905f          	clrw	y
 171  009e ef04          	ldw	(4,x),y
 172  00a0 ef02          	ldw	(2,x),y
 173  00a2 ff            	ldw	(x),y
 174                     ; 154     report_rc_actions = true;
 175                     ; 155 }
 176  00a3 85            	popw	x
 177  00a4 72100000      	bset	L5_report_rc_actions
 178  00a8 81            	ret	
 180                     ; 157 static void normalize_channel(RC_CHANNEL_T *c)
 180                     ; 158 {
 181  00a9               L11_normalize_channel:
 182       00000000      OFST:	set	0
 184                     ; 159     if (c->raw_data < dev_config.servo_pulse_min  ||  c->raw_data > dev_config.servo_pulse_max) {
 185  00a9 9093          	ldw	y,x
 186  00ab 89            	pushw	x
 187  00ac 90fe          	ldw	y,(y)
 188  00ae 90c3000c      	cpw	y,_dev_config+12
 189  00b2 250a          	jrult	L74
 191  00b4 9093          	ldw	y,x
 192  00b6 90fe          	ldw	y,(y)
 193  00b8 90c3000e      	cpw	y,_dev_config+14
 194  00bc 230a          	jrule	L54
 195  00be               L74:
 196                     ; 160         c->normalized = 0;
 197  00be 1e01          	ldw	x,(OFST+1,sp)
 198  00c0 905f          	clrw	y
 199  00c2 ef02          	ldw	(2,x),y
 200                     ; 161         c->absolute = 0;
 201  00c4 ef04          	ldw	(4,x),y
 202                     ; 162         return;
 203  00c6 85            	popw	x
 204  00c7 81            	ret	
 205  00c8               L54:
 206                     ; 165     if (c->raw_data < SERVO_PULSE_CLAMP_LOW) {
 207  00c8 1601          	ldw	y,(OFST+1,sp)
 208  00ca 90fe          	ldw	y,(y)
 209  00cc 90a30320      	cpw	y,#800
 210  00d0 2407          	jruge	L15
 211                     ; 166         c->raw_data = SERVO_PULSE_CLAMP_LOW;
 212  00d2 1e01          	ldw	x,(OFST+1,sp)
 213  00d4 90ae0320      	ldw	y,#800
 214  00d8 ff            	ldw	(x),y
 215  00d9               L15:
 216                     ; 169     if (c->raw_data > SERVO_PULSE_CLAMP_HIGH) {
 217  00d9 1601          	ldw	y,(OFST+1,sp)
 218  00db 90fe          	ldw	y,(y)
 219  00dd 90a308fd      	cpw	y,#2301
 220  00e1 2507          	jrult	L35
 221                     ; 170         c->raw_data = SERVO_PULSE_CLAMP_HIGH;
 222  00e3 1e01          	ldw	x,(OFST+1,sp)
 223  00e5 90ae08fc      	ldw	y,#2300
 224  00e9 ff            	ldw	(x),y
 225  00ea               L35:
 226                     ; 173     if (c->raw_data == c->endpoint.centre) {
 227  00ea 1e01          	ldw	x,(OFST+1,sp)
 228  00ec 9093          	ldw	y,x
 229  00ee fe            	ldw	x,(x)
 230  00ef 90e309        	cpw	x,(9,y)
 231  00f2 2607          	jrne	L55
 232                     ; 174         c->normalized = 0;
 233  00f4 1e01          	ldw	x,(OFST+1,sp)
 234  00f6 905f          	clrw	y
 236  00f8 cc01a7        	jp	LC002
 237  00fb               L55:
 238                     ; 176     else if (c->raw_data < c->endpoint.centre) {
 239  00fb 1e01          	ldw	x,(OFST+1,sp)
 240  00fd fe            	ldw	x,(x)
 241  00fe 90e309        	cpw	x,(9,y)
 242  0101 1e01          	ldw	x,(OFST+1,sp)
 243  0103 fe            	ldw	x,(x)
 244  0104 244e          	jruge	L16
 245                     ; 177         if (c->raw_data < c->endpoint.left) {
 246  0106 90e307        	cpw	x,(7,y)
 247  0109 240a          	jruge	L36
 248                     ; 178             c->endpoint.left = c->raw_data;
 249  010b 1e01          	ldw	x,(OFST+1,sp)
 250  010d 9093          	ldw	y,x
 251  010f 90fe          	ldw	y,(y)
 252  0111 ef07          	ldw	(7,x),y
 253  0113 9093          	ldw	y,x
 254  0115               L36:
 255                     ; 182         c->normalized = (c->endpoint.centre - c->raw_data) * 101 /
 255                     ; 183             (c->endpoint.centre - c->endpoint.left);
 256  0115 90fe          	ldw	y,(y)
 257  0117 1e01          	ldw	x,(OFST+1,sp)
 258  0119 ee09          	ldw	x,(9,x)
 259  011b 90bf00        	ldw	c_x,y
 260  011e 90ae0065      	ldw	y,#101
 261  0122 72b00000      	subw	x,c_x
 262  0126 cd0000        	call	c_imul
 264  0129 89            	pushw	x
 265  012a 1e03          	ldw	x,(OFST+3,sp)
 266  012c 1603          	ldw	y,(OFST+3,sp)
 267  012e ee09          	ldw	x,(9,x)
 268  0130 90ee07        	ldw	y,(7,y)
 269  0133 90bf00        	ldw	c_x,y
 270  0136 9085          	popw	y
 271  0138 72b00000      	subw	x,c_x
 272  013c 51            	exgw	x,y
 273  013d 65            	divw	x,y
 274  013e 9093          	ldw	y,x
 275  0140 1e01          	ldw	x,(OFST+1,sp)
 276                     ; 184         if (c->normalized > 100) {
 277  0142 90a30065      	cpw	y,#101
 278  0146 2f04          	jrslt	L56
 279                     ; 185             c->normalized = 100;
 280  0148 90ae0064      	ldw	y,#100
 281  014c               L56:
 282  014c ef02          	ldw	(2,x),y
 283                     ; 187         if (!c->reversed) {
 284  014e e606          	ld	a,(6,x)
 285  0150 2657          	jrne	L75
 286                     ; 188             c->normalized = -c->normalized;
 287  0152 204c          	jp	LC003
 288  0154               L16:
 289                     ; 192         if (c->raw_data > c->endpoint.right) {
 290  0154 90e30b        	cpw	x,(11,y)
 291  0157 230a          	jrule	L37
 292                     ; 193             c->endpoint.right = c->raw_data;
 293  0159 1e01          	ldw	x,(OFST+1,sp)
 294  015b 9093          	ldw	y,x
 295  015d 90fe          	ldw	y,(y)
 296  015f ef0b          	ldw	(11,x),y
 297  0161 9093          	ldw	y,x
 298  0163               L37:
 299                     ; 195         c->normalized = (c->raw_data - c->endpoint.centre) * 101 /
 299                     ; 196             (c->endpoint.right - c->endpoint.centre);
 300  0163 90ee09        	ldw	y,(9,y)
 301  0166 1e01          	ldw	x,(OFST+1,sp)
 302  0168 fe            	ldw	x,(x)
 303  0169 90bf00        	ldw	c_x,y
 304  016c 90ae0065      	ldw	y,#101
 305  0170 72b00000      	subw	x,c_x
 306  0174 cd0000        	call	c_imul
 308  0177 89            	pushw	x
 309  0178 1e03          	ldw	x,(OFST+3,sp)
 310  017a 1603          	ldw	y,(OFST+3,sp)
 311  017c ee0b          	ldw	x,(11,x)
 312  017e 90ee09        	ldw	y,(9,y)
 313  0181 90bf00        	ldw	c_x,y
 314  0184 9085          	popw	y
 315  0186 72b00000      	subw	x,c_x
 316  018a 51            	exgw	x,y
 317  018b 65            	divw	x,y
 318  018c 9093          	ldw	y,x
 319  018e 1e01          	ldw	x,(OFST+1,sp)
 320                     ; 197         if (c->normalized > 100) {
 321  0190 90a30065      	cpw	y,#101
 322  0194 2f04          	jrslt	L57
 323                     ; 198             c->normalized = 100;
 324  0196 90ae0064      	ldw	y,#100
 325  019a               L57:
 326  019a ef02          	ldw	(2,x),y
 327                     ; 200         if (c->reversed) {
 328  019c e606          	ld	a,(6,x)
 329  019e 2709          	jreq	L75
 330                     ; 201             c->normalized = -c->normalized;
 331  01a0               LC003:
 332  01a0 9093          	ldw	y,x
 333  01a2 90ee02        	ldw	y,(2,y)
 334  01a5 9050          	negw	y
 335  01a7               LC002:
 336  01a7 ef02          	ldw	(2,x),y
 337  01a9               L75:
 338                     ; 205     if (c->normalized < 0) {
 339  01a9 e602          	ld	a,(2,x)
 340  01ab 2a0a          	jrpl	L101
 341                     ; 206         c->absolute = -c->normalized;
 342  01ad ee02          	ldw	x,(2,x)
 343  01af 1601          	ldw	y,(OFST+1,sp)
 344  01b1 50            	negw	x
 345  01b2 90ef04        	ldw	(4,y),x
 347  01b5 2007          	jra	L301
 348  01b7               L101:
 349                     ; 209         c->absolute = c->normalized;
 350  01b7 9093          	ldw	y,x
 351  01b9 90ee02        	ldw	y,(2,y)
 352  01bc ef04          	ldw	(4,x),y
 353  01be               L301:
 354                     ; 211 }
 355  01be 85            	popw	x
 356  01bf 81            	ret	
 358                     ; 213 static void initialize_channel(RC_CHANNEL_T *c) 
 358                     ; 214 {
 359  01c0               L31_initialize_channel:
 360       00000000      OFST:	set	0
 362                     ; 215     c->endpoint.centre = c->raw_data;
 363  01c0 9093          	ldw	y,x
 364  01c2 89            	pushw	x
 365  01c3 90fe          	ldw	y,(y)
 366  01c5 ef09          	ldw	(9,x),y
 367                     ; 216     c->endpoint.left = c->raw_data - dev_config.initial_endpoint_delta;
 368  01c7 fe            	ldw	x,(x)
 369  01c8 1601          	ldw	y,(OFST+1,sp)
 370  01ca 72b00010      	subw	x,_dev_config+16
 371  01ce 90ef07        	ldw	(7,y),x
 372                     ; 217     c->endpoint.right = c->raw_data + dev_config.initial_endpoint_delta;
 373  01d1 1e01          	ldw	x,(OFST+1,sp)
 374  01d3 fe            	ldw	x,(x)
 375  01d4 72bb0010      	addw	x,_dev_config+16
 376  01d8 90ef0b        	ldw	(11,y),x
 377                     ; 218 }
 378  01db 85            	popw	x
 379  01dc 81            	ret	
 381                     	switch	.ubsct
 382  0000               L7_servo_reader_timer:
 383  0000 00000000      	ds.b	4
 384                     	xdef	_read_rc_channels
 385                     	xdef	_output_raw_channels
 386                     	xdef	_init_servo_reader
 387                     	xref	_rc_channel
 388                     	xref	_dev_config
 389                     	xref.b	_global_flags
 390                     	xref.b	c_x
 391                     	xref	c_imul
 392                     	xref	c_rtol
 393                     	xref	c_uitolx
 394                     	xref	c_lgsbc
 395                     	xref	c_lzmp
 396                     	end

Symbol table:

L101                     000001b7    Defined
                           348   340
L11_normalize_channel    000000a9    Defined
                           181   115   127   131   137   357
L12                      00000066    Defined
                           124    82
L13                      00000021    Defined
                            71    68
L14                      0000007a    Defined
                           139   104   123   134
L15                      000000d9    Defined
                           215   210
L16                      00000154    Defined
                           288   244
L301                     000001be    Defined
                           353   347
L31_initialize_channel   000001c0    Defined
                           359   107   111   380
L34                      0000009a    Defined
                           167   161
L35                      000000ea    Defined
                           225   220
L36                      00000115    Defined
                           254   247
L37                      00000163    Defined
                           298   291
L3_servo_reader_state    00000000    Defined, Zero Page
                            35    75    84    96   118
L51                      00000032    Defined
                            87    78
L52                      00000017    Defined
                            64    54    59
L54                      000000c8    Defined
                           205   194
L55                      000000fb    Defined
                           237   231
L56                      0000014c    Defined
                           281   278
L57                      0000019a    Defined
                           325   322
L5_report_rc_actions     00000000    Defined
                            38    68    73   177
L71                      00000043    Defined
                            99    80
L74                      000000be    Defined
                           195   189
L75                      000001a9    Defined
                           337   285   329
L7_servo_reader_timer    00000000    Defined, Zero Page
                           382    56    92   101
LC002                    000001a7    Defined
                           335   236
LC003                    000001a0    Defined
                           331   287
OFST                     00000000    Defined, Absolute
                           149   156   163   169   197   207   212   217   222   227
                           233   239   242   249   257   265   266   275   293   301
                           309   310   319   343   369   373
_dev_config              00000000    Public
                           388    89   134   161   188   193   370   375
_global_flags            00000000    Public, Zero Page
                           389    46    54    66   120   141
_init_servo_reader       00000000    Defined, Public
                            43    49
_output_raw_channels     0000007f    Defined, Public
                           147   179
_rc_channel              00000000    Public
                           387   106   110   114   126   130   136   154   159   166
_read_rc_channels        00000005    Defined, Public
                            51   145
c_imul                   00000000    Public
                           391   262   306
c_lgsbc                  00000000    Public
                           394    62
c_lzmp                   00000000    Public
                           395    57   102
c_rtol                   00000000    Public
                           392    93
c_uitolx                 00000000    Public
                           393    90
c_x                      00000000    Public, Zero Page
                           390   259   261   269   271   303   305   313   315
