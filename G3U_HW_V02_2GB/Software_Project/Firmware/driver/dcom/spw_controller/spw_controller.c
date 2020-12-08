/*
 * spw_controller.c
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#include "spw_controller.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
bool bSpwcGetLinkConfig(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxSpwcCh != NULL) {

		vpxDcomChannel = (TDcomChannel *) (pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr);

		pxSpwcCh->xSpwcLinkConfig = vpxDcomChannel->xSpacewire.xSpwcLinkConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcSetLinkConfig(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxSpwcCh != NULL) {

		vpxDcomChannel = (TDcomChannel *) (pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr);

		vpxDcomChannel->xSpacewire.xSpwcLinkConfig = pxSpwcCh->xSpwcLinkConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcGetLinkStatus(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxSpwcCh != NULL) {

		vpxDcomChannel = (TDcomChannel *) (pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr);

		pxSpwcCh->xSpwcLinkStatus = vpxDcomChannel->xSpacewire.xSpwcLinkStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcGetLinkError(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxSpwcCh != NULL) {

		vpxDcomChannel = (TDcomChannel *) (pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr);

		pxSpwcCh->xSpwcLinkError = vpxDcomChannel->xSpacewire.xSpwcLinkError;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcGetTimecodeControl(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxSpwcCh != NULL) {

		vpxDcomChannel = (TDcomChannel *) (pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr);

		pxSpwcCh->xSpwcTimecodeControl = vpxDcomChannel->xSpacewire.xSpwcTimecodeControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcSetTimecodeControl(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxSpwcCh != NULL) {

		vpxDcomChannel = (TDcomChannel *) (pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr);

		vpxDcomChannel->xSpacewire.xSpwcTimecodeControl = pxSpwcCh->xSpwcTimecodeControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcGetTimecodeStatus(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxSpwcCh != NULL) {

		vpxDcomChannel = (TDcomChannel *) (pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr);

		pxSpwcCh->xSpwcTimecodeStatus = vpxDcomChannel->xSpacewire.xSpwcTimecodeStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcSendTimecode(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxSpwcCh != NULL) {

		vpxDcomChannel = (TDcomChannel *) (pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr);

		vpxDcomChannel->xSpacewire.xSpwcTimecodeControl.ucTxTime = pxSpwcCh->xSpwcTimecodeControl.ucTxTime;
		vpxDcomChannel->xSpacewire.xSpwcTimecodeControl.ucTxControl = pxSpwcCh->xSpwcTimecodeControl.ucTxControl;
		vpxDcomChannel->xSpacewire.xSpwcTimecodeControl.bTxSend = TRUE;

		pxSpwcCh->xSpwcTimecodeControl.bTxSend = FALSE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcReceiveTimecode(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxSpwcCh != NULL) {

		vpxDcomChannel = (TDcomChannel *) (pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr);

		pxSpwcCh->xSpwcTimecodeStatus.ucRxTime = vpxDcomChannel->xSpacewire.xSpwcTimecodeStatus.ucRxTime;
		pxSpwcCh->xSpwcTimecodeStatus.ucRxControl = vpxDcomChannel->xSpacewire.xSpwcTimecodeStatus.ucRxControl;
		pxSpwcCh->xSpwcTimecodeStatus.bRxReceived = vpxDcomChannel->xSpacewire.xSpwcTimecodeStatus.bRxReceived;

		if (vpxDcomChannel->xSpacewire.xSpwcTimecodeStatus.bRxReceived) {
			vpxDcomChannel->xSpacewire.xSpwcTimecodeControl.bRxReceivedClr = TRUE;
		}

		pxSpwcCh->xSpwcTimecodeControl.bRxReceivedClr = FALSE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcGetSpwCodecErrInj(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxSpwcCh != NULL) {

		vpxDcomChannel = (TDcomChannel *) (pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr);

		pxSpwcCh->xSpwcSpwCodecErrInj = vpxDcomChannel->xSpacewire.xSpwcSpwCodecErrInj;

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bSpwcSetSpwCodecErrInj(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxSpwcCh != NULL) {

		vpxDcomChannel = (TDcomChannel *) (pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr);

		vpxDcomChannel->xSpacewire.xSpwcSpwCodecErrInj.ucErrInjErrCode = pxSpwcCh->xSpwcSpwCodecErrInj.ucErrInjErrCode;
		if (pxSpwcCh->xSpwcSpwCodecErrInj.bResetErrInj) {
			vpxDcomChannel->xSpacewire.xSpwcSpwCodecErrInj.bResetErrInj = TRUE;
		} else if (pxSpwcCh->xSpwcSpwCodecErrInj.bStartErrInj) {
			vpxDcomChannel->xSpacewire.xSpwcSpwCodecErrInj.bStartErrInj = TRUE;
		}

		bStatus = TRUE;
	}

	return (bStatus);
}



bool bSpwcInitCh(TSpwcChannel *pxSpwcCh, alt_u8 ucDcomCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxSpwcCh != NULL) {

		switch (ucDcomCh) {
		case eDcomSpwCh1:
			pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) DCOM_CH_1_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *) (DCOM_CH_1_BASE_ADDR);
			vpxDcomChannel->xSpacewire.xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) DCOM_CH_1_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh2:
			pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) DCOM_CH_2_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *) (DCOM_CH_2_BASE_ADDR);
			vpxDcomChannel->xSpacewire.xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) DCOM_CH_2_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh3:
			pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) DCOM_CH_3_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *) (DCOM_CH_3_BASE_ADDR);
			vpxDcomChannel->xSpacewire.xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) DCOM_CH_3_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh4:
			pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) DCOM_CH_4_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *) (DCOM_CH_4_BASE_ADDR);
			vpxDcomChannel->xSpacewire.xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) DCOM_CH_4_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh5:
			pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) DCOM_CH_5_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *) (DCOM_CH_5_BASE_ADDR);
			vpxDcomChannel->xSpacewire.xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) DCOM_CH_5_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh6:
			pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) DCOM_CH_6_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *) (DCOM_CH_6_BASE_ADDR);
			vpxDcomChannel->xSpacewire.xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) DCOM_CH_6_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh7:
			pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) DCOM_CH_7_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *) (DCOM_CH_7_BASE_ADDR);
			vpxDcomChannel->xSpacewire.xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) DCOM_CH_7_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh8:
			pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) DCOM_CH_8_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *) (DCOM_CH_8_BASE_ADDR);
			vpxDcomChannel->xSpacewire.xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) DCOM_CH_8_BASE_ADDR;
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}

		if (bValidCh) {
			if (!bSpwcGetLinkConfig(pxSpwcCh)) {
				bInitFail = TRUE;
			}
			if (!bSpwcGetLinkStatus(pxSpwcCh)) {
				bInitFail = TRUE;
			}
			if (!bSpwcGetLinkError(pxSpwcCh)) {
				bInitFail = TRUE;
			}
			if (!bSpwcGetTimecodeControl(pxSpwcCh)) {
				bInitFail = TRUE;
			}
			if (!bSpwcGetTimecodeStatus(pxSpwcCh)) {
				bInitFail = TRUE;
			}
			if (!bSpwcGetSpwCodecErrInj(pxSpwcCh)) {
				bInitFail = TRUE;
			}

			if (!bInitFail) {
				bStatus = TRUE;
			}
		}
	}
	return bStatus;
}

alt_u8 ucSpwcCalculateLinkDiv(alt_8 ucLinkSpeed) {
	alt_u8 ucLinkDiv;

	if (ucLinkSpeed < 100) {
		ucLinkDiv = (alt_u8) (round(200.0 / ((float) ucLinkSpeed))) - 1;
	} else {
		ucLinkDiv = 1;
	}

	return (ucLinkDiv);
}
//! [public functions]

//! [private functions]
//! [private functions]

