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

bool bUartTxBufferFull(void){
	bool bFull;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	bFull = vpxUartModule->xUartTxBufferStatus.bTxFull;

	return (bFull);
}

bool bUartRxBufferEmpty(void){
	bool bEmpty;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	bEmpty = vpxUartModule->xUartRxBufferStatus.bRxEmpty;

	return (bEmpty);
}

alt_u16 usiUartTxBufferUsedSpace(void){
	alt_u16 usiUsedSpace = 0;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	if (vpxUartModule->xUartTxBufferStatus.bTxFull) {
		usiUsedSpace = UART_TX_BUFFER_LENGTH_BYTES;
	} else {
		usiUsedSpace = vpxUartModule->xUartTxBufferStatus.usiTxUsedWords;
	}

	return (usiUsedSpace);
}

alt_u16 usiUartTxBufferFreeSpace(void){
	alt_u16 usiFreeSpace = 0;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	if (vpxUartModule->xUartTxBufferStatus.bTxFull) {
		usiFreeSpace = 0;
	} else {
		usiFreeSpace = UART_TX_BUFFER_LENGTH_BYTES - vpxUartModule->xUartTxBufferStatus.usiTxUsedWords;
	}

	return (usiFreeSpace);
}

alt_u16 usiUartRxBufferUsedSpace(void){
	alt_u16 usiUsedSpace = 0;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	usiUsedSpace = vpxUartModule->xUartRxBufferStatus.usiRxUsedWords;
	if ((0 == usiUsedSpace) && (!vpxUartModule->xUartRxBufferStatus.bRxEmpty)) {
		usiUsedSpace = UART_RX_BUFFER_LENGTH_BYTES;
	}

	return (usiUsedSpace);
}

alt_u16 usiUartRxBufferFreeSpace(void){
	alt_u16 usiFreeSpace = 0;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	usiFreeSpace = UART_RX_BUFFER_LENGTH_BYTES - vpxUartModule->xUartRxBufferStatus.usiRxUsedWords;
	if ((UART_RX_BUFFER_LENGTH_BYTES == usiFreeSpace) && (!vpxUartModule->xUartRxBufferStatus.bRxEmpty)) {
		usiFreeSpace = 0;
	}

	return (usiFreeSpace);
}

void vUartWriteCharBlocking(char cTxChar){

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	while (vpxUartModule->xUartTxBufferStatus.bTxFull){}
	vpxUartModule->xUartTxBufferControl.ucTxWriteData = (alt_u8)cTxChar;
	vpxUartModule->xUartTxBufferControl.bTxWriteReq = TRUE;

}

void vUartWriteBufferBlocking(char *pcTxBuffer, alt_u16 usiLength){
	alt_u16 usiCnt = 0;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	for (usiCnt = 0; usiCnt < usiLength; usiCnt++) {
		while (vpxUartModule->xUartTxBufferStatus.bTxFull){}
		vpxUartModule->xUartTxBufferControl.ucTxWriteData = (alt_u8)(pcTxBuffer[usiCnt]);
		vpxUartModule->xUartTxBufferControl.bTxWriteReq = TRUE;
	}

}

char cUartReadCharBlocking(void){
	char cRxChar;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	while (vpxUartModule->xUartRxBufferStatus.bRxEmpty){}
	cRxChar = (char)(vpxUartModule->xUartRxBufferStatus.ucRxReadData);
	vpxUartModule->xUartRxBufferControl.bRxReadReq = TRUE;

	return (cRxChar);
}

void vUartReadBufferBlocking(char *pcRxBuffer, alt_u16 usiLength){
	alt_u16 usiCnt = 0;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	for (usiCnt = 0; usiCnt < usiLength; usiCnt++) {
		while (vpxUartModule->xUartRxBufferStatus.bRxEmpty){}
		pcRxBuffer[usiCnt] = (char)(vpxUartModule->xUartRxBufferStatus.ucRxReadData);
		vpxUartModule->xUartRxBufferControl.bRxReadReq = TRUE;
	}

}

bool bUartWriteCharNonBlocking(char cTxChar){
	bool bSuccess = FALSE;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	if (!vpxUartModule->xUartTxBufferStatus.bTxFull) {
		vpxUartModule->xUartTxBufferControl.ucTxWriteData = (alt_u8)cTxChar;
		vpxUartModule->xUartTxBufferControl.bTxWriteReq = TRUE;
		bSuccess = TRUE;
	}

	return (bSuccess);
}

alt_u16 usiUartWriteBufferNonBlocking(char *pcTxBuffer, alt_u16 usiLength){
	alt_u16 usiWrittenChars = 0;
	alt_u16 usiCnt = 0;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	for (usiCnt = 0; usiCnt < usiLength; usiCnt++) {
		if (!vpxUartModule->xUartTxBufferStatus.bTxFull) {
			vpxUartModule->xUartTxBufferControl.ucTxWriteData = (alt_u8)(pcTxBuffer[usiCnt]);
			vpxUartModule->xUartTxBufferControl.bTxWriteReq = TRUE;
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

	if (!vpxUartModule->xUartRxBufferStatus.bRxEmpty) {
		*pcTxChar = (char)(vpxUartModule->xUartRxBufferStatus.ucRxReadData);
		vpxUartModule->xUartRxBufferControl.bRxReadReq = TRUE;
		bSuccess = TRUE;
	}

	return (bSuccess);
}

alt_u16 usiUartReadBufferNonBlocking(char *pcRxBuffer, alt_u16 usiLength){
	alt_u16 usiReadChars = 0;
	alt_u16 usiCnt = 0;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	for (usiCnt = 0; usiCnt < usiLength; usiCnt++) {
		if (!vpxUartModule->xUartRxBufferStatus.bRxEmpty) {
			pcRxBuffer[usiCnt] = (char)(vpxUartModule->xUartRxBufferStatus.ucRxReadData);
			vpxUartModule->xUartRxBufferControl.bRxReadReq = TRUE;
			usiReadChars++;
		} else {
			break;
		}
	}

	return (usiReadChars);
}

bool bUartFlushRxBuffer(alt_u16 usiWordsToFlush){
	bool bStatus   = FALSE;

	alt_u16 usiWordsCnt = 0;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	while (!vpxUartModule->xUartRxBufferStatus.bRxEmpty) {
		vpxUartModule->xUartRxBufferControl.bRxReadReq = TRUE;
		usiWordsCnt++;
		if (usiWordsToFlush == usiWordsCnt) {
			break;
		}
	}
	bStatus = TRUE;

	return (bStatus);
}

bool bUartDmaTxReset(bool bWait){
	bool bStatus   = FALSE;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	vpxUartModule->xUartTxDataControl.bTxRdReset = TRUE;
	if (bWait) {
		// wait for the avm controller to be free
		while (vpxUartModule->xUartTxDataStatus.bTxRdBusy) {
			alt_busy_sleep(1); /* delay 1us */
		}
	}
	bStatus = TRUE;

	return (bStatus);
}

bool bUartDmaTxBusy(void){
	bool bBusy;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	bBusy = vpxUartModule->xUartTxDataStatus.bTxRdBusy;

	return (bBusy);
}

bool bUartDmaTxTransfer(alt_u8 ucDdrMemId, alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBytes){
	bool bStatus = FALSE;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	union Ddr2MemoryAddress unMemoryAddress;

	bool bMemoryFlag = FALSE;
	bool bNotBusyFlag = FALSE;

	alt_u32 uliRoundedTransferSizeInBytes = 0;

	switch (ucDdrMemId) {
		case eDdr2Memory1:
			unMemoryAddress.ulliMemAddr64b = DDR2_M1_BASE_ADDR + (alt_u64)((alt_u32)uliDdrInitialAddr);
			bMemoryFlag = TRUE;
			break;
		case eDdr2Memory2:
			unMemoryAddress.ulliMemAddr64b = DDR2_M2_BASE_ADDR + (alt_u64)((alt_u32)uliDdrInitialAddr);
			bMemoryFlag = TRUE;
			break;
		default:
			bMemoryFlag = FALSE;
			break;
	}

	if (!vpxUartModule->xUartTxDataStatus.bTxRdBusy) {
		bNotBusyFlag = TRUE;
	}

	/* Need to adjust the transfer size because of hardware implementation */
	uliRoundedTransferSizeInBytes = uliTransferSizeInBytes - 1;

	if ((bMemoryFlag) && (bNotBusyFlag)) {

		// reset the avm controller
		bUartDmaTxReset(TRUE);

		// start new transfer
		vpxUartModule->xUartTxDataControl.uliTxRdInitAddrLowDword = unMemoryAddress.uliMemAddr32b[0];
		vpxUartModule->xUartTxDataControl.uliTxRdInitAddrHighDword = unMemoryAddress.uliMemAddr32b[1];
		vpxUartModule->xUartTxDataControl.uliTxRdDataLenghtBytes = uliRoundedTransferSizeInBytes;
		vpxUartModule->xUartTxDataControl.bTxRdStart = TRUE;
		bStatus = TRUE;

	}
	return bStatus;
}

bool bUartDmaRxReset(bool bWait){
	bool bStatus   = FALSE;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	vpxUartModule->xUartRxDataControl.bRxWrReset = TRUE;
	if (bWait) {
		// wait for the avm controller to be free
		while (vpxUartModule->xUartRxDataStatus.bRxWrBusy) {
			alt_busy_sleep(1); /* delay 1us */
		}
	}
	bStatus = TRUE;

	return (bStatus);
}

bool bUartDmaRxBusy(void){
	bool bBusy;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	bBusy = vpxUartModule->xUartRxDataStatus.bRxWrBusy;

	return (bBusy);
}

bool bUartDmaRxTransfer(alt_u8 ucDdrMemId, alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBytes){
	bool bStatus = FALSE;

	volatile TUartModule *vpxUartModule = (TUartModule *)UART_BASE_ADDR;

	union Ddr2MemoryAddress unMemoryAddress;

	bool bMemoryFlag = FALSE;
	bool bNotBusyFlag = FALSE;

	alt_u32 uliRoundedTransferSizeInBytes = 0;

	switch (ucDdrMemId) {
		case eDdr2Memory1:
			unMemoryAddress.ulliMemAddr64b = DDR2_M1_BASE_ADDR + (alt_u64)((alt_u32)uliDdrInitialAddr);
			bMemoryFlag = TRUE;
			break;
		case eDdr2Memory2:
			unMemoryAddress.ulliMemAddr64b = DDR2_M2_BASE_ADDR + (alt_u64)((alt_u32)uliDdrInitialAddr);
			bMemoryFlag = TRUE;
			break;
		default:
			bMemoryFlag = FALSE;
			break;
	}

	if (!vpxUartModule->xUartRxDataStatus.bRxWrBusy) {
		bNotBusyFlag = TRUE;
	}

	/* Need to adjust the transfer size because of hardware implementation */
	uliRoundedTransferSizeInBytes = uliTransferSizeInBytes - 1;

	if ((bMemoryFlag) && (bNotBusyFlag)) {

		// reset the avm controller
		bUartDmaRxReset(TRUE);

		// start new transfer
		vpxUartModule->xUartRxDataControl.uliRxWrInitAddrLowDword = unMemoryAddress.uliMemAddr32b[0];
		vpxUartModule->xUartRxDataControl.uliRxWrInitAddrHighDword = unMemoryAddress.uliMemAddr32b[1];
		vpxUartModule->xUartRxDataControl.uliRxWrDataLenghtBytes = uliRoundedTransferSizeInBytes;
		vpxUartModule->xUartRxDataControl.bRxWrStart = TRUE;
		bStatus = TRUE;

	}
	return bStatus;
}

//! [public functions]

//! [private functions]
//! [private functions]
