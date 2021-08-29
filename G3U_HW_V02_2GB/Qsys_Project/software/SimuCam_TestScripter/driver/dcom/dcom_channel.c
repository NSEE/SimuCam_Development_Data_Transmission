/*
 * dcom_channel.c
 *
 *  Created on: 31/03/2019
 *      Author: rfranca
 */

#include "dcom_channel.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
bool bDcomSetGlobalIrqEn(bool bGlobalIrqEnable, alt_u8 ucDcomCh) {
	bool bStatus = FALSE;

	volatile TDcomChannel *vpxDcomChannel;

	switch (ucDcomCh) {
	case eDcomSpwCh1:
		vpxDcomChannel = (TDcomChannel *) DCOM_CH_1_BASE_ADDR;
		vpxDcomChannel->xDcomIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eDcomSpwCh2:
		vpxDcomChannel = (TDcomChannel *) DCOM_CH_2_BASE_ADDR;
		vpxDcomChannel->xDcomIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eDcomSpwCh3:
		vpxDcomChannel = (TDcomChannel *) DCOM_CH_3_BASE_ADDR;
		vpxDcomChannel->xDcomIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eDcomSpwCh4:
		vpxDcomChannel = (TDcomChannel *) DCOM_CH_4_BASE_ADDR;
		vpxDcomChannel->xDcomIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eDcomSpwCh5:
		vpxDcomChannel = (TDcomChannel *) DCOM_CH_5_BASE_ADDR;
		vpxDcomChannel->xDcomIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eDcomSpwCh6:
		vpxDcomChannel = (TDcomChannel *) DCOM_CH_6_BASE_ADDR;
		vpxDcomChannel->xDcomIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eDcomSpwCh7:
		vpxDcomChannel = (TDcomChannel *) DCOM_CH_7_BASE_ADDR;
		vpxDcomChannel->xDcomIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eDcomSpwCh8:
		vpxDcomChannel = (TDcomChannel *) DCOM_CH_8_BASE_ADDR;
		vpxDcomChannel->xDcomIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return bStatus;
}

bool bDcomInitCh(TDcomChannel *pxDcomCh, alt_u8 ucDcomCh) {
	bool bStatus = FALSE;
	bool bInitFail = FALSE;

	if (!bSpwcInitCh(&(pxDcomCh->xSpacewire), ucDcomCh)) {
		bInitFail = TRUE;
	}
	if (!bDschInitIrq(ucDcomCh)) {
		bInitFail = TRUE;
	}
	if (!bDschInitCh(&(pxDcomCh->xDataScheduler), ucDcomCh)) {
		bInitFail = TRUE;
	}
	if (!bRmapInitCh(&(pxDcomCh->xRmap), ucDcomCh)) {
		bInitFail = TRUE;
	}
	if (!bRprtInitCh(&(pxDcomCh->xReport), ucDcomCh)) {
		bInitFail = TRUE;
	}
	if (!bRprtInitIrq(ucDcomCh)) {
		bInitFail = TRUE;
	}

	if (!bInitFail) {
		bStatus = TRUE;
	}

	return bStatus;
}

//! [public functions]

//! [private functions]
//! [private functions]

