/*
 ************************************************************************************************
 *                                              NSEE
 *                                             Address
 *
 *                                       All Rights Reserved
 *
 *
 * Filename     : simucam_init_task.c
 * Programmer(s): Yuri Bunduki
 * Created on: May 27, 2019
 * Description  : Source file for the Simucam initialization task.
 ************************************************************************************************
 */
/*$PAGE*/

#include "simucam_init_task.h"

/*
 * Configuration of the sub-unit management task
 */
//#define SUB_UNIT_TASK_PRIORITY 7
//OS_STK sub_unit_task_stack[TASK_STACKSIZE];

/*
 * Configuration of the simucam command management task[yb]
 */
//
//#define COMMAND_MANAGEMENT_TASK_PRIORITY 6
//OS_STK CommandManagementTaskStk[TASK_STACKSIZE];


//void SimucamCreateTasks(void) {
//	INT8U error_code;
//
//	/*
//	 * Creating the command management task [yb]
//	 */
//	error_code = OSTaskCreateExt(CommandManagementTask,
//	NULL, (void *) &CommandManagementTaskStk[TASK_STACKSIZE - 1],
//	COMMAND_MANAGEMENT_TASK_PRIORITY,
//	COMMAND_MANAGEMENT_TASK_PRIORITY, CommandManagementTaskStk,
//	TASK_STACKSIZE,
//	NULL, 0);
//
//	alt_uCOSIIErrorHandler(error_code, 0);
//
//	/*
//	 * Creating the sub_unit 1 management task [yb]
//	 */
//	error_code = OSTaskCreateExt(sub_unit_control_task,
//	NULL, (void *) &sub_unit_task_stack[TASK_STACKSIZE - 1],
//	SUB_UNIT_TASK_PRIORITY,
//	SUB_UNIT_TASK_PRIORITY, sub_unit_task_stack,
//	TASK_STACKSIZE,
//	NULL, 0);
//
//	alt_uCOSIIErrorHandler(error_code, 0);
//
//#if DEBUG_ON
//	fprintf(fp, "Tasks created successfully\r\n");
//#endif
//}
