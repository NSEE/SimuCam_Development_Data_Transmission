/******************************************************************************
* Copyright (c) 2006 Altera Corporation, San Jose, California, USA.           *
* All rights reserved. All use of this software and documentation is          *
* subject to the License Agreement located at the end of this file below.     *
*******************************************************************************                                                                             *
* Date - October 24, 2006                                                     *
* Module - simple_socket_server.h                                             *
*                                                                             *                                                                             *
******************************************************************************/

/* 
 * Simple Socket Server (SSS) example. 
 * 
 * Please refer to the Altera Nichestack Tutorial documentation for details on this 
 * software example, as well as details on how to configure the TCP/IP 
 * networking stack and MicroC/OS-II Real-Time Operating System.  The Altera
 * Nichestack Tutorial, along with the rest of the Nios II documentation is published 
 * on the Altera web-site.  See: 
 * Start Menu -> Programs -> Nios II Development Kit -> Nios II Documentation.
 * In particular, chapter 9 of the Nios II Software Developer's Handbook 
 * describes Ethernet & Network stack.
 * 
 * Software Design Methodology Note:
 * 
 * The naming convention used in the Simple Socket Server Tutorial employs
 * capitalized software module references as prefixes to variables to identify
 * public resources for each software module, while lower-case 
 * variables with underscores indicate a private resource used strictly 
 * internally to a software module.
 * 
 * The software modules are named and have capitalized variable identifiers as
 * follows:
 * 
 * SSS      Simple Socket Server software module  
 * LED      Light Emitting Diode Management software module
 * NETUTILS Network Utilities software module
 * 
 * OS       Micrium MicroC/OS-II Real-Time Operating System software component
 */
 
 /* Validate supported Software components specified on system library properties page.
  */
#ifndef __SIMPLE_SOCKET_SERVER_H__
#define __SIMPLE_SOCKET_SERVER_H__

#if !defined (ALT_INICHE)
  #error The Simple Socket Server example requires the 
  #error NicheStack TCP/IP Stack Software Component. Please see the Nichestack
  #error Tutorial for details on Nichestack TCP/IP Stack - Nios II Edition,
  #error including notes on migrating applications from lwIP to NicheStack.
#endif

#ifndef __ucosii__
  #error This Simple Socket Server example requires 
  #error the MicroC/OS-II Intellectual Property Software Component.
#endif

#if defined (ALT_LWIP)
  #error The Simple Socket Server example requires the 
  #error NicheStack TCP/IP Stack Software Component, and no longer works
  #error with the lwIP networking stack.  Please see the Altera Nichstack
  #error Tutorial for details on Nichestack TCP/IP Stack - Nios II Edition,
  #error including notes on migrating applications from lwIP to NicheStack.
#endif


/* Nichestack definitions */
#include "ipport.h"
#include "tcpport.h"

/*
 * Task Prototypes:
 * 
 *    LEDManagementTask() - Manages the LEDs on the Nios Development Board, 
 * driven by commands received via a MicroC/OS-II queue, SSSLEDCommmandQ.
 * 
 *    SSSSimpleSocketServerTask() - Manages the socket server connection and 
 * calls relevant subroutines to manage the socket connection.
 * 
 *    LED7SegLightshowTask() blinks the 7-segment LEDs with a random pattern. 
 * The pattern stops and starts in response to LEDManagementTask's posting and 
 * pending to the MicroC/OS-II semaphore named SSSLEDLightshowSem.
 * 
 *    SSSInitialTask() instantiates all of the MicroC/OS-II resources.
 * 
 */
void SSSSimpleSocketServerTask();

/*
 * Command task prototype
 */

void CommandManagementTask();

void SSSCreateTasks();

/*
 *  Task Priorities:
 * 
 *  MicroC/OS-II only allows one task (thread) per priority number.   
 */
#define SSS_SIMPLE_SOCKET_SERVER_TASK_PRIORITY  10
#define SSS_INITIAL_TASK_PRIORITY               5

/* 
 * The IP, gateway, and subnet mask address below are used as a last resort
 * if no network settings can be found, and DHCP (if enabled) fails. You can
 * edit these as a quick-and-dirty way of changing network settings if desired.
 * 
 * Default IP addresses are set to all zeros so that DHCP server packets will
 * penetrate secure routers. They are NOT intended to be valid static IPs, 
 * these values are only a valid default on networks with DHCP server. 
 * 
 * If DHCP will not be used, select valid static IP addresses here, for example:
 *           IP: 10.9.11.216
 *      Gateway: 10.9.11.1
 *  Subnet Mask: 255.255.255.0
 */

#define IPADDR0   10
#define IPADDR1   9
#define IPADDR2   11
#define IPADDR3   216

#define GWADDR0   10
#define GWADDR1   9
#define GWADDR2   11
#define GWADDR3   1

#define MSKADDR0  255
#define MSKADDR1  255
#define MSKADDR2  255
#define MSKADDR3  0

/*
 * IP Port(s) for our application(s)
 */
#define SSS_PORT 30

/* Definition of Task Stack size for tasks not using Nichestack */
#define   TASK_STACKSIZE       2048

/* 
 * Defined commands for the sss server to interpret
 */
#define CMD_LEDS_BIT_0_TOGGLE   '0'
#define CMD_LEDS_BIT_1_TOGGLE   '1'
#define CMD_LEDS_BIT_2_TOGGLE   '2'
#define CMD_LEDS_BIT_3_TOGGLE   '3'
#define CMD_LEDS_BIT_4_TOGGLE   '4'
#define CMD_LEDS_BIT_5_TOGGLE   '5'
#define CMD_LEDS_BIT_6_TOGGLE   '6'
#define CMD_LEDS_BIT_7_TOGGLE   '7'
#define CMD_LEDS_LIGHTSHOW      'S'
#define CMD_QUIT                'Q'
  
/* 
 * Bit Masks for LED Toggles 
 */
#define BIT_0 0x1
#define BIT_1 0x2
#define BIT_2 0x4
#define BIT_3 0x8
#define BIT_4 0x10
#define BIT_5 0x20
#define BIT_6 0x40
#define BIT_7 0x80

/* 
 * TX & RX buffer sizes for all socket sends & receives in our sss app
 */
#define SSS_RX_BUF_SIZE  1500
#define SSS_TX_BUF_SIZE  1500

/* 
 * Here we structure to manage sss communication for a single connection
 */
typedef struct SSS_SOCKET
{
  enum { READY, COMPLETE, CLOSE } state; 
  int       fd;
  int       close;
  INT8U     rx_buffer[SSS_RX_BUF_SIZE];
  INT8U     *rx_rd_pos; /* position we've read up to */
  INT8U     *rx_wr_pos; /* position we've written up to */
} SSSConn;

/*
 * Handles to our MicroC/OS-II resources. All of the resources beginning with 
 * "SSS" are declared in file "simple_socket_server.c".
 */

#define BUFFER_SIZE				2000000
#define EMPIRICAL_BUFFER_MIN 	21
#define SSSBUFFER_ADDR			0x7FF0BDC0

#define PROTOCOL_OVERHEAD		7
#define EXIT_CODE				3

/*
 * data address that will be removed
 */
extern INT8U *data_addr;

struct ethernet_buffer{
	INT8U rx_buffer[BUFFER_SIZE];
	INT8U *rx_rd_pos;
	INT8U *rx_wr_pos;
};

/*
 * Command + payload struct for the simucam ethernet control
 */

struct x_ethernet_payload {
	INT8U header;		/* Command Header */
	INT16U packet_id;	/* Unique identifier */
	INT8U type;			/* Will be the command id */
	INT8U sub_type;		/* Could carry the sub-unit id */
	INT32U size;		/* Size pre-computed in function */
	INT8U data[1500];	/* Data array */
	INT16U crc;			/* We will use the CCITT-CRC, that is also used in the PUS protocol */


}_ethernet_payload;

/*
 * SimuCam tasks prototypes
 */

void DataCreateOSQ();
void SimucamCreateOSQ();

/*
 * Handles to the SimuCam control data queues
 */

extern OS_EVENT *SimucamDataQ;
extern OS_EVENT *p_simucam_command_q;
extern OS_EVENT *p_telemetry_queue;

#endif /* __SIMPLE_SOCKET_SERVER_H__ */

/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2006 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
* Altera does not recommend, suggest or require that this reference design    *
* file be used in conjunction or combination with any other product.          *
******************************************************************************/
