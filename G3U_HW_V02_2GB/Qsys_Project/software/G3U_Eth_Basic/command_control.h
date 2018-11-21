/*
 * command_control.h
 *
 *  Created on: 21/11/2018
 *      Author: root
 */

#ifndef COMMAND_CONTROL_H_
#define COMMAND_CONTROL_H_

/* Macro definitions */
#define LENGTH_OFFSET 3


struct _imagette_control{

	INT16U offset; //define the unit later
	INT8U* imagette_start;
}_imagette_control;

/* Control functions*/
void v_parse_data(struct _ethernet_payload,struct _imagette_control);

INT32U i_compute_size(INT8U*);

#endif /* COMMAND_CONTROL_H_ */
