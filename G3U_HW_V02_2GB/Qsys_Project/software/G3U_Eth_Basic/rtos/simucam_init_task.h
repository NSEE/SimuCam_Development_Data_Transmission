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


#include <stdio.h>
#include <string.h>
#include <ctype.h> 

#include "../simucam_definitions.h"
#include "../alt_error_handler.h"

/* MicroC/OS-II definitions */
#include "includes.h"

/*sub-unit definitions*/
#include "sub_unit_control_task.h"

/* Command control definitions*/
#include "command_control_task.h"


#include "../api_drivers/ddr2/ddr2.h"

/* Include to get the ETH Configs from the SimuCam */
#include "../utils/configs_simucam.h"

/* Nichestack definitions */
#include "ipport.h"
#include "libport.h"
#include "osport.h"
#include "default_configs.h"
#include "rtos_tasks.h"

#include "../simucam_model.h"
#include "tasks_init.h"

#define     TASK_STACKSIZE          2048

#define     DATAQ_BUF_SIZE          1500
#define     BUFFER_SIZE				2000
#define     EMPIRICAL_BUFFER_MIN 	21
#define     SSSBUFFER_ADDR			0x7FF0BDC0

#define     PROTOCOL_OVERHEAD		7
#define     EXIT_CODE				3

/*
 * data address that will be removed
 */
extern INT8U *data_addr;

/*
 * SimuCam tasks prototypes
 */

void DataCreateOSQ();
void SimucamCreateOSQ();

/*
 * Handles to the SimuCam control data queues
 */

extern OS_EVENT *SimucamDataQ;
extern OS_EVENT *p_simucam_command_q;
extern OS_EVENT *p_telemetry_queue;
extern INT16U i_id_accum;
//extern SSSConn conn;
extern T_Simucam T_simucam;

/*
 * Command task prototype
 */
void SimucamCreateTasks(void);
void DataCreateOSQ(void);
void SimucamCreateOSQ(void);


/*
 * Sub-Unit queues prototypes
 */
void sub_unit_create_os_data_structs();
void sub_unit_create_queue(void);


#endif /* SIMUCAM_INIT_TASK_H_ */
