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

enum SpwcChHMuxSelId {
	eSpwcChHMuxSelIdDcom = 0u, /* SpaceWire Channel H Mux Select ID for DCOM Channel */
	eSpwcChHMuxSelIdRmpe = 1u, /* SpaceWire Channel H Mux Select ID for Rmap Echoing */
	eSpwcChHMuxSelIdNone = 2u  /* SpaceWire Channel H Mux Select ID for None Selected */
} SpwcChHMuxSelId;

enum SpwcSpwCodecErrId {
	eSpwcSpwCodecErrIdNone        = 0u,  /* SpaceWire Codec Error Injection Error ID for No Error */
	eSpwcSpwCodecErrIdDiscon      = 1u,  /* SpaceWire Codec Error Injection Error ID for Disconnection Error */
	eSpwcSpwCodecErrIdParity      = 2u,  /* SpaceWire Codec Error Injection Error ID for Parity Error */
	eSpwcSpwCodecErrIdEscape      = 3u,  /* SpaceWire Codec Error Injection Error ID for Escape (ESC+ESC) Error */
	eSpwcSpwCodecErrIdCredit      = 4u,  /* SpaceWire Codec Error Injection Error ID for Credit Error */
	eSpwcSpwCodecErrIdChar        = 5u,  /* SpaceWire Codec Error Injection Error ID for Char Error */
} SpwcSpwCodecErrId;

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

bool bSpwcChHMuxSelect(alt_u32 uliMuxSelect);

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
