/*
 * Copyright (c) 2004, Technische Universitat Berlin
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the Technische Universitat Berlin nor the names
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * - Revision -------------------------------------------------------------
 * $Revision$
 * $Date$ 
 * ======================================================================== 
 */
 
 /**
 * HPLTDA5250M configuration  
 * Controlling the TDA5250 at the HPL layer.. 
 *
 * @author Kevin Klues (klues@tkn.tu-berlin.de)
 */
 
#include "msp430baudrates.h"
#include "msp430BusResource.h"
enum {
  TDA5250_UART_BUS_ID = unique(MSP430_UARTO_BUS)
};
configuration HPLTDA5250DataC {
  provides {
    interface Init;  
    interface HPLTDA5250Data;
    interface Resource as Resource;
  }
}
implementation {
  components HPLTDA5250DataM
	         , HPLUSART0C
           , TDA5250RadioIO
           ;
   
  Init = HPLTDA5250DataM;
	Init = HPLUSART0C;
  Resource = HPLTDA5250DataM.Resource;
  HPLTDA5250Data = HPLTDA5250DataM;
  
	HPLTDA5250DataM.DATA -> TDA5250RadioIO.TDA5250RadioDATA;
	HPLTDA5250DataM.USARTControl -> HPLUSART0C;
	HPLTDA5250DataM.USARTFeedback -> HPLUSART0C;
	HPLTDA5250DataM.UARTResource -> HPLUSART0C.Resource[TDA5250_UART_BUS_ID];
  HPLTDA5250DataM.ResourceUser -> HPLUSART0C.ResourceUser; 	
}