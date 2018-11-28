/*
************************************************************************************************
*                                              NSEE
*                                             Address
*
*                                       All Rights Reserved
*
*
* Filename     : sub_unit_control.h
* Programmer(s): Yuri Bunduki
* Description  : Header file for the Sub-Unit management task
************************************************************************************************
*/
/*$PAGE*/

#ifndef SUB_UNIT_CONTROL_H_
#define SUB_UNIT_CONTROL_H_


/*
************************************************************************************************
*                                        INCLUDE FILES
************************************************************************************************
*/

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <ucos_ii.h>

#include "os_cfg.h"
#include "utils/util.h"
#include "alt_error_handler.h"
#include "includes.h"
#include "simple_socket_server.h"
#include "command_control.h"

/*
 * Include configurations for the SpW communication modules [yb]
 */
#include "logic/comm/comm.h"

/*$PAGE*/

/*
************************************************************************************************
*                                        CONSTANTS & MACROS
************************************************************************************************
*/

#define SUBUNIT_BUFFER 10

/*$PAGE*/

/*
 * Sub-Unit queues prototypes
 */
void sub_unit_create_os_data_structs();
void sub_unit_create_queue(void);

/*
 * Sub-Unit tasks prototypes
 */
void sub_unit_control_task ();

/*
 * SubUnit control queues handles
 */

extern OS_EVENT *p_sub_unit_config_queue;
extern OS_EVENT *p_sub_unit_command_queue;

/*
 * Sub-Unit semaphores declaration
 */

OS_EVENT *sub_unit_command_semaphore;


/*
************************************************************************************************
*                                            DATA TYPES
************************************************************************************************
*/

/*
 * Structure to identify the Sub-Unit configuration parameters
 * mode: 0-> config, 1-> running
 * [receive_data: 0->ethernet, 1->SSD] Not needed anymore
 * RMAP_handling: 0->none, 1->echoing, 2->logging
 * forward_data to ethernet link
 */
struct _sub_config {
	INT8U mode;
	//INT8U receive_data;
	INT8U forward_data;
	INT8U RMAP_handling;
	struct _imagette_control *imagette;
}_sub_config;

struct _sub_data {
	INT8U p_data_addr[100];
	INT32U i_data_size;
}_sub_data;

/*$PAGE*/

#endif /* SUB_UNIT_CONTROL_H_ */
