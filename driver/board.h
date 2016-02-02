#include "globals.h"

extern void board_int(void);
extern void uart_int(void);
extern void uart_send(u8 *data, u8 length);
extern void reboot(void);
extern void delay(u16 ms);
extern bool get_ch3_state(void);
extern void hw_beep_swith(bool on);
extern void led(u8 led);
extern u8 get_dip_state(void);
extern void hw_storage_read(u8 *ee_addr, void *ram_addr, u16 length);
extern void hw_storage_write(u8 *ee_addr, void *ram_addr, u16 length);
extern void pwm_update(u8 channel, u16 duty);

