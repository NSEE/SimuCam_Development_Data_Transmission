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
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include <ucos_ii.h>
#include "os_cfg.h"
#include "os_cpu.h"
#include "simple_socket_server.h"
#include "../alt_error_handler.h"
#include "../utils/util.h"
#include "sub_unit_control_task.h"
#include "../logic/ddr2/ddr2.h"
#include "../simucam_definitions.h"

/*
 * Include configurations for the communication modules [yb]
 */
#include "../logic/comm/comm.h"

/*$PAGE*/

#ifndef COMMAND_CONTROL_H_
#define COMMAND_CONTROL_H_

/*
 ************************************************************************************************
 *                                        CONSTANTS & MACROS
 ************************************************************************************************
 */

/* Macro definitions */
#define LENGTH_OFFSET				3		/*Byte number offset for the 4 length bytes*/
#define MAX_IMAGETTE_SIZE 			400000 	/*Imagette size in bytes*/
#define DELAY_SIZE					6 		/*Number of bytes used for delay value*/
#define CENTRAL_TIMER_RESOLUTION	1		/*Timer resolution, counter uses 100Hz, so 10 = 1s*/
#define MAX_IMAGETTES				500		/*Maximum number of imagettes */
#define DATA_SHIFT					12		/*Data header shift*/
#define ASCII_A						65

#define DMA_DEV						0

/*
 * Error codes definitions
 */
#define ACK_OK						0
#define COMMAND_NOT_ACCEPTED		4
#define COMMAND_NOT_FOUND			5 	/*Command not found code*/
#define NOT_IMPLEMENTED				7	/*Command not implemented*/
#define	TIMER_ERROR					8
#define PARSER_ERROR				9
#define	ECHO_ERROR					10

extern INT16U i_imagette_number;
extern INT16U i_imagette_counter;
extern SSSConn conn;

OS_TMR *central_timer;
OS_TMR *simucam_running_timer;

/*$PAGE*/

/*
 ************************************************************************************************
 *                                            DATA TYPES
 ************************************************************************************************
 */

struct x_imagette {
	/*
	 * Usar memcpy
	 */
	INT32U offset; /* In miliseconds*/
	INT16U imagette_length; /* length of N imagette */
	INT8U imagette_start; /*Pointer to de DDR2 address*/
}x_imagette;


struct imagette_control {
#if DMA_DEV
	x_imagette *dataset[MAX_IMAGETTES];
#endif
#if !DMA_DEV
	INT32U offset[MAX_IMAGETTES]; /* In miliseconds*/
	INT16U imagette_length[MAX_IMAGETTES]; /* length of N imagette */
	INT8U imagette[MAX_IMAGETTE_SIZE]; /*Pointer to de DDR2 address*/
#endif
	INT16U nb_of_imagettes; /*Number of imagettes in dataset*/
	INT32U size; 			/*Imagette array size*/
	INT8U tag[8];
	INT8U sto_locale;
}imagette_control;


/*$PAGE*/

/*
 ************************************************************************************************
 *                                        FUNCTION PROTOTYPES
 ************************************************************************************************
 */

int v_parse_data(struct x_ethernet_payload*,struct imagette_control*);
void v_ack_creator(struct x_ethernet_payload* p_error_response, int error_code);
INT32U i_compute_size(INT8U*);
INT8U set_spw_linkspeed(INT8U, INT8U);
void i_echo_dataset_direct_send(struct x_ethernet_payload*, INT8U*);
void v_HK_creator(struct x_ethernet_payload*, INT8U);
void central_timer_callback_function(void *);
void simucam_running_timer_callback_function(void *);

/*$PAGE*/

#endif /* COMMAND_CONTROL_H_ */
