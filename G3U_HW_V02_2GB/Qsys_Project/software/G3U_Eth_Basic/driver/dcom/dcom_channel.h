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

//! [constants definition]
//! [constants definition]

//! [public module structs definition]
//! [public module structs definition]

extern TDcomChannel xCh[8];

//! [public function prototypes]
bool bDcomSetGlobalIrqEn(bool bGlobalIrqEnable, alt_u8 ucDcomCh);

bool bDcomInitCh(TDcomChannel *pxDcomCh, alt_u8 ucDcomCh);

//! [public function prototypes]

INT8U set_spw_linkspeed(TDcomChannel *x_channel, INT8U i_linkspeed_code);

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* DCOM_CHANNEL_H_ */
