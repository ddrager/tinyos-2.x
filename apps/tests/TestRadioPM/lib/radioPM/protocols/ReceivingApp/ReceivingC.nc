/*
 * "Copyright (c) 2005 Washington University in St. Louis.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL WASHINGTON UNIVERSITY IN ST. LOUIS BE LIABLE TO ANY PARTY 
 * FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING 
 * OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF WASHINGTON 
 * UNIVERSITY IN ST. LOUIS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * WASHINGTON UNIVERSITY IN ST. LOUIS SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND WASHINGTON UNIVERSITY IN ST. LOUIS HAS NO 
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS."
 */

/**
 *
 * @author Kevin Klues (klueska@cs.wustl.edu)
 * @version $Revision$
 * @date $Date$ 
 */

#include "DutyCycling.h"
    
generic module ReceivingC(DutyCycleModes onTime, DutyCycleModes offTime) {
  uses {
    interface Boot;
    interface Leds;
    interface RadioDutyCycling;
    interface Receive as AMReceiver;
  }
}
implementation {

  event void Boot.booted() {
    call RadioDutyCycling.setModes(onTime, offTime);
  }

  event message_t* AMReceiver.receive(message_t* bufPtr, void* payload, uint8_t len) {
//     call Leds.led1Toggle();
    return bufPtr;
  }

  event void RadioDutyCycling.beginOnTime() {
  }

  event void RadioDutyCycling.beginOffTime() {
  }
}