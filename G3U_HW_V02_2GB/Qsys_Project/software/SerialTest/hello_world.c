/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>

#include <altera_avalon_pio_regs.h>
#include <errno.h>
#include "system.h"
#include <stdio.h>
#include <stdbool.h>
#include <sys/alt_stdio.h>
#include <unistd.h>  // usleep (unix standard?)
#include <sys/alt_alarm.h> // time tick function (alt_nticks(), alt_ticks_per_second())
#include <sys/alt_timestamp.h>
#include <priv/alt_busy_sleep.h>

#ifndef bool
	//typedef short int bool;
	//typedef enum e_bool { false = 0, true = 1 } bool;
	//#define false   0
	//#define true    1
	#define FALSE   0
	#define TRUE    1
#endif

typedef struct UartModule {
	bool bUartTxWrreq;
	alt_u32 uliUartTxWrdata;
	bool    bUartTxFull;
	bool    bUartRxRdreq;
	bool    bUartRxEmpty;
	alt_u32 uliUartRxRddata;
} TUartModule;

int main()
{
  printf("Hello from Nios II!\n");

  volatile TUartModule *vpxUartModule = (TUartModule *)UART_MODULE_TOP_0_BASE;



  while (1) {

	  if (!vpxUartModule->bUartRxEmpty){
		  printf("Incoming data: %c \n", (char)vpxUartModule->uliUartRxRddata);
		  vpxUartModule->bUartRxRdreq = true;
	  }

	  vpxUartModule->uliUartTxWrdata = (alt_u32)'c';
	  vpxUartModule->bUartTxWrreq = true;
	  vpxUartModule->uliUartTxWrdata = (alt_u32)'u';
	  vpxUartModule->bUartTxWrreq = true;
	  vpxUartModule->uliUartTxWrdata = (alt_u32)'a';
	  vpxUartModule->bUartTxWrreq = true;
	  vpxUartModule->uliUartTxWrdata = (alt_u32)'t';
	  vpxUartModule->bUartTxWrreq = true;
	  vpxUartModule->uliUartTxWrdata = (alt_u32)'r';
	  vpxUartModule->bUartTxWrreq = true;
	  vpxUartModule->uliUartTxWrdata = (alt_u32)'o';
	  vpxUartModule->bUartTxWrreq = true;
	  vpxUartModule->uliUartTxWrdata = (alt_u32)'\n';
	  vpxUartModule->bUartTxWrreq = true;

	  usleep(1000000);

  }

  return 0;
}
