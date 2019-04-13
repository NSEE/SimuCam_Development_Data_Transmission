/*
 * data_scheduler.h
 *
 *  Created on: 01/04/2019
 *      Author: rfranca
 */

#ifndef DATA_SCHEDULER_H_
#define DATA_SCHEDULER_H_

#include "../dcom.h"

//! [constants definition]
//! [constants definition]

//! [public module structs definition]
typedef struct DschTimerConfig {
	bool bStartOnSync;
	alt_u32 uliTimerDiv;
} TDschTimerConfig;

typedef struct DschTimerStatus {
	bool bStopped;
	bool bStarted;
	bool bRunning;
	bool bCleared;
} TDschTimerStatus;

typedef struct DschChannel {
	alt_u32 *puliDschChAddr;
	TDschTimerConfig xTimerConfig;
	TDschTimerStatus xTimerStatus;
} TDschChannel;
//! [public module structs definition]

//! [public function prototypes]
// Set functions -> set data from channel variable to hardware
// Get functions -> get data from hardware to channel variable

bool bDschSetTimerConfig(TDschChannel *pxDschCh);
bool bDschGetTimerConfig(TDschChannel *pxDschCh);

bool bDschGetTimerStatus(TDschChannel *pxDschCh);

bool bDschSetTime(TDschChannel *pxDschCh, alt_u32 uliTime);
alt_u32 uliDschGetTime(TDschChannel *pxDschCh);

bool bDschStartTimer(TDschChannel *pxDschCh);
bool bDschRunTimer(TDschChannel *pxDschCh);
bool bDschStopTimer(TDschChannel *pxDschCh);
bool bDschClrTimer(TDschChannel *pxDschCh);

bool bDschInitCh(TDschChannel *pxDschCh, alt_u8 ucDcomCh);
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* DATA_SCHEDULER_H_ */
