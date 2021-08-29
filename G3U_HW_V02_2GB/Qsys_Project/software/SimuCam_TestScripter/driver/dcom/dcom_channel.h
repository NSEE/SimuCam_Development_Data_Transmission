/*
 * dcom_channel.h
 *
 *  Created on: 10/01/2019
 *      Author: rfranca
 */

#ifndef DCOM_CHANNEL_H_
#define DCOM_CHANNEL_H_

#include "dcom.h"
#include "spw_controller/spw_controller.h"
#include "data_scheduler/data_scheduler.h"
#include "rmap/rmap.h"
#include "report/report.h"

//! [constants definition]
//! [constants definition]

//! [public module structs definition]
//! [public module structs definition]

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
