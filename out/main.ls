   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
   4                     ; Optimizer V4.3.3 - 10 Feb 2010
  34                     ; 24 static void service_systick(void)
  34                     ; 25 {
  35                     	scross	off
  36  0000               L5_service_systick:
  38                     ; 26     if (!systick_count) {
  39  0000 ae0000        	ldw	x,#L3_systick_count
  40  0003 cd0000        	call	c_lzmp
  42  0006 2605          	jrne	L7
  43                     ; 27         global_flags.systick = 0;
  44  0008 72110001      	bres	_global_flags+1,#0
  45                     ; 28         return;
  46  000c 81            	ret	
  47  000d               L7:
  48                     ; 31     global_flags.systick = 1;
  49  000d 72100001      	bset	_global_flags+1,#0
  50                     ; 34     --systick_count;
  51  0011 a601          	ld	a,#1
  53                     ; 36 }
  54  0013 cc0000        	jp	c_lgsbc
  56                     	bsct
  57  0000               L31_no_signal_timeout:
  58  0000 0000          	dc.w	0
  59                     ; 40 static void check_no_signal(void)
  59                     ; 41 {
  60                     	switch	.text
  61  0016               L11_check_no_signal:
  63                     ; 44     if (global_flags.rc_update_event) {
  64  0016 7203000109    	btjf	_global_flags+1,#1,L51
  65                     ; 45         global_flags.no_signal = false;
  66  001b 72190001      	bres	_global_flags+1,#4
  67                     ; 46         no_signal_timeout = dev_config.no_signal_timeout;
  68  001f ce0004        	ldw	x,_dev_config+4
  69  0022 bf00          	ldw	L31_no_signal_timeout,x
  70  0024               L51:
  71                     ; 49     if (global_flags.systick) {
  72  0024 720100010b    	btjf	_global_flags+1,#0,L71
  73                     ; 50         --no_signal_timeout;
  74  0029 be00          	ldw	x,L31_no_signal_timeout
  75  002b 5a            	decw	x
  76  002c bf00          	ldw	L31_no_signal_timeout,x
  77                     ; 51         if (no_signal_timeout == 0) {
  78  002e 2604          	jrne	L71
  79                     ; 52             global_flags.no_signal = true;
  80  0030 72180001      	bset	_global_flags+1,#4
  81  0034               L71:
  82                     ; 55 }
  83  0034 81            	ret	
  85                     ; 57 void diagnostics_service(void)
  85                     ; 58 {
  86  0035               _diagnostics_service:
  88                     ; 59 	if (!global_flags.ready_to_go)
  89  0035 b601          	ld	a,_global_flags+1
  90  0037 a520          	bcp	a,#32
  91                     ; 63 }
  92  0039 81            	ret	
  94                     ; 64 void main(void) 
  94                     ; 65 {
  95  003a               _main:
  97                     ; 66 	board_int();
  98  003a cd0000        	call	_board_int
 100                     ; 67 	host_cmd_init();
 101  003d cd0000        	call	_host_cmd_init
 103                     ; 68 	security_init();	
 104  0040 cd0000        	call	_security_init
 106                     ; 69 	load_all_parameters();	
 107  0043 cd0000        	call	_load_all_parameters
 109                     ; 70 	init_servo_reader();
 110  0046 cd0000        	call	_init_servo_reader
 112                     ; 71 	verify_encrypted_uid();
 113  0049 cd0000        	call	_verify_encrypted_uid
 115  004c               L52:
 116                     ; 75 		service_systick();
 117  004c adb2          	call	L5_service_systick
 119                     ; 76 		read_rc_channels();
 120  004e cd0000        	call	_read_rc_channels
 122                     ; 77 		host_cmd_process();		
 123  0051 cd0000        	call	_host_cmd_process
 125                     ; 78 		check_setup_mode();
 126  0054 cd0000        	call	_check_setup_mode
 128                     ; 79 		input_ch3_handler();
 129  0057 cd0000        	call	_input_ch3_handler
 131                     ; 80 		update_servo_output();
 132  005a cd0000        	call	_update_servo_output
 134                     ; 81 		check_no_signal();
 135  005d adb7          	call	L11_check_no_signal
 137                     ; 82 		diagnostics_service();
 138  005f add4          	call	_diagnostics_service
 141  0061 20e9          	jra	L52
 143                     	xdef	_main
 144                     	xdef	_diagnostics_service
 145                     	switch	.ubsct
 146  0000               L3_systick_count:
 147  0000 00000000      	ds.b	4
 148                     	xref	_board_int
 149                     	xref	_verify_encrypted_uid
 150                     	xref	_security_init
 151                     	xref	_host_cmd_process
 152                     	xref	_host_cmd_init
 153                     	xref	_load_all_parameters
 154                     	xref	_input_ch3_handler
 155                     	xref	_read_rc_channels
 156                     	xref	_init_servo_reader
 157                     	xref	_check_setup_mode
 158                     	xref	_update_servo_output
 159                     	xref	_dev_config
 160                     	xref.b	_global_flags
 161                     	xref	c_lgsbc
 162                     	xref	c_lzmp
 163                     	end

Symbol table:

L11_check_no_signal     00000016    Defined
                           61    84   135
L31_no_signal_timeout   00000000    Defined, Zero Page
                           57    69    74    76
L3_systick_count        00000000    Defined, Zero Page
                          146    39
L51                     00000024    Defined
                           70    64
L52                     0000004c    Defined
                          115   141
L5_service_systick      00000000    Defined
                           36    55   117
L7                      0000000d    Defined
                           47    42
L71                     00000034    Defined
                           81    72    78
_board_int              00000000    Public
                          148    98
_check_setup_mode       00000000    Public
                          157   126
_dev_config             00000000    Public
                          159    68
_diagnostics_service    00000035    Defined, Public
                           86    93   138
_global_flags           00000000    Public, Zero Page
                          160    44    49    64    66    72    80    89
_host_cmd_init          00000000    Public
                          152   101
_host_cmd_process       00000000    Public
                          151   123
_init_servo_reader      00000000    Public
                          156   110
_input_ch3_handler      00000000    Public
                          154   129
_load_all_parameters    00000000    Public
                          153   107
_main                   0000003a    Defined, Public
                           95   142
_read_rc_channels       00000000    Public
                          155   120
_security_init          00000000    Public
                          150   104
_update_servo_output    00000000    Public
                          158   132
_verify_encrypted_uid   00000000    Public
                          149   113
c_lgsbc                 00000000    Public
                          161    54
c_lzmp                  00000000    Public
                          162    40
