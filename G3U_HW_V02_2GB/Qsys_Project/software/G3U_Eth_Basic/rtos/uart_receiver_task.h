/*
 ************************************************************************************************
 *                                              NSEE
 *                                             Address
 *
 *                                       All Rights Reserved
 *
 *
 * Filename     : uart_receiver_task.h
 * Programmer(s): Yuri Bunduki
 * Created on: Nov 28, 2019
 * Description  : Header file for the uart communication receiver task.
 ************************************************************************************************
 */
/*$PAGE*/

#ifndef RTOS_UART_RECEIVER_TASK_H_
#define RTOS_UART_RECEIVER_TASK_H_

/*
************************************************************************************************
*                                        INCLUDE FILES
************************************************************************************************
*/

#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "includes.h"
#include "../simucam_definitions.h"
#include "../api_drivers/ddr2/ddr2.h"

/*
************************************************************************************************
*                                        CONSTANTS & MACROS
************************************************************************************************
*/
#define PROTOCOL_OVERHEAD		7
#define HEADER_OVERHEAD         8
#define PAYLOAD_OVERHEAD        10
#define IMAGETTE_HEADER         12
#define UART_BUFFER_SIZE        256

typedef enum { sRConfiguring = 0, sGetHeader, sGetImagettes, sGetCommand, sSendToCmdCtrl, sSendToACKReceiver } tReaderStates;

extern T_Simucam T_simucam;
/*
 * Handles to the SimuCam control data queues
 */

extern OS_EVENT *SimucamDataQ;
extern OS_EVENT *p_simucam_command_q;
extern OS_EVENT *p_telemetry_queue;
extern INT16U i_id_accum;

#endif /* RTOS_UART_RECEIVER_TASK_H_ */
