/* $Id$ */
/*
 * Copyright (c) 2005 Arch Rock Corporation 
 * All rights reserved. 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *	Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *	Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *  
 *   Neither the name of the Arch Rock Corporation nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE ARCHED
 * ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
/**
 *
 * @author Kaisen Lin
 * @author Phil Buonadonna
 */

#include "im2sb.h"

configuration LIS3L02DQInternalC {
  provides interface Resource[uint8_t id];
  provides interface HplLIS3L02DQ[uint8_t id];
  provides interface SplitControl;
}

implementation {
  components new SimpleFcfsArbiterC( "LIS3L02DQ.Resource" ) as Arbiter;
  components MainC;
  Resource = Arbiter;

  components HplLIS3L02DQLogicSPIP as Logic;
  MainC.SoftwareInit -> Logic;

  components GeneralIOC;
  Logic.InterruptPin -> GeneralIOC.GeneralIO[GPIO_LIS3L02DQ_RDY_INT];
  Logic.InterruptAlert -> GeneralIOC.GpioInterrupt[GPIO_LIS3L02DQ_RDY_INT];

  components HplPXA27xSSP1C;
  // 0: Motorola SPI
  // 3: random guess what SSP Clock Rate should be
  // 7: 8 bit data size OR 15: 16 bit data size?
  // FALSE: No "Receive without transmit"
  components new HalPXA27xSpiPioC(128, 7, FALSE) as HalSpi;
  HalSpi.SSP -> HplPXA27xSSP1C;
  MainC.SoftwareInit -> HalSpi;
  Logic.SpiPacket -> HalSpi.SpiPacket[unique("SPIInstance")];

  components LIS3L02DQInternalP as Internal;
  HplLIS3L02DQ = Internal;
  Internal.ToHPLC -> Logic.HplLIS3L02DQ;
  
  SplitControl = Logic;

  components HplPXA27xGPIOC;
  Logic.SPICLK -> HplPXA27xGPIOC.HplPXA27xGPIOPin[SSP1_SCLK];
  Logic.SPIFRM -> HplPXA27xGPIOC.HplPXA27xGPIOPin[SSP1_SFRM];
  Logic.SPIRxD -> HplPXA27xGPIOC.HplPXA27xGPIOPin[SSP1_RXD];
  Logic.SPITxD -> HplPXA27xGPIOC.HplPXA27xGPIOPin[SSP1_TXD];

  components HalLIS3L02DQControlP as Control;
  Control.Hpl -> Logic;
  
}