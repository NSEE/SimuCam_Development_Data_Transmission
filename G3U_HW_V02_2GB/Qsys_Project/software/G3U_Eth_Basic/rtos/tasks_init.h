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
void telemetry_manager_task();

#endif /* TASKS_INIT_H_ */
