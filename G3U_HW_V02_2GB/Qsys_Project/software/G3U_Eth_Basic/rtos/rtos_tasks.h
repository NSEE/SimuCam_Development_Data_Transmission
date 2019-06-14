/*
 * rtos_tasks.h
 *
 *  Created on: 24/04/2018
 *      Author: rfranca
 */

#ifndef RTOS_TASKS_H_
#define RTOS_TASKS_H_

	#include "system.h"
	#include "alt_types.h"
	#include <altera_msgdma.h>

	#define SIMUCAM_TASK_STACKSIZE 2048

	#define SPW_LINK_TASK_PRIORITY 27
	#define LOG_TASK_PRIORITY      28
	
	extern alt_msgdma_dev *DMADev;

	void Init_Simucam_Tasks(void);

#endif /* RTOS_TASKS_H_ */
