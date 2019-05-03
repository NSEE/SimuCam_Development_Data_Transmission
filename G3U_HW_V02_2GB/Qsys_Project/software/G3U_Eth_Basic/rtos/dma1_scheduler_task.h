/*
 * dma1_scheduler_task.h
 *
 *  Created on: 03/05/2019
 *      Author: root
 */

#ifndef DMA1_SCHEDULER_TASK_H_
#define DMA1_SCHEDULER_TASK_H_

#include "../simucam_definitions.h"
#include "tasks_init.h"

extern OS_EVENT *p_dma_scheduler_controller_queue[2];
extern OS_EVENT *p_sub_unit_config_queue[8];
extern OS_EVENT *DMA_sched_queue[2];
extern T_Simucam T_simucam;



#endif /* DMA1_SCHEDULER_TASK_H_ */
