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

/*
 * Include configurations for the communication modules [yb]
 */
#include "logic/comm/comm.h"


#ifndef COMMAND_CONTROL_H_
#define COMMAND_CONTROL_H_

/* Macro definitions */
#define LENGTH_OFFSET				3	/*Byte number offset for the 4 length bytes*/
#define IMAGETTE_SIZE 				13 	/*Imagette size in bytes*/
#define DELAY_SIZE					6 	/*Number of bytes used for delay value*/
#define CENTRAL_TIMER_RESOLUTION	100	/*Timer resolution, counter uses 100Hz, so 10 = 1s*/
#define MAX_IMAGETTES				50	/*Maximum number of imagettes */
#define DATA_SHIFT					4	/*Data header shift*/

struct _imagette_control{

	INT32U offset[MAX_IMAGETTES]; 					/* In miliseconds*/
	INT16U imagette_length[MAX_IMAGETTES];			/* length of N imagette */
	INT8U  imagette[MAX_IMAGETTES*IMAGETTE_SIZE];	/*Pointer to de DDR2 address*/
	INT16U nb_of_imagettes;							/*Number of imagettes in dataset*/
	INT32U size;									/*Imagette array size*/
}_imagette_control;

//struct imagette{
//
//	INT8U *imagette_byte[IMAGETTE_SIZE-1];	/*Pointer to de DDR2 address*/
//
//}imagette;

/* Control functions*/
int v_parse_data(struct _ethernet_payload*,struct _imagette_control*);

INT32U i_compute_size(INT8U*);

OS_TMR *central_timer;

#endif /* COMMAND_CONTROL_H_ */
