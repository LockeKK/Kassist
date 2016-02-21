/*
    Copyright (C) 2016 Locke Huang(locke.huang@gmail.com)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

/******************************************************************************

    This module reads the servo pulses for steering, throttle and CH3/AUX
    from a receiver.

    It can also read the pulses from a CPPM output, provided your receiver
    has such an output.

    It populates the global rc_channel[] array with the read data.


    Internal operation for reading servo pulses:
    --------------------------------------------
    The SCTimer in 16-bit mode is utilized.
    We use 3 events, 3 capture registers, and 3 CTIN signals connected to the
    servo input pins. The 16 bit timer L is running at 2 MHz, giving us a
    resolution of 0.5 us.

    At rest, the 3 capture registers wait for a rising edge.
    When an edge is detected the value is retrieved from the capture register
    and stored in a holding place. The edge of the capture block is toggled.

    When a falling edge is detected we calculate the difference (taking
    overflow into account) and store it in a result registers (raw_data, one
    per rc_channel).

    In order to be able to be able to handle missing channels we do the
    following:

    Each rc_channel has a flag that gets set on the rising edge.
    When a rc_channel sees its flag set at a rising edge it clears the
    flags of the *other* channels, but leaves its own flat set. It then copies
    all result registers into transfer registers (one per rc_channel) and sets a
    flag to let the mainloop know that a set of data is available.
    The result registers are cleared.

    This way the first rc_channel that outputs data will dictate the repeat
    frequency of the combined set of channels. If this "dominant rc_channel"
    goes missing, another rc_channel will take over after two pulses.

    Missing channels will have the value 0 in raw_data, active channels the
    measured pulse duration in milliseconds.

    The downside of the algorithm is that there is a one frame delay
    of the output, but it is very robust for use in the pre-processor.


    Internal operation for reading CPPM:
    ------------------------------------
    The SCTimer in 16-bit mode is utilized.
    We use 1 event, 1 capture register, and the CTIN_1 signals connected to the
    ST servo input pin. The 16 bit timer L is running at 2 MHz, giving us a
    resolution of 0.5 us.

    The capture register is setup to trigger of falling edges of the CPPM
    signal. Every time an interrupt occurs the time duration from the
    previous pulse is calculated.

    If that time difference is larger than the largest servo pulse we expect
    (which is 2.5 ms) then we know that a new CPPM "frame" has started and
    we set our state-machine so that the next edge is stored as CH1, then
    the next as CH2, and one more edge as CH3. After we received all
    3 channels we update the rest of the light controller with the new
    data and setup the CPPM reader to wait for a frame sync signal (= >2/5ms
    between interrupts). Smaller pulses (i.e. because the receiver outputs
    more than 3 channles) are ignored.

    In case the receiver outputs less than 3 channels, the frame detection
    function outputs the channels that have been received so far.


******************************************************************************/
#include "globals.h"

#define SERVO_PULSE_CLAMP_LOW 800
#define SERVO_PULSE_CLAMP_HIGH 2300


static enum {
    WAIT_FOR_FIRST_PULSE,
    WAIT_FOR_TIMEOUT,
    NORMAL_OPERATION
} servo_reader_state = WAIT_FOR_FIRST_PULSE;

static volatile bool report_rc_actions = false;
static u32 servo_reader_timer;
static void normalize_channel(RC_CHANNEL_T *c);
static void initialize_channel(RC_CHANNEL_T *c);

void init_servo_reader(void)
{
    global_flags.rc_is_initializing = 1;
	/* dev_config the Timer to capature the pulse*/
	/* TODO*/
}

void read_rc_channels(void)
{
    if (global_flags.systick) {
        if (servo_reader_timer) {
            --servo_reader_timer;
        }
    }

    global_flags.rc_update_event = false;

    if (!report_rc_actions) {
        return;
    }
    report_rc_actions = false;

    switch (servo_reader_state) {
        case WAIT_FOR_FIRST_PULSE:
            servo_reader_timer = dev_config.startup_time;
            servo_reader_state = WAIT_FOR_TIMEOUT;
            break;

        case WAIT_FOR_TIMEOUT:
            if (servo_reader_timer == 0) {
                initialize_channel(&rc_channel[ST]);
                initialize_channel(&rc_channel[TH]);
                normalize_channel(&rc_channel[CH3]);

                servo_reader_state = NORMAL_OPERATION;
                global_flags.rc_is_initializing = 0;
            }
            global_flags.rc_update_event = true;
            break;

        case NORMAL_OPERATION:
            normalize_channel(&rc_channel[ST]);
            normalize_channel(&rc_channel[TH]);
            if (!dev_config.flags.ch3_is_local_switch) {
                normalize_channel(&rc_channel[CH3]);
            }
            global_flags.rc_update_event = true;
            break;

        default:
            servo_reader_state = WAIT_FOR_FIRST_PULSE;
            break;
    }
}

void output_raw_channels(u16 result[3])
{
    rc_channel[ST].raw_data = result[0] >> 1;
    rc_channel[TH].raw_data = result[1] >> 1;
    if (!dev_config.flags.ch3_is_local_switch) {
        rc_channel[CH3].raw_data = result[2] >> 1;
    }

    result[0] = result[1] = result[2] = 0;
    report_rc_actions = true;
}

static void normalize_channel(RC_CHANNEL_T *c)
{
    if (c->raw_data < dev_config.servo_pulse_min  ||  c->raw_data > dev_config.servo_pulse_max) {
        c->normalized = 0;
        c->absolute = 0;
        return;
    }

    if (c->raw_data < SERVO_PULSE_CLAMP_LOW) {
        c->raw_data = SERVO_PULSE_CLAMP_LOW;
    }

    if (c->raw_data > SERVO_PULSE_CLAMP_HIGH) {
        c->raw_data = SERVO_PULSE_CLAMP_HIGH;
    }

    if (c->raw_data == c->endpoint.centre) {
        c->normalized = 0;
    }
    else if (c->raw_data < c->endpoint.centre) {
        if (c->raw_data < c->endpoint.left) {
            c->endpoint.left = c->raw_data;
        }
        // In order to acheive a stable 100% value we actually calculate the
        // percentage up to 101%, and then clamp to 100%.
        c->normalized = (c->endpoint.centre - c->raw_data) * 101 /
            (c->endpoint.centre - c->endpoint.left);
        if (c->normalized > 100) {
            c->normalized = 100;
        }
        if (!c->reversed) {
            c->normalized = -c->normalized;
        }
    }
    else {
        if (c->raw_data > c->endpoint.right) {
            c->endpoint.right = c->raw_data;
        }
        c->normalized = (c->raw_data - c->endpoint.centre) * 101 /
            (c->endpoint.right - c->endpoint.centre);
        if (c->normalized > 100) {
            c->normalized = 100;
        }
        if (c->reversed) {
            c->normalized = -c->normalized;
        }
    }

    if (c->normalized < 0) {
        c->absolute = -c->normalized;
    }
    else {
        c->absolute = c->normalized;
    }
}

static void initialize_channel(RC_CHANNEL_T *c) 
{
    c->endpoint.centre = c->raw_data;
    c->endpoint.left = c->raw_data - dev_config.initial_endpoint_delta;
    c->endpoint.right = c->raw_data + dev_config.initial_endpoint_delta;
}
