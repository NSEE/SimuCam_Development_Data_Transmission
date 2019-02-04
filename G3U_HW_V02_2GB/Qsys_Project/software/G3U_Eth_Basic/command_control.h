/*
 * command_control.h
 *
 *  Created on: 21/11/2018
 *      Author: root
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include <ucos_ii.h>
#include "os_cfg.h"
#include "os_cpu.h"
#include "simple_socket_server.h"
#include "alt_error_handler.h"
#include "utils/util.h"
#include "sub_unit_control.h"
#include "logic/ddr2/ddr2.h"

/*
 * Include configurations for the communication modules [yb]
 */
#include "logic/comm/comm.h"


#ifndef COMMAND_CONTROL_H_
#define COMMAND_CONTROL_H_

/* Macro definitions */
#define LENGTH_OFFSET				3		/*Byte number offset for the 4 length bytes*/
#define MAX_IMAGETTE_SIZE 			20000 	/*Imagette size in bytes*/
#define DELAY_SIZE					6 		/*Number of bytes used for delay value*/
#define CENTRAL_TIMER_RESOLUTION	1		/*Timer resolution, counter uses 100Hz, so 10 = 1s*/
#define MAX_IMAGETTES				500		/*Maximum number of imagettes */
#define DATA_SHIFT					12		/*Data header shift*/
#define ASCII_A						65

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

struct imagette_control{

	INT32U offset[MAX_IMAGETTES]; 					/* In miliseconds*/
	INT16U imagette_length[MAX_IMAGETTES];			/* length of N imagette */
	INT8U  imagette[MAX_IMAGETTE_SIZE];	/*Pointer to de DDR2 address*/
	INT8U* img_test;								/* Teste de imagette referenciada*/
	INT16U nb_of_imagettes;							/*Number of imagettes in dataset*/
	INT32U size;									/*Imagette array size*/
	INT8U tag[8];
	INT8U sto_locale;
}imagette_control;

//struct imagette{
//
//	INT8U *imagette_byte[IMAGETTE_SIZE-1];	/*Pointer to de DDR2 address*/
//
//}imagette;

/* Control functions*/
int v_parse_data(struct _ethernet_payload*,struct imagette_control*);
void v_ack_creator(struct _ethernet_payload* p_error_response, int error_code);
INT32U i_compute_size(INT8U*);

extern INT16U i_imagette_number;
extern INT16U i_imagette_counter;
extern SSSConn conn;

OS_TMR *central_timer;
OS_TMR *simucam_running_timer;

#endif /* COMMAND_CONTROL_H_ */
