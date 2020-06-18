/*
 * simucam_definitions.h
 *
 *  Created on: 06/12/2018
 *      Author: Tiago-Low
 */

#ifndef SIMUCAM_DEFINITIONS_H_
#define SIMUCAM_DEFINITIONS_H_

#define DEBUG_ON    	1
#if DEBUG_ON
	#define debug( fp, mensage )    if ( DEBUG_ON ) { fprintf( fp, mensage ); }
#endif

/* HW and FW release version */
#define SIMUCAM_RELEASE                 "I2dev"
#define SIMUCAM_HW_VERSION              "0.3"
#define SIMUCAM_FW_VERSION              "0.0.testbench"

#ifndef bool
	//typedef short int bool;
	//typedef enum e_bool { false = 0, true = 1 } bool;
	//#define false   0
	//#define true    1
	#define FALSE   0
	#define TRUE    1
#endif

typedef enum { dlFullMessage  = 0, dlCustom0, dlMinorMessage, dlCustom1, dlMajorMessage, dlCustom2, dlJustMajorProgress, dlCriticalOnly } tDebugLevel;
#define DEBUG_LEVEL                     4

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

/*---- initialization_simucam -----*/
#include "driver/leds/leds.h"
#include "driver/seven_seg/seven_seg.h"
/*---------------------------------*/

/* Variable that will carry the debug JTAG device file descriptor*/
#if DEBUG_ON
    FILE* fp;
#endif

#define min_sim( x , y ) ((x < y) ? x : y)

#include <altera_avalon_uart.h>


#endif /* SIMUCAM_DEFINITIONS_H_ */
