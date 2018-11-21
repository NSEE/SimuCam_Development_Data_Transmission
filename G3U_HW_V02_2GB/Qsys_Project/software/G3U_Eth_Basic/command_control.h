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
#define LENGTH_OFFSET	3 //Byte number offset for the 4 length bytes
#define IMAGETTE_SIZE 	5 //Imagette size in bytes
#define DELAY_SIZE		1 //Number of bytes used for delay value


struct _imagette_control{

	INT16U offset; //define the unit later
	INT8U* imagette_start;
}_imagette_control;

/* Control functions*/
void v_parse_data(struct _ethernet_payload*,struct _imagette_control*);

INT32U i_compute_size(INT8U*);

OS_TMR central_timer;

#endif /* COMMAND_CONTROL_H_ */
