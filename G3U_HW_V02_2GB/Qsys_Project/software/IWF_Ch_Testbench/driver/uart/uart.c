/*
 * uart.c
 *
 *  Created on: 20 de dez de 2019
 *      Author: rfranca
 */

#include "uart.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]

bool bUartTxBufferFull(){
	bool bFull;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	bFull = vpxUartModule->xUartTxBufferStatus.bFull;

	return (bFull);
}

bool bUartRxBufferEmpty(){
	bool bEmpty;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	bEmpty = vpxUartModule->xUartRxBufferStatus.bEmpty;

	return (bEmpty);
}

void vUartWriteCharBlocking(char cTxChar){

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	while (vpxUartModule->xUartTxBufferStatus.bFull){}
	vpxUartModule->xUartTxBufferControl.ucWrData = (alt_u8)cTxChar;
	vpxUartModule->xUartTxBufferControl.bWrReq = TRUE;

}

void vUartWriteBufferBlocking(char *pcTxBuffer, alt_u16 usiLength){
	alt_u16 usiCnt = 0;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	for (usiCnt = 0; usiCnt < usiLength; usiCnt++) {
		while (vpxUartModule->xUartTxBufferStatus.bFull){}
		vpxUartModule->xUartTxBufferControl.ucWrData = (alt_u8)(pcTxBuffer[usiCnt]);
		vpxUartModule->xUartTxBufferControl.bWrReq = TRUE;
	}

}

char cUartReadCharBlocking(){
	char cRxChar;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	while (vpxUartModule->xUartRxBufferStatus.bEmpty){}
	cRxChar = (char)(vpxUartModule->xUartRxBufferStatus.ucRdData);
	vpxUartModule->xUartRxBufferControl.bRdReq = TRUE;

	return (cRxChar);
}

void vUartReadBufferBlocking(char *pcRxBuffer, alt_u16 usiLength){
	alt_u16 usiCnt = 0;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	for (usiCnt = 0; usiCnt < usiLength; usiCnt++) {
		while (vpxUartModule->xUartRxBufferStatus.bEmpty){}
		pcRxBuffer[usiCnt] = (char)(vpxUartModule->xUartRxBufferStatus.ucRdData);
		vpxUartModule->xUartRxBufferControl.bRdReq = TRUE;
	}

}

bool bUartWriteCharNonBlocking(char cTxChar){
	bool bSuccess = FALSE;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	if (!vpxUartModule->xUartTxBufferStatus.bFull) {
		vpxUartModule->xUartTxBufferControl.ucWrData = (alt_u8)cTxChar;
		vpxUartModule->xUartTxBufferControl.bWrReq = TRUE;
		bSuccess = TRUE;
	}

	return (bSuccess);
}

alt_u16 usiUartWriteBufferNonBlocking(char *pcTxBuffer, alt_u16 usiLength){
	alt_u16 usiWrittenChars = 0;
	alt_u16 usiCnt = 0;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	for (usiCnt = 0; usiCnt < usiLength; usiCnt++) {
		if (!vpxUartModule->xUartTxBufferStatus.bFull) {
			vpxUartModule->xUartTxBufferControl.ucWrData = (alt_u8)(pcTxBuffer[usiCnt]);
			vpxUartModule->xUartTxBufferControl.bWrReq = TRUE;
			usiWrittenChars++;
		} else {
			break;
		}
	}

	return (usiWrittenChars);
}

bool bUartReadCharNonBlocking(char *pcTxChar){
	bool bSuccess = FALSE;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	if (!vpxUartModule->xUartRxBufferStatus.bEmpty) {
		*pcTxChar = (char)(vpxUartModule->xUartRxBufferStatus.ucRdData);
		vpxUartModule->xUartRxBufferControl.bRdReq = TRUE;
		bSuccess = TRUE;
	}

	return (bSuccess);
}

alt_u16 usiUartReadBufferNonBlocking(char *pcRxBuffer, alt_u16 usiLength){
	alt_u16 usiReadChars = 0;
	alt_u16 usiCnt = 0;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	for (usiCnt = 0; usiCnt < usiLength; usiCnt++) {
		if (!vpxUartModule->xUartRxBufferStatus.bEmpty) {
			pcRxBuffer[usiCnt] = (char)(vpxUartModule->xUartRxBufferStatus.ucRdData);
			vpxUartModule->xUartRxBufferControl.bRdReq = TRUE;
			usiReadChars++;
		} else {
			break;
		}
	}

	return (usiReadChars);
}

//! [public functions]

//! [private functions]
//! [private functions]
