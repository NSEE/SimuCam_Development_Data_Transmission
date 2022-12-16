/*
 * rmap.h
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#ifndef RMAP_H_
#define RMAP_H_

#include "../dcom.h"

//! [constants definition]

enum RmapRmapErrId {
	eRmapRmapErrIdInitLogAddr     = 0u,  /* RMAP Error Injection Error ID for Initiator Logical Address */
	eRmapRmapErrIdInstructions    = 1u,  /* RMAP Error Injection Error ID for Instructions Field */
	eRmapRmapErrIdInsPktType      = 2u,  /* RMAP Error Injection Error ID for Packet Type Instruction */
	eRmapRmapErrIdInsCmdWriteRead = 3u,  /* RMAP Error Injection Error ID for Write/Read Instruction Command */
	eRmapRmapErrIdInsCmdVerifData = 4u,  /* RMAP Error Injection Error ID for Verify Data Before Reply Instruction Command */
	eRmapRmapErrIdInsCmdReply     = 5u,  /* RMAP Error Injection Error ID for Reply Instruction Command */
	eRmapRmapErrIdInsCmdIncAddr   = 6u,  /* RMAP Error Injection Error ID for Increment Address Instruction Command */
	eRmapRmapErrIdInsReplyAddrLen = 7u,  /* RMAP Error Injection Error ID for Reply Address Length Instruction */
	eRmapRmapErrIdStatus          = 8u,  /* RMAP Error Injection Error ID for Status */
	eRmapRmapErrIdTargLogAddr     = 9u,  /* RMAP Error Injection Error ID for Target Logical Address */
	eRmapRmapErrIdTransactionId   = 10u, /* RMAP Error Injection Error ID for Transaction Identifier */
	eRmapRmapErrIdDataLength      = 11u, /* RMAP Error Injection Error ID for Data Length */
	eRmapRmapErrIdHeaderCrc       = 12u, /* RMAP Error Injection Error ID for Header CRC */
	eRmapRmapErrIdHeaderEep       = 13u, /* RMAP Error Injection Error ID for Header EEP */
	eRmapRmapErrIdDataCrc         = 14u, /* RMAP Error Injection Error ID for Data CRC */
	eRmapRmapErrIdDataEep         = 15u, /* RMAP Error Injection Error ID for Data EEP */
	eRmapRmapErrIdMissingResponse = 16u, /* RMAP Error Injection Error ID for Missing Response */
	eRmapRmapErrMaxIndex
} RmapRmapErrId;

//! [constants definition]

//! [public module structs definition]
//! [public module structs definition]

//! [public function prototypes]

// Get functions -> get data from hardware to channel variable
// Set functions -> set data from channel variable to hardware

bool bRmapGetCodecConfig(TRmapChannel *pxRmapCh);
bool bRmapSetCodecConfig(TRmapChannel *pxRmapCh);

bool bRmapGetCodecStatus(TRmapChannel *pxRmapCh);

bool bRmapGetCodecError(TRmapChannel *pxRmapCh);

bool bRmapGetRmapErrInj(TRmapChannel *pxRmapCh);
bool bRmapSetRmapErrInj(TRmapChannel *pxRmapCh);
bool bRmapRstRmapErrInj(TRmapChannel *pxRmapCh);
bool bRmapInjRmapErrInj(TRmapChannel *pxRmapCh, alt_u8 ucErrorId, alt_u32 uliValue, alt_u16 usiRepeats);

bool bRmapGetMemAreaConfig(TRmapChannel *pxRmapCh);
bool bRmapSetMemAreaConfig(TRmapChannel *pxRmapCh);

bool bRmapGetRmapMemArea(TRmapChannel *pxRmapCh);
bool bRmapSetRmapMemArea(TRmapChannel *pxRmapCh);

bool bRmapGetEchoingMode(TRmapChannel *pxRmapCh);
bool bRmapSetEchoingMode(TRmapChannel *pxRmapCh);

bool bRmapClearMemArea(TRmapChannel *pxRmapCh);

void vRmapResetEchoingModule(alt_u32 uliWaitTimeUs);

bool bRmapInitCh(TRmapChannel *pxRmapCh, alt_u8 ucDcomCh);

//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* RMAP_H_ */
