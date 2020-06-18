/*
 * uart.h
 *
 *  Created on: 20 de dez de 2019
 *      Author: rfranca
 */

#ifndef UART_H_
#define UART_H_

#include "../../simucam_definitions.h"
#include "../../api_drivers/ddr2/ddr2.h"

//! [constants definition]

#define UART_BASE_ADDR UART_MODULE_TOP_0_BASE

#define UART_TX_BUFFER_LENGTH_BYTES     (alt_u16)32768
#define UART_RX_BUFFER_LENGTH_BYTES     (alt_u16)32768
//! [constants definition]

//! [public module structs definition]
/* UART Tx Buffer Control Register Struct */
typedef struct UartTxBufferControl {
	bool bTxWriteReq; /* Tx Buffer Write Requisition */
	alt_u8 ucTxWriteData; /* Tx Buffer Write Data */
} TUartTxBufferControl;

/* UART Tx Buffer Status Register Struct */
typedef struct UartTxBufferStatus {
	bool bTxFull; /* Tx Buffer Full */
	alt_u16 usiTxUsedWords; /* Tx Buffer Used Words [Bytes] */
} TUartTxBufferStatus;

/* UART Rx Buffer Control Register Struct */
typedef struct UartRxBufferControl {
	bool bRxReadReq; /* Rx Buffer Read Requisition */
} TUartRxBufferControl;

/* UART Rx Buffer Status Register Struct */
typedef struct UartRxBufferStatus {
	bool bRxEmpty; /* Rx Buffer Empty */
	alt_u8 ucRxReadData; /* Rx Buffer Read Data */
	alt_u16 usiRxUsedWords; /* Rx Buffer Used Words [Bytes] */
} TUartRxBufferStatus;

/* UART Tx Data Control Register Struct */
typedef struct UartTxDataControl {
	alt_u32 uliTxRdInitAddrHighDword; /* Tx Initial Read Address [High Dword] */
	alt_u32 uliTxRdInitAddrLowDword; /* Tx Initial Read Address [Low Dword] */
	alt_u32 uliTxRdDataLenghtBytes; /* Tx Read Data Length [Bytes] */
	bool bTxRdStart; /* Tx Data Read Start */
	bool bTxRdReset; /* Tx Data Read Reset */
} TUartTxDataControl;

/* UART Tx Data Status Register Struct */
typedef struct UartTxDataStatus {
	bool bTxRdBusy; /* Tx Data Read Busy */
} TUartTxDataStatus;

/* UART Rx Data Control Register Struct */
typedef struct UartRxDataControl {
	alt_u32 uliRxWrInitAddrHighDword; /* Rx Initial Write Address [High Dword] */
	alt_u32 uliRxWrInitAddrLowDword; /* Rx Initial Write Address [Low Dword] */
	alt_u32 uliRxWrDataLenghtBytes; /* Rx Write Data Length [Bytes] */
	bool bRxWrStart; /* Rx Data Write Start */
	bool bRxWrReset; /* Rx Data Write Reset */
} TUartRxDataControl;

/* UART Rx Data Status Register Struct */
typedef struct UartRxDataStatus {
	bool bRxWrBusy; /* Rx Data Write Busy */
} TUartRxDataStatus;

/* General Struct for Registers Access */
typedef struct UartModule {
	TUartTxBufferControl xUartTxBufferControl;
	TUartTxBufferStatus xUartTxBufferStatus;
	TUartRxBufferControl xUartRxBufferControl;
	TUartRxBufferStatus xUartRxBufferStatus;
	TUartTxDataControl xUartTxDataControl;
	TUartTxDataStatus xUartTxDataStatus;
	TUartRxDataControl xUartRxDataControl;
	TUartRxDataStatus xUartRxDataStatus;
} TUartModule;

//! [public module structs definition]

//! [public function prototypes]

bool bUartTxBufferFull(void);
bool bUartRxBufferEmpty(void);

alt_u16 usiUartTxBufferUsedSpace(void);
alt_u16 usiUartTxBufferFreeSpace(void);
alt_u16 usiUartRxBufferUsedSpace(void);
alt_u16 usiUartRxBufferFreeSpace(void);

void vUartWriteCharBlocking(char cTxChar);
void vUartWriteBufferBlocking(char *pcTxBuffer, alt_u16 usiLength);
char cUartReadCharBlocking(void);
void vUartReadBufferBlocking(char *pcRxBuffer, alt_u16 usiLength);

bool bUartWriteCharNonBlocking(char cTxChar);
alt_u16 usiUartWriteBufferNonBlocking(char *pcTxBuffer, alt_u16 usiLength);
bool bUartReadCharNonBlocking(char *pcTxChar);
alt_u16 usiUartReadBufferNonBlocking(char *pcRxBuffer, alt_u16 usiLength);

bool bUartFlushRxBuffer(alt_u16 usiWordsToFlush); /* Flush usiWordsToFlush words from Rx Buffer, stops when first Rx Buffer empty occurs. 0 = flush all */

bool bUartDmaTxReset(bool bWait);
bool bUartDmaTxBusy(void);
bool bUartDmaTxTransfer(alt_u8 ucDdrMemId, alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBytes);

bool bUartDmaRxReset(bool bWait);
bool bUartDmaRxBusy(void);
bool bUartDmaRxTransfer(alt_u8 ucDdrMemId, alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBytes);

//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* UART_H_ */
