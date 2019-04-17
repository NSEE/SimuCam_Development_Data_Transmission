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

//#include <stdio.h>
//#include <string.h>
//#include <ctype.h>
//#include <ucos_ii.h>
//#include "command_control_task.h"
#include "sub_unit_control_task.h"
#include "simple_socket_server.h"

/*
 ************************************************************************************************
 *                                        CONSTANTS & MACROS
 ************************************************************************************************
 */

extern OS_EVENT *p_telemetry_queue;
/*
 ************************************************************************************************
 *                                            DATA TYPES
 ************************************************************************************************
 */

//void telemetry_manager_task();
void telemetry_manager_create_os_data_structs();
#endif /* TELEMETRY_MANAGER_TASK_H_ */
