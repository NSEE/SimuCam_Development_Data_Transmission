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
 * Creation of the queue for receive/command communication [yb]
 */

OS_EVENT *p_simucam_command_q;
struct T_uart_payload *p_simucam_command_q_table[16]; /*Storage for SimucamCommandQ */

/*
 * Configuration of the sub-unit management task
 */
OS_STK sub_unit_task_stack[TASK_STACKSIZE];
OS_STK sub_unit_task_stack_1[TASK_STACKSIZE];
OS_STK sub_unit_task_stack_2[TASK_STACKSIZE];
OS_STK sub_unit_task_stack_3[TASK_STACKSIZE];
OS_STK sub_unit_task_stack_4[TASK_STACKSIZE];
OS_STK sub_unit_task_stack_5[TASK_STACKSIZE];
OS_STK sub_unit_task_stack_6[TASK_STACKSIZE];
OS_STK sub_unit_task_stack_7[TASK_STACKSIZE];

/*
 * Configuration of the simucam command management task[yb]
 */
OS_STK CommandManagementTaskStk[TASK_STACKSIZE];

/*
 * Configuration of the simucam command management task[yb]
 */

OS_STK dma1_scheduler_task_stack_0[TASK_STACKSIZE];
OS_STK dma1_scheduler_task_stack_1[TASK_STACKSIZE];

/*
 * Echo task stack
 */
OS_STK echo_task_stack[TASK_STACKSIZE];

/*
 * Uart receiver task stack
 */
OS_STK uart_rcv_task_stack[TASK_STACKSIZE];

/*
 * Periodic HK task stack
 */
OS_STK periodic_HK_task_stack[TASK_STACKSIZE];

/*
 * Configuration of the simucam data queue[yb]
 */

OS_EVENT *SimucamDataQ;
INT8U *SimucamDataQTbl[DATAQ_BUF_SIZE]; /*Storage for SimucamCommandQ */

INT8U *data_addr;

/*
 * DMA mutex
 */
OS_EVENT *xMutexDMA[2];

/*
 * Create the Simucam command queue
 */

void SimucamCreateOSQ(void) {
	p_simucam_command_q = OSQCreate((void *) (&p_simucam_command_q_table[0]),
	DATAQ_BUF_SIZE);

	if (!p_simucam_command_q) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE, "Failed to create Simucam Command Queue.\n");
	} else {
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
		fprintf(fp, "Simucam Command Queue created successfully.\r\n");
}
#endif
	}
}

/*
 * Create the Simucam data queue
 */
void DataCreateOSQ(void) {
	SimucamDataQ = OSQCreate((void *) (&SimucamDataQTbl[0]), DATAQ_BUF_SIZE);

	if (!SimucamDataQ) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE, "Failed to create SimucamDataQ.\n");
	} else {
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
		fprintf(fp, "SimucamDataQ created successfully.\r\n");
}
#endif
	}
}

/* Sub unit dataqs */

/*
 * Creation of the sub-unit communication queue [yb]
 */
OS_EVENT *p_sub_unit_config_queue[8];
void *p_sub_unit_config_queue_tbl_0[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/
void *p_sub_unit_config_queue_tbl_1[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/
void *p_sub_unit_config_queue_tbl_2[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/
void *p_sub_unit_config_queue_tbl_3[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/
void *p_sub_unit_config_queue_tbl_4[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/
void *p_sub_unit_config_queue_tbl_5[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/
void *p_sub_unit_config_queue_tbl_6[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/
void *p_sub_unit_config_queue_tbl_7[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/

/*
 * Creation of the schedulerQueue
 */
OS_EVENT *DMA_sched_queue[2];
void *DMA1_sched_queue_tbl[DMA_SCHED_BUFFER]; /*Storage for sub_unit queue*/
void *DMA2_sched_queue_tbl[DMA_SCHED_BUFFER]; /*Storage for sub_unit queue*/

/*
 * Creation of the DMA scheduler controller
 */
OS_EVENT *p_dma_scheduler_controller_queue[2];
void *p_dma_scheduler_controller_queue_tbl_0[SUBUNIT_BUFFER];
void *p_dma_scheduler_controller_queue_tbl_1[SUBUNIT_BUFFER];

/*
 * Create the sub-unit defined data structures and queues
 */
void sub_unit_create_os_data_structs(void) {

	DMA_sched_queue[0] = OSQCreate(&DMA1_sched_queue_tbl[0],
	DMA_SCHED_BUFFER);
	if (!DMA_sched_queue[0]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE, "Failed to create p_sub_unit_queue.\n");
	}

	DMA_sched_queue[1] = OSQCreate(&DMA2_sched_queue_tbl[0],
	DMA_SCHED_BUFFER);
	if (!DMA_sched_queue[1]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE, "Failed to create p_sub_unit_queue.\n");
	}

	/*
	 * Create the sub-unit config queue [yb]
	 */
	p_sub_unit_config_queue[0] = OSQCreate(&p_sub_unit_config_queue_tbl_0[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue[0]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE, "Failed to create p_sub_unit_queue.\n");
	}

	p_sub_unit_config_queue[1] = OSQCreate(&p_sub_unit_config_queue_tbl_1[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue[1]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE, "Failed to create p_sub_unit_queue.\n");
	}

	p_sub_unit_config_queue[2] = OSQCreate(&p_sub_unit_config_queue_tbl_2[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue[2]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE, "Failed to create p_sub_unit_queue.\n");
	}

	p_sub_unit_config_queue[3] = OSQCreate(&p_sub_unit_config_queue_tbl_3[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue[3]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE, "Failed to create p_sub_unit_queue.\n");
	}

	p_sub_unit_config_queue[4] = OSQCreate(&p_sub_unit_config_queue_tbl_4[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue[4]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE, "Failed to create p_sub_unit_queue.\n");
	}

	p_sub_unit_config_queue[5] = OSQCreate(&p_sub_unit_config_queue_tbl_5[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue[5]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE, "Failed to create p_sub_unit_queue.\n");
	}

	p_sub_unit_config_queue[6] = OSQCreate(&p_sub_unit_config_queue_tbl_6[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue[6]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE, "Failed to create p_sub_unit_queue.\n");
	}

	p_sub_unit_config_queue[7] = OSQCreate(&p_sub_unit_config_queue_tbl_7[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue[7]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE, "Failed to create p_sub_unit_queue.\n");
	}

	p_dma_scheduler_controller_queue[0] = OSQCreate(&p_dma_scheduler_controller_queue_tbl_0[0],
	SUBUNIT_BUFFER);

	/*
	 * Creation of the DMA scheduller queues
	 */
	if (!p_dma_scheduler_controller_queue[0]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE, "Failed to create p_dma_scheduler_controller_queue 0.\n");
	}

	p_dma_scheduler_controller_queue[1] = OSQCreate(&p_dma_scheduler_controller_queue_tbl_1[0],
	SUBUNIT_BUFFER);

	if (!p_dma_scheduler_controller_queue[1]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE, "Failed to create p_dma_scheduler_controller_queue 1.\n");
	}

	/*
	 * Creation of echo queue
	 */
	p_echo_queue = OSQCreate(&p_echo_queue_tbl[0],
	ECHO_QUEUE_BUFFER);

	if (!p_echo_queue) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE, "Failed to create p_echo_queue.\n");
	}
}

/* TODO format
 * Function used to initialize all simucam tasks
 */
void SimucamCreateTasks(void) {
	INT8U error_code;

	/*
	 * Creating the command management task [yb]
	 */
	error_code = OSTaskCreateExt(CommandManagementTask,
	NULL, (void *) &CommandManagementTaskStk[TASK_STACKSIZE - 1],
	COMMAND_MANAGEMENT_TASK_PRIORITY,
	COMMAND_MANAGEMENT_TASK_PRIORITY, CommandManagementTaskStk,
	TASK_STACKSIZE,
	NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the sub_unit 0 management task [yb]
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task, (void *) 0, (void *) &sub_unit_task_stack[TASK_STACKSIZE - 1],
	SUB_UNIT_TASK_PRIORITY,
	SUB_UNIT_TASK_PRIORITY, sub_unit_task_stack,
	TASK_STACKSIZE,
	NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	OSTimeDlyHMSM(0, 0, 1, 0);

	/*
	 * Creating the sub_unit 1 management task [yb] TODO: Change to one .c
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_1, (void *) 1, (void *) &sub_unit_task_stack_1[TASK_STACKSIZE - 1],
	SUB_UNIT_TASK_PRIORITY + 1,
	SUB_UNIT_TASK_PRIORITY + 1, sub_unit_task_stack_1,
	TASK_STACKSIZE,
	NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the sub_unit 2 management task [yb] TODO: Change to one .c
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_2, (void *) 2, (void *) &sub_unit_task_stack_2[TASK_STACKSIZE - 1],
	SUB_UNIT_TASK_PRIORITY + 2,
	SUB_UNIT_TASK_PRIORITY + 2, sub_unit_task_stack_2,
	TASK_STACKSIZE,
	NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the sub_unit 3 management task [yb] TODO: Change to one .c
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_3, (void *) 3, (void *) &sub_unit_task_stack_3[TASK_STACKSIZE - 1],
	SUB_UNIT_TASK_PRIORITY + 3,
	SUB_UNIT_TASK_PRIORITY + 3, sub_unit_task_stack_3,
	TASK_STACKSIZE,
	NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the sub_unit 4 management task [yb] TODO: Change to one .c
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_4, (void *) 4, (void *) &sub_unit_task_stack_4[TASK_STACKSIZE - 1],
	SUB_UNIT_TASK_PRIORITY + 4,
	SUB_UNIT_TASK_PRIORITY + 4, sub_unit_task_stack_4,
	TASK_STACKSIZE,
	NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);
	/*
	 * Creating the sub_unit 5 management task [yb] TODO: Change to one .c
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_5, (void *) 5, (void *) &sub_unit_task_stack_5[TASK_STACKSIZE - 1],
	SUB_UNIT_TASK_PRIORITY + 5,
	SUB_UNIT_TASK_PRIORITY + 5, sub_unit_task_stack_5,
	TASK_STACKSIZE,
	NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the sub_unit 6 management task [yb] TODO: Change to one .c
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_6, (void *) 6, (void *) &sub_unit_task_stack_6[TASK_STACKSIZE - 1],
	SUB_UNIT_TASK_PRIORITY + 6,
	SUB_UNIT_TASK_PRIORITY + 6, sub_unit_task_stack_6,
	TASK_STACKSIZE,
	NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the sub_unit 7 management task [yb] TODO: Change to one .c
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_7, (void *) 7, (void *) &sub_unit_task_stack_7[TASK_STACKSIZE - 1],
	SUB_UNIT_TASK_PRIORITY + 7,
	SUB_UNIT_TASK_PRIORITY + 7, sub_unit_task_stack_7,
	TASK_STACKSIZE,
	NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the DMA controller task [yb]
	 */
	error_code = OSTaskCreateExt(dma1_scheduler_task, (void *) 0, (void *) &dma1_scheduler_task_stack_0[TASK_STACKSIZE - 1],
	DMA_SCHEDULER_TASK_PRIORITY,
	DMA_SCHEDULER_TASK_PRIORITY, dma1_scheduler_task_stack_0,
	TASK_STACKSIZE,
	NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the DMA2 controller task [yb]
	 */
	error_code = OSTaskCreateExt(dma2_scheduler_task, (void *) 1, (void *) &dma1_scheduler_task_stack_1[TASK_STACKSIZE - 1],
	DMA_SCHEDULER_TASK_PRIORITY + 1,
	DMA_SCHEDULER_TASK_PRIORITY + 1, dma1_scheduler_task_stack_1,
	TASK_STACKSIZE,
	NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the Echo task [yb]
	 */
	error_code = OSTaskCreateExt(echo_task, NULL, (void *) &echo_task_stack[TASK_STACKSIZE - 1],
	ECHO_TASK_PRIORITY,
	ECHO_TASK_PRIORITY, echo_task_stack,
	TASK_STACKSIZE,
	NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the UART receiver task
	 */
	error_code = OSTaskCreateExt(uart_receiver_task, NULL, (void *) &uart_rcv_task_stack[TASK_STACKSIZE - 1],
	UART_RCV_TASK_PRIORITY,
	UART_RCV_TASK_PRIORITY, uart_rcv_task_stack,
	TASK_STACKSIZE,
	NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the periodic HK task
	 */
	error_code = OSTaskCreateExt(periodic_HK_task, NULL, (void *) &periodic_HK_task_stack[TASK_STACKSIZE - 1],
	PERIODIC_HK_TASK_PRIORITY,
	PERIODIC_HK_TASK_PRIORITY, periodic_HK_task_stack,
	TASK_STACKSIZE,
	NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	xMutexDMA[0] = OSMutexCreate(PCP_MUTEX_DMA_QUEUE, &error_code);
	if (error_code != OS_ERR_NONE) {
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xCritical) {
		fprintf(fp, "Error creating mutex\r\n");
}
#endif
	}
	xMutexDMA[1] = OSMutexCreate(PCP_MUTEX_DMA_QUEUE + 1, &error_code);
	if (error_code != OS_ERR_NONE) {
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xCritical) {
		fprintf(fp, "Error creating mutex\r\n");
}
#endif
	}
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
	fprintf(fp, "Tasks created successfully\r\n");
}
#endif

}
