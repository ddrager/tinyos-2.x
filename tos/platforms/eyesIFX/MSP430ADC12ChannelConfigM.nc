/*
 * Copyright (c) 2004, Technische Universitaet Berlin
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
 * - Neither the name of the Technische Universitaet Berlin nor the names 
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
 *
 * - Revision -------------------------------------------------------------
 * $Revision$
 * $Date$
 * @author: Jan Hauer <hauer@tkn.tu-berlin.de>
 * ========================================================================
 */

/* channel configuration data for eyesIFX{1,2} onboard sensors required by ADCC */
module MSP430ADC12ChannelConfigM {
  uses {
    interface MSP430ADC12ChannelConfig;  
  }
}
implementation
{
  async event msp430adc12_channel_config_t MSP430ADC12ChannelConfig.getConfigurationData(uint8_t channel)
  {
    msp430adc12_channel_config_t defaultConfig = {0,0,0,0,0,0,0,0};
    switch (channel)
    {
      case 0:
        { 
        // external temperature sensor
        msp430adc12_channel_config_t config = {
                      INPUT_CHANNEL_A0, REFERENCE_AVcc_AVss, REFVOLT_LEVEL_1_5,
                      SHT_SOURCE_SMCLK, SHT_CLOCK_DIV_1, SAMPLE_HOLD_4_CYCLES,
                      SAMPCON_SOURCE_SMCLK, SAMPCON_CLOCK_DIV_1 };
        return config;
        }
      case 2: 
        {
        // light sensor
        msp430adc12_channel_config_t config = {
                      INPUT_CHANNEL_A2, REFERENCE_VREFplus_AVss, REFVOLT_LEVEL_1_5,
                      SHT_SOURCE_SMCLK, SHT_CLOCK_DIV_1, SAMPLE_HOLD_64_CYCLES,
                      SAMPCON_SOURCE_SMCLK, SAMPCON_CLOCK_DIV_1 };
        return config;
        }
      case 3: 
        {
        // rssi sensor (vref)
        msp430adc12_channel_config_t config = {
                      INPUT_CHANNEL_A3, REFERENCE_VREFplus_AVss, REFVOLT_LEVEL_1_5,
                      SHT_SOURCE_SMCLK, SHT_CLOCK_DIV_1, SAMPLE_HOLD_4_CYCLES,
                      SAMPCON_SOURCE_SMCLK, SAMPCON_CLOCK_DIV_1 };
        /*
        // rssi sensor (vcc)
        msp430adc12_channel_config_t config = {
                      INPUT_CHANNEL_A3, REFERENCE_AVcc_AVss, REFVOLT_LEVEL_1_5,
                      SHT_SOURCE_SMCLK, SHT_CLOCK_DIV_1, SAMPLE_HOLD_4_CYCLES,
                      SAMPCON_SOURCE_SMCLK, SAMPCON_CLOCK_DIV_1 };
        */
        return config;
        }
        break;
      default:
        break;
    }
    return defaultConfig;
  }
}
