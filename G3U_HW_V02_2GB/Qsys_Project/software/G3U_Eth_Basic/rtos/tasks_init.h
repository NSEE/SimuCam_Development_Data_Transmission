/*
 * tasks_init.h
 *
 *  Created on: 13/04/2019
 *      Author: root
 */

#ifndef TASKS_INIT_H_
#define TASKS_INIT_H_

void sub_unit_control_task 		(void *task_data);
void sub_unit_control_task_1 	(void *task_data);
void sub_unit_control_task_2	(void *task_data);
void sub_unit_control_task_3	(void *task_data);
void sub_unit_control_task_4	(void *task_data);
void sub_unit_control_task_5	(void *task_data);
void sub_unit_control_task_6	(void *task_data);
void sub_unit_control_task_7	(void *task_data);
void telemetry_manager_task();
void dma1_scheduler_task		(void *task_data);


/*
 * Tasks priorities definitions
 */
#define PCP_MUTEX_DMA_QUEUE			6
#define DMA_SCHEDULER_TASK_PRIORITY 8
#define SUB_UNIT_TASK_PRIORITY 11
#define COMMAND_MANAGEMENT_TASK_PRIORITY 10
#define TELEMETRY_TASK_PRIORITY 30



#endif /* TASKS_INIT_H_ */
