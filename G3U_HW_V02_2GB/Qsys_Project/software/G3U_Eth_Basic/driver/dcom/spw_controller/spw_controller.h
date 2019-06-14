/*
 * spw_controller.h
 *
 *  Created on: 01/04/2019
 *      Author: rfranca
 */

#ifndef SPW_CONTROLLER_H_
#define SPW_CONTROLLER_H_


#include "../dcom.h"

//! [constants definition]
//! [constants definition]

//! [public module structs definition]
typedef struct SpwcLinkConfig {
	bool bAutostart;
	bool bLinkStart;
	bool bDisconnect;
	alt_u8 ucTxDivCnt;
} TSpwcLinkConfig;

typedef struct SpwcLinkError {
	bool bDisconnect;
	bool bParity;
	bool bEscape;
	bool bCredit;
} TSpwcLinkError;

typedef struct SpwcLinkStatus {
	bool bStarted;
	bool bConnecting;
	bool bRunning;
} TSpwcLinkStatus;

typedef struct SpwcRxTimecode {
	alt_u8 ucCounter;
	alt_u8 ucControl;
	bool bReceived;
} TSpwcRxTimecode;

typedef struct SpwcTxTimecode {
	alt_u8 ucCounter;
	alt_u8 ucControl;
	bool bTransmit;
} TSpwcTxTimecode;

typedef struct SpwcChannel {
	alt_u32 *puliSpwcChAddr;
	TSpwcLinkConfig xLinkConfig;
	TSpwcLinkError xLinkError;
	TSpwcLinkStatus xLinkStatus;
	TSpwcRxTimecode xRxTimecode;
	TSpwcTxTimecode xTxTimecode;
} TSpwcChannel;
//! [public module structs definition]

//! [public function prototypes]
// Set functions -> set data from channel variable to hardware
// Get functions -> get data from hardware to channel variable

bool bSpwcSetLink(TSpwcChannel *pxSpwcCh);
bool bSpwcGetLink(TSpwcChannel *pxSpwcCh);

bool bSpwcGetLinkError(TSpwcChannel *pxSpwcCh);

bool bSpwcGetLinkStatus(TSpwcChannel *pxSpwcCh);

bool bSpwcSetTxTimecode(TSpwcChannel *pxSpwcCh);
bool bSpwcGetTxTimecode(TSpwcChannel *pxSpwcCh);

bool bSpwcGetRxTimecode(TSpwcChannel *pxSpwcCh);

bool bSpwcInitCh(TSpwcChannel *pxSpwcCh, alt_u8 ucDcomCh);
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]


#endif /* SPW_CONTROLLER_H_ */
