/*
 * data_buffers.h
 *
 *  Created on: 31/03/2019
 *      Author: rfranca
 */

#ifndef DATA_BUFFERS_H_
#define DATA_BUFFERS_H_

#include "../dcom.h"

//! [constants definition]
const alt_u16 cuiDataBufferSize = 0;
//! [constants definition]

//! [public module structs definition]
typedef struct DatbBufferStatus {
	bool bDataBufferFull;
	bool bDataBufferEmpty;
	alt_u16 uiDataBufferUsed;
	alt_u16 uiDataBufferFree;
} TDatbBufferStatus;

typedef struct DatbChannel {
	alt_u32 *puliDatbChAddr;
	TDatbBufferStatus xBufferStatus;
} TDatbChannel;
//! [public module structs definition]

//! [public function prototypes]
// Set functions -> set data from channel variable to hardware
// Get functions -> get data from hardware to channel variable

bool bDatbGetBuffersStatus(TDatbChannel *pxDatbCh);

bool bDatbInitCh(TDatbChannel *pxDatbCh, alt_u8 ucDcomCh);
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* DATA_BUFFERS_H_ */
