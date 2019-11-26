
/*
 ************************************************************************************************
 *                                              NSEE
 *                                             Address
 *
 *                                       All Rights Reserved
 *
 *
 * Filename     : simucam_definitions.h
 * Programmer(s): Yuri Bunduki
 * Created on: Mar 22, 2019
 * Description  : Header file for the Simucam definitions.
 ************************************************************************************************
 */
/*$PAGE*/


#ifndef SIMUCAM_DEFINITIONS_H_
#define SIMUCAM_DEFINITIONS_H_

#include <altera_up_sd_card_avalon_interface.h>
#include <altera_msgdma.h>
#include <altera_avalon_pio_regs.h>
#include <errno.h>
#include "system.h"
#include <stdio.h>
#include <sys/alt_stdio.h>
#include <unistd.h>  // usleep (unix standard?)
#include <sys/alt_flash.h>
#include <sys/alt_flash_types.h>
#include <sys/alt_alarm.h> // time tick function (alt_nticks(), alt_ticks_per_second())
#include <sys/alt_timestamp.h>
#include <sys/alt_irq.h>  // interrupt
#include <priv/alt_legacy_irq.h>
#include <priv/alt_busy_sleep.h>
#include "simucam_model.h"

/*
 ************************************************************************************************
 *                                        CONSTANTS & MACROS
 ************************************************************************************************
 */

#define DEBUG_ON 					0

#define ECHO_CMD_OVERHEAD			15

#define TELEMETRY_BUFFER_SIZE		256
#define	DMA_SCHED_BUFFER			128
#define ECHO_QUEUE_BUFFER			512
#define ECHO_BUFFER					512

#define ACK_TYPE					1
#define ERROR_TYPE					2
#define ECHO_TYPE					3

#define NB_CHANNELS					8		/* nb of active channels (max 8)*/

#define MAX_IMAGETTES				500		/*Maximum number of imagettes */

#define DMA_OFFSET					6
#define LENGTH_OFFSET				3		/*Byte number offset for the 4 length bytes*/
#define MAX_IMAGETTE_SIZE 			400000 	/*Imagette size in bytes*/
#define DELAY_SIZE					6 		/*Number of bytes used for delay value*/
#define CENTRAL_TIMER_RESOLUTION	1		/*Timer resolution, counter uses 100Hz, so 10 = 1s*/
#define DATA_SHIFT					12		/*Data header shift*/
#define ASCII_A						65

#define DMA_DEV						0

#define DDR2_BASE_ADDR_DATASET_1	0x00000000
#define DDR2_BASE_ADDR_DATASET_2	0x20000000	/* 512Mb space for dataset 1 */
#define	DDR2_BASE_ADDR_DATASET_3	0x40000000
#define	DDR2_BASE_ADDR_DATASET_4	0x60000000

#define TIMER_CLOCK_DIV_1MS			99999		/*Timer div for 1ms clock*/

#define HK_SIZE						30			/* HK ack size */
/*
 * Error codes definitions transform into enum
 */
#define ACK_OK						0
#define COMMAND_NOT_ACCEPTED		4
#define COMMAND_NOT_FOUND			5 	/*Command not found code*/
#define NOT_IMPLEMENTED				7	/*Command not implemented*/
#define	TIMER_ERROR					8
#define PARSER_ERROR				9
#define	ECHO_ERROR					10

/*
 * Priorities definitions
 */

extern OS_EVENT *xMutexDMA[2];


#ifndef bool
	//typedef short int bool;
	//typedef enum e_bool { false = 0, true = 1 } bool;
	//#define false   0
	//#define true    1
	#define FALSE   0
	#define TRUE    1
#endif


#if DEBUG_ON
	#define debug( fp, mensage )    if ( DEBUG_ON ) { fprintf( fp, mensage ); }
#endif

/* Variable that will carry the debug JTAG device file descriptor*/
#if DEBUG_ON
    extern FILE* fp;
#endif

/*
************************************************************************************************
*                                            DATA TYPES
************************************************************************************************
*/

/*
 * Structure to identify the Sub-Unit configuration parameters
 * mode: 0-> config, 1-> running
 * [receive_data: 0->ethernet, 1->SSD] Not needed anymore
 * RMAP_handling: 0->none, 1->echoing, 2->logging
 * forward_data to ethernet link
 */
typedef struct sub_config {

	INT8U mode;
	//INT8U receive_data;
	INT8U forward_data;
	INT8U RMAP_handling;
	INT8U link_config;
	INT8U linkspeed;
	INT8U linkstatus_running;
	INT8U echo_sent;
	INT8U sub_status_sending;
	INT8U link_status;
	struct Timagette_control *imagette;

}sub_config_t;

struct _sub_data {
	INT8U p_data_addr[100];
	INT32U i_data_size;
}_sub_data;

typedef struct x_imagette {
	/*
	 * Usar memcpy
	 */
	INT32U offset; /* In miliseconds*/
	INT16U imagette_length; /* length of N imagette */
	INT8U imagette_start; /*Pointer to de DDR2 address*/
}x_imagette;

typedef struct Timagette_control {
#if DMA_DEV
	struct x_imagette *dataset[MAX_IMAGETTES];
#endif
#if !DMA_DEV
	INT32U offset[MAX_IMAGETTES]; /* In miliseconds*/
	INT16U imagette_length[MAX_IMAGETTES]; /* length of N imagette */
//	INT8U imagette[MAX_IMAGETTE_SIZE]; /*Pointer to de DDR2 address*/
	INT8U imagette[MAX_IMAGETTES];
	struct x_imagette *dataset[MAX_IMAGETTES];
#endif
	INT16U nb_of_imagettes; /*Number of imagettes in dataset*/
	INT32U size; 			/*Imagette array size*/
	INT8U tag[8];
	INT8U sto_locale;
}Timagette_control;

struct x_telemetry {

	INT8U i_type;
	INT8U i_channel;
	INT8U error_code;
	struct x_ethernet_payload *p_payload;
	struct Timagette_control *p_imagette;

} x_telemetry;


/*$PAGE*/

typedef enum { dlFullMessage = 0, dlCustom0, dlMinorMessage, dlCustom1, dlMajorMessage, dlCustom2, dlJustMajorProgress, dlCriticalOnly } tDebugLevel;


/* Variable that will carry the debug JTAG device file descriptor*/
//#if DEBUG_ON
//    extern FILE* fp;
//#endif

#define min_sim( x , y ) ((x < y) ? x : y)

#endif /* SIMUCAM_DEFINITIONS_H_ */
