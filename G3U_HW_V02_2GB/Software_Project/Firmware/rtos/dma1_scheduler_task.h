/*
 ************************************************************************************************
 *                                              NSEE
 *                                             Address
 *
 *                                       All Rights Reserved
 *
 *
 * Filename     : dma1_scheduler_task.h
 * Programmer(s): Yuri Bunduki
 * Created on: May 03, 2019
 * Description  : Header file for the DMA scheduler task.
 ************************************************************************************************
 */
/*$PAGE*/

#ifndef DMA1_SCHEDULER_TASK_H_
#define DMA1_SCHEDULER_TASK_H_
/*
 ************************************************************************************************
 *                                        INCLUDE FILES
 ************************************************************************************************
 */
#include "../simucam_definitions.h"
#include "../alt_error_handler.h"
#include "tasks_init.h"
/*$PAGE*/

/*
 ************************************************************************************************
 *                                        CONSTANTS & MACROS
 ************************************************************************************************
 */
extern OS_EVENT *p_dma_scheduler_controller_queue[2];
extern OS_EVENT *p_sub_unit_config_queue[8];
extern OS_EVENT *DMA_sched_queue[2];
extern T_Simucam T_simucam;
/*$PAGE*/

#endif /* DMA1_SCHEDULER_TASK_H_ */
