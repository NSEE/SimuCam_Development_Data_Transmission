/*
 * sub_unit_control.h
 *
 *  Created on: Oct 22, 2018
 *      Author: Yuri Bunduki
 */

#ifndef SUB_UNIT_CONTROL_H_
#define SUB_UNIT_CONTROL_H_

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <ucos_ii.h>

#include "os_cfg.h"
#include "utils/util.h"
#include "alt_error_handler.h"
#include "includes.h"
#include "simple_socket_server.h"

/*
 * Include configurations for the SpW communication modules [yb]
 */
#include "logic/comm/comm.h"

#define SUBUNIT_BUFFER 10

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


struct _sub_config {
	INT8U mode;
	//INT8U receive_data;
	INT8U forward_data;
	INT8U RMAP_handling;
//struct imagette* imagette[];
}_sub_config;

struct _sub_data {
	INT8U *p_data_addr;
	INT32U i_data_size;
}_sub_data;

#endif /* SUB_UNIT_CONTROL_H_ */
