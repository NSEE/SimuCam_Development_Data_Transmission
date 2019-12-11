/*
 ************************************************************************************************
 *                                              NSEE
 *                                             Address
 *
 *                                       All Rights Reserved
 *
 *
 * Filename     : tasks_init.h
 * Programmer(s): Yuri Bunduki
 * Created on: Apr 13, 2019
 * Description  : Header file for the Simucam initialization tasks declaration.
 ************************************************************************************************
 */
/*$PAGE*/

#ifndef TASKS_INIT_H_
#define TASKS_INIT_H_

/*
 ************************************************************************************************
 *                                        FUNCTION PROTOTYPES
 ************************************************************************************************
 */

void CommandManagementTask      ();
void sub_unit_control_task 		(void *task_data);
void sub_unit_control_task_1 	(void *task_data);
void sub_unit_control_task_2	(void *task_data);
void sub_unit_control_task_3	(void *task_data);
void sub_unit_control_task_4	(void *task_data);
void sub_unit_control_task_5	(void *task_data);
void sub_unit_control_task_6	(void *task_data);
void sub_unit_control_task_7	(void *task_data);
void dma1_scheduler_task		(void *task_data);
void dma2_scheduler_task		(void *task_data);
void echo_task					(void);
void uart_receiver_task			(void *task_data);

/*$PAGE*/
/*
 ************************************************************************************************
 *                                        CONSTANTS & MACROS
 ************************************************************************************************
 */

/*
 * Tasks priorities definitions
 */
#define UART_RCV_TASK_PRIORITY				4
#define SIMUCAM_INITIAL_TASK_PRIORITY       5
#define PCP_MUTEX_DMA_QUEUE					6
#define DMA_SCHEDULER_TASK_PRIORITY 		8
#define SUB_UNIT_TASK_PRIORITY 				11
#define COMMAND_MANAGEMENT_TASK_PRIORITY 	10
#define ECHO_TASK_PRIORITY					30

/*$PAGE*/

#endif /* TASKS_INIT_H_ */
