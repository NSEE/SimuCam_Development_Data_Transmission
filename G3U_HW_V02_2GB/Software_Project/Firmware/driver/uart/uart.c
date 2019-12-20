/*
 * uart.c
 *
 *  Created on: 20 de dez de 2019
 *      Author: rfranca
 */

#include "uart.h"

void vUartWriteChar(char cTxChar){
	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;
	vpxUartModule->uliUartTxWrdata = (alt_u32)cTxChar;
	vpxUartModule->bUartTxWrreq = true;
}

void vUartWriteBuffer(char *pcTxBuffer, alt_u16 usiLength){
	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;
	alt_u16 usiCnt = 0;
	for (usiCnt = 0; usiCnt < usiLength; usiCnt++) {
		vpxUartModule->uliUartTxWrdata = (alt_u32)(pcTxBuffer[usiCnt]);
		vpxUartModule->bUartTxWrreq = true;
	}
}

char cUartReadChar(){
	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;
	char cRxChar;
	while (vpxUartModule->bUartRxEmpty){}
	cRxChar = (char)((vpxUartModule->uliUartRxRddata) & 0xFF);
	vpxUartModule->bUartRxRdreq = true;
	return cRxChar;
}

void vUartReadBuffer(char *pcRxBuffer, alt_u16 usiLength){
	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;
	alt_u16 usiCnt = 0;
	for (usiCnt = 0; usiCnt < usiLength; usiCnt++) {
		while (vpxUartModule->bUartRxEmpty){}
		pcRxBuffer[usiCnt] = (char)((vpxUartModule->uliUartRxRddata) & 0xFF);
		vpxUartModule->bUartRxRdreq = true;
	}
}
