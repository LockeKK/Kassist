static void (*timer_callback)(u16 *);

/*
RC channels caputures: TM2, 16bit general timer, 3 channels.prescare: 16
PWM output: TM1, 16bit advanced timer, 4 channels.prescare: 16
20 systick: TM6, 8bit common timer, 1 channels, prescare: 128, counter 200.
*/

void timer_int(void)
{
	hw_timer_int();
	timer_callback = output_raw_channels;
}

static void hw_timer_int()
{

}


@interrupt void timer_interrupt(void)
{
	/*TODO: 20mS timer*/
	++systick_count;
}

@interrupt void SCT_irq_handler(void)
{
    static u16 start[3] = {0, 0, 0};
    static u16 result[3] = {0, 0, 0};
    static u8 channel_flags = 0;
    u16 capture_value;

    int i;

    for (i = 1; i <= 3; i++) {
        // Event i: Capture CTIN_i
        if (LPC_SCT->EVFLAG & (1 << i)) {
            capture_value = LPC_SCT->CAP[i].L;

            if (LPC_SCT->EVENT[i].CTRL & (0x1 << 10)) {
                // Rising edge triggered
                start[i - 1] = capture_value;

                if (channel_flags & (1 << i)) {
                    timer_callback(result);
                    channel_flags = (1 << i);
                }
                channel_flags |= (1 << i);
            }
            else {
                // Falling edge triggered
                if (start[i - 1] > capture_value) {
                    // Compensate for wrap-around
                    capture_value += LPC_SCT->MATCHREL[0].L + 1;
                }
                result[i - 1] = capture_value - start[i - 1];
            }

            LPC_SCT->EVENT[i].CTRL ^= (0x3 << 10);   // IOCOND: toggle edge
            LPC_SCT->EVFLAG = (1 << i);
        }
    }
}

