/*
 * uart.h
 *
 *  Created on: 20 de dez de 2019
 *      Author: rfranca
 */

#ifndef UART_H_
#define UART_H_

#include "../../simucam_definitions.h"

//! [constants definition]

#define UART_BASE_ADDR UART_MODULE_TOP_0_BASE

//! [constants definition]

//! [public module structs definition]

/* UART Tx Buffer Control Register Struct */
typedef struct UartTxBufferControl {
	bool bWrReq; /* Tx Buffer Write Requisition */
	alt_u8 ucWrData; /* Tx Buffer Write Data */
} TUartTxBufferControl;

 /* UART Tx Buffer Status Register Struct */
typedef struct UartTxBufferStatus {
	bool bFull; /* Tx Buffer Full */
	alt_u16 usiUsedW; /* Tx Buffer Used Words [Bytes] */
} TUartTxBufferStatus;

 /* UART Rx Buffer Control Register Struct */
typedef struct UartRxBufferControl {
	bool bRdReq; /* Rx Buffer Read Requisition */
} TUartRxBufferControl;

 /* UART Rx Buffer Status Register Struct */
typedef struct UartRxBufferStatus {
	bool bEmpty; /* Rx Buffer Empty */
	alt_u8 ucRdData; /* Rx Buffer Read Data */
	alt_u16 usiUsedW; /* Rx Buffer Used Words [Bytes] */
} TUartRxBufferStatus;

 /* General Struct for Registers Access */
typedef struct UartModule {
	TUartTxBufferControl xUartTxBufferControl;
	TUartTxBufferStatus xUartTxBufferStatus;
	TUartRxBufferControl xUartRxBufferControl;
	TUartRxBufferStatus xUartRxBufferStatus;
} TUartModule;

//! [public module structs definition]

//! [public function prototypes]

bool bUartTxBufferFull();
bool bUartRxBufferEmpty();

void vUartWriteCharBlocking(char cTxChar);
void vUartWriteBufferBlocking(char *pcTxBuffer, alt_u16 usiLength);
char cUartReadCharBlocking();
void vUartReadBufferBlocking(char *pcRxBuffer, alt_u16 usiLength);

bool bUartWriteCharNonBlocking(char cTxChar);
alt_u16 usiUartWriteBufferNonBlocking(char *pcTxBuffer, alt_u16 usiLength);
bool bUartReadCharNonBlocking(char *pcTxChar);
alt_u16 usiUartReadBufferNonBlocking(char *pcRxBuffer, alt_u16 usiLength);

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
