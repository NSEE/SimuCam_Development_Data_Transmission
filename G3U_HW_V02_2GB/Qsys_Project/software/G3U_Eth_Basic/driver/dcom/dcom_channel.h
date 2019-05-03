/*
 * dcom_channel.h
 *
 *  Created on: 31/03/2019
 *      Author: rfranca
 */

#ifndef DCOM_CHANNEL_H_
#define DCOM_CHANNEL_H_

#include "dcom.h"
#include "data_buffers/data_buffers.h"
#include "data_controller/data_controller.h"
#include "data_scheduler/data_scheduler.h"
#include "spw_controller/spw_controller.h"

//! [constants definition]
// address
// bit masks
//! [constants definition]

//! [public module structs definition]
typedef struct DcomChannel {
	alt_u32 *puliCommChAddr;
	TDatbChannel xDataBuffer;
	TDschChannel xDataScheduler;
	TDctrChannel xDataController;
	TSpwcChannel xSpacewire;
} TDcomChannel;
//! [public module structs definition]

extern TDcomChannel xCh[8];

//! [public function prototypes]
bool bDcomSetGlobalIrqEn(bool bGlobalIrqEnable, alt_u8 ucDcomCh);

bool bDcomInitCh(TDcomChannel *pxDcomCh, alt_u8 ucDcomCh);
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* DCOM_CHANNEL_H_ */
