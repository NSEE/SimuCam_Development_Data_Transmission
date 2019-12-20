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

#include "uart.h"

#ifndef bool
	//typedef short int bool;
	//typedef enum e_bool { false = 0, true = 1 } bool;
	//#define false   0
	//#define true    1
	#define FALSE   0
	#define TRUE    1
#endif

char cTxBuffer[64];
char cRxBuffer[64];
alt_u16 usiStringLength = 0;

int main()
{
  printf("Hello from Nios II!\n");

  volatile TUartModule *vpxUartModule = (TUartModule *)UART_MODULE_TOP_0_BASE;

//  printf("0x%08lX \n", *((alt_u32*)(UART_MODULE_TOP_0_BASE)));
//  printf("0x%08lX \n", *((alt_u32*)(UART_MODULE_TOP_0_BASE + 4)));
//  printf("0x%08lX \n", *((alt_u32*)(UART_MODULE_TOP_0_BASE + 8)));
//  printf("0x%08lX \n", *((alt_u32*)(UART_MODULE_TOP_0_BASE + 12)));
//  printf("0x%08lX \n", *((alt_u32*)(UART_MODULE_TOP_0_BASE + 16)));
//  printf("0x%08lX \n", *((alt_u32*)(UART_MODULE_TOP_0_BASE + 20)));
//  printf("0x%08lX \n", *((alt_u32*)(UART_MODULE_TOP_0_BASE + 24)));
//  printf("0x%08lX \n", *((alt_u32*)(UART_MODULE_TOP_0_BASE + 28)));

  while (1) {


	  usiStringLength = sprintf(cTxBuffer, "Hello from Nios II!\n");
	  vUartWriteBuffer(cTxBuffer, usiStringLength);

	  vUartReadBuffer(cRxBuffer, 16);
	  printf("Incoming data: %s\n", cRxBuffer);
//	  printf(" %c", cRxBuffer[0]);
//	  printf(" %c", cRxBuffer[1]);
//	  printf(" %c", cRxBuffer[2]);
//	  printf(" %c", cRxBuffer[3]);
//	  printf(" %c", cRxBuffer[4]);
//	  printf(" %c", cRxBuffer[5]);
//	  printf(" %c", cRxBuffer[6]);
//	  printf(" %c", cRxBuffer[7]);
//	  printf(" %c", cRxBuffer[8]);
//	  printf(" %c", cRxBuffer[9]);
//	  printf(" %c", cRxBuffer[10]);
//	  printf(" %c", cRxBuffer[11]);
//	  printf(" %c", cRxBuffer[12]);
//	  printf(" %c", cRxBuffer[13]);
//	  printf(" %c", cRxBuffer[14]);
//
//	  printf("\n");

//	  printf("Incoming data: ");
//	  while (vpxUartModule->uliUartRxUsedw > 0) {
//		  printf(" %c", cUartReadChar());
//		  usleep(100);
//	  }
//	  printf("\n");

//	  if (!vpxUartModule->bUartRxEmpty){
//		  printf("Incoming data: %c \n", (char)vpxUartModule->uliUartRxRddata);
//		  vpxUartModule->bUartRxRdreq = true;
//	  }
//
//	  vpxUartModule->uliUartTxWrdata = (alt_u32)'c';
//	  vpxUartModule->bUartTxWrreq = true;
//	  vpxUartModule->uliUartTxWrdata = (alt_u32)'u';
//	  vpxUartModule->bUartTxWrreq = true;
//	  vpxUartModule->uliUartTxWrdata = (alt_u32)'a';
//	  vpxUartModule->bUartTxWrreq = true;
//	  vpxUartModule->uliUartTxWrdata = (alt_u32)'t';
//	  vpxUartModule->bUartTxWrreq = true;
//	  vpxUartModule->uliUartTxWrdata = (alt_u32)'r';
//	  vpxUartModule->bUartTxWrreq = true;
//	  vpxUartModule->uliUartTxWrdata = (alt_u32)'o';
//	  vpxUartModule->bUartTxWrreq = true;
//	  vpxUartModule->uliUartTxWrdata = (alt_u32)'\n';
//	  vpxUartModule->bUartTxWrreq = true;

	  usleep(1000000);

  }

  return 0;
}
