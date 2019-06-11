/*
 ************************************************************************************************
 *                                              NSEE
 *                                             Address
 *
 *                                       All Rights Reserved
 *
 *
 * Filename     : command_control_task.c
 * Programmer(s): Yuri Bunduki
 * Created on: Dec 21, 2018
 * Description  : Header file for the command control management task.
 ************************************************************************************************
 */
/*$PAGE*/

/*
 ************************************************************************************************
 *                                        INCLUDE FILES
 ************************************************************************************************
 */
#include "includes.h"
#include "../alt_error_handler.h"
#include "../utils/util.h"
#include "../driver/dcom/dcom_channel.h"
#include "sub_unit_control_task.h"
#include "../simucam_definitions.h"
#include "../api_drivers/ddr2/ddr2.h"
#include "../driver/sync/sync.h"
#include "simple_socket_server.h"			/* Used in the conn/send op */
/*
 * Include configurations for the communication modules [yb]
 */

/*$PAGE*/

#ifndef COMMAND_CONTROL_H_
#define COMMAND_CONTROL_H_

/*
 ************************************************************************************************
 *                                        CONSTANTS & MACROS
 ************************************************************************************************
 */

extern INT16U i_imagette_number;
extern INT16U i_imagette_counter;

/*$PAGE*/

/*
 ************************************************************************************************
 *                                        FUNCTION PROTOTYPES
 ************************************************************************************************
 */

void v_ack_creator(struct x_ethernet_payload* p_error_response, int error_code);
INT32U i_compute_size(INT8U*);
void i_echo_dataset_direct_send(struct x_ethernet_payload*, INT8U*);
void v_HK_creator(struct x_ethernet_payload*, INT8U);
void central_timer_callback_function(void *);
void simucam_running_timer_callback_function(void *);
int v_parse_data_teste(struct x_ethernet_payload *p_payload,
		Timagette_control *p_img_ctrl, x_imagette *dataset[MAX_IMAGETTES]);

/*$PAGE*/

#endif /* COMMAND_CONTROL_H_ */
