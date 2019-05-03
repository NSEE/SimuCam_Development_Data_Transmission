/*
************************************************************************************************
*                                              NSEE
*                                             Address
*
*                                       All Rights Reserved
*
*
* Filename     : sub_unit_control.h
* Programmer(s): Yuri Bunduki
* Description  : Header file for the Sub-Unit management task
************************************************************************************************
*/
/*$PAGE*/

#ifndef SUB_UNIT_CONTROL_H_
#define SUB_UNIT_CONTROL_H_


/*
************************************************************************************************
*                                        INCLUDE FILES
************************************************************************************************
*/

#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "includes.h"
#include "../alt_error_handler.h"
#include "../utils/util.h"
#include "../api_drivers/ddr2/ddr2.h"
#include "../api_drivers/iwf_simucam_dma/iwf_simucam_dma.h"
#include "../simucam_definitions.h"
#include "../driver/dcom/dcom_channel.h"


#include "tasks_init.h"


/*
 * Include configurations for the SpW communication modules [yb]
 */

/*$PAGE*/

/*
************************************************************************************************
*                                        CONSTANTS & MACROS
************************************************************************************************
*/

#define SUBUNIT_BUFFER 		10


/*$PAGE*/


/* Macro definitions */

//INT8U set_spw_linkspeed(TDcomChannel *x_channel, INT8U i_linkspeed_code);

/*
 * Sub-Unit queues prototypes
 */
void sub_unit_create_os_data_structs();
void sub_unit_create_queue(void);

INT8U set_spw_linkspeed(TDcomChannel *x_channel, INT8U i_linkspeed_code);

/*
 * SubUnit control queues handles
 */

//extern OS_EVENT *p_sub_unit_config_queue;
extern OS_EVENT *p_sub_unit_command_queue;
extern volatile INT32U i_central_timer_counter;
extern volatile INT32U i_running_timer_counter;
extern INT8U i_echo_sent_data;
extern INT16U i_id_accum;
INT16U i_imagette_number;


extern T_Simucam T_simucam;


#endif /* SUB_UNIT_CONTROL_H_ */
