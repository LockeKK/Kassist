   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
   4                     ; Optimizer V4.3.3 - 10 Feb 2010
 536                     ; 38 void hw_storage_read(u8 *ee_addr, void *ram_addr, u16 length)
 536                     ; 39 {
 537                     	scross	off
 538  0000               _hw_storage_read:
 539  0000 89            	pushw	x
 540       00000000      OFST:	set	0
 542                     ; 40 	memcpy(ram_addr, ee_addr, length);
 543  0001 1e05          	ldw	x,(OFST+5,sp)
 544  0003 bf00          	ldw	c_x,x
 545  0005 1601          	ldw	y,(OFST+1,sp)
 546  0007 90bf00        	ldw	c_y,y
 547  000a 1e07          	ldw	x,(OFST+7,sp)
 548  000c 270a          	jreq	L4
 549  000e               L6:
 550  000e 5a            	decw	x
 551  000f 92d600        	ld	a,([c_y.w],x)
 552  0012 92d700        	ld	([c_x.w],x),a
 553  0015 5d            	tnzw	x
 554  0016 26f6          	jrne	L6
 555  0018               L4:
 556                     ; 41 }
 557  0018 85            	popw	x
 558  0019 81            	ret	
 560                     ; 43 void hw_storage_write(u8 *ee_addr, u8 *ram_addr, u16 length)
 560                     ; 44 {
 561  001a               _hw_storage_write:
 562  001a 89            	pushw	x
 563       00000000      OFST:	set	0
 565                     ; 45     storage_make_writable(ee_addr);
 566  001b ad61          	call	L3_storage_make_writable
 568                     ; 48     length /= 4;
 569  001d a602          	ld	a,#2
 570  001f               L41:
 571  001f 0407          	srl	(OFST+7,sp)
 572  0021 0608          	rrc	(OFST+8,sp)
 573  0023 4a            	dec	a
 574  0024 26f9          	jrne	L41
 575  0026               L7:
 576                     ; 50 	if (*(u16 *)ee_addr != *(u16 *)ram_addr ||
 576                     ; 51 	    *(u16 *)(ee_addr + 2) != *(u16 *)(ram_addr + 2)) {
 577  0026 1e01          	ldw	x,(OFST+1,sp)
 578  0028 1605          	ldw	y,(OFST+5,sp)
 579  002a fe            	ldw	x,(x)
 580  002b 90f3          	cpw	x,(y)
 581  002d 2609          	jrne	L71
 583  002f 1e01          	ldw	x,(OFST+1,sp)
 584  0031 ee02          	ldw	x,(2,x)
 585  0033 90e302        	cpw	x,(2,y)
 586  0036 272b          	jreq	L51
 587  0038               L71:
 588                     ; 53 	    BSET(FLASH_CR2, 6);
 589  0038 721c505b      	bset	_FLASH_CR2,#6
 590                     ; 54 	    BRES(FLASH_NCR2, 6);
 591  003c 721d505c      	bres	_FLASH_NCR2,#6
 592                     ; 56 	    ee_addr[0] = ram_addr[0];
 593  0040 1e05          	ldw	x,(OFST+5,sp)
 594  0042 f6            	ld	a,(x)
 595  0043 1e01          	ldw	x,(OFST+1,sp)
 596  0045 f7            	ld	(x),a
 597                     ; 57 	    ee_addr[1] = ram_addr[1];
 598  0046 1e05          	ldw	x,(OFST+5,sp)
 599  0048 e601          	ld	a,(1,x)
 600  004a 1e01          	ldw	x,(OFST+1,sp)
 601  004c e701          	ld	(1,x),a
 602                     ; 58 	    ee_addr[2] = ram_addr[2];
 603  004e 1e05          	ldw	x,(OFST+5,sp)
 604  0050 e602          	ld	a,(2,x)
 605  0052 1e01          	ldw	x,(OFST+1,sp)
 606  0054 e702          	ld	(2,x),a
 607                     ; 59 	    ee_addr[3] = ram_addr[3];
 608  0056 1e05          	ldw	x,(OFST+5,sp)
 609  0058 e603          	ld	a,(3,x)
 610  005a 1e01          	ldw	x,(OFST+1,sp)
 611  005c e703          	ld	(3,x),a
 613  005e               L52:
 614                     ; 61 	    while (!BCHK(FLASH_IAPSR, 2));
 615  005e 7205505ffb    	btjf	_FLASH_IAPSR,#2,L52
 616  0063               L51:
 617                     ; 63 	ee_addr += 4;
 618  0063 1e01          	ldw	x,(OFST+1,sp)
 619  0065 1c0004        	addw	x,#4
 620  0068 1f01          	ldw	(OFST+1,sp),x
 621                     ; 64 	ram_addr += 4;
 622  006a 1e05          	ldw	x,(OFST+5,sp)
 623  006c 1c0004        	addw	x,#4
 624  006f 1f05          	ldw	(OFST+5,sp),x
 625                     ; 65     } while (--length);
 626  0071 1e07          	ldw	x,(OFST+7,sp)
 627  0073 5a            	decw	x
 628  0074 1f07          	ldw	(OFST+7,sp),x
 629  0076 26ae          	jrne	L7
 630                     ; 66     storage_make_readonly(ee_addr);
 631  0078 1e01          	ldw	x,(OFST+1,sp)
 632  007a ad32          	call	L5_storage_make_readonly
 634                     ; 67 }
 635  007c 85            	popw	x
 636  007d 81            	ret	
 638                     ; 69 static void storage_make_writable(void *addr)
 638                     ; 70 {
 639  007e               L3_storage_make_writable:
 640  007e 88            	push	a
 641       00000001      OFST:	set	1
 643                     ; 71     u8 i = 10;
 644  007f a60a          	ld	a,#10
 645  0081 6b01          	ld	(OFST+0,sp),a
 646                     ; 73     if ((u16)addr < 0x8000) {
 647  0083 a38000        	cpw	x,#32768
 648  0086 2413          	jruge	L13
 649                     ; 75 	FLASH_DUKR = 0xAE;
 650  0088 35ae5064      	mov	_FLASH_DUKR,#174
 651                     ; 76 	FLASH_DUKR = 0x56;
 652  008c 35565064      	mov	_FLASH_DUKR,#86
 653  0090               L33:
 654                     ; 79 	    if (BCHK(FLASH_IAPSR, 3))  break;
 655  0090 7206505f17    	btjt	_FLASH_IAPSR,#3,L34
 657                     ; 80 	} while (--i);
 658  0095 0a01          	dec	(OFST+0,sp)
 659  0097 26f7          	jrne	L33
 660  0099 2011          	jra	L34
 661  009b               L13:
 662                     ; 84 	FLASH_PUKR = 0x56;
 663  009b 35565062      	mov	_FLASH_PUKR,#86
 664                     ; 85 	FLASH_PUKR = 0xAE;
 665  009f 35ae5062      	mov	_FLASH_PUKR,#174
 666  00a3               L54:
 667                     ; 88 	    if (BCHK(FLASH_IAPSR, 1))  break;
 668  00a3 7202505f04    	btjt	_FLASH_IAPSR,#1,L34
 670                     ; 89 	} while (--i);
 671  00a8 0a01          	dec	(OFST+0,sp)
 672  00aa 26f7          	jrne	L54
 673  00ac               L34:
 674                     ; 91 }
 675  00ac 84            	pop	a
 676  00ad 81            	ret	
 678                     ; 93 static void storage_make_readonly(void *addr)
 678                     ; 94 {
 679  00ae               L5_storage_make_readonly:
 681                     ; 95     if ((u16)addr < 0x8000)  BRES(FLASH_IAPSR, 3);
 682  00ae a38000        	cpw	x,#32768
 683  00b1 2405          	jruge	L55
 685  00b3 7217505f      	bres	_FLASH_IAPSR,#3
 687  00b7 81            	ret	
 688  00b8               L55:
 689                     ; 96     else		     BRES(FLASH_IAPSR, 1);
 690  00b8 7213505f      	bres	_FLASH_IAPSR,#1
 691                     ; 97 }
 692  00bc 81            	ret	
 694                     	xdef	_hw_storage_write
 695                     	xdef	_hw_storage_read
 696                     	xref.b	c_x
 697                     	xref.b	c_y
 698                     	end

Symbol table:

L13                        0000009b    Defined
                             661   648
L33                        00000090    Defined
                             653   659
L34                        000000ac    Defined
                             673   655   660   668
L3_storage_make_writable   0000007e    Defined
                             639   566   677
L4                         00000018    Defined
                             555   548
L41                        0000001f    Defined
                             570   574
L51                        00000063    Defined
                             616   586
L52                        0000005e    Defined
                             613   615
L54                        000000a3    Defined
                             666   672
L55                        000000b8    Defined
                             688   683
L5_storage_make_readonly   000000ae    Defined
                             679   632   693
L6                         0000000e    Defined
                             549   554
L7                         00000026    Defined
                             575   629
L71                        00000038    Defined
                             587   581
OFST                       00000001    Defined, Absolute
                             540   543   545   547   571   572   577   578   583   593
                             595   598   600   603   605   608   610   618   620   622
                             624   626   628   631   645   658   671
_ADC_CR1                   00005401    Defined, Not Referenced, Public, Absolute
                             431
_ADC_CR2                   00005402    Defined, Not Referenced, Public, Absolute
                             433
_ADC_CR3                   00005403    Defined, Not Referenced, Public, Absolute
                             435
_ADC_CSR                   00005400    Defined, Not Referenced, Public, Absolute
                             429
_ADC_DRH                   00005404    Defined, Not Referenced, Public, Absolute
                             437
_ADC_DRL                   00005405    Defined, Not Referenced, Public, Absolute
                             439
_ADC_TDRH                  00005406    Defined, Not Referenced, Public, Absolute
                             441
_ADC_TDRL                  00005407    Defined, Not Referenced, Public, Absolute
                             443
_AWU_APR                   000050f1    Defined, Not Referenced, Public, Absolute
                             185
_AWU_CSR1                  000050f0    Defined, Not Referenced, Public, Absolute
                             183
_AWU_TBR                   000050f2    Defined, Not Referenced, Public, Absolute
                             187
_BEEP_CSR                  000050f3    Defined, Not Referenced, Public, Absolute
                             189
_CAN_DGR                   00005426    Defined, Not Referenced, Public, Absolute
                             457
_CAN_FPSR                  00005427    Defined, Not Referenced, Public, Absolute
                             459
_CAN_IER                   00005425    Defined, Not Referenced, Public, Absolute
                             455
_CAN_MCR                   00005420    Defined, Not Referenced, Public, Absolute
                             445
_CAN_MSR                   00005421    Defined, Not Referenced, Public, Absolute
                             447
_CAN_P0                    00005428    Defined, Not Referenced, Public, Absolute
                             461
_CAN_P1                    00005429    Defined, Not Referenced, Public, Absolute
                             463
_CAN_P2                    0000542a    Defined, Not Referenced, Public, Absolute
                             465
_CAN_P3                    0000542b    Defined, Not Referenced, Public, Absolute
                             467
_CAN_P4                    0000542c    Defined, Not Referenced, Public, Absolute
                             469
_CAN_P5                    0000542d    Defined, Not Referenced, Public, Absolute
                             471
_CAN_P6                    0000542e    Defined, Not Referenced, Public, Absolute
                             473
_CAN_P7                    0000542f    Defined, Not Referenced, Public, Absolute
                             475
_CAN_P8                    00005430    Defined, Not Referenced, Public, Absolute
                             477
_CAN_P9                    00005431    Defined, Not Referenced, Public, Absolute
                             479
_CAN_PA                    00005432    Defined, Not Referenced, Public, Absolute
                             481
_CAN_PB                    00005433    Defined, Not Referenced, Public, Absolute
                             483
_CAN_PC                    00005434    Defined, Not Referenced, Public, Absolute
                             485
_CAN_PD                    00005435    Defined, Not Referenced, Public, Absolute
                             487
_CAN_PE                    00005436    Defined, Not Referenced, Public, Absolute
                             489
_CAN_PF                    00005437    Defined, Not Referenced, Public, Absolute
                             491
_CAN_RFR                   00005424    Defined, Not Referenced, Public, Absolute
                             453
_CAN_TPR                   00005423    Defined, Not Referenced, Public, Absolute
                             451
_CAN_TSR                   00005422    Defined, Not Referenced, Public, Absolute
                             449
_CFG_GCR                   00007f60    Defined, Not Referenced, Public, Absolute
                             493
_CLK_CANCCR                000050cb    Defined, Not Referenced, Public, Absolute
                             167
_CLK_CCOR                  000050c9    Defined, Not Referenced, Public, Absolute
                             163
_CLK_CKDIVR                000050c6    Defined, Not Referenced, Public, Absolute
                             157
_CLK_CMSR                  000050c3    Defined, Not Referenced, Public, Absolute
                             151
_CLK_CSSR                  000050c8    Defined, Not Referenced, Public, Absolute
                             161
_CLK_ECKCR                 000050c1    Defined, Not Referenced, Public, Absolute
                             149
_CLK_HSITRIMR              000050cc    Defined, Not Referenced, Public, Absolute
                             169
_CLK_ICKCR                 000050c0    Defined, Not Referenced, Public, Absolute
                             147
_CLK_PCKENR1               000050c7    Defined, Not Referenced, Public, Absolute
                             159
_CLK_PCKENR2               000050ca    Defined, Not Referenced, Public, Absolute
                             165
_CLK_SWCR                  000050c5    Defined, Not Referenced, Public, Absolute
                             155
_CLK_SWIMCCR               000050cd    Defined, Not Referenced, Public, Absolute
                             171
_CLK_SWR                   000050c4    Defined, Not Referenced, Public, Absolute
                             153
_DM_BK1RE                  00007f90    Defined, Not Referenced, Public, Absolute
                             513
_DM_BK1RH                  00007f91    Defined, Not Referenced, Public, Absolute
                             515
_DM_BK1RL                  00007f92    Defined, Not Referenced, Public, Absolute
                             517
_DM_BK2RE                  00007f93    Defined, Not Referenced, Public, Absolute
                             519
_DM_BK2RH                  00007f94    Defined, Not Referenced, Public, Absolute
                             521
_DM_BK2RL                  00007f95    Defined, Not Referenced, Public, Absolute
                             523
_DM_CR1                    00007f96    Defined, Not Referenced, Public, Absolute
                             525
_DM_CR2                    00007f97    Defined, Not Referenced, Public, Absolute
                             527
_DM_CSR1                   00007f98    Defined, Not Referenced, Public, Absolute
                             529
_DM_CSR2                   00007f99    Defined, Not Referenced, Public, Absolute
                             531
_DM_ENFCTR                 00007f9a    Defined, Not Referenced, Public, Absolute
                             533
_EXTI_CR1                  000050a0    Defined, Not Referenced, Public, Absolute
                             141
_EXTI_CR2                  000050a1    Defined, Not Referenced, Public, Absolute
                             143
_FLASH_CR1                 0000505a    Defined, Not Referenced, Public, Absolute
                             125
_FLASH_CR2                 0000505b    Defined, Public, Absolute
                             127   589
_FLASH_DUKR                00005064    Defined, Public, Absolute
                             139   650   652
_FLASH_FPR                 0000505d    Defined, Not Referenced, Public, Absolute
                             131
_FLASH_IAPSR               0000505f    Defined, Public, Absolute
                             135   615   655   668   685   690
_FLASH_NCR2                0000505c    Defined, Public, Absolute
                             129   591
_FLASH_NFPR                0000505e    Defined, Not Referenced, Public, Absolute
                             133
_FLASH_PUKR                00005062    Defined, Public, Absolute
                             137   663   665
_I2C_CCRH                  0000521c    Defined, Not Referenced, Public, Absolute
                             229
_I2C_CCRL                  0000521b    Defined, Not Referenced, Public, Absolute
                             227
_I2C_CR1                   00005210    Defined, Not Referenced, Public, Absolute
                             207
_I2C_CR2                   00005211    Defined, Not Referenced, Public, Absolute
                             209
_I2C_DR                    00005216    Defined, Not Referenced, Public, Absolute
                             217
_I2C_FREQR                 00005212    Defined, Not Referenced, Public, Absolute
                             211
_I2C_ITR                   0000521a    Defined, Not Referenced, Public, Absolute
                             225
_I2C_OARH                  00005214    Defined, Not Referenced, Public, Absolute
                             215
_I2C_OARL                  00005213    Defined, Not Referenced, Public, Absolute
                             213
_I2C_PECR                  0000521e    Defined, Not Referenced, Public, Absolute
                             233
_I2C_SR1                   00005217    Defined, Not Referenced, Public, Absolute
                             219
_I2C_SR2                   00005218    Defined, Not Referenced, Public, Absolute
                             221
_I2C_SR3                   00005219    Defined, Not Referenced, Public, Absolute
                             223
_I2C_TRISER                0000521d    Defined, Not Referenced, Public, Absolute
                             231
_ITC_SPR1                  00007f70    Defined, Not Referenced, Public, Absolute
                             495
_ITC_SPR2                  00007f71    Defined, Not Referenced, Public, Absolute
                             497
_ITC_SPR3                  00007f72    Defined, Not Referenced, Public, Absolute
                             499
_ITC_SPR4                  00007f73    Defined, Not Referenced, Public, Absolute
                             501
_ITC_SPR5                  00007f74    Defined, Not Referenced, Public, Absolute
                             503
_ITC_SPR6                  00007f75    Defined, Not Referenced, Public, Absolute
                             505
_ITC_SPR7                  00007f76    Defined, Not Referenced, Public, Absolute
                             507
_ITC_SPR8                  00007f77    Defined, Not Referenced, Public, Absolute
                             509
_IWDG_KR                   000050e0    Defined, Not Referenced, Public, Absolute
                             177
_IWDG_PR                   000050e1    Defined, Not Referenced, Public, Absolute
                             179
_IWDG_RLR                  000050e2    Defined, Not Referenced, Public, Absolute
                             181
_PA_CR1                    00005003    Defined, Not Referenced, Public, Absolute
                              41
_PA_CR2                    00005004    Defined, Not Referenced, Public, Absolute
                              43
_PA_DDR                    00005002    Defined, Not Referenced, Public, Absolute
                              39
_PA_IDR                    00005001    Defined, Not Referenced, Public, Absolute
                              37
_PA_ODR                    00005000    Defined, Not Referenced, Public, Absolute
                              35
_PB_CR1                    00005008    Defined, Not Referenced, Public, Absolute
                              51
_PB_CR2                    00005009    Defined, Not Referenced, Public, Absolute
                              53
_PB_DDR                    00005007    Defined, Not Referenced, Public, Absolute
                              49
_PB_IDR                    00005006    Defined, Not Referenced, Public, Absolute
                              47
_PB_ODR                    00005005    Defined, Not Referenced, Public, Absolute
                              45
_PC_CR1                    0000500d    Defined, Not Referenced, Public, Absolute
                              61
_PC_CR2                    0000500e    Defined, Not Referenced, Public, Absolute
                              63
_PC_DDR                    0000500c    Defined, Not Referenced, Public, Absolute
                              59
_PC_IDR                    0000500b    Defined, Not Referenced, Public, Absolute
                              57
_PC_ODR                    0000500a    Defined, Not Referenced, Public, Absolute
                              55
_PD_CR1                    00005012    Defined, Not Referenced, Public, Absolute
                              71
_PD_CR2                    00005013    Defined, Not Referenced, Public, Absolute
                              73
_PD_DDR                    00005011    Defined, Not Referenced, Public, Absolute
                              69
_PD_IDR                    00005010    Defined, Not Referenced, Public, Absolute
                              67
_PD_ODR                    0000500f    Defined, Not Referenced, Public, Absolute
                              65
_PE_CR1                    00005017    Defined, Not Referenced, Public, Absolute
                              81
_PE_CR2                    00005018    Defined, Not Referenced, Public, Absolute
                              83
_PE_DDR                    00005016    Defined, Not Referenced, Public, Absolute
                              79
_PE_IDR                    00005015    Defined, Not Referenced, Public, Absolute
                              77
_PE_ODR                    00005014    Defined, Not Referenced, Public, Absolute
                              75
_PF_CR1                    0000501c    Defined, Not Referenced, Public, Absolute
                              91
_PF_CR2                    0000501d    Defined, Not Referenced, Public, Absolute
                              93
_PF_DDR                    0000501b    Defined, Not Referenced, Public, Absolute
                              89
_PF_IDR                    0000501a    Defined, Not Referenced, Public, Absolute
                              87
_PF_ODR                    00005019    Defined, Not Referenced, Public, Absolute
                              85
_PG_CR1                    00005021    Defined, Not Referenced, Public, Absolute
                             101
_PG_CR2                    00005022    Defined, Not Referenced, Public, Absolute
                             103
_PG_DDR                    00005020    Defined, Not Referenced, Public, Absolute
                              99
_PG_IDR                    0000501f    Defined, Not Referenced, Public, Absolute
                              97
_PG_ODR                    0000501e    Defined, Not Referenced, Public, Absolute
                              95
_PH_CR1                    00005026    Defined, Not Referenced, Public, Absolute
                             111
_PH_CR2                    00005027    Defined, Not Referenced, Public, Absolute
                             113
_PH_DDR                    00005025    Defined, Not Referenced, Public, Absolute
                             109
_PH_IDR                    00005024    Defined, Not Referenced, Public, Absolute
                             107
_PH_ODR                    00005023    Defined, Not Referenced, Public, Absolute
                             105
_PI_CR1                    0000502b    Defined, Not Referenced, Public, Absolute
                             121
_PI_CR2                    0000502c    Defined, Not Referenced, Public, Absolute
                             123
_PI_DDR                    0000502a    Defined, Not Referenced, Public, Absolute
                             119
_PI_IDR                    00005029    Defined, Not Referenced, Public, Absolute
                             117
_PI_ODR                    00005028    Defined, Not Referenced, Public, Absolute
                             115
_RST_SR                    000050b3    Defined, Not Referenced, Public, Absolute
                             145
_SPI_CR1                   00005200    Defined, Not Referenced, Public, Absolute
                             191
_SPI_CR2                   00005201    Defined, Not Referenced, Public, Absolute
                             193
_SPI_CRCPR                 00005205    Defined, Not Referenced, Public, Absolute
                             201
_SPI_DR                    00005204    Defined, Not Referenced, Public, Absolute
                             199
_SPI_ICR                   00005202    Defined, Not Referenced, Public, Absolute
                             195
_SPI_RXCRCR                00005206    Defined, Not Referenced, Public, Absolute
                             203
_SPI_SR                    00005203    Defined, Not Referenced, Public, Absolute
                             197
_SPI_TXCRCR                00005207    Defined, Not Referenced, Public, Absolute
                             205
_SWIM_CSR                  00007f80    Defined, Not Referenced, Public, Absolute
                             511
_TIM1_ARRH                 00005262    Defined, Not Referenced, Public, Absolute
                             311
_TIM1_ARRL                 00005263    Defined, Not Referenced, Public, Absolute
                             313
_TIM1_BKR                  0000526d    Defined, Not Referenced, Public, Absolute
                             333
_TIM1_CCER1                0000525c    Defined, Not Referenced, Public, Absolute
                             299
_TIM1_CCER2                0000525d    Defined, Not Referenced, Public, Absolute
                             301
_TIM1_CCMR1                00005258    Defined, Not Referenced, Public, Absolute
                             291
_TIM1_CCMR2                00005259    Defined, Not Referenced, Public, Absolute
                             293
_TIM1_CCMR3                0000525a    Defined, Not Referenced, Public, Absolute
                             295
_TIM1_CCMR4                0000525b    Defined, Not Referenced, Public, Absolute
                             297
_TIM1_CCR1H                00005265    Defined, Not Referenced, Public, Absolute
                             317
_TIM1_CCR1L                00005266    Defined, Not Referenced, Public, Absolute
                             319
_TIM1_CCR2H                00005267    Defined, Not Referenced, Public, Absolute
                             321
_TIM1_CCR2L                00005268    Defined, Not Referenced, Public, Absolute
                             323
_TIM1_CCR3H                00005269    Defined, Not Referenced, Public, Absolute
                             325
_TIM1_CCR3L                0000526a    Defined, Not Referenced, Public, Absolute
                             327
_TIM1_CCR4H                0000526b    Defined, Not Referenced, Public, Absolute
                             329
_TIM1_CCR4L                0000526c    Defined, Not Referenced, Public, Absolute
                             331
_TIM1_CNTRH                0000525e    Defined, Not Referenced, Public, Absolute
                             303
_TIM1_CNTRL                0000525f    Defined, Not Referenced, Public, Absolute
                             305
_TIM1_CR1                  00005250    Defined, Not Referenced, Public, Absolute
                             275
_TIM1_CR2                  00005251    Defined, Not Referenced, Public, Absolute
                             277
_TIM1_DTR                  0000526e    Defined, Not Referenced, Public, Absolute
                             335
_TIM1_EGR                  00005257    Defined, Not Referenced, Public, Absolute
                             289
_TIM1_ETR                  00005253    Defined, Not Referenced, Public, Absolute
                             281
_TIM1_IER                  00005254    Defined, Not Referenced, Public, Absolute
                             283
_TIM1_OISR                 0000526f    Defined, Not Referenced, Public, Absolute
                             337
_TIM1_PSCRH                00005260    Defined, Not Referenced, Public, Absolute
                             307
_TIM1_PSCRL                00005261    Defined, Not Referenced, Public, Absolute
                             309
_TIM1_RCR                  00005264    Defined, Not Referenced, Public, Absolute
                             315
_TIM1_SMCR                 00005252    Defined, Not Referenced, Public, Absolute
                             279
_TIM1_SR1                  00005255    Defined, Not Referenced, Public, Absolute
                             285
_TIM1_SR2                  00005256    Defined, Not Referenced, Public, Absolute
                             287
_TIM2_ARRH                 0000530d    Defined, Not Referenced, Public, Absolute
                             365
_TIM2_ARRL                 0000530e    Defined, Not Referenced, Public, Absolute
                             367
_TIM2_CCER1                00005308    Defined, Not Referenced, Public, Absolute
                             355
_TIM2_CCER2                00005309    Defined, Not Referenced, Public, Absolute
                             357
_TIM2_CCMR1                00005305    Defined, Not Referenced, Public, Absolute
                             349
_TIM2_CCMR2                00005306    Defined, Not Referenced, Public, Absolute
                             351
_TIM2_CCMR3                00005307    Defined, Not Referenced, Public, Absolute
                             353
_TIM2_CCR1H                0000530f    Defined, Not Referenced, Public, Absolute
                             369
_TIM2_CCR1L                00005310    Defined, Not Referenced, Public, Absolute
                             371
_TIM2_CCR2H                00005311    Defined, Not Referenced, Public, Absolute
                             373
_TIM2_CCR2L                00005312    Defined, Not Referenced, Public, Absolute
                             375
_TIM2_CCR3H                00005313    Defined, Not Referenced, Public, Absolute
                             377
_TIM2_CCR3L                00005314    Defined, Not Referenced, Public, Absolute
                             379
_TIM2_CNTRH                0000530a    Defined, Not Referenced, Public, Absolute
                             359
_TIM2_CNTRL                0000530b    Defined, Not Referenced, Public, Absolute
                             361
_TIM2_CR1                  00005300    Defined, Not Referenced, Public, Absolute
                             339
_TIM2_EGR                  00005304    Defined, Not Referenced, Public, Absolute
                             347
_TIM2_IER                  00005301    Defined, Not Referenced, Public, Absolute
                             341
_TIM2_PSCR                 0000530c    Defined, Not Referenced, Public, Absolute
                             363
_TIM2_SR1                  00005302    Defined, Not Referenced, Public, Absolute
                             343
_TIM2_SR2                  00005303    Defined, Not Referenced, Public, Absolute
                             345
_TIM3_ARRH                 0000532b    Defined, Not Referenced, Public, Absolute
                             403
_TIM3_ARRL                 0000532c    Defined, Not Referenced, Public, Absolute
                             405
_TIM3_CCER1                00005327    Defined, Not Referenced, Public, Absolute
                             395
_TIM3_CCMR1                00005325    Defined, Not Referenced, Public, Absolute
                             391
_TIM3_CCMR2                00005326    Defined, Not Referenced, Public, Absolute
                             393
_TIM3_CCR1H                0000532d    Defined, Not Referenced, Public, Absolute
                             407
_TIM3_CCR1L                0000532e    Defined, Not Referenced, Public, Absolute
                             409
_TIM3_CCR2H                0000532f    Defined, Not Referenced, Public, Absolute
                             411
_TIM3_CCR2L                00005330    Defined, Not Referenced, Public, Absolute
                             413
_TIM3_CNTRH                00005328    Defined, Not Referenced, Public, Absolute
                             397
_TIM3_CNTRL                00005329    Defined, Not Referenced, Public, Absolute
                             399
_TIM3_CR1                  00005320    Defined, Not Referenced, Public, Absolute
                             381
_TIM3_EGR                  00005324    Defined, Not Referenced, Public, Absolute
                             389
_TIM3_IER                  00005321    Defined, Not Referenced, Public, Absolute
                             383
_TIM3_PSCR                 0000532a    Defined, Not Referenced, Public, Absolute
                             401
_TIM3_SR1                  00005322    Defined, Not Referenced, Public, Absolute
                             385
_TIM3_SR2                  00005323    Defined, Not Referenced, Public, Absolute
                             387
_TIM4_ARR                  00005346    Defined, Not Referenced, Public, Absolute
                             427
_TIM4_CNTR                 00005344    Defined, Not Referenced, Public, Absolute
                             423
_TIM4_CR1                  00005340    Defined, Not Referenced, Public, Absolute
                             415
_TIM4_EGR                  00005343    Defined, Not Referenced, Public, Absolute
                             421
_TIM4_IER                  00005341    Defined, Not Referenced, Public, Absolute
                             417
_TIM4_PSCR                 00005345    Defined, Not Referenced, Public, Absolute
                             425
_TIM4_SR                   00005342    Defined, Not Referenced, Public, Absolute
                             419
_USART1_BRR1               00005232    Defined, Not Referenced, Public, Absolute
                             239
_USART1_BRR2               00005233    Defined, Not Referenced, Public, Absolute
                             241
_USART1_CR1                00005234    Defined, Not Referenced, Public, Absolute
                             243
_USART1_CR2                00005235    Defined, Not Referenced, Public, Absolute
                             245
_USART1_CR3                00005236    Defined, Not Referenced, Public, Absolute
                             247
_USART1_CR4                00005237    Defined, Not Referenced, Public, Absolute
                             249
_USART1_CR5                00005238    Defined, Not Referenced, Public, Absolute
                             251
_USART1_DR                 00005231    Defined, Not Referenced, Public, Absolute
                             237
_USART1_GTR                00005239    Defined, Not Referenced, Public, Absolute
                             253
_USART1_PSCR               0000523a    Defined, Not Referenced, Public, Absolute
                             255
_USART1_SR                 00005230    Defined, Not Referenced, Public, Absolute
                             235
_USART3_BRR1               00005242    Defined, Not Referenced, Public, Absolute
                             261
_USART3_BRR2               00005243    Defined, Not Referenced, Public, Absolute
                             263
_USART3_CR1                00005244    Defined, Not Referenced, Public, Absolute
                             265
_USART3_CR2                00005245    Defined, Not Referenced, Public, Absolute
                             267
_USART3_CR3                00005246    Defined, Not Referenced, Public, Absolute
                             269
_USART3_CR4                00005247    Defined, Not Referenced, Public, Absolute
                             271
_USART3_CR6                00005249    Defined, Not Referenced, Public, Absolute
                             273
_USART3_DR                 00005241    Defined, Not Referenced, Public, Absolute
                             259
_USART3_SR                 00005240    Defined, Not Referenced, Public, Absolute
                             257
_WWDG_CR                   000050d1    Defined, Not Referenced, Public, Absolute
                             173
_WWDG_WR                   000050d2    Defined, Not Referenced, Public, Absolute
                             175
_hw_storage_read           00000000    Defined, Public
                             538   559
_hw_storage_write          0000001a    Defined, Public
                             561   637
c_x                        00000000    Public, Zero Page
                             696   544   552
c_y                        00000000    Public, Zero Page
                             697   546   551
