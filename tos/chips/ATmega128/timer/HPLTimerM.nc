/// $Id$

/**
 * Copyright (c) 2004-2005 Crossbow Technology, Inc.  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL CROSSBOW TECHNOLOGY OR ANY OF ITS LICENSORS BE LIABLE TO 
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL 
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF CROSSBOW OR ITS LICENSOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
 * DAMAGE. 
 *
 * CROSSBOW TECHNOLOGY AND ITS LICENSORS SPECIFICALLY DISCLAIM ALL WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY 
 * AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS 
 * ON AN "AS IS" BASIS, AND NEITHER CROSSBOW NOR ANY LICENSOR HAS ANY 
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR 
 * MODIFICATIONS.
 */

/// @author Martin Turon <mturon@xbow.com>

#include <ATm128Timer.h>

module HPLTimerM
{
  provides {
      // 8-bit Timers
      interface HPLTimer<uint8_t>   as Timer0;
      interface HPLTimerCtrl8       as Timer0Ctrl;
      interface HPLCompare<uint8_t> as Compare0;

      interface HPLTimer<uint8_t>   as Timer2;
      interface HPLTimerCtrl8       as Timer2Ctrl;
      interface HPLCompare<uint8_t> as Compare2;

      // 16-bit Timers
      interface HPLTimer<uint16_t>   as Timer1;
      interface HPLTimerCtrl16       as Timer1Ctrl;
      interface HPLCapture<uint16_t> as Capture1;
      interface HPLCompare<uint16_t> as Compare1A;
      interface HPLCompare<uint16_t> as Compare1B;
      interface HPLCompare<uint16_t> as Compare1C;

      interface HPLTimer<uint16_t>   as Timer3;
      interface HPLTimerCtrl16       as Timer3Ctrl;
      interface HPLCapture<uint16_t> as Capture3;
      interface HPLCompare<uint16_t> as Compare3A;
      interface HPLCompare<uint16_t> as Compare3B;
      interface HPLCompare<uint16_t> as Compare3C;
  }
}
implementation
{
  //=== Read the current timer value. ===================================
  async command uint8_t  Timer0.get() { return TCNT0; }
  async command uint8_t  Timer2.get() { return TCNT2; }
  async command uint16_t Timer1.get() { return TCNT1; }
  async command uint16_t Timer3.get() { return TCNT3; }

  //=== Set/clear the current timer value. ==============================
  async command void Timer0.set(uint8_t t)  { TCNT0 = t; }
  async command void Timer2.set(uint8_t t)  { TCNT2 = t; }
  async command void Timer1.set(uint16_t t) { TCNT1 = t; }
  async command void Timer3.set(uint16_t t) { TCNT3 = t; }

  //=== Read the current timer scale. ===================================
  async command uint8_t Timer0.getScale() { return TCCR0 & 0x7; }
  async command uint8_t Timer2.getScale() { return TCCR2 & 0x7; }
  async command uint8_t Timer1.getScale() { return TCCR1B & 0x7; }
  async command uint8_t Timer3.getScale() { return TCCR3B & 0x7; }

  //=== Turn off the timers. ============================================
  async command void Timer0.off() { call Timer2.setScale(AVR_CLOCK_OFF); }
  async command void Timer2.off() { call Timer2.setScale(AVR_CLOCK_OFF); }
  async command void Timer1.off() { call Timer2.setScale(AVR_CLOCK_OFF); }
  async command void Timer3.off() { call Timer2.setScale(AVR_CLOCK_OFF); }

  //=== Write a new timer scale. ========================================
  async command void Timer0.setScale(uint8_t s)  { 
      ATm128TimerControl_t x = call Timer0Ctrl.getControl();
      x.bits.cs = s;
      call Timer0Ctrl.setControl(x);  
  }
  async command void Timer2.setScale(uint8_t s)  { 
      ATm128TimerControl_t x = call Timer2Ctrl.getControl();
      x.bits.cs = s;
      call Timer2Ctrl.setControl(x);  
  }
  async command void Timer1.setScale(uint8_t s)  { 
      ATm128TimerCtrlCapture_t x = call Timer1Ctrl.getCtrlCapture();
      x.bits.cs = s;
      call Timer1Ctrl.setCtrlCapture(x);  
  }
  async command void Timer3.setScale(uint8_t s)  { 
      ATm128TimerCtrlCapture_t x = call Timer3Ctrl.getCtrlCapture();
      x.bits.cs = s;
      call Timer3Ctrl.setCtrlCapture(x);  
  }

  //=== Read the control registers. =====================================
  async command ATm128TimerControl_t Timer0Ctrl.getControl() { 
      return *(ATm128TimerControl_t*)&TCCR0; 
  }
  async command ATm128TimerControl_t Timer2Ctrl.getControl() { 
      return *(ATm128TimerControl_t*)&TCCR2; 
  }
  async command ATm128TimerCtrlCompare_t Timer1Ctrl.getCtrlCompare() { 
      return *(ATm128TimerCtrlCompare_t*)&TCCR1A; 
  }
  async command ATm128TimerCtrlCompare_t Timer3Ctrl.getCtrlCompare() { 
      return *(ATm128TimerCtrlCompare_t*)&TCCR3A; 
  }
  async command ATm128TimerCtrlCapture_t Timer1Ctrl.getCtrlCapture() { 
      return *(ATm128TimerCtrlCapture_t*)&TCCR1B; 
  }
  async command ATm128TimerCtrlCapture_t Timer3Ctrl.getCtrlCapture() { 
      return *(ATm128TimerCtrlCapture_t*)&TCCR3B; 
  }
  async command ATm128TimerCtrlClock_t Timer1Ctrl.getCtrlClock() { 
      return *(ATm128TimerCtrlClock_t*)&TCCR1C; 
  }
  async command ATm128TimerCtrlClock_t Timer3Ctrl.getCtrlClock() { 
      return *(ATm128TimerCtrlClock_t*)&TCCR3C; 
  }


  //=== Control registers utilities. ==================================
  DEFINE_UNION_CAST(TimerCtrlCompare2int, ATm128TimerCtrlCompare_t, uint16_t);
  DEFINE_UNION_CAST(TimerCtrlCapture2int, ATm128TimerCtrlCapture_t, uint16_t);
  DEFINE_UNION_CAST(TimerCtrlClock2int, ATm128TimerCtrlClock_t, uint16_t);

  //=== Write the control registers. ====================================
  async command void Timer0Ctrl.setControl( ATm128TimerControl_t x ) { 
      TCCR0 = x.flat; 
  }
  async command void Timer2Ctrl.setControl( ATm128TimerControl_t x ) { 
      TCCR2 = x.flat; 
  }
  async command void Timer1Ctrl.setCtrlCompare( ATm128_TCCR1A_t x ) { 
      TCCR1A = TimerCtrlCompare2int(x); 
  }
  async command void Timer1Ctrl.setCtrlCapture( ATm128_TCCR1B_t x ) { 
      TCCR1B = TimerCtrlCapture2int(x); 
  }
  async command void Timer1Ctrl.setCtrlClock( ATm128_TCCR1C_t x ) { 
      TCCR1C = TimerCtrlClock2int(x); 
  }
  async command void Timer3Ctrl.setCtrlCompare( ATm128_TCCR3A_t x ) { 
      TCCR3A = TimerCtrlCompare2int(x); 
  }
  async command void Timer3Ctrl.setCtrlCapture( ATm128_TCCR3B_t x ) { 
      TCCR3B = TimerCtrlCapture2int(x); 
  }
  async command void Timer3Ctrl.setCtrlClock( ATm128_TCCR3C_t x ) { 
      TCCR3C = TimerCtrlClock2int(x); 
  }

  //=== Read the interrupt mask. =====================================
  async command ATm128_TIMSK_t Timer0Ctrl.getInterruptMask() { 
      return *(ATm128_TIMSK_t*)&TIMSK; 
  }
  async command ATm128_TIMSK_t Timer2Ctrl.getInterruptMask() { 
      return *(ATm128_TIMSK_t*)&TIMSK; 
  }
  async command ATm128_ETIMSK_t Timer1Ctrl.getInterruptMask() { 
      return *(ATm128_ETIMSK_t*)&ETIMSK; 
  }
  async command ATm128_ETIMSK_t Timer3Ctrl.getInterruptMask() { 
      return *(ATm128_ETIMSK_t*)&ETIMSK; 
  }

  //=== Write the interrupt mask. ====================================
  DEFINE_UNION_CAST(TimerMask8_2int, ATm128_TIMSK_t, uint8_t);
  DEFINE_UNION_CAST(TimerMask16_2int, ATm128_ETIMSK_t, uint8_t);

  async command void Timer0Ctrl.setInterruptMask( ATm128_TIMSK_t x ) { 
      TIMSK = TimerMask8_2int(x); 
  }
  async command void Timer2Ctrl.setInterruptMask( ATm128_TIMSK_t x ) { 
      TIMSK = TimerMask8_2int(x); 
  }
  async command void Timer1Ctrl.setInterruptMask( ATm128_ETIMSK_t x ) { 
      ETIMSK = TimerMask16_2int(x); 
  }
  async command void Timer3Ctrl.setInterruptMask( ATm128_ETIMSK_t x ) { 
      ETIMSK = TimerMask16_2int(x); 
  }

  //=== Read the interrupt flags. =====================================
  async command ATm128_TIFR_t Timer0Ctrl.getInterruptFlag() { 
      return *(ATm128_TIFR_t*)&TIFR; 
  }
  async command ATm128_TIFR_t Timer2Ctrl.getInterruptFlag() { 
      return *(ATm128_TIFR_t*)&TIFR; 
  }
  async command ATm128_ETIFR_t Timer1Ctrl.getInterruptFlag() { 
      return *(ATm128_ETIFR_t*)&ETIFR; 
  }
  async command ATm128_ETIFR_t Timer3Ctrl.getInterruptFlag() { 
      return *(ATm128_ETIFR_t*)&ETIFR; 
  }

  //=== Write the interrupt flags. ====================================
  DEFINE_UNION_CAST(TimerFlags8_2int, ATm128_TIFR_t, uint8_t);
  DEFINE_UNION_CAST(TimerFlags16_2int, ATm128_ETIFR_t, uint8_t);

  async command void Timer0Ctrl.setInterruptFlag( ATm128_TIFR_t x ) { 
      TIFR = TimerFlags8_2int(x); 
  }
  async command void Timer2Ctrl.setInterruptFlag( ATm128_TIFR_t x ) { 
      TIFR = TimerFlags8_2int(x); 
  }
  async command void Timer1Ctrl.setInterruptFlag( ATm128_ETIFR_t x ) { 
      ETIFR = TimerFlags16_2int(x); 
  }
  async command void Timer3Ctrl.setInterruptFlag( ATm128_ETIFR_t x ) { 
      ETIFR = TimerFlags16_2int(x); 
  }

  //=== Timer 8-bit implementation. ====================================
  async command void Timer0.reset() { SET_BIT(TIFR, TOV0); }
  async command void Timer0.start() { SET_BIT(TIMSK, TOIE0); }
  async command void Timer0.stop()  { CLR_BIT(TIMSK, TOIE0); }
  async command bool Timer0.test()  { 
      return (call Timer0Ctrl.getInterruptFlag()).bits.tov0; 
  }
  async command bool Timer0.isOn()  { 
      return (call Timer0Ctrl.getInterruptMask()).bits.toie0; 
  }
  async command void Compare0.reset() { SET_BIT(TIFR, OCF0); }
  async command void Compare0.start() { SET_BIT(TIMSK,OCIE0); }
  async command void Compare0.stop()  { CLR_BIT(TIMSK,OCIE0); }
  async command bool Compare0.test()  { 
      return (call Timer0Ctrl.getInterruptFlag()).bits.ocf0; 
  }
  async command bool Compare0.isOn()  { 
      return (call Timer0Ctrl.getInterruptMask()).bits.ocie0; 
  }

  async command void Timer2.reset() { SET_BIT(TIFR,TOV2); }
  async command void Timer2.start() { SET_BIT(TIMSK,TOIE2); }
  async command void Timer2.stop()  { CLR_BIT(TIMSK,TOIE2); }
  async command bool Timer2.test()  { 
      return (call Timer2Ctrl.getInterruptFlag()).bits.tov2; 
  }
  async command bool Timer2.isOn()  { 
      return (call Timer2Ctrl.getInterruptMask()).bits.toie2; 
  }
  async command void Compare2.reset() { SET_BIT(TIFR,OCF2); }
  async command void Compare2.start() { SET_BIT(TIMSK,OCIE2); }
  async command void Compare2.stop()  { CLR_BIT(TIMSK,OCIE2); }
  async command bool Compare2.test()  { 
      return (call Timer2Ctrl.getInterruptFlag()).bits.ocf2; 
  }
  async command bool Compare2.isOn()  { 
      return (call Timer2Ctrl.getInterruptMask()).bits.ocie2; 
  }

  //=== Capture 16-bit implementation. ===================================
  async command void Capture1.setEdge(bool up) { WRITE_BIT(TCCR1B,ICES1, up); }
  async command void Capture3.setEdge(bool up) { WRITE_BIT(TCCR3B,ICES3, up); }

  //=== Timer 16-bit implementation. ===================================
  async command void Timer1.reset()    { SET_BIT(TIFR,TOV1); }
  async command void Capture1.reset()  { SET_BIT(TIFR,ICF1); }
  async command void Compare1A.reset() { SET_BIT(TIFR,OCF1A); }
  async command void Compare1B.reset() { SET_BIT(TIFR,OCF1B); }
  async command void Compare1C.reset() { SET_BIT(ETIFR,OCF1C); }

  async command void Timer1.start()    { SET_BIT(TIMSK,TOIE1); }
  async command void Capture1.start()  { SET_BIT(TIMSK,TICIE1); }
  async command void Compare1A.start() { SET_BIT(TIMSK,OCIE1A); }
  async command void Compare1B.start() { SET_BIT(TIMSK,OCIE1B); }
  async command void Compare1C.start() { SET_BIT(ETIMSK,OCIE1C); }

  async command void Timer1.stop()    { CLR_BIT(ETIMSK,TOIE3); }
  async command void Capture1.stop()  { CLR_BIT(ETIMSK,TICIE1); }
  async command void Compare1A.stop() { CLR_BIT(ETIMSK,OCIE3A); }
  async command void Compare1B.stop() { CLR_BIT(ETIMSK,OCIE3B); }
  async command void Compare1C.stop() { CLR_BIT(ETIMSK,OCIE3C); }

  // Note: Many Timer1 interrupt flags are on Timer0 register
  async command bool Timer1.test() { 
      return (call Timer0Ctrl.getInterruptFlag()).bits.tov1; 
  }
  async command bool Capture1.test()  { 
      return (call Timer0Ctrl.getInterruptFlag()).bits.icf1; 
  }
  async command bool Compare1A.test() { 
      return (call Timer0Ctrl.getInterruptFlag()).bits.ocf1a; 
  }
  async command bool Compare1B.test() { 
      return (call Timer0Ctrl.getInterruptFlag()).bits.ocf1b; 
  }
  async command bool Compare1C.test() { 
      return (call Timer1Ctrl.getInterruptFlag()).bits.ocf1c; 
  }

  // Note: Many Timer1 interrupt mask bits are on Timer0 register
  async command bool Timer1.isOn() {
      return (call Timer0Ctrl.getInterruptMask()).bits.toie1;
  }
  async command bool Capture1.isOn()  {
      return (call Timer0Ctrl.getInterruptMask()).bits.ticie1;
  }
  async command bool Compare1A.isOn() {
      return (call Timer0Ctrl.getInterruptMask()).bits.ocie1a;
  }
  async command bool Compare1B.isOn() {
      return (call Timer0Ctrl.getInterruptMask()).bits.ocie1b;
  }
  async command bool Compare1C.isOn() {
      return (call Timer1Ctrl.getInterruptMask()).bits.ocie1c;
  }

  async command void Timer3.reset()    { SET_BIT(ETIFR,TOV3); }
  async command void Capture3.reset()  { SET_BIT(ETIFR,ICF3); }
  async command void Compare3A.reset() { SET_BIT(ETIFR,OCF3A); }
  async command void Compare3B.reset() { SET_BIT(ETIFR,OCF3B); }
  async command void Compare3C.reset() { SET_BIT(ETIFR,OCF3C); }

  async command void Timer3.start()    { SET_BIT(ETIMSK,TOIE3); }
  async command void Capture3.start()  { SET_BIT(ETIMSK,TICIE3); }
  async command void Compare3A.start() { SET_BIT(ETIMSK,OCIE3A); }
  async command void Compare3B.start() { SET_BIT(ETIMSK,OCIE3B); }
  async command void Compare3C.start() { SET_BIT(ETIMSK,OCIE3C); }

  async command void Timer3.stop()    { CLR_BIT(ETIMSK,TOIE3); }
  async command void Capture3.stop()  { CLR_BIT(ETIMSK,TICIE3); }
  async command void Compare3A.stop() { CLR_BIT(ETIMSK,OCIE3A); }
  async command void Compare3B.stop() { CLR_BIT(ETIMSK,OCIE3B); }
  async command void Compare3C.stop() { CLR_BIT(ETIMSK,OCIE3C); }

  async command bool Timer3.test() { 
      return (call Timer3Ctrl.getInterruptFlag()).bits.tov3; 
  }
  async command bool Capture3.test()  { 
      return (call Timer3Ctrl.getInterruptFlag()).bits.icf3; 
  }
  async command bool Compare3A.test() { 
      return (call Timer3Ctrl.getInterruptFlag()).bits.ocf3a; 
  }
  async command bool Compare3B.test() { 
      return (call Timer3Ctrl.getInterruptFlag()).bits.ocf3b; 
  }
  async command bool Compare3C.test() { 
      return (call Timer3Ctrl.getInterruptFlag()).bits.ocf3c; 
  }

  async command bool Timer3.isOn() {
      return (call Timer3Ctrl.getInterruptMask()).bits.toie3;
  }
  async command bool Capture3.isOn()  {
      return (call Timer3Ctrl.getInterruptMask()).bits.ticie3;
  }
  async command bool Compare3A.isOn() {
      return (call Timer3Ctrl.getInterruptMask()).bits.ocie3a;
  }
  async command bool Compare3B.isOn() {
      return (call Timer3Ctrl.getInterruptMask()).bits.ocie3b;
  }
  async command bool Compare3C.isOn() {
      return (call Timer3Ctrl.getInterruptMask()).bits.ocie3c;
  }

  //=== Read the compare registers. =====================================
  async command uint8_t Compare0.get()   { return OCR0; }
  async command uint8_t Compare2.get()   { return OCR2; }
  async command uint16_t Compare1A.get() { return OCR1A; }
  async command uint16_t Compare1B.get() { return OCR1B; }
  async command uint16_t Compare1C.get() { return OCR1C; }
  async command uint16_t Compare3A.get() { return OCR3A; }
  async command uint16_t Compare3B.get() { return OCR3B; }
  async command uint16_t Compare3C.get() { return OCR3C; }

  //=== Write the compare registers. ====================================
  async command void Compare0.set(uint8_t t)   { OCR0 = t; }
  async command void Compare2.set(uint8_t t)   { OCR2 = t; }
  async command void Compare1A.set(uint16_t t) { OCR1A = t; }
  async command void Compare1B.set(uint16_t t) { OCR1B = t; }
  async command void Compare1C.set(uint16_t t) { OCR1C = t; }
  async command void Compare3A.set(uint16_t t) { OCR3A = t; }
  async command void Compare3B.set(uint16_t t) { OCR3B = t; }
  async command void Compare3C.set(uint16_t t) { OCR3C = t; }

  //=== Read the capture registers. =====================================
  async command uint16_t Capture1.get() { return ICR1; }
  async command uint16_t Capture3.get() { return ICR3; }

  //=== Write the capture registers. ====================================
  async command void Capture1.set(uint16_t t)  { ICR1 = t; }
  async command void Capture3.set(uint16_t t)  { ICR3 = t; }

  //=== Timer interrupts signals ========================================
  default async event void Compare0.fired() { }
  AVR_NONATOMIC_HANDLER(SIG_OUTPUT_COMPARE0) {
    signal Compare0.fired();
  }
  default async event void Timer0.overflow() { }
  AVR_NONATOMIC_HANDLER(SIG_OVERFLOW0) {
    signal Timer0.overflow();
  }


  default async event void Compare2.fired() { }
  AVR_NONATOMIC_HANDLER(SIG_OUTPUT_COMPARE2) {
    signal Compare2.fired();
  }
  default async event void Timer2.overflow() { }
  AVR_NONATOMIC_HANDLER(SIG_OVERFLOW2) {
    signal Timer2.overflow();
  }


  default async event void Compare1A.fired() { }
  AVR_NONATOMIC_HANDLER(SIG_OUTPUT_COMPARE1A) {
    signal Compare1A.fired();
  }
  default async event void Compare1B.fired() { }
  AVR_NONATOMIC_HANDLER(SIG_OUTPUT_COMPARE1B) {
    signal Compare1B.fired();
  }
  default async event void Compare1C.fired() { }
  AVR_NONATOMIC_HANDLER(SIG_OUTPUT_COMPARE1C) {
    signal Compare1C.fired();
  }
  default async event void Capture1.captured(uint16_t time) { }
  AVR_NONATOMIC_HANDLER(SIG_INPUT_CAPTURE1) {
    signal Capture1.captured(call Timer1.get());
  }
  default async event void Timer1.overflow() { }
  AVR_NONATOMIC_HANDLER(SIG_OVERFLOW1) {
    signal Timer1.overflow();
  }


  default async event void Compare3A.fired() { }
  AVR_NONATOMIC_HANDLER(SIG_OUTPUT_COMPARE3A) {
    signal Compare3A.fired();
  }
  default async event void Compare3B.fired() { }
  AVR_NONATOMIC_HANDLER(SIG_OUTPUT_COMPARE3B) {
    signal Compare3B.fired();
  }
  default async event void Compare3C.fired() { }
  AVR_NONATOMIC_HANDLER(SIG_OUTPUT_COMPARE3C) {
    signal Compare3C.fired();
  }
  default async event void Capture3.captured(uint16_t time) { }
  AVR_NONATOMIC_HANDLER(SIG_INPUT_CAPTURE3) {
    signal Capture3.captured(call Timer3.get());
  }
  default async event void Timer3.overflow() { }
  AVR_NONATOMIC_HANDLER(SIG_OVERFLOW3) {
    signal Timer3.overflow();
  }
}