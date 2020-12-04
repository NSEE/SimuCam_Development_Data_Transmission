/*
 * spw_controller.h
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#ifndef SPW_CONTROLLER_H_
#define SPW_CONTROLLER_H_

#include <math.h>

#include "../dcom.h"

//! [constants definition]
//! [constants definition]

//! [public module structs definition]
//! [public module structs definition]

//! [public function prototypes]

// Get functions -> get data from hardware to channel variable
// Set functions -> set data from channel variable to hardware

bool bSpwcGetLinkConfig(TSpwcChannel *pxSpwcCh);
bool bSpwcSetLinkConfig(TSpwcChannel *pxSpwcCh);

bool bSpwcGetLinkStatus(TSpwcChannel *pxSpwcCh);

bool bSpwcGetLinkError(TSpwcChannel *pxSpwcCh);

bool bSpwcGetTimecodeControl(TSpwcChannel *pxSpwcCh);
bool bSpwcSetTimecodeControl(TSpwcChannel *pxSpwcCh);

bool bSpwcGetTimecodeStatus(TSpwcChannel *pxSpwcCh);

bool bSpwcSendTimecode(TSpwcChannel *pxSpwcCh);
bool bSpwcReceiveTimecode(TSpwcChannel *pxSpwcCh);

bool bSpwcGetSpwCodecErrInj(TSpwcChannel *pxSpwcCh);
bool bSpwcSetSpwCodecErrInj(TSpwcChannel *pxSpwcCh);

bool bSpwcInitCh(TSpwcChannel *pxSpwcCh, alt_u8 ucDcomCh);

alt_u8 ucSpwcCalculateLinkDiv(alt_8 ucLinkSpeed);
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
