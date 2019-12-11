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
struct x_ethernet_payload *p_simucam_command_q_table[16]; /*Storage for SimucamCommandQ */

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
	p_simucam_command_q = OSQCreate(&p_simucam_command_q_table[0],
	DATAQ_BUF_SIZE);

	if (!p_simucam_command_q) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create Simucam Command Queue.\n");
	} else {
#if DEBUG_ON
		fprintf(fp, "Simucam Command Queue created successfully.\r\n");
#endif
	}
}

/*
 * Create the Simucam data queue
 */
void DataCreateOSQ(void) {
	SimucamDataQ = OSQCreate(&SimucamDataQTbl[0], DATAQ_BUF_SIZE);

	if (!SimucamDataQ) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create SimucamDataQ.\n");
	} else {
#if DEBUG_ON
		fprintf(fp, "SimucamDataQ created successfully.\r\n");
#endif
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
	error_code = OSTaskCreateExt(sub_unit_control_task, (void *) 0,
			(void *) &sub_unit_task_stack[TASK_STACKSIZE - 1],
			SUB_UNIT_TASK_PRIORITY,
			SUB_UNIT_TASK_PRIORITY, sub_unit_task_stack,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	OSTimeDlyHMSM(0, 0, 1, 0);

	/*
	 * Creating the sub_unit 1 management task [yb]
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_1, (void *) 1,
			(void *) &sub_unit_task_stack_1[TASK_STACKSIZE - 1],
			SUB_UNIT_TASK_PRIORITY + 1,
			SUB_UNIT_TASK_PRIORITY + 1, sub_unit_task_stack_1,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the sub_unit 2 management task [yb]
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_2, (void *) 2,
			(void *) &sub_unit_task_stack_2[TASK_STACKSIZE - 1],
			SUB_UNIT_TASK_PRIORITY + 2,
			SUB_UNIT_TASK_PRIORITY + 2, sub_unit_task_stack_2,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the sub_unit 3 management task [yb]
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_3, (void *) 3,
			(void *) &sub_unit_task_stack_3[TASK_STACKSIZE - 1],
			SUB_UNIT_TASK_PRIORITY + 3,
			SUB_UNIT_TASK_PRIORITY + 3, sub_unit_task_stack_3,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the sub_unit 4 management task [yb]
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_4, (void *) 4,
			(void *) &sub_unit_task_stack_4[TASK_STACKSIZE - 1],
			SUB_UNIT_TASK_PRIORITY + 4,
			SUB_UNIT_TASK_PRIORITY + 4, sub_unit_task_stack_4,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);
	/*
	 * Creating the sub_unit 5 management task [yb]
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_5, (void *) 5,
			(void *) &sub_unit_task_stack_5[TASK_STACKSIZE - 1],
			SUB_UNIT_TASK_PRIORITY + 5,
			SUB_UNIT_TASK_PRIORITY + 5, sub_unit_task_stack_5,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the sub_unit 6 management task [yb]
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_6, (void *) 6,
			(void *) &sub_unit_task_stack_6[TASK_STACKSIZE - 1],
			SUB_UNIT_TASK_PRIORITY + 6,
			SUB_UNIT_TASK_PRIORITY + 6, sub_unit_task_stack_6,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the sub_unit 7 management task [yb]
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_7, (void *) 7,
			(void *) &sub_unit_task_stack_7[TASK_STACKSIZE - 1],
			SUB_UNIT_TASK_PRIORITY + 7,
			SUB_UNIT_TASK_PRIORITY + 7, sub_unit_task_stack_7,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the DMA controller task [yb]
	 */
	error_code = OSTaskCreateExt(dma1_scheduler_task, (void *) 0,
			(void *) &dma1_scheduler_task_stack_0[TASK_STACKSIZE - 1],
			DMA_SCHEDULER_TASK_PRIORITY,
			DMA_SCHEDULER_TASK_PRIORITY, dma1_scheduler_task_stack_0,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the DMA2 controller task [yb]
	 */
	error_code = OSTaskCreateExt(dma2_scheduler_task, (void *) 1,
			(void *) &dma1_scheduler_task_stack_1[TASK_STACKSIZE - 1],
			DMA_SCHEDULER_TASK_PRIORITY + 1,
			DMA_SCHEDULER_TASK_PRIORITY + 1, dma1_scheduler_task_stack_1,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the Echo task [yb]
	 */
	error_code = OSTaskCreateExt(echo_task, NULL,
			(void *) &echo_task_stack[TASK_STACKSIZE - 1],
			ECHO_TASK_PRIORITY,
			ECHO_TASK_PRIORITY, echo_task_stack,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the UART receiver task
     * Initialized in the main task
	 */
	error_code = OSTaskCreateExt(uart_receiver_task, NULL,
			(void *) &uart_rcv_task_stack[TASK_STACKSIZE - 1],
			UART_RCV_TASK_PRIORITY,
			UART_RCV_TASK_PRIORITY, uart_rcv_task_stack,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	xMutexDMA[0] = OSMutexCreate(PCP_MUTEX_DMA_QUEUE, &error_code);
	if (error_code != OS_ERR_NONE) {
#if DEBUG_ON
		fprintf(fp, "Error creating mutex\r\n");
#endif
	}
	xMutexDMA[1] = OSMutexCreate(PCP_MUTEX_DMA_QUEUE + 1, &error_code);
	if (error_code != OS_ERR_NONE) {
#if DEBUG_ON
		fprintf(fp, "Error creating mutex\r\n");
#endif
	}
	fprintf(fp, "Tasks created successfully\r\n");
#if DEBUG_ON
	fprintf(fp, "Tasks created successfully\r\n");
#endif

}
