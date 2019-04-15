/*
 * command_control.h
 *
 *  Created on: 21/11/2018
 *      Author: Yuri Bunduki
 */

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

///* Macro definitions */
//#define LENGTH_OFFSET				3		/*Byte number offset for the 4 length bytes*/
//#define MAX_IMAGETTE_SIZE 			400000 	/*Imagette size in bytes*/
//#define DELAY_SIZE					6 		/*Number of bytes used for delay value*/
//#define CENTRAL_TIMER_RESOLUTION	1		/*Timer resolution, counter uses 100Hz, so 10 = 1s*/
//#define MAX_IMAGETTES				500		/*Maximum number of imagettes */
//#define DATA_SHIFT					12		/*Data header shift*/
//#define ASCII_A						65
//
//#define DMA_DEV						0
//
//#define DDR2_BASE_ADDR_DATASET_1	0x0
//
///*
// * Error codes definitions
// */
//#define ACK_OK						0
//#define COMMAND_NOT_ACCEPTED		4
//#define COMMAND_NOT_FOUND			5 	/*Command not found code*/
//#define NOT_IMPLEMENTED				7	/*Command not implemented*/
//#define	TIMER_ERROR					8
//#define PARSER_ERROR				9
//#define	ECHO_ERROR					10

extern INT16U i_imagette_number;
extern INT16U i_imagette_counter;

/*$PAGE*/

/*
 ************************************************************************************************
 *                                            DATA TYPES
 ************************************************************************************************
 */




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
