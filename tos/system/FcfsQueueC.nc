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
 
generic module FcfsQueueC(uint8_t size) {
  provides {
    interface Init;
    interface Queue<uint8_t> as FcfsQueue;
  }
}
implementation {
  enum {NO_ENTRY = 0xFF};

  uint8_t resQ[size];
  uint8_t qHead = NO_ENTRY;
  uint8_t qTail = NO_ENTRY;
  uint8_t current_size;
  
  bool inQueue(uint8_t id) {
    return resQ[id] != NO_ENTRY || qTail == id;
  }

  command error_t Init.init() {
    memset(resQ, NO_ENTRY, sizeof(resQ));
    current_size = 0;
    return SUCCESS;
  }  

  command uint8_t FcfsQueue.dequeue() {
    if(qHead != NO_ENTRY) {
      uint8_t id = qHead;
      qHead = resQ[qHead];
      if(qHead == NO_ENTRY)
        qTail = NO_ENTRY;
      resQ[id] = NO_ENTRY;
      current_size--;
      return id;
    }
    return NO_ENTRY;
  }
  
  command error_t FcfsQueue.enqueue(uint8_t id) {
    if(!inQueue(id)) {
      if(qHead == NO_ENTRY)
	      qHead = id;
	    else
	      resQ[qTail] = id;
	    qTail = id;
      current_size++;
      return SUCCESS;
    }
    return EBUSY;
  }

  command bool FcfsQueue.empty() {
    if(qHead == NO_ENTRY) return TRUE;
    return FALSE;
  }

  command uint8_t FcfsQueue.size() {
    return current_size;
  }

  command uint8_t FcfsQueue.maxSize() {
    return size;
  }

  command uint8_t FcfsQueue.head() {
    return qHead;
  }    
}