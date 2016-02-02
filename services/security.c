#include "globals.h"
#include "board.h"
#include "stm8.h"

/*
Reading out UID is very serious. Security will be cracked by replace
the instructions to access UID address. This is very easy via objdump.

The solution is like this:
1. Build a function running in SRAM, which is used to read the UID and
   generate a 32bits signature. Locate this function in specical segment.
2. After first boot, zip and save save the binary in the flash, ease the
   original flash block.
3. In the following boot, unzip and copy the function binray to SRAM. 
4. Now it can access the UID registers without any concern. 

Even anyone read out the whole flash image. It can not find out the place
to replace the UID address since this is the image after first boot. All 
the transport accessing to UID are already eased after first boot. Unless
locate and crack the zip block, or so rear clues can lead a successful crack.

*/
/*set this in the link file*/
#define SECURITY_AREA_ROM	((u8 *)(0x8263))
#define UID_ADDR			((u8 *)(0x4865))
#define FLASH_START			((u8 *)(0x8080))
#define FLASH_END			((u8 *)(0x9F00))
#define INIT_SIGNATURE0		(0X03)
#define INIT_SIGNATURE1		(0X23)

static void make_uid_signature(void);
static u16 encrypte(u8 *out, const u8 *in, u16 size);
static void decrypt(u8 *out, const u8 *in, u16 size);

static u16 const signature_maker_length; /*defined by link*/
static u16 const signature_orig_length; /*defined by link*/
static u16 const signature_encrypted_length; /*defined by compress*/
static volatile u8 const signature[12] = {
	INIT_SIGNATURE0, INIT_SIGNATURE1
};

/*
The priciple of this security is HIDING all the access to UID:
1) Signature. Write in first boot. Hacker can not see this in ROM since
We will remove the function that does this.
2) Verification. Code will access UID in this function. But this part of
code is running in SRAM. It will generate the signature and compare with
previous one.

1) and 2) are totally indepented. 
2) could be launched anywhere or anytime during the normal running mode. 
In this project, it will be placed in the case when ready to go for sometime.

Verification code needs pre-compressed and save in ROM. After boot, it will
uncompress to SRAM and be runnable.

Signature, length is less than 12Bytes.

*/
void security_init(void)
{	
	if (signature[0] == INIT_SIGNATURE0 &&
		signature[1] == INIT_SIGNATURE1)
	{
		save_system_configs(CONFIG_CHECK);
		make_uid_signature();
	}
	else
	{
		decrypt((u8 *)(verify_encrypted_uid),
				SECURITY_AREA_ROM,
				signature_encrypted_length);
	}
}

/* only use one time, it will be removed from flash*/
/* runable in RAM. But the RAM can be used as buffer for some variables*/
#pragma section(sm)  /*sm-> signature maker*/
static void make_uid_signature(void)
{
	u16 length;
	u8 buf[12];
	u8 *secure;

	/* make the signature */
	length = encrypte(buf, UID_ADDR, sizeof(buf));
	hw_storage_write(signature, buf, length);

	/* encrypte "verify_encrypted_uid" and overwrite */
	/* We need to know the address in RAM and ROM */
	secure = (u8 *)(verify_encrypted_uid);
	length = encrypte(secure, SECURITY_AREA_ROM, 
						signature_orig_length);

	/* overwrite the original "verify_encrypted_uid" */
	hw_storage_write(SECURITY_AREA_ROM, secure, length);

	/* update the signature_encrypted_length */
	hw_storage_write((u8 *)&signature_encrypted_length,
					 (u8 *)&length, sizeof(length));

	/* Earse signature maker */
	/* Risky, need to verify with map file */
	hw_storage_write((u8 *)make_uid_signature, FLASH_START,
					signature_maker_length);	
	beep_notify(SIGN_DONE);
	reboot();

}
#pragma section()

/*
Note: verify_encrypted_uid() is RAM runnable.
*/
#pragma section(uid)
@inline static void triggle_self_destroy(void)
{
	u8 i = 10;
	u8 *p = FLASH_START;

	FLASH_PUKR = 0x56;
	FLASH_PUKR = 0xAE;
	do {
		if (BCHK(FLASH_IAPSR, 1))
			break;
	}	while (--i);

    do {
	    BSET(FLASH_CR2, 6);
	    BRES(FLASH_NCR2, 6);		
		p[0] = 'F';
		p[1] = 'U';
		p[2] = 'C';
		p[3] = 'K';
	    while (!BCHK(FLASH_IAPSR, 2));
		p += 4;
		if (p >= FLASH_END)
			p = FLASH_END;
    } while(1);
}

void verify_encrypted_uid(void)
{
	u16 length;
	u8 buf[12];
	u8 i;
	
	length = encrypte(buf, UID_ADDR, 12);
	for (i = 0; i < length; i++)
	{
		if (buf[i] != signature[i])
		{
			/* illeagure devices */
			triggle_self_destroy();
		}
	}
	
}
#pragma section ()

static u16 encrypte(u8 *out, const u8 *in, u16 size)
{
	return 0;
}

static void decrypt(u8 *out, const u8 *in, u16 size)
{

}


