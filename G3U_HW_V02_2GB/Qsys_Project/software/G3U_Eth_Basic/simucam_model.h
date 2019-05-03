/*
 * simucam_model.h
 *
 *  Created on: 15/04/2019
 *      Author: root
 */

#ifndef SIMUCAM_MODEL_H_
#define SIMUCAM_MODEL_H_
#include <altera_up_sd_card_avalon_interface.h>

#ifndef bool
//typedef short int bool;
//typedef enum e_bool { false = 0, true = 1 } bool;
//#define false   0
//#define true    1
#define FALSE   0
#define TRUE    1
#endif

/* Sub modes enum */
typedef enum {
	subModeConfig = 0,
	subModeRun,
	subModeInit,
	subModetoConfig,
	subModetoRun,
	subAccessDMA1,
	subAccessDMA2,
	subAbort,
	subEOT,
	subChangeMode
} TSubStates;

/* MeB status enum */
typedef enum {
	simModeConfig = 0,
	simModeRun,
	simModeInit,
	simModetoConfig,
	simModetoRun,
	simDMA1Back,
	simDMA2Back,
	simDMA1Sched,
	simDMA2Sched,
	simAbort
} TSimStates;

typedef struct T_imagette {
	INT32U offset; /* In miliseconds*/
	INT16U imagette_length; /* length of N imagette */
	INT8U imagette_start; /*Pointer to de DDR2 address*/
} T_Imagette;

typedef struct T_dataset {
	INT32U addr_init;
	INT8U tag[8];
	INT16U nb_of_imagettes; /* Number of imagettes in dataset*/
	INT16U i_imagette; /* Imagette current number */
	T_Imagette *p_iterador; /* Imagettes Iterator */
} T_dataset;

typedef struct T_Sub_conf {
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
	bool	b_abort;
	INT16U	i_imagette_control;
} T_Sub_conf;

typedef struct T_Sub {
	T_Sub_conf T_conf;
	T_dataset T_data;
} T_Sub;

typedef struct T_Simucam_conf {
	INT8U b_meb_status;
	INT8U echo_sent;
	INT8U i_forward_data;
} T_Simucam_conf;

typedef struct T_simucam_status {
	TSimStates simucam_mode;
	INT16U simucam_total_imagettes_sent;
	INT32U simucam_running_time;
	bool has_dma_1;
	bool has_dma_2;
	INT16U	TM_id;
} T_simucam_status;

typedef struct T_Simucam {
	T_Simucam_conf T_conf;
	T_simucam_status T_status;
	T_Sub T_Sub[8];
} T_Simucam;
/*
 * Command + payload struct for the simucam ethernet control
 */

typedef struct x_ethernet_payload {
	INT8U header;		/* Command Header */
	INT16U packet_id;	/* Unique identifier */
	INT8U type;			/* Will be the command id */
	INT8U sub_type;		/* Could carry the sub-unit id */
	INT32U size;		/* Size pre-computed in function */
	INT8U data[1500];	/* Data array */
	INT16U crc;			/* We will use the CCITT-CRC, that is also used in the PUS protocol */


}_ethernet_payload;

#endif /* SIMUCAM_MODEL_H_ */
