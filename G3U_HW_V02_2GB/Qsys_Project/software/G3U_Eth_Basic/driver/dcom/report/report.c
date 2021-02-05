/*
 * report.c
 *
 *  Created on: 2 de fev de 2021
 *      Author: rfranca
 */

#include "report.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
// A variable to hold the context of interrupt
static volatile int viCh1HoldContext;
static volatile int viCh2HoldContext;
static volatile int viCh3HoldContext;
static volatile int viCh4HoldContext;
static volatile int viCh5HoldContext;
static volatile int viCh6HoldContext;
static volatile int viCh7HoldContext;
static volatile int viCh8HoldContext;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]

void vRprtCh1IrqHandler(void* pvContext) {
	/* Cast context to hold_context's type. It is important that this be
	 * declared volatile to avoid unwanted compiler optimization.
	 * volatile int* pviHoldContext = (volatile int*) pvContext;
	 * Use context value according to your app logic...
	 * *pviHoldContext = ...;
	 * if (*pviHoldContext == '0') {}...
	 * App logic sequence...
	 */
	
	INT8U usi_link_nb = 0;

	 volatile TDcomChannel *vpxDcomChannel = (TDcomChannel *) (DCOM_CH_1_BASE_ADDR);

	/* SpW Link Connected Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwLinkConnectedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwLinkConnectedFlagClr = TRUE;

		/* SpW Link Connected Flag Treatment */
		v_p_event_creator(eidSpwConn+usi_link_nb);
	}

	/* SpW Link Disconnected Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwLinkDisconnectedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwLinkDisconnectedFlagClr = TRUE;

		/* SpW Link Disconnected Flag Treatment */
		v_p_event_creator(eidSpwDis+usi_link_nb);
	}

	/* SpW Error Disconnect Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrDisconnectFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrDisconnectFlagClr = TRUE;

		/* SpW Error Disconnect Flag Treatment */
		v_error_event_creator(eidErrDisc, usi_link_nb);
	}

	/* SpW Error Parity Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrParityFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrParityFlagClr = TRUE;

		/* SpW Error Parity Flag Treatment */
		v_error_event_creator(eidErrPar, usi_link_nb);
	}

	/* SpW Error Escape Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrEscapeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrEscapeFlagClr = TRUE;

		/* SpW Error Escape Flag Treatment */
		v_error_event_creator(eidErrEsc, usi_link_nb);
	}

	/* SpW Error Credit Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrCreditFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrCreditFlagClr = TRUE;

		/* SpW Error Credit Flag Treatment */
		v_error_event_creator(eidErrCred, usi_link_nb);
	}

	/* Rx Timecode Received Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRxTimecodeReceivedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRxTimecodeReceivedFlagClr = TRUE;

		/* Rx Timecode Received Flag Treatment */
		v_p_event_timecode_creator(vpxDcomChannel->xSpacewire.xSpwcTimecodeStatus.ucRxTime, usi_link_nb);
	}

	/* Rmap Error Early EOP Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrEarlyEopFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrEarlyEopFlagClr = TRUE;

		/* Rmap Error Early EOP Flag Treatment */
		v_error_event_creator(eidErrEOP, usi_link_nb);
	}

	/* Rmap Error EEP Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrEepFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrEepFlagClr = TRUE;

		/* Rmap Error EEP Flag Treatment */
		v_error_event_creator(eidErrEEP, usi_link_nb);
	}

	/* Rmap Error Header CRC Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrHeaderCrcFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrHeaderCrcFlagClr = TRUE;

		/* Rmap Error Header CRC Flag Treatment */
		v_error_event_creator(eidErrEEP, usi_link_nb);
	}

	/* Rmap Error Unused Packet Type Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrUnusedPacketTypeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrUnusedPacketTypeFlagClr = TRUE;

		/* Rmap Error Unused Packet Type Flag Treatment */
		v_error_event_creator(eidErrUnPack, usi_link_nb);
	}

	/* Rmap Error Invalid Command Code Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrInvalidCommandCodeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrInvalidCommandCodeFlagClr = TRUE;

		/* Rmap Error Invalid Command Code Flag Treatment */
		v_error_event_creator(eidErrInvCmd, usi_link_nb);
	}

	/* Rmap Error Too Much Data Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrTooMuchDataFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrTooMuchDataFlagClr = TRUE;

		/* Rmap Error Too Much Data Flag Treatment */
		v_error_event_creator(eidErrTData, usi_link_nb);
	}

	/* Rmap Error Invalid Data Crc Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrInvalidDataCrcFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrInvalidDataCrcFlagClr = TRUE;

		/* Rmap Error Invalid Data Crc Flag Treatment */
		v_error_event_creator(eidErrInvCRC, usi_link_nb);
	}

}

void vRprtCh2IrqHandler(void* pvContext) {
	/* Cast context to hold_context's type. It is important that this be
	 * declared volatile to avoid unwanted compiler optimization.
	 * volatile int* pviHoldContext = (volatile int*) pvContext;
	 * Use context value according to your app logic...
	 * *pviHoldContext = ...;
	 * if (*pviHoldContext == '0') {}...
	 * App logic sequence...
	 */

	INT8U usi_link_nb = 1;
	 volatile TDcomChannel *vpxDcomChannel = (TDcomChannel *) (DCOM_CH_2_BASE_ADDR);

	/* SpW Link Connected Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwLinkConnectedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwLinkConnectedFlagClr = TRUE;

		/* SpW Link Connected Flag Treatment */
		v_p_event_creator(eidSpwConn+usi_link_nb);
	}

	/* SpW Link Disconnected Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwLinkDisconnectedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwLinkDisconnectedFlagClr = TRUE;

		/* SpW Link Disconnected Flag Treatment */
		v_p_event_creator(eidSpwDis+usi_link_nb);
	}

	/* SpW Error Disconnect Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrDisconnectFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrDisconnectFlagClr = TRUE;

		/* SpW Error Disconnect Flag Treatment */
		v_error_event_creator(eidErrDisc, usi_link_nb);
	}

	/* SpW Error Parity Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrParityFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrParityFlagClr = TRUE;

		/* SpW Error Parity Flag Treatment */
		v_error_event_creator(eidErrPar, usi_link_nb);
	}

	/* SpW Error Escape Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrEscapeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrEscapeFlagClr = TRUE;

		/* SpW Error Escape Flag Treatment */
		v_error_event_creator(eidErrEsc, usi_link_nb);
	}

	/* SpW Error Credit Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrCreditFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrCreditFlagClr = TRUE;

		/* SpW Error Credit Flag Treatment */
		v_error_event_creator(eidErrCred, usi_link_nb);
	}

	/* Rx Timecode Received Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRxTimecodeReceivedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRxTimecodeReceivedFlagClr = TRUE;

		/* Rx Timecode Received Flag Treatment */
		v_p_event_timecode_creator(vpxDcomChannel->xSpacewire.xSpwcTimecodeStatus.ucRxTime, usi_link_nb);
	}

	/* Rmap Error Early EOP Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrEarlyEopFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrEarlyEopFlagClr = TRUE;

		/* Rmap Error Early EOP Flag Treatment */
		v_error_event_creator(eidErrEOP, usi_link_nb);
	}

	/* Rmap Error EEP Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrEepFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrEepFlagClr = TRUE;

		/* Rmap Error EEP Flag Treatment */
		v_error_event_creator(eidErrEEP, usi_link_nb);
	}

	/* Rmap Error Header CRC Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrHeaderCrcFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrHeaderCrcFlagClr = TRUE;

		/* Rmap Error Header CRC Flag Treatment */
		v_error_event_creator(eidErrEEP, usi_link_nb);
	}

	/* Rmap Error Unused Packet Type Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrUnusedPacketTypeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrUnusedPacketTypeFlagClr = TRUE;

		/* Rmap Error Unused Packet Type Flag Treatment */
		v_error_event_creator(eidErrUnPack, usi_link_nb);
	}

	/* Rmap Error Invalid Command Code Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrInvalidCommandCodeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrInvalidCommandCodeFlagClr = TRUE;

		/* Rmap Error Invalid Command Code Flag Treatment */
		v_error_event_creator(eidErrInvCmd, usi_link_nb);
	}

	/* Rmap Error Too Much Data Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrTooMuchDataFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrTooMuchDataFlagClr = TRUE;

		/* Rmap Error Too Much Data Flag Treatment */
		v_error_event_creator(eidErrTData, usi_link_nb);
	}

	/* Rmap Error Invalid Data Crc Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrInvalidDataCrcFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrInvalidDataCrcFlagClr = TRUE;

		/* Rmap Error Invalid Data Crc Flag Treatment */
		v_error_event_creator(eidErrInvCRC, usi_link_nb);
	}

}

void vRprtCh3IrqHandler(void* pvContext) {
	/* Cast context to hold_context's type. It is important that this be
	 * declared volatile to avoid unwanted compiler optimization.
	 * volatile int* pviHoldContext = (volatile int*) pvContext;
	 * Use context value according to your app logic...
	 * *pviHoldContext = ...;
	 * if (*pviHoldContext == '0') {}...
	 * App logic sequence...
	 */

INT8U usi_link_nb = 2;
	 volatile TDcomChannel *vpxDcomChannel = (TDcomChannel *) (DCOM_CH_3_BASE_ADDR);

	/* SpW Link Connected Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwLinkConnectedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwLinkConnectedFlagClr = TRUE;

		/* SpW Link Connected Flag Treatment */
		v_p_event_creator(eidSpwConn+usi_link_nb);
	}

	/* SpW Link Disconnected Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwLinkDisconnectedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwLinkDisconnectedFlagClr = TRUE;

		/* SpW Link Disconnected Flag Treatment */
		v_p_event_creator(eidSpwDis+usi_link_nb);
	}

	/* SpW Error Disconnect Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrDisconnectFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrDisconnectFlagClr = TRUE;

		/* SpW Error Disconnect Flag Treatment */
		v_error_event_creator(eidErrDisc, usi_link_nb);
	}

	/* SpW Error Parity Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrParityFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrParityFlagClr = TRUE;

		/* SpW Error Parity Flag Treatment */
		v_error_event_creator(eidErrPar, usi_link_nb);
	}

	/* SpW Error Escape Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrEscapeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrEscapeFlagClr = TRUE;

		/* SpW Error Escape Flag Treatment */
		v_error_event_creator(eidErrEsc, usi_link_nb);
	}

	/* SpW Error Credit Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrCreditFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrCreditFlagClr = TRUE;

		/* SpW Error Credit Flag Treatment */
		v_error_event_creator(eidErrCred, usi_link_nb);
	}

	/* Rx Timecode Received Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRxTimecodeReceivedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRxTimecodeReceivedFlagClr = TRUE;

		/* Rx Timecode Received Flag Treatment */
		v_p_event_timecode_creator(vpxDcomChannel->xSpacewire.xSpwcTimecodeStatus.ucRxTime, usi_link_nb);
	}

	/* Rmap Error Early EOP Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrEarlyEopFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrEarlyEopFlagClr = TRUE;

		/* Rmap Error Early EOP Flag Treatment */
		v_error_event_creator(eidErrEOP, usi_link_nb);
	}

	/* Rmap Error EEP Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrEepFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrEepFlagClr = TRUE;

		/* Rmap Error EEP Flag Treatment */
		v_error_event_creator(eidErrEEP, usi_link_nb);
	}

	/* Rmap Error Header CRC Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrHeaderCrcFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrHeaderCrcFlagClr = TRUE;

		/* Rmap Error Header CRC Flag Treatment */
		v_error_event_creator(eidErrEEP, usi_link_nb);
	}

	/* Rmap Error Unused Packet Type Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrUnusedPacketTypeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrUnusedPacketTypeFlagClr = TRUE;

		/* Rmap Error Unused Packet Type Flag Treatment */
		v_error_event_creator(eidErrUnPack, usi_link_nb);
	}

	/* Rmap Error Invalid Command Code Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrInvalidCommandCodeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrInvalidCommandCodeFlagClr = TRUE;

		/* Rmap Error Invalid Command Code Flag Treatment */
		v_error_event_creator(eidErrInvCmd, usi_link_nb);
	}

	/* Rmap Error Too Much Data Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrTooMuchDataFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrTooMuchDataFlagClr = TRUE;

		/* Rmap Error Too Much Data Flag Treatment */
		v_error_event_creator(eidErrTData, usi_link_nb);
	}

	/* Rmap Error Invalid Data Crc Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrInvalidDataCrcFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrInvalidDataCrcFlagClr = TRUE;

		/* Rmap Error Invalid Data Crc Flag Treatment */
		v_error_event_creator(eidErrInvCRC, usi_link_nb);
	}

}

void vRprtCh4IrqHandler(void* pvContext) {
	/* Cast context to hold_context's type. It is important that this be
	 * declared volatile to avoid unwanted compiler optimization.
	 * volatile int* pviHoldContext = (volatile int*) pvContext;
	 * Use context value according to your app logic...
	 * *pviHoldContext = ...;
	 * if (*pviHoldContext == '0') {}...
	 * App logic sequence...
	 */

INT8U usi_link_nb = 3;
	 volatile TDcomChannel *vpxDcomChannel = (TDcomChannel *) (DCOM_CH_4_BASE_ADDR);

	/* SpW Link Connected Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwLinkConnectedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwLinkConnectedFlagClr = TRUE;

		/* SpW Link Connected Flag Treatment */
		v_p_event_creator(eidSpwConn+usi_link_nb);
	}

	/* SpW Link Disconnected Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwLinkDisconnectedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwLinkDisconnectedFlagClr = TRUE;

		/* SpW Link Disconnected Flag Treatment */
		v_p_event_creator(eidSpwDis+usi_link_nb);
	}

	/* SpW Error Disconnect Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrDisconnectFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrDisconnectFlagClr = TRUE;

		/* SpW Error Disconnect Flag Treatment */
		v_error_event_creator(eidErrDisc, usi_link_nb);
	}

	/* SpW Error Parity Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrParityFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrParityFlagClr = TRUE;

		/* SpW Error Parity Flag Treatment */
		v_error_event_creator(eidErrPar, usi_link_nb);
	}

	/* SpW Error Escape Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrEscapeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrEscapeFlagClr = TRUE;

		/* SpW Error Escape Flag Treatment */
		v_error_event_creator(eidErrEsc, usi_link_nb);
	}

	/* SpW Error Credit Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrCreditFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrCreditFlagClr = TRUE;

		/* SpW Error Credit Flag Treatment */
		v_error_event_creator(eidErrCred, usi_link_nb);
	}

	/* Rx Timecode Received Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRxTimecodeReceivedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRxTimecodeReceivedFlagClr = TRUE;

		/* Rx Timecode Received Flag Treatment */
		v_p_event_timecode_creator(vpxDcomChannel->xSpacewire.xSpwcTimecodeStatus.ucRxTime, usi_link_nb);
	}

	/* Rmap Error Early EOP Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrEarlyEopFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrEarlyEopFlagClr = TRUE;

		/* Rmap Error Early EOP Flag Treatment */
		v_error_event_creator(eidErrEOP, usi_link_nb);
	}

	/* Rmap Error EEP Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrEepFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrEepFlagClr = TRUE;

		/* Rmap Error EEP Flag Treatment */
		v_error_event_creator(eidErrEEP, usi_link_nb);
	}

	/* Rmap Error Header CRC Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrHeaderCrcFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrHeaderCrcFlagClr = TRUE;

		/* Rmap Error Header CRC Flag Treatment */
		v_error_event_creator(eidErrEEP, usi_link_nb);
	}

	/* Rmap Error Unused Packet Type Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrUnusedPacketTypeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrUnusedPacketTypeFlagClr = TRUE;

		/* Rmap Error Unused Packet Type Flag Treatment */
		v_error_event_creator(eidErrUnPack, usi_link_nb);
	}

	/* Rmap Error Invalid Command Code Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrInvalidCommandCodeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrInvalidCommandCodeFlagClr = TRUE;

		/* Rmap Error Invalid Command Code Flag Treatment */
		v_error_event_creator(eidErrInvCmd, usi_link_nb);
	}

	/* Rmap Error Too Much Data Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrTooMuchDataFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrTooMuchDataFlagClr = TRUE;

		/* Rmap Error Too Much Data Flag Treatment */
		v_error_event_creator(eidErrTData, usi_link_nb);
	}

	/* Rmap Error Invalid Data Crc Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrInvalidDataCrcFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrInvalidDataCrcFlagClr = TRUE;

		/* Rmap Error Invalid Data Crc Flag Treatment */
		v_error_event_creator(eidErrInvCRC, usi_link_nb);
	}

}

void vRprtCh5IrqHandler(void* pvContext) {
	/* Cast context to hold_context's type. It is important that this be
	 * declared volatile to avoid unwanted compiler optimization.
	 * volatile int* pviHoldContext = (volatile int*) pvContext;
	 * Use context value according to your app logic...
	 * *pviHoldContext = ...;
	 * if (*pviHoldContext == '0') {}...
	 * App logic sequence...
	 */

INT8U usi_link_nb = 4;
	 volatile TDcomChannel *vpxDcomChannel = (TDcomChannel *) (DCOM_CH_5_BASE_ADDR);

	/* SpW Link Connected Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwLinkConnectedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwLinkConnectedFlagClr = TRUE;

		/* SpW Link Connected Flag Treatment */
		v_p_event_creator(eidSpwConn+usi_link_nb);
	}

	/* SpW Link Disconnected Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwLinkDisconnectedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwLinkDisconnectedFlagClr = TRUE;

		/* SpW Link Disconnected Flag Treatment */
		v_p_event_creator(eidSpwDis+usi_link_nb);
	}

	/* SpW Error Disconnect Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrDisconnectFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrDisconnectFlagClr = TRUE;

		/* SpW Error Disconnect Flag Treatment */
		v_error_event_creator(eidErrDisc, usi_link_nb);
	}

	/* SpW Error Parity Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrParityFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrParityFlagClr = TRUE;

		/* SpW Error Parity Flag Treatment */
		v_error_event_creator(eidErrPar, usi_link_nb);
	}

	/* SpW Error Escape Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrEscapeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrEscapeFlagClr = TRUE;

		/* SpW Error Escape Flag Treatment */
		v_error_event_creator(eidErrEsc, usi_link_nb);
	}

	/* SpW Error Credit Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrCreditFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrCreditFlagClr = TRUE;

		/* SpW Error Credit Flag Treatment */
		v_error_event_creator(eidErrCred, usi_link_nb);
	}

	/* Rx Timecode Received Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRxTimecodeReceivedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRxTimecodeReceivedFlagClr = TRUE;

		/* Rx Timecode Received Flag Treatment */
		v_p_event_timecode_creator(vpxDcomChannel->xSpacewire.xSpwcTimecodeStatus.ucRxTime, usi_link_nb);
	}

	/* Rmap Error Early EOP Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrEarlyEopFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrEarlyEopFlagClr = TRUE;

		/* Rmap Error Early EOP Flag Treatment */
		v_error_event_creator(eidErrEOP, usi_link_nb);
	}

	/* Rmap Error EEP Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrEepFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrEepFlagClr = TRUE;

		/* Rmap Error EEP Flag Treatment */
		v_error_event_creator(eidErrEEP, usi_link_nb);
	}

	/* Rmap Error Header CRC Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrHeaderCrcFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrHeaderCrcFlagClr = TRUE;

		/* Rmap Error Header CRC Flag Treatment */
		v_error_event_creator(eidErrEEP, usi_link_nb);
	}

	/* Rmap Error Unused Packet Type Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrUnusedPacketTypeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrUnusedPacketTypeFlagClr = TRUE;

		/* Rmap Error Unused Packet Type Flag Treatment */
		v_error_event_creator(eidErrUnPack, usi_link_nb);
	}

	/* Rmap Error Invalid Command Code Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrInvalidCommandCodeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrInvalidCommandCodeFlagClr = TRUE;

		/* Rmap Error Invalid Command Code Flag Treatment */
		v_error_event_creator(eidErrInvCmd, usi_link_nb);
	}

	/* Rmap Error Too Much Data Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrTooMuchDataFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrTooMuchDataFlagClr = TRUE;

		/* Rmap Error Too Much Data Flag Treatment */
		v_error_event_creator(eidErrTData, usi_link_nb);
	}

	/* Rmap Error Invalid Data Crc Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrInvalidDataCrcFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrInvalidDataCrcFlagClr = TRUE;

		/* Rmap Error Invalid Data Crc Flag Treatment */
		v_error_event_creator(eidErrInvCRC, usi_link_nb);
	}

}

void vRprtCh6IrqHandler(void* pvContext) {
	/* Cast context to hold_context's type. It is important that this be
	 * declared volatile to avoid unwanted compiler optimization.
	 * volatile int* pviHoldContext = (volatile int*) pvContext;
	 * Use context value according to your app logic...
	 * *pviHoldContext = ...;
	 * if (*pviHoldContext == '0') {}...
	 * App logic sequence...
	 */

INT8U usi_link_nb = 5;
	 volatile TDcomChannel *vpxDcomChannel = (TDcomChannel *) (DCOM_CH_6_BASE_ADDR);

	/* SpW Link Connected Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwLinkConnectedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwLinkConnectedFlagClr = TRUE;

		/* SpW Link Connected Flag Treatment */
		v_p_event_creator(eidSpwConn+usi_link_nb);
	}

	/* SpW Link Disconnected Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwLinkDisconnectedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwLinkDisconnectedFlagClr = TRUE;

		/* SpW Link Disconnected Flag Treatment */
		v_p_event_creator(eidSpwDis+usi_link_nb);
	}

	/* SpW Error Disconnect Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrDisconnectFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrDisconnectFlagClr = TRUE;

		/* SpW Error Disconnect Flag Treatment */
		v_error_event_creator(eidErrDisc, usi_link_nb);
	}

	/* SpW Error Parity Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrParityFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrParityFlagClr = TRUE;

		/* SpW Error Parity Flag Treatment */
		v_error_event_creator(eidErrPar, usi_link_nb);
	}

	/* SpW Error Escape Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrEscapeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrEscapeFlagClr = TRUE;

		/* SpW Error Escape Flag Treatment */
		v_error_event_creator(eidErrEsc, usi_link_nb);
	}

	/* SpW Error Credit Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrCreditFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrCreditFlagClr = TRUE;

		/* SpW Error Credit Flag Treatment */
		v_error_event_creator(eidErrCred, usi_link_nb);
	}

	/* Rx Timecode Received Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRxTimecodeReceivedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRxTimecodeReceivedFlagClr = TRUE;

		/* Rx Timecode Received Flag Treatment */
		v_p_event_timecode_creator(vpxDcomChannel->xSpacewire.xSpwcTimecodeStatus.ucRxTime, usi_link_nb);
	}

	/* Rmap Error Early EOP Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrEarlyEopFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrEarlyEopFlagClr = TRUE;

		/* Rmap Error Early EOP Flag Treatment */
		v_error_event_creator(eidErrEOP, usi_link_nb);
	}

	/* Rmap Error EEP Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrEepFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrEepFlagClr = TRUE;

		/* Rmap Error EEP Flag Treatment */
		v_error_event_creator(eidErrEEP, usi_link_nb);
	}

	/* Rmap Error Header CRC Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrHeaderCrcFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrHeaderCrcFlagClr = TRUE;

		/* Rmap Error Header CRC Flag Treatment */
		v_error_event_creator(eidErrEEP, usi_link_nb);
	}

	/* Rmap Error Unused Packet Type Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrUnusedPacketTypeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrUnusedPacketTypeFlagClr = TRUE;

		/* Rmap Error Unused Packet Type Flag Treatment */
		v_error_event_creator(eidErrUnPack, usi_link_nb);
	}

	/* Rmap Error Invalid Command Code Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrInvalidCommandCodeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrInvalidCommandCodeFlagClr = TRUE;

		/* Rmap Error Invalid Command Code Flag Treatment */
		v_error_event_creator(eidErrInvCmd, usi_link_nb);
	}

	/* Rmap Error Too Much Data Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrTooMuchDataFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrTooMuchDataFlagClr = TRUE;

		/* Rmap Error Too Much Data Flag Treatment */
		v_error_event_creator(eidErrTData, usi_link_nb);
	}

	/* Rmap Error Invalid Data Crc Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrInvalidDataCrcFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrInvalidDataCrcFlagClr = TRUE;

		/* Rmap Error Invalid Data Crc Flag Treatment */
		v_error_event_creator(eidErrInvCRC, usi_link_nb);
	}

}

void vRprtCh7IrqHandler(void* pvContext) {
	/* Cast context to hold_context's type. It is important that this be
	 * declared volatile to avoid unwanted compiler optimization.
	 * volatile int* pviHoldContext = (volatile int*) pvContext;
	 * Use context value according to your app logic...
	 * *pviHoldContext = ...;
	 * if (*pviHoldContext == '0') {}...
	 * App logic sequence...
	 */

INT8U usi_link_nb = 6;
	 volatile TDcomChannel *vpxDcomChannel = (TDcomChannel *) (DCOM_CH_7_BASE_ADDR);

	/* SpW Link Connected Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwLinkConnectedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwLinkConnectedFlagClr = TRUE;

		/* SpW Link Connected Flag Treatment */
		v_p_event_creator(eidSpwConn+usi_link_nb);
	}

	/* SpW Link Disconnected Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwLinkDisconnectedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwLinkDisconnectedFlagClr = TRUE;

		/* SpW Link Disconnected Flag Treatment */
		v_p_event_creator(eidSpwDis+usi_link_nb);
	}

	/* SpW Error Disconnect Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrDisconnectFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrDisconnectFlagClr = TRUE;

		/* SpW Error Disconnect Flag Treatment */
		v_error_event_creator(eidErrDisc, usi_link_nb);
	}

	/* SpW Error Parity Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrParityFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrParityFlagClr = TRUE;

		/* SpW Error Parity Flag Treatment */
		v_error_event_creator(eidErrPar, usi_link_nb);
	}

	/* SpW Error Escape Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrEscapeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrEscapeFlagClr = TRUE;

		/* SpW Error Escape Flag Treatment */
		v_error_event_creator(eidErrEsc, usi_link_nb);
	}

	/* SpW Error Credit Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrCreditFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrCreditFlagClr = TRUE;

		/* SpW Error Credit Flag Treatment */
		v_error_event_creator(eidErrCred, usi_link_nb);
	}

	/* Rx Timecode Received Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRxTimecodeReceivedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRxTimecodeReceivedFlagClr = TRUE;

		/* Rx Timecode Received Flag Treatment */
		v_p_event_timecode_creator(vpxDcomChannel->xSpacewire.xSpwcTimecodeStatus.ucRxTime, usi_link_nb);
	}

	/* Rmap Error Early EOP Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrEarlyEopFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrEarlyEopFlagClr = TRUE;

		/* Rmap Error Early EOP Flag Treatment */
		v_error_event_creator(eidErrEOP, usi_link_nb);
	}

	/* Rmap Error EEP Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrEepFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrEepFlagClr = TRUE;

		/* Rmap Error EEP Flag Treatment */
		v_error_event_creator(eidErrEEP, usi_link_nb);
	}

	/* Rmap Error Header CRC Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrHeaderCrcFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrHeaderCrcFlagClr = TRUE;

		/* Rmap Error Header CRC Flag Treatment */
		v_error_event_creator(eidErrEEP, usi_link_nb);
	}

	/* Rmap Error Unused Packet Type Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrUnusedPacketTypeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrUnusedPacketTypeFlagClr = TRUE;

		/* Rmap Error Unused Packet Type Flag Treatment */
		v_error_event_creator(eidErrUnPack, usi_link_nb);
	}

	/* Rmap Error Invalid Command Code Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrInvalidCommandCodeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrInvalidCommandCodeFlagClr = TRUE;

		/* Rmap Error Invalid Command Code Flag Treatment */
		v_error_event_creator(eidErrInvCmd, usi_link_nb);
	}

	/* Rmap Error Too Much Data Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrTooMuchDataFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrTooMuchDataFlagClr = TRUE;

		/* Rmap Error Too Much Data Flag Treatment */
		v_error_event_creator(eidErrTData, usi_link_nb);
	}

	/* Rmap Error Invalid Data Crc Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrInvalidDataCrcFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrInvalidDataCrcFlagClr = TRUE;

		/* Rmap Error Invalid Data Crc Flag Treatment */
		v_error_event_creator(eidErrInvCRC, usi_link_nb);
	}

}

void vRprtCh8IrqHandler(void* pvContext) {
	/* Cast context to hold_context's type. It is important that this be
	 * declared volatile to avoid unwanted compiler optimization.
	 * volatile int* pviHoldContext = (volatile int*) pvContext;
	 * Use context value according to your app logic...
	 * *pviHoldContext = ...;
	 * if (*pviHoldContext == '0') {}...
	 * App logic sequence...
	 */

INT8U usi_link_nb = 7;
	 volatile TDcomChannel *vpxDcomChannel = (TDcomChannel *) (DCOM_CH_8_BASE_ADDR);

	/* SpW Link Connected Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwLinkConnectedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwLinkConnectedFlagClr = TRUE;

		/* SpW Link Connected Flag Treatment */
		v_p_event_creator(eidSpwConn+usi_link_nb);
	}

	/* SpW Link Disconnected Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwLinkDisconnectedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwLinkDisconnectedFlagClr = TRUE;

		/* SpW Link Disconnected Flag Treatment */
		v_p_event_creator(eidSpwDis+usi_link_nb);
	}

	/* SpW Error Disconnect Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrDisconnectFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrDisconnectFlagClr = TRUE;

		/* SpW Error Disconnect Flag Treatment */
		v_error_event_creator(eidErrDisc, usi_link_nb);
	}

	/* SpW Error Parity Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrParityFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrParityFlagClr = TRUE;

		/* SpW Error Parity Flag Treatment */
		v_error_event_creator(eidErrPar, usi_link_nb);
	}

	/* SpW Error Escape Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrEscapeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrEscapeFlagClr = TRUE;

		/* SpW Error Escape Flag Treatment */
		v_error_event_creator(eidErrEsc, usi_link_nb);
	}

	/* SpW Error Credit Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bSpwErrCreditFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrCreditFlagClr = TRUE;

		/* SpW Error Credit Flag Treatment */
		v_error_event_creator(eidErrCred, usi_link_nb);
	}

	/* Rx Timecode Received Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRxTimecodeReceivedFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRxTimecodeReceivedFlagClr = TRUE;

		/* Rx Timecode Received Flag Treatment */
		v_p_event_timecode_creator(vpxDcomChannel->xSpacewire.xSpwcTimecodeStatus.ucRxTime, usi_link_nb);
	}

	/* Rmap Error Early EOP Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrEarlyEopFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrEarlyEopFlagClr = TRUE;

		/* Rmap Error Early EOP Flag Treatment */
		v_error_event_creator(eidErrEOP, usi_link_nb);
	}

	/* Rmap Error EEP Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrEepFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrEepFlagClr = TRUE;

		/* Rmap Error EEP Flag Treatment */
		v_error_event_creator(eidErrEEP, usi_link_nb);
	}

	/* Rmap Error Header CRC Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrHeaderCrcFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrHeaderCrcFlagClr = TRUE;

		/* Rmap Error Header CRC Flag Treatment */
		v_error_event_creator(eidErrEEP, usi_link_nb);
	}

	/* Rmap Error Unused Packet Type Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrUnusedPacketTypeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrUnusedPacketTypeFlagClr = TRUE;

		/* Rmap Error Unused Packet Type Flag Treatment */
		v_error_event_creator(eidErrUnPack, usi_link_nb);
	}

	/* Rmap Error Invalid Command Code Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrInvalidCommandCodeFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrInvalidCommandCodeFlagClr = TRUE;

		/* Rmap Error Invalid Command Code Flag Treatment */
		v_error_event_creator(eidErrInvCmd, usi_link_nb);
	}

	/* Rmap Error Too Much Data Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrTooMuchDataFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrTooMuchDataFlagClr = TRUE;

		/* Rmap Error Too Much Data Flag Treatment */
		v_error_event_creator(eidErrTData, usi_link_nb);
	}

	/* Rmap Error Invalid Data Crc Flag */
	if (vpxDcomChannel->xReport.xRprtIrqFlag.bRmapErrInvalidDataCrcFlag) {
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrInvalidDataCrcFlagClr = TRUE;

		/* Rmap Error Invalid Data Crc Flag Treatment */
		v_error_event_creator(eidErrInvCRC, usi_link_nb);
	}

}

bool bRprtInitIrq(alt_u8 ucDcomCh) {
	bool bStatus = FALSE;
	void* pvHoldContext;
	volatile TDcomChannel *vpxDcomChannel;
	switch (ucDcomCh) {
	case eDcomSpwCh1:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh1HoldContext;
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_1_BASE_ADDR);
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_1_RPRT_IRQ, pvHoldContext, vRprtCh1IrqHandler);
		bStatus = TRUE;
		break;
	case eDcomSpwCh2:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh2HoldContext;
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_2_BASE_ADDR);
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_2_RPRT_IRQ, pvHoldContext, vRprtCh2IrqHandler);
		bStatus = TRUE;
		break;
	case eDcomSpwCh3:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh3HoldContext;
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_3_BASE_ADDR);
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_3_RPRT_IRQ, pvHoldContext, vRprtCh3IrqHandler);
		bStatus = TRUE;
		break;
	case eDcomSpwCh4:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh4HoldContext;
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_4_BASE_ADDR);
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_4_RPRT_IRQ, pvHoldContext, vRprtCh4IrqHandler);
		bStatus = TRUE;
		break;
	case eDcomSpwCh5:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh5HoldContext;
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_5_BASE_ADDR);
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_5_RPRT_IRQ, pvHoldContext, vRprtCh5IrqHandler);
		bStatus = TRUE;
		break;
	case eDcomSpwCh6:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh6HoldContext;
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_6_BASE_ADDR);
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_6_RPRT_IRQ, pvHoldContext, vRprtCh6IrqHandler);
		bStatus = TRUE;
		break;
	case eDcomSpwCh7:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh7HoldContext;
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_7_BASE_ADDR);
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_7_RPRT_IRQ, pvHoldContext, vRprtCh7IrqHandler);
		bStatus = TRUE;
		break;
	case eDcomSpwCh8:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh8HoldContext;
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_8_BASE_ADDR);
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_8_RPRT_IRQ, pvHoldContext, vRprtCh8IrqHandler);
		bStatus = TRUE;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	if (bStatus) {
		// Clear all flags
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwLinkConnectedFlagClr = TRUE;
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwLinkDisconnectedFlagClr = TRUE;
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrDisconnectFlagClr = TRUE;
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrParityFlagClr = TRUE;
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrEscapeFlagClr = TRUE;
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bSpwErrCreditFlagClr = TRUE;
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRxTimecodeReceivedFlagClr = TRUE;
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrEarlyEopFlagClr = TRUE;
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrEepFlagClr = TRUE;
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrHeaderCrcFlagClr = TRUE;
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrUnusedPacketTypeFlagClr = TRUE;
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrInvalidCommandCodeFlagClr = TRUE;
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrTooMuchDataFlagClr = TRUE;
		vpxDcomChannel->xReport.xRprtIrqFlagClr.bRmapErrInvalidDataCrcFlagClr = TRUE;
	}

	return (bStatus);
}

bool bRprtGetIrqControl(TRprtChannel *pxRprtCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxRprtCh != NULL) {

		vpxDcomChannel = (TDcomChannel *) (pxRprtCh->xRprtDevAddr.uliRprtBaseAddr);

		pxRprtCh->xRprtIrqControl = vpxDcomChannel->xReport.xRprtIrqControl;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bRprtSetIrqControl(TRprtChannel *pxRprtCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxRprtCh != NULL) {

		vpxDcomChannel = (TDcomChannel *) (pxRprtCh->xRprtDevAddr.uliRprtBaseAddr);

		vpxDcomChannel->xReport.xRprtIrqControl = pxRprtCh->xRprtIrqControl;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bRprtGetIrqFlags(TRprtChannel *pxRprtCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxRprtCh != NULL) {

		vpxDcomChannel = (TDcomChannel *) (pxRprtCh->xRprtDevAddr.uliRprtBaseAddr);

		pxRprtCh->xRprtIrqFlag = vpxDcomChannel->xReport.xRprtIrqFlag;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bRprtInitCh(TRprtChannel *pxRprtCh, alt_u8 ucDcomCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxRprtCh != NULL) {

		switch (ucDcomCh) {
		case eDcomSpwCh1:
			pxRprtCh->xRprtDevAddr.uliRprtBaseAddr = (alt_u32) DCOM_CH_1_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *) (DCOM_CH_1_BASE_ADDR);
			vpxDcomChannel->xReport.xRprtDevAddr.uliRprtBaseAddr = (alt_u32) DCOM_CH_1_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh2:
			pxRprtCh->xRprtDevAddr.uliRprtBaseAddr = (alt_u32) DCOM_CH_2_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *) (DCOM_CH_2_BASE_ADDR);
			vpxDcomChannel->xReport.xRprtDevAddr.uliRprtBaseAddr = (alt_u32) DCOM_CH_2_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh3:
			pxRprtCh->xRprtDevAddr.uliRprtBaseAddr = (alt_u32) DCOM_CH_3_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *) (DCOM_CH_3_BASE_ADDR);
			vpxDcomChannel->xReport.xRprtDevAddr.uliRprtBaseAddr = (alt_u32) DCOM_CH_3_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh4:
			pxRprtCh->xRprtDevAddr.uliRprtBaseAddr = (alt_u32) DCOM_CH_4_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *) (DCOM_CH_4_BASE_ADDR);
			vpxDcomChannel->xReport.xRprtDevAddr.uliRprtBaseAddr = (alt_u32) DCOM_CH_4_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh5:
			pxRprtCh->xRprtDevAddr.uliRprtBaseAddr = (alt_u32) DCOM_CH_5_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *) (DCOM_CH_5_BASE_ADDR);
			vpxDcomChannel->xReport.xRprtDevAddr.uliRprtBaseAddr = (alt_u32) DCOM_CH_5_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh6:
			pxRprtCh->xRprtDevAddr.uliRprtBaseAddr = (alt_u32) DCOM_CH_6_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *) (DCOM_CH_6_BASE_ADDR);
			vpxDcomChannel->xReport.xRprtDevAddr.uliRprtBaseAddr = (alt_u32) DCOM_CH_6_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh7:
			pxRprtCh->xRprtDevAddr.uliRprtBaseAddr = (alt_u32) DCOM_CH_7_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *) (DCOM_CH_7_BASE_ADDR);
			vpxDcomChannel->xReport.xRprtDevAddr.uliRprtBaseAddr = (alt_u32) DCOM_CH_7_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh8:
			pxRprtCh->xRprtDevAddr.uliRprtBaseAddr = (alt_u32) DCOM_CH_8_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *) (DCOM_CH_8_BASE_ADDR);
			vpxDcomChannel->xReport.xRprtDevAddr.uliRprtBaseAddr = (alt_u32) DCOM_CH_8_BASE_ADDR;
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}

		if (bValidCh) {

			if (!bRprtGetIrqControl(pxRprtCh)) {
				bInitFail = TRUE;
			}
			if (!bRprtGetIrqFlags(pxRprtCh)) {
				bInitFail = TRUE;
			}

			if (!bInitFail) {
				bStatus = TRUE;
			}
		}
	}
	return (bStatus);
}

//! [public functions]

//! [private functions]
//! [private functions]
