/*
 ************************************************************************************************
 *                                              NSEE
 *                                             Address
 *
 *                                       All Rights Reserved
 *
 *
 * Filename     : simucam_init_task.h
 * Programmer(s): Yuri Bunduki
 * Created on: May 27, 2019
 * Description  : Header file for the Simucam initialization task.
 ************************************************************************************************
 */
/*$PAGE*/

#ifndef SIMUCAM_INIT_TASK_H_
#define SIMUCAM_INIT_TASK_H_

#include "../simucam_definitions.h"
#include "../alt_error_handler.h"

/* MicroC/OS-II definitions */
#include "includes.h"

/*sub-unit definitions*/
#include "sub_unit_control_task.h"

/* Command control definitions*/
#include "command_control_task.h"

/* Nichestack definitions */
#include "ipport.h"
#include "libport.h"
#include "osport.h"
#include "default_configs.h"
#include "rtos_tasks.h"

void SimucamCreateTasks(void);
void CommandManagementTask();

#endif /* SIMUCAM_INIT_TASK_H_ */
