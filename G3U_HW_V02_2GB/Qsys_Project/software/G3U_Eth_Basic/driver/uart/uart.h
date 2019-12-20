/*
 * uart.h
 *
 *  Created on: 20 de dez de 2019
 *      Author: rfranca
 */

#ifndef UART_H_
#define UART_H_

#include "../../simucam_definitions.h"

#define UART_BASE_ADDR UART_MODULE_TOP_0_BASE

typedef struct UartModule {
	alt_u32 bUartTxWrreq;
	alt_u32 uliUartTxWrdata;
	alt_u32    bUartTxFull;
	alt_u32 uliUartTxUsedw;
	alt_u32    bUartRxRdreq;
	alt_u32    bUartRxEmpty;
	alt_u32 uliUartRxRddata;
	alt_u32 uliUartRxUsedw;
} TUartModule;

void vUartWriteChar(char cTxChar);
void vUartWriteBuffer(char *pcTxBuffer, alt_u16 usiLength);
char cUartReadChar();
void vUartReadBuffer(char *pcRxBuffer, alt_u16 usiLength);

#endif /* UART_H_ */
