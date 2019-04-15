/*
 * simucam_model.h
 *
 *  Created on: 15/04/2019
 *      Author: root
 */

#ifndef SIMUCAM_MODEL_H_
#define SIMUCAM_MODEL_H_

/* Sub modes enum */
typedef enum { subModeConfig = 0, subModeRun, subModeInit, subModetoConfig, subModetoRun }TSubStates;

typedef struct T_imagette{
	INT32U 	offset; 				/* In miliseconds*/
	INT16U	imagette_length; 		/* length of N imagette */
	INT8U	imagette_start; 	/*Pointer to de DDR2 address*/
}T_Imagette;

typedef struct T_dataset{
	INT32U		addr_init;
	INT8U 		tag[8];
	INT16U 		nb_of_imagettes; 		/* Number of imagettes in dataset*/
	INT16U		i_imagette;				/* Imagette current number */
	T_Imagette	*p_iterador;			/* Imagettes Iterator */
}T_dataset;

typedef struct T_Sub_conf{
	TSubStates mode;
	//INT8U receive_data;
	INT8U forward_data;
	INT8U RMAP_handling;
	INT8U link_config;
	INT8U linkspeed;
	INT8U linkstatus_running;
	INT8U echo_sent;
	INT8U sub_status_sending;
	INT8U link_status;
}T_Sub_conf;

typedef struct T_Sub{
	T_Sub_conf	T_conf;
	T_dataset	T_data;
}T_Sub;

typedef struct T_Simucam_conf{
	INT8U	b_meb_status;
	INT8U	echo_sent;
	INT8U	b_abort[8];
}T_Simucam_conf;

typedef struct T_Simucam{
	T_Simucam_conf 	T_conf;
	T_Sub			T_Sub[8];
}T_Simucam;

#endif /* SIMUCAM_MODEL_H_ */
