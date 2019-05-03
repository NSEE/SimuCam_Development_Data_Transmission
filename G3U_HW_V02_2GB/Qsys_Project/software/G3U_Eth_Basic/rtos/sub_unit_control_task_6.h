/*
 * sub_unit_control_task_6.h
 *
 *  Created on: 17/04/2019
 *      Author: root
 */

#ifndef SUB_UNIT_CONTROL_TASK_6_H_
#define SUB_UNIT_CONTROL_TASK_6_H_

/*
 ************************************************************************************************
 *                                        INCLUDE FILES
 ************************************************************************************************
 */

#include "sub_unit_control_task.h"

/*
 * Include configurations for the SpW communication modules [yb]
 */

/*$PAGE*/

/*
 ************************************************************************************************
 *                                        CONSTANTS & MACROS
 ************************************************************************************************
 */

#define SUBUNIT_BUFFER 		10

/*$PAGE*/

/* Macro definitions */

/*
 * Sub-Unit tasks prototypes
 */
//void sub_unit_control_task ();
/*
 * SubUnit control queues handles
 */

extern OS_EVENT *p_sub_unit_config_queue[8];
extern volatile INT32U i_central_timer_counter;
extern volatile INT32U i_running_timer_counter;
extern INT8U i_echo_sent_data;
extern INT16U i_id_accum;
INT16U i_imagette_number;

void sub_unit_control_task_1(void *task_data);

/*
 * Sub-Unit semaphores declaration
 */

OS_EVENT *sub_unit_command_semaphore;

extern T_Simucam T_simucam;


#endif /* SUB_UNIT_CONTROL_TASK_6_H_ */
