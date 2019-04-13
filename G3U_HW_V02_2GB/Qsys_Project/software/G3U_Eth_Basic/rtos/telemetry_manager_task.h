/*
 ************************************************************************************************
 *                                              NSEE
 *                                             Address
 *
 *                                       All Rights Reserved
 *
 *
 * Filename     : telemetry_manager_task.c
 * Programmer(s): Yuri Bunduki
 * Created on: Mar 28, 2019
 * Description  : Header file for the telemetry manager task.
 ************************************************************************************************
 */
/*$PAGE*/

#ifndef TELEMETRY_MANAGER_TASK_H_
#define TELEMETRY_MANAGER_TASK_H_

/*
 ************************************************************************************************
 *                                        INCLUDE FILES
 ************************************************************************************************
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <ucos_ii.h>
#include "command_control_task.h"
#include "simple_socket_server.h"

/*
 ************************************************************************************************
 *                                        CONSTANTS & MACROS
 ************************************************************************************************
 */
#define TELEMETRY_BUFFER_SIZE	300

#define ACK_TYPE				1
#define ERROR_TYPE				2
#define ECHO_TYPE				3

extern OS_EVENT *p_telemetry_queue;
/*
 ************************************************************************************************
 *                                            DATA TYPES
 ************************************************************************************************
 */

struct x_telemetry {

	INT8U i_type;
	INT8U i_channel;
	INT8U error_code;
	struct x_ethernet_payload *p_payload;
	struct imagette_control *p_imagette;

} x_telemetry;

void telemetry_manager_task();
void telemetry_manager_create_os_data_structs();
#endif /* TELEMETRY_MANAGER_TASK_H_ */
