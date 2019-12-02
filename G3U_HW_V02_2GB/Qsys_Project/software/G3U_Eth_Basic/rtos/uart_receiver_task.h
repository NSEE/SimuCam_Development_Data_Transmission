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
#include "../simucam_model.h"
#include "../simucam_definitions.h"

/*
************************************************************************************************
*                                        CONSTANTS & MACROS
************************************************************************************************
*/
#define PROTOCOL_OVERHEAD		7
#define UART_BUFFER_SIZE        2000

typedef enum { sRConfiguring = 0, sGetRxUart, sSendToParser, sSendToACKReceiver } tReaderStates;

#endif /* RTOS_UART_RECEIVER_TASK_H_ */
