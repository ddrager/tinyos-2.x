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
 * @author Joe Polastre
 * Revision:  $Revision$
 *
 * This module provides a wrapper for hardware independent control of
 * the radio.
 */

module CC2420RadioControlM {
  provides {
    interface RadioControl;
    interface RadioPacket;
  }
  uses {
    interface CC2420Control as CC2420;
  }
}

implementation {
  uint8_t rfpower = 0;

  /*************************************************************
   * TinyOS virtual RF channel support
   */
  command error_t RadioControl.SetRFChannel(uint8_t channel) {
    if (channel > call RadioControl.GetMaxChannels() - 1) {
      return FAIL;
    }
    return call CC2420.TunePreset(channel + 11);
  }

  command uint8_t RadioControl.GetRFChannel() {
    return (call CC2420.GetPreset()) - 11;
  }

  command uint8_t RadioControl.GetMaxChannels() {
    return TOS_MAX_CHANNELS;
  }

  /*************************************************************
   * RF output power programming
   */
  command error_t RadioControl.SetRFPower(uint8_t power) {
    atomic rfpower = power;
    // CC2420 power level is between 0 and 31
    return call CC2420.SetRFPower(power >> 3);
  }

  command uint8_t RadioControl.GetRFPower() {
    uint8_t _rfpower = rfpower;
    if (_rfpower > 0)
      return _rfpower;
    else 
      return call CC2420.GetRFPower() << 3;
  }

  /*************************************************************
   * Conversion functions
   */
  command int8_t RadioControl.RFtoDB(uint8_t power) {
    // power declines like log, but for simplicity, we make it linear
    return power/10;
  }

  command uint8_t RadioControl.DBtoRF(int8_t dbm) {
    // power declines like log, but for simplicity, we make it linear
    if (dbm > 0) {
      return 255;
    }
    else if (dbm < -25) {
      return 0;
    }
    return 255 + (dbm*10);
  }

  /*************************************************************
   * Radio Timing characteristics
   */
  command uint16_t RadioControl.getTimeBit() {
    return CC2420_TIME_BIT;
  }

  command uint16_t RadioControl.getTimeByte() {
    return CC2420_TIME_BYTE;
  }

  command uint16_t RadioControl.getTimeSymbol() {
    return CC2420_TIME_SYMBOL;
  }

  /*************************************************************
   * Retrieving common fields from the packet in a platform
   * independent-manner
   *************************************************************/

  /*************************************************************
   * LENGTH
   */
  command uint8_t RadioPacket.getLength(message_t* msg) {
    return msg->header.length;
  }

  command error_t RadioPacket.setLength(message_t* msg, uint8_t _length) {
    atomic msg->header.length = _length;
    return SUCCESS;
  }

  /*************************************************************
   * DATA
   */
  command uint8_t* RadioPacket.getData(message_t* msg) {
    return msg->data;
  }

  /*************************************************************
   * ADDRESS
   */
  command uint16_t RadioPacket.getAddress(message_t* msg) {
    return msg->header.addr;
  }
  command error_t RadioPacket.setAddress(message_t* msg, uint16_t _addr) {
    atomic msg->header.addr = _addr;
    return SUCCESS;
  }

  /*************************************************************
   * GROUP
   */
  command uint16_t RadioPacket.getGroup(message_t* msg) {
    return msg->header.destpan;
  }
  command error_t RadioPacket.setGroup(message_t* msg, uint16_t group) {
    atomic msg->header.destpan = group;
    return SUCCESS;
  }

  /*************************************************************
   * TIME
   */
  command uint16_t RadioPacket.getTime(message_t* msg) {
    return msg->metadata.time;
  }

  /*************************************************************
   * ACKNOWLEDGMENTS
   */
  command bool RadioPacket.isAck(message_t* msg) {
    return msg->metadata.ack;
  }

}