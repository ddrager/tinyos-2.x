// $Id$

/*
 * "Copyright (c) 2000-2005 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 * The implementation of the standard 3 LED mote abstraction.
 *
 * @author Joe Polastre
 * @author Philip Levis
 *
 * @date   March 21, 2005
 */
/*
 * one-led hacks for span, sma 6/2010
 */

module LedsP @safe() {
  provides {
    interface Init;
    interface Leds;
  }
  uses {
    interface GeneralIO as Led0;
    interface GeneralIO as Led1;
    interface GeneralIO as Led2;
  }
}
implementation {
  command error_t Init.init() {
    atomic {
      dbg("Init", "LEDS: initialized.\n");
      call Led0.makeOutput();
      call Led0.set();
    }
    return SUCCESS;
  }

  /* Note: the call is inside the dbg, as it's typically a read of a volatile
     location, so can't be deadcode eliminated */
#define DBGLED(n) \
  dbg("LedsC", "LEDS: Led" #n " %s.\n", call Led ## n .get() ? "off" : "on");

  async command void Leds.led0On() {
    call Led0.clr();
    DBGLED(0);
  }

  async command void Leds.led0Off() {
    call Led0.set();
    DBGLED(0);
  }

  async command void Leds.led0Toggle() {
    call Led0.toggle();
    DBGLED(0);
  }

  async command void Leds.led1On() {
  }

  async command void Leds.led1Off() {
  }

  async command void Leds.led1Toggle() {
  }

  async command void Leds.led2On() {
  }

  async command void Leds.led2Off() {
  }

  async command void Leds.led2Toggle() {
  }

  async command uint8_t Leds.get() {
    uint8_t rval;
    atomic {
      rval = 0;
      if (!call Led0.get()) {
	rval |= LEDS_LED0;
      }
    }
    return rval;
  }

  async command void Leds.set(uint8_t val) {
    atomic {
      if (val & LEDS_LED0) {
	call Leds.led0On();
      }
      else {
	call Leds.led0Off();
      }
    }
  }
}
