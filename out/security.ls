   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
   4                     ; Optimizer V4.3.3 - 10 Feb 2010
 536                     	switch	.data
 537  0000               L71_signature:
 538  0000 03            	dc.b	3
 539  0001 23            	dc.b	35
 540  0002 000000000000  	ds.b	10
 541                     ; 60 void security_init(void)
 541                     ; 61 {	
 542                     	scross	off
 543                     	switch	.text
 544  0000               _security_init:
 546                     ; 62 	if (signature[0] == INIT_SIGNATURE0 &&
 546                     ; 63 		signature[1] == INIT_SIGNATURE1)
 547  0000 c60000        	ld	a,L71_signature
 548  0003 a103          	cp	a,#3
 549  0005 260f          	jrne	L12
 551  0007 c60001        	ld	a,L71_signature+1
 552  000a a123          	cp	a,#35
 553  000c 2608          	jrne	L12
 554                     ; 65 		save_system_configs(CONFIG_CHECK);
 555  000e a601          	ld	a,#1
 556  0010 cd0000        	call	_save_system_configs
 558                     ; 66 		make_uid_signature();
 561  0013 cc0000        	jp	L3_make_uid_signature
 562  0016               L12:
 563                     ; 70 		decrypt((u8 *)(verify_encrypted_uid),
 563                     ; 71 				SECURITY_AREA_ROM,
 563                     ; 72 				signature_encrypted_length);
 564  0016 ce0000        	ldw	x,L51_signature_encrypted_length
 565  0019 89            	pushw	x
 566  001a ae8263        	ldw	x,#33379
 567  001d 89            	pushw	x
 568  001e ae0000        	ldw	x,#_verify_encrypted_uid
 569  0021 ad05          	call	L7_decrypt
 571  0023 5b04          	addw	sp,#4
 572                     ; 74 }
 573  0025 81            	ret	
 575                     ; 79 static void make_uid_signature(void)
 575                     ; 80 {
 576                     .sm:	section	.text
 577  0000               L3_make_uid_signature:
 578  0000 5210          	subw	sp,#16
 579       00000010      OFST:	set	16
 581                     ; 86 	length = encrypte(buf, UID_ADDR, sizeof(buf));
 582  0002 ae000c        	ldw	x,#12
 583  0005 89            	pushw	x
 584  0006 ae4865        	ldw	x,#18533
 585  0009 89            	pushw	x
 586  000a 96            	ldw	x,sp
 587  000b 1c0005        	addw	x,#OFST-11
 588  000e cd0026        	call	L5_encrypte
 590  0011 5b04          	addw	sp,#4
 591  0013 1f0f          	ldw	(OFST-1,sp),x
 592                     ; 87 	hw_storage_write(signature, buf, length);
 593  0015 89            	pushw	x
 594  0016 96            	ldw	x,sp
 595  0017 1c0003        	addw	x,#OFST-13
 596  001a 89            	pushw	x
 597  001b ae0000        	ldw	x,#L71_signature
 598  001e cd0000        	call	_hw_storage_write
 600  0021 5b04          	addw	sp,#4
 601                     ; 91 	secure = (u8 *)(verify_encrypted_uid);
 602  0023 ae0000        	ldw	x,#_verify_encrypted_uid
 603  0026 1f0d          	ldw	(OFST-3,sp),x
 604                     ; 92 	length = encrypte(secure, SECURITY_AREA_ROM, 
 604                     ; 93 						signature_orig_length);
 605  0028 ce0002        	ldw	x,L31_signature_orig_length
 606  002b 89            	pushw	x
 607  002c ae8263        	ldw	x,#33379
 608  002f 89            	pushw	x
 609  0030 ae0000        	ldw	x,#_verify_encrypted_uid
 610  0033 cd0026        	call	L5_encrypte
 612  0036 5b04          	addw	sp,#4
 613  0038 1f0f          	ldw	(OFST-1,sp),x
 614                     ; 96 	hw_storage_write(SECURITY_AREA_ROM, secure, length);
 615  003a 89            	pushw	x
 616  003b 1e0f          	ldw	x,(OFST-1,sp)
 617  003d 89            	pushw	x
 618  003e ae8263        	ldw	x,#33379
 619  0041 cd0000        	call	_hw_storage_write
 621  0044 5b04          	addw	sp,#4
 622                     ; 99 	hw_storage_write((u8 *)&signature_encrypted_length,
 622                     ; 100 					 (u8 *)&length, sizeof(length));
 623  0046 ae0002        	ldw	x,#2
 624  0049 89            	pushw	x
 625  004a 96            	ldw	x,sp
 626  004b 1c0011        	addw	x,#OFST+1
 627  004e 89            	pushw	x
 628  004f ae0000        	ldw	x,#L51_signature_encrypted_length
 629  0052 cd0000        	call	_hw_storage_write
 631  0055 5b04          	addw	sp,#4
 632                     ; 104 	hw_storage_write((u8 *)make_uid_signature, FLASH_START,
 632                     ; 105 					signature_maker_length); 	
 633  0057 ce0004        	ldw	x,L11_signature_maker_length
 634  005a 89            	pushw	x
 635  005b ae8080        	ldw	x,#32896
 636  005e 89            	pushw	x
 637  005f ae0000        	ldw	x,#L3_make_uid_signature
 638  0062 cd0000        	call	_hw_storage_write
 640  0065 5b04          	addw	sp,#4
 641                     ; 106 	reboot();
 642  0067 cd0000        	call	_reboot
 644                     ; 108 }
 645  006a 5b10          	addw	sp,#16
 646  006c 81            	ret	
 648                     ; 141 void verify_encrypted_uid(void)
 648                     ; 142 {
 649                     .uid:	section	.text
 650  0000               _verify_encrypted_uid:
 651  0000 5213          	subw	sp,#19
 652       00000013      OFST:	set	19
 654                     ; 147 	length = encrypte(buf, UID_ADDR, 12);
 655  0002 ae000c        	ldw	x,#12
 656  0005 89            	pushw	x
 657  0006 ae4865        	ldw	x,#18533
 658  0009 89            	pushw	x
 659  000a 96            	ldw	x,sp
 660  000b 1c000b        	addw	x,#OFST-8
 661  000e cd0026        	call	L5_encrypte
 663  0011 5b04          	addw	sp,#4
 664  0013 1f05          	ldw	(OFST-14,sp),x
 665                     ; 148 	for (i = 0; i < length; i++)
 666  0015 0f13          	clr	(OFST+0,sp)
 668  0017 2061          	jra	L53
 669  0019               L13:
 670                     ; 150 		if (buf[i] != signature[i])
 671  0019 5f            	clrw	x
 672  001a 97            	ld	xl,a
 673  001b d60000        	ld	a,(L71_signature,x)
 674  001e 6b01          	ld	(OFST-18,sp),a
 675  0020 96            	ldw	x,sp
 676  0021 1c0007        	addw	x,#OFST-12
 677  0024 9f            	ld	a,xl
 678  0025 5e            	swapw	x
 679  0026 1b13          	add	a,(OFST+0,sp)
 680  0028 2401          	jrnc	L63
 681  002a 5c            	incw	x
 682  002b               L63:
 683  002b 02            	rlwa	x,a
 684  002c f6            	ld	a,(x)
 685  002d 1101          	cp	a,(OFST-18,sp)
 686  002f 2747          	jreq	L14
 687                     ; 117 	u8 i = 10;
 688  0031 a60a          	ld	a,#10
 689  0033 6b02          	ld	(OFST-17,sp),a
 690                     ; 118 	u8 *p = FLASH_START;
 691  0035 ae8080        	ldw	x,#32896
 692  0038 1f03          	ldw	(OFST-16,sp),x
 693                     ; 120 	FLASH_PUKR = 0x56;
 694  003a 35565062      	mov	_FLASH_PUKR,#86
 695                     ; 121 	FLASH_PUKR = 0xAE;
 696  003e 35ae5062      	mov	_FLASH_PUKR,#174
 697  0042               L34:
 698                     ; 123 		if (BCHK(FLASH_IAPSR, 1))
 699  0042 7202505f04    	btjt	_FLASH_IAPSR,#1,L35
 700                     ; 124 			break;
 701                     ; 125 	}	while (--i);
 702  0047 0a02          	dec	(OFST-17,sp)
 703  0049 26f7          	jrne	L34
 704  004b               L35:
 705                     ; 128 	    BSET(FLASH_CR2, 6);
 706  004b 721c505b      	bset	_FLASH_CR2,#6
 707                     ; 129 	    BRES(FLASH_NCR2, 6);		
 708                     ; 130 		p[0] = 'F';
 709  004f a646          	ld	a,#70
 710  0051 721d505c      	bres	_FLASH_NCR2,#6
 711  0055 f7            	ld	(x),a
 712                     ; 131 		p[1] = 'U';
 713  0056 a655          	ld	a,#85
 714  0058 e701          	ld	(1,x),a
 715                     ; 132 		p[2] = 'C';
 716  005a a643          	ld	a,#67
 717  005c e702          	ld	(2,x),a
 718                     ; 133 		p[3] = 'K';
 719  005e a64b          	ld	a,#75
 720  0060 e703          	ld	(3,x),a
 722  0062               L36:
 723                     ; 134 	    while (!BCHK(FLASH_IAPSR, 2));
 724  0062 7205505ffb    	btjf	_FLASH_IAPSR,#2,L36
 725                     ; 135 		p += 4;
 726  0067 1c0004        	addw	x,#4
 727  006a 1f03          	ldw	(OFST-16,sp),x
 728                     ; 136 		if (p >= FLASH_END)
 729  006c a39f00        	cpw	x,#40704
 730  006f 25da          	jrult	L35
 731                     ; 137 			p = FLASH_END;
 732  0071 ae9f00        	ldw	x,#40704
 733  0074 1f03          	ldw	(OFST-16,sp),x
 734  0076 20d3          	jra	L35
 735  0078               L14:
 736                     ; 148 	for (i = 0; i < length; i++)
 737  0078 0c13          	inc	(OFST+0,sp)
 738  007a               L53:
 740  007a 7b13          	ld	a,(OFST+0,sp)
 741  007c 5f            	clrw	x
 742  007d 97            	ld	xl,a
 743  007e 1305          	cpw	x,(OFST-14,sp)
 744  0080 2597          	jrult	L13
 745                     ; 157 }
 746  0082 5b13          	addw	sp,#19
 747  0084 81            	ret	
 749                     ; 160 static u16 encrypte(u8 *out, const u8 *in, u16 size)
 749                     ; 161 {
 750                     	switch	.text
 751  0026               L5_encrypte:
 753                     ; 162 	return 0;
 754  0026 5f            	clrw	x
 756  0027 81            	ret	
 758                     ; 165 static void decrypt(u8 *out, const u8 *in, u16 size)
 758                     ; 166 {
 759  0028               L7_decrypt:
 761                     ; 168 }
 762  0028 81            	ret	
 764                     .const:	section	.text
 765  0000               L51_signature_encrypted_length:
 766  0000 0000          	ds.b	2
 767  0002               L31_signature_orig_length:
 768  0002 0000          	ds.b	2
 769  0004               L11_signature_maker_length:
 770  0004 0000          	ds.b	2
 771                     	xref	_hw_storage_write
 772                     	xref	_reboot
 773                     	xdef	_verify_encrypted_uid
 774                     	xdef	_security_init
 775                     	xref	_save_system_configs
 776                     	end

Symbol table:

L11_signature_maker_length       00000004    Defined
                                   769   633
L12                              00000016    Defined
                                   562   549   553
L13                              00000019    Defined
                                   669   744
L14                              00000078    Defined
                                   735   686
L31_signature_orig_length        00000002    Defined
                                   767   605
L34                              00000042    Defined
                                   697   703
L35                              0000004b    Defined
                                   704   699   730   734
L36                              00000062    Defined
                                   722   724
L3_make_uid_signature            00000000    Defined
                                   577   561   637   647
L51_signature_encrypted_length   00000000    Defined
                                   765   564   628
L53                              0000007a    Defined
                                   738   668
L5_encrypte                      00000026    Defined
                                   751   588   610   661   757
L63                              0000002b    Defined
                                   682   680
L71_signature                    00000000    Defined
                                   537   547   551   597   673
L7_decrypt                       00000028    Defined
                                   759   569   763
OFST                             00000013    Defined, Absolute
                                   579   587   591   595   603   613   616   626   660   664
                                   666   674   676   679   685   689   692   702   727   733
                                   737   740   743
_ADC_CR1                         00005401    Defined, Not Referenced, Public, Absolute
                                   431
_ADC_CR2                         00005402    Defined, Not Referenced, Public, Absolute
                                   433
_ADC_CR3                         00005403    Defined, Not Referenced, Public, Absolute
                                   435
_ADC_CSR                         00005400    Defined, Not Referenced, Public, Absolute
                                   429
_ADC_DRH                         00005404    Defined, Not Referenced, Public, Absolute
                                   437
_ADC_DRL                         00005405    Defined, Not Referenced, Public, Absolute
                                   439
_ADC_TDRH                        00005406    Defined, Not Referenced, Public, Absolute
                                   441
_ADC_TDRL                        00005407    Defined, Not Referenced, Public, Absolute
                                   443
_AWU_APR                         000050f1    Defined, Not Referenced, Public, Absolute
                                   185
_AWU_CSR1                        000050f0    Defined, Not Referenced, Public, Absolute
                                   183
_AWU_TBR                         000050f2    Defined, Not Referenced, Public, Absolute
                                   187
_BEEP_CSR                        000050f3    Defined, Not Referenced, Public, Absolute
                                   189
_CAN_DGR                         00005426    Defined, Not Referenced, Public, Absolute
                                   457
_CAN_FPSR                        00005427    Defined, Not Referenced, Public, Absolute
                                   459
_CAN_IER                         00005425    Defined, Not Referenced, Public, Absolute
                                   455
_CAN_MCR                         00005420    Defined, Not Referenced, Public, Absolute
                                   445
_CAN_MSR                         00005421    Defined, Not Referenced, Public, Absolute
                                   447
_CAN_P0                          00005428    Defined, Not Referenced, Public, Absolute
                                   461
_CAN_P1                          00005429    Defined, Not Referenced, Public, Absolute
                                   463
_CAN_P2                          0000542a    Defined, Not Referenced, Public, Absolute
                                   465
_CAN_P3                          0000542b    Defined, Not Referenced, Public, Absolute
                                   467
_CAN_P4                          0000542c    Defined, Not Referenced, Public, Absolute
                                   469
_CAN_P5                          0000542d    Defined, Not Referenced, Public, Absolute
                                   471
_CAN_P6                          0000542e    Defined, Not Referenced, Public, Absolute
                                   473
_CAN_P7                          0000542f    Defined, Not Referenced, Public, Absolute
                                   475
_CAN_P8                          00005430    Defined, Not Referenced, Public, Absolute
                                   477
_CAN_P9                          00005431    Defined, Not Referenced, Public, Absolute
                                   479
_CAN_PA                          00005432    Defined, Not Referenced, Public, Absolute
                                   481
_CAN_PB                          00005433    Defined, Not Referenced, Public, Absolute
                                   483
_CAN_PC                          00005434    Defined, Not Referenced, Public, Absolute
                                   485
_CAN_PD                          00005435    Defined, Not Referenced, Public, Absolute
                                   487
_CAN_PE                          00005436    Defined, Not Referenced, Public, Absolute
                                   489
_CAN_PF                          00005437    Defined, Not Referenced, Public, Absolute
                                   491
_CAN_RFR                         00005424    Defined, Not Referenced, Public, Absolute
                                   453
_CAN_TPR                         00005423    Defined, Not Referenced, Public, Absolute
                                   451
_CAN_TSR                         00005422    Defined, Not Referenced, Public, Absolute
                                   449
_CFG_GCR                         00007f60    Defined, Not Referenced, Public, Absolute
                                   493
_CLK_CANCCR                      000050cb    Defined, Not Referenced, Public, Absolute
                                   167
_CLK_CCOR                        000050c9    Defined, Not Referenced, Public, Absolute
                                   163
_CLK_CKDIVR                      000050c6    Defined, Not Referenced, Public, Absolute
                                   157
_CLK_CMSR                        000050c3    Defined, Not Referenced, Public, Absolute
                                   151
_CLK_CSSR                        000050c8    Defined, Not Referenced, Public, Absolute
                                   161
_CLK_ECKCR                       000050c1    Defined, Not Referenced, Public, Absolute
                                   149
_CLK_HSITRIMR                    000050cc    Defined, Not Referenced, Public, Absolute
                                   169
_CLK_ICKCR                       000050c0    Defined, Not Referenced, Public, Absolute
                                   147
_CLK_PCKENR1                     000050c7    Defined, Not Referenced, Public, Absolute
                                   159
_CLK_PCKENR2                     000050ca    Defined, Not Referenced, Public, Absolute
                                   165
_CLK_SWCR                        000050c5    Defined, Not Referenced, Public, Absolute
                                   155
_CLK_SWIMCCR                     000050cd    Defined, Not Referenced, Public, Absolute
                                   171
_CLK_SWR                         000050c4    Defined, Not Referenced, Public, Absolute
                                   153
_DM_BK1RE                        00007f90    Defined, Not Referenced, Public, Absolute
                                   513
_DM_BK1RH                        00007f91    Defined, Not Referenced, Public, Absolute
                                   515
_DM_BK1RL                        00007f92    Defined, Not Referenced, Public, Absolute
                                   517
_DM_BK2RE                        00007f93    Defined, Not Referenced, Public, Absolute
                                   519
_DM_BK2RH                        00007f94    Defined, Not Referenced, Public, Absolute
                                   521
_DM_BK2RL                        00007f95    Defined, Not Referenced, Public, Absolute
                                   523
_DM_CR1                          00007f96    Defined, Not Referenced, Public, Absolute
                                   525
_DM_CR2                          00007f97    Defined, Not Referenced, Public, Absolute
                                   527
_DM_CSR1                         00007f98    Defined, Not Referenced, Public, Absolute
                                   529
_DM_CSR2                         00007f99    Defined, Not Referenced, Public, Absolute
                                   531
_DM_ENFCTR                       00007f9a    Defined, Not Referenced, Public, Absolute
                                   533
_EXTI_CR1                        000050a0    Defined, Not Referenced, Public, Absolute
                                   141
_EXTI_CR2                        000050a1    Defined, Not Referenced, Public, Absolute
                                   143
_FLASH_CR1                       0000505a    Defined, Not Referenced, Public, Absolute
                                   125
_FLASH_CR2                       0000505b    Defined, Public, Absolute
                                   127   706
_FLASH_DUKR                      00005064    Defined, Not Referenced, Public, Absolute
                                   139
_FLASH_FPR                       0000505d    Defined, Not Referenced, Public, Absolute
                                   131
_FLASH_IAPSR                     0000505f    Defined, Public, Absolute
                                   135   699   724
_FLASH_NCR2                      0000505c    Defined, Public, Absolute
                                   129   710
_FLASH_NFPR                      0000505e    Defined, Not Referenced, Public, Absolute
                                   133
_FLASH_PUKR                      00005062    Defined, Public, Absolute
                                   137   694   696
_I2C_CCRH                        0000521c    Defined, Not Referenced, Public, Absolute
                                   229
_I2C_CCRL                        0000521b    Defined, Not Referenced, Public, Absolute
                                   227
_I2C_CR1                         00005210    Defined, Not Referenced, Public, Absolute
                                   207
_I2C_CR2                         00005211    Defined, Not Referenced, Public, Absolute
                                   209
_I2C_DR                          00005216    Defined, Not Referenced, Public, Absolute
                                   217
_I2C_FREQR                       00005212    Defined, Not Referenced, Public, Absolute
                                   211
_I2C_ITR                         0000521a    Defined, Not Referenced, Public, Absolute
                                   225
_I2C_OARH                        00005214    Defined, Not Referenced, Public, Absolute
                                   215
_I2C_OARL                        00005213    Defined, Not Referenced, Public, Absolute
                                   213
_I2C_PECR                        0000521e    Defined, Not Referenced, Public, Absolute
                                   233
_I2C_SR1                         00005217    Defined, Not Referenced, Public, Absolute
                                   219
_I2C_SR2                         00005218    Defined, Not Referenced, Public, Absolute
                                   221
_I2C_SR3                         00005219    Defined, Not Referenced, Public, Absolute
                                   223
_I2C_TRISER                      0000521d    Defined, Not Referenced, Public, Absolute
                                   231
_ITC_SPR1                        00007f70    Defined, Not Referenced, Public, Absolute
                                   495
_ITC_SPR2                        00007f71    Defined, Not Referenced, Public, Absolute
                                   497
_ITC_SPR3                        00007f72    Defined, Not Referenced, Public, Absolute
                                   499
_ITC_SPR4                        00007f73    Defined, Not Referenced, Public, Absolute
                                   501
_ITC_SPR5                        00007f74    Defined, Not Referenced, Public, Absolute
                                   503
_ITC_SPR6                        00007f75    Defined, Not Referenced, Public, Absolute
                                   505
_ITC_SPR7                        00007f76    Defined, Not Referenced, Public, Absolute
                                   507
_ITC_SPR8                        00007f77    Defined, Not Referenced, Public, Absolute
                                   509
_IWDG_KR                         000050e0    Defined, Not Referenced, Public, Absolute
                                   177
_IWDG_PR                         000050e1    Defined, Not Referenced, Public, Absolute
                                   179
_IWDG_RLR                        000050e2    Defined, Not Referenced, Public, Absolute
                                   181
_PA_CR1                          00005003    Defined, Not Referenced, Public, Absolute
                                    41
_PA_CR2                          00005004    Defined, Not Referenced, Public, Absolute
                                    43
_PA_DDR                          00005002    Defined, Not Referenced, Public, Absolute
                                    39
_PA_IDR                          00005001    Defined, Not Referenced, Public, Absolute
                                    37
_PA_ODR                          00005000    Defined, Not Referenced, Public, Absolute
                                    35
_PB_CR1                          00005008    Defined, Not Referenced, Public, Absolute
                                    51
_PB_CR2                          00005009    Defined, Not Referenced, Public, Absolute
                                    53
_PB_DDR                          00005007    Defined, Not Referenced, Public, Absolute
                                    49
_PB_IDR                          00005006    Defined, Not Referenced, Public, Absolute
                                    47
_PB_ODR                          00005005    Defined, Not Referenced, Public, Absolute
                                    45
_PC_CR1                          0000500d    Defined, Not Referenced, Public, Absolute
                                    61
_PC_CR2                          0000500e    Defined, Not Referenced, Public, Absolute
                                    63
_PC_DDR                          0000500c    Defined, Not Referenced, Public, Absolute
                                    59
_PC_IDR                          0000500b    Defined, Not Referenced, Public, Absolute
                                    57
_PC_ODR                          0000500a    Defined, Not Referenced, Public, Absolute
                                    55
_PD_CR1                          00005012    Defined, Not Referenced, Public, Absolute
                                    71
_PD_CR2                          00005013    Defined, Not Referenced, Public, Absolute
                                    73
_PD_DDR                          00005011    Defined, Not Referenced, Public, Absolute
                                    69
_PD_IDR                          00005010    Defined, Not Referenced, Public, Absolute
                                    67
_PD_ODR                          0000500f    Defined, Not Referenced, Public, Absolute
                                    65
_PE_CR1                          00005017    Defined, Not Referenced, Public, Absolute
                                    81
_PE_CR2                          00005018    Defined, Not Referenced, Public, Absolute
                                    83
_PE_DDR                          00005016    Defined, Not Referenced, Public, Absolute
                                    79
_PE_IDR                          00005015    Defined, Not Referenced, Public, Absolute
                                    77
_PE_ODR                          00005014    Defined, Not Referenced, Public, Absolute
                                    75
_PF_CR1                          0000501c    Defined, Not Referenced, Public, Absolute
                                    91
_PF_CR2                          0000501d    Defined, Not Referenced, Public, Absolute
                                    93
_PF_DDR                          0000501b    Defined, Not Referenced, Public, Absolute
                                    89
_PF_IDR                          0000501a    Defined, Not Referenced, Public, Absolute
                                    87
_PF_ODR                          00005019    Defined, Not Referenced, Public, Absolute
                                    85
_PG_CR1                          00005021    Defined, Not Referenced, Public, Absolute
                                   101
_PG_CR2                          00005022    Defined, Not Referenced, Public, Absolute
                                   103
_PG_DDR                          00005020    Defined, Not Referenced, Public, Absolute
                                    99
_PG_IDR                          0000501f    Defined, Not Referenced, Public, Absolute
                                    97
_PG_ODR                          0000501e    Defined, Not Referenced, Public, Absolute
                                    95
_PH_CR1                          00005026    Defined, Not Referenced, Public, Absolute
                                   111
_PH_CR2                          00005027    Defined, Not Referenced, Public, Absolute
                                   113
_PH_DDR                          00005025    Defined, Not Referenced, Public, Absolute
                                   109
_PH_IDR                          00005024    Defined, Not Referenced, Public, Absolute
                                   107
_PH_ODR                          00005023    Defined, Not Referenced, Public, Absolute
                                   105
_PI_CR1                          0000502b    Defined, Not Referenced, Public, Absolute
                                   121
_PI_CR2                          0000502c    Defined, Not Referenced, Public, Absolute
                                   123
_PI_DDR                          0000502a    Defined, Not Referenced, Public, Absolute
                                   119
_PI_IDR                          00005029    Defined, Not Referenced, Public, Absolute
                                   117
_PI_ODR                          00005028    Defined, Not Referenced, Public, Absolute
                                   115
_RST_SR                          000050b3    Defined, Not Referenced, Public, Absolute
                                   145
_SPI_CR1                         00005200    Defined, Not Referenced, Public, Absolute
                                   191
_SPI_CR2                         00005201    Defined, Not Referenced, Public, Absolute
                                   193
_SPI_CRCPR                       00005205    Defined, Not Referenced, Public, Absolute
                                   201
_SPI_DR                          00005204    Defined, Not Referenced, Public, Absolute
                                   199
_SPI_ICR                         00005202    Defined, Not Referenced, Public, Absolute
                                   195
_SPI_RXCRCR                      00005206    Defined, Not Referenced, Public, Absolute
                                   203
_SPI_SR                          00005203    Defined, Not Referenced, Public, Absolute
                                   197
_SPI_TXCRCR                      00005207    Defined, Not Referenced, Public, Absolute
                                   205
_SWIM_CSR                        00007f80    Defined, Not Referenced, Public, Absolute
                                   511
_TIM1_ARRH                       00005262    Defined, Not Referenced, Public, Absolute
                                   311
_TIM1_ARRL                       00005263    Defined, Not Referenced, Public, Absolute
                                   313
_TIM1_BKR                        0000526d    Defined, Not Referenced, Public, Absolute
                                   333
_TIM1_CCER1                      0000525c    Defined, Not Referenced, Public, Absolute
                                   299
_TIM1_CCER2                      0000525d    Defined, Not Referenced, Public, Absolute
                                   301
_TIM1_CCMR1                      00005258    Defined, Not Referenced, Public, Absolute
                                   291
_TIM1_CCMR2                      00005259    Defined, Not Referenced, Public, Absolute
                                   293
_TIM1_CCMR3                      0000525a    Defined, Not Referenced, Public, Absolute
                                   295
_TIM1_CCMR4                      0000525b    Defined, Not Referenced, Public, Absolute
                                   297
_TIM1_CCR1H                      00005265    Defined, Not Referenced, Public, Absolute
                                   317
_TIM1_CCR1L                      00005266    Defined, Not Referenced, Public, Absolute
                                   319
_TIM1_CCR2H                      00005267    Defined, Not Referenced, Public, Absolute
                                   321
_TIM1_CCR2L                      00005268    Defined, Not Referenced, Public, Absolute
                                   323
_TIM1_CCR3H                      00005269    Defined, Not Referenced, Public, Absolute
                                   325
_TIM1_CCR3L                      0000526a    Defined, Not Referenced, Public, Absolute
                                   327
_TIM1_CCR4H                      0000526b    Defined, Not Referenced, Public, Absolute
                                   329
_TIM1_CCR4L                      0000526c    Defined, Not Referenced, Public, Absolute
                                   331
_TIM1_CNTRH                      0000525e    Defined, Not Referenced, Public, Absolute
                                   303
_TIM1_CNTRL                      0000525f    Defined, Not Referenced, Public, Absolute
                                   305
_TIM1_CR1                        00005250    Defined, Not Referenced, Public, Absolute
                                   275
_TIM1_CR2                        00005251    Defined, Not Referenced, Public, Absolute
                                   277
_TIM1_DTR                        0000526e    Defined, Not Referenced, Public, Absolute
                                   335
_TIM1_EGR                        00005257    Defined, Not Referenced, Public, Absolute
                                   289
_TIM1_ETR                        00005253    Defined, Not Referenced, Public, Absolute
                                   281
_TIM1_IER                        00005254    Defined, Not Referenced, Public, Absolute
                                   283
_TIM1_OISR                       0000526f    Defined, Not Referenced, Public, Absolute
                                   337
_TIM1_PSCRH                      00005260    Defined, Not Referenced, Public, Absolute
                                   307
_TIM1_PSCRL                      00005261    Defined, Not Referenced, Public, Absolute
                                   309
_TIM1_RCR                        00005264    Defined, Not Referenced, Public, Absolute
                                   315
_TIM1_SMCR                       00005252    Defined, Not Referenced, Public, Absolute
                                   279
_TIM1_SR1                        00005255    Defined, Not Referenced, Public, Absolute
                                   285
_TIM1_SR2                        00005256    Defined, Not Referenced, Public, Absolute
                                   287
_TIM2_ARRH                       0000530d    Defined, Not Referenced, Public, Absolute
                                   365
_TIM2_ARRL                       0000530e    Defined, Not Referenced, Public, Absolute
                                   367
_TIM2_CCER1                      00005308    Defined, Not Referenced, Public, Absolute
                                   355
_TIM2_CCER2                      00005309    Defined, Not Referenced, Public, Absolute
                                   357
_TIM2_CCMR1                      00005305    Defined, Not Referenced, Public, Absolute
                                   349
_TIM2_CCMR2                      00005306    Defined, Not Referenced, Public, Absolute
                                   351
_TIM2_CCMR3                      00005307    Defined, Not Referenced, Public, Absolute
                                   353
_TIM2_CCR1H                      0000530f    Defined, Not Referenced, Public, Absolute
                                   369
_TIM2_CCR1L                      00005310    Defined, Not Referenced, Public, Absolute
                                   371
_TIM2_CCR2H                      00005311    Defined, Not Referenced, Public, Absolute
                                   373
_TIM2_CCR2L                      00005312    Defined, Not Referenced, Public, Absolute
                                   375
_TIM2_CCR3H                      00005313    Defined, Not Referenced, Public, Absolute
                                   377
_TIM2_CCR3L                      00005314    Defined, Not Referenced, Public, Absolute
                                   379
_TIM2_CNTRH                      0000530a    Defined, Not Referenced, Public, Absolute
                                   359
_TIM2_CNTRL                      0000530b    Defined, Not Referenced, Public, Absolute
                                   361
_TIM2_CR1                        00005300    Defined, Not Referenced, Public, Absolute
                                   339
_TIM2_EGR                        00005304    Defined, Not Referenced, Public, Absolute
                                   347
_TIM2_IER                        00005301    Defined, Not Referenced, Public, Absolute
                                   341
_TIM2_PSCR                       0000530c    Defined, Not Referenced, Public, Absolute
                                   363
_TIM2_SR1                        00005302    Defined, Not Referenced, Public, Absolute
                                   343
_TIM2_SR2                        00005303    Defined, Not Referenced, Public, Absolute
                                   345
_TIM3_ARRH                       0000532b    Defined, Not Referenced, Public, Absolute
                                   403
_TIM3_ARRL                       0000532c    Defined, Not Referenced, Public, Absolute
                                   405
_TIM3_CCER1                      00005327    Defined, Not Referenced, Public, Absolute
                                   395
_TIM3_CCMR1                      00005325    Defined, Not Referenced, Public, Absolute
                                   391
_TIM3_CCMR2                      00005326    Defined, Not Referenced, Public, Absolute
                                   393
_TIM3_CCR1H                      0000532d    Defined, Not Referenced, Public, Absolute
                                   407
_TIM3_CCR1L                      0000532e    Defined, Not Referenced, Public, Absolute
                                   409
_TIM3_CCR2H                      0000532f    Defined, Not Referenced, Public, Absolute
                                   411
_TIM3_CCR2L                      00005330    Defined, Not Referenced, Public, Absolute
                                   413
_TIM3_CNTRH                      00005328    Defined, Not Referenced, Public, Absolute
                                   397
_TIM3_CNTRL                      00005329    Defined, Not Referenced, Public, Absolute
                                   399
_TIM3_CR1                        00005320    Defined, Not Referenced, Public, Absolute
                                   381
_TIM3_EGR                        00005324    Defined, Not Referenced, Public, Absolute
                                   389
_TIM3_IER                        00005321    Defined, Not Referenced, Public, Absolute
                                   383
_TIM3_PSCR                       0000532a    Defined, Not Referenced, Public, Absolute
                                   401
_TIM3_SR1                        00005322    Defined, Not Referenced, Public, Absolute
                                   385
_TIM3_SR2                        00005323    Defined, Not Referenced, Public, Absolute
                                   387
_TIM4_ARR                        00005346    Defined, Not Referenced, Public, Absolute
                                   427
_TIM4_CNTR                       00005344    Defined, Not Referenced, Public, Absolute
                                   423
_TIM4_CR1                        00005340    Defined, Not Referenced, Public, Absolute
                                   415
_TIM4_EGR                        00005343    Defined, Not Referenced, Public, Absolute
                                   421
_TIM4_IER                        00005341    Defined, Not Referenced, Public, Absolute
                                   417
_TIM4_PSCR                       00005345    Defined, Not Referenced, Public, Absolute
                                   425
_TIM4_SR                         00005342    Defined, Not Referenced, Public, Absolute
                                   419
_USART1_BRR1                     00005232    Defined, Not Referenced, Public, Absolute
                                   239
_USART1_BRR2                     00005233    Defined, Not Referenced, Public, Absolute
                                   241
_USART1_CR1                      00005234    Defined, Not Referenced, Public, Absolute
                                   243
_USART1_CR2                      00005235    Defined, Not Referenced, Public, Absolute
                                   245
_USART1_CR3                      00005236    Defined, Not Referenced, Public, Absolute
                                   247
_USART1_CR4                      00005237    Defined, Not Referenced, Public, Absolute
                                   249
_USART1_CR5                      00005238    Defined, Not Referenced, Public, Absolute
                                   251
_USART1_DR                       00005231    Defined, Not Referenced, Public, Absolute
                                   237
_USART1_GTR                      00005239    Defined, Not Referenced, Public, Absolute
                                   253
_USART1_PSCR                     0000523a    Defined, Not Referenced, Public, Absolute
                                   255
_USART1_SR                       00005230    Defined, Not Referenced, Public, Absolute
                                   235
_USART3_BRR1                     00005242    Defined, Not Referenced, Public, Absolute
                                   261
_USART3_BRR2                     00005243    Defined, Not Referenced, Public, Absolute
                                   263
_USART3_CR1                      00005244    Defined, Not Referenced, Public, Absolute
                                   265
_USART3_CR2                      00005245    Defined, Not Referenced, Public, Absolute
                                   267
_USART3_CR3                      00005246    Defined, Not Referenced, Public, Absolute
                                   269
_USART3_CR4                      00005247    Defined, Not Referenced, Public, Absolute
                                   271
_USART3_CR6                      00005249    Defined, Not Referenced, Public, Absolute
                                   273
_USART3_DR                       00005241    Defined, Not Referenced, Public, Absolute
                                   259
_USART3_SR                       00005240    Defined, Not Referenced, Public, Absolute
                                   257
_WWDG_CR                         000050d1    Defined, Not Referenced, Public, Absolute
                                   173
_WWDG_WR                         000050d2    Defined, Not Referenced, Public, Absolute
                                   175
_hw_storage_write                00000000    Public
                                   771   598   619   629   638
_reboot                          00000000    Public
                                   772   642
_save_system_configs             00000000    Public
                                   775   556
_security_init                   00000000    Defined, Public
                                   544   574
_verify_encrypted_uid            00000000    Defined, Public
                                   650   568   602   609   748
