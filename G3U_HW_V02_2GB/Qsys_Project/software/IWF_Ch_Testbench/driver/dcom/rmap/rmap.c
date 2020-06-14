/*
 * rmap.c
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#include "rmap.h"

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
bool bRmapGetCodecConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxRmapCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapCodecConfig = vpxDcomChannel->xRmap.xRmapCodecConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetCodecConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxRmapCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		vpxDcomChannel->xRmap.xRmapCodecConfig = pxRmapCh->xRmapCodecConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetCodecStatus(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxRmapCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapCodecStatus = vpxDcomChannel->xRmap.xRmapCodecStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetCodecError(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxRmapCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapCodecError = vpxDcomChannel->xRmap.xRmapCodecError;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetMemAreaConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxRmapCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapMemAreaConfig = vpxDcomChannel->xRmap.xRmapMemAreaConfig;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapSetMemAreaConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxRmapCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		vpxDcomChannel->xRmap.xRmapMemAreaConfig  = pxRmapCh->xRmapMemAreaConfig;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetRmapMemArea(TRmapChannel *pxRmapCh) {
	bool bStatus = TRUE;
	/*
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig = vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig;

		bStatus = TRUE;
	}
	*/

	return bStatus;
}

bool bRmapSetRmapMemArea(TRmapChannel *pxRmapCh) {
	bool bStatus = TRUE;
	/*
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig = pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig;

		bStatus = TRUE;
	}
	*/

	return bStatus;
}

bool bRmapClearMemArea(TRmapChannel *pxRmapCh){
	bool bStatus = FALSE;
	alt_u16 usiAddrCnt = 0;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxRmapCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		for (usiAddrCnt = 0; usiAddrCnt < RMAP_MEMORY_AREA_LENGTH_BYTES; usiAddrCnt++) {
			vpxDcomChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaReg.ucRmapMemByte[usiAddrCnt] = 0x00;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapInitCh(TRmapChannel *pxRmapCh, alt_u8 ucDcomCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxRmapCh != NULL) {

		switch (ucDcomCh) {
		case eDcomSpwCh1:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) DCOM_CH_1_BASE_ADDR;
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) DCOM_RMAP_MEM_1_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *)(DCOM_CH_1_BASE_ADDR);
			vpxDcomChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) DCOM_CH_1_BASE_ADDR;
			vpxDcomChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) DCOM_RMAP_MEM_1_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh2:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) DCOM_CH_2_BASE_ADDR;
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) DCOM_RMAP_MEM_2_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *)(DCOM_CH_2_BASE_ADDR);
			vpxDcomChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) DCOM_CH_2_BASE_ADDR;
			vpxDcomChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) DCOM_RMAP_MEM_2_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh3:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) DCOM_CH_3_BASE_ADDR;
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) DCOM_RMAP_MEM_3_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *)(DCOM_CH_3_BASE_ADDR);
			vpxDcomChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) DCOM_CH_3_BASE_ADDR;
			vpxDcomChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) DCOM_RMAP_MEM_3_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh4:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) DCOM_CH_4_BASE_ADDR;
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) DCOM_RMAP_MEM_4_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *)(DCOM_CH_4_BASE_ADDR);
			vpxDcomChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) DCOM_CH_4_BASE_ADDR;
			vpxDcomChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) DCOM_RMAP_MEM_4_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh5:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) DCOM_CH_5_BASE_ADDR;
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) DCOM_RMAP_MEM_5_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *)(DCOM_CH_5_BASE_ADDR);
			vpxDcomChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) DCOM_CH_5_BASE_ADDR;
			vpxDcomChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) DCOM_RMAP_MEM_5_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh6:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) DCOM_CH_6_BASE_ADDR;
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) DCOM_RMAP_MEM_6_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *)(DCOM_CH_6_BASE_ADDR);
			vpxDcomChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) DCOM_CH_6_BASE_ADDR;
			vpxDcomChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) DCOM_RMAP_MEM_6_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh7:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) DCOM_CH_7_BASE_ADDR;
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) DCOM_RMAP_MEM_7_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *)(DCOM_CH_7_BASE_ADDR);
			vpxDcomChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) DCOM_CH_7_BASE_ADDR;
			vpxDcomChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) DCOM_RMAP_MEM_7_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh8:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) DCOM_CH_8_BASE_ADDR;
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) DCOM_RMAP_MEM_8_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *)(DCOM_CH_8_BASE_ADDR);
			vpxDcomChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) DCOM_CH_8_BASE_ADDR;
			vpxDcomChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) DCOM_RMAP_MEM_8_BASE_ADDR;
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}

		if (bValidCh) {
			if (!bRmapGetCodecConfig(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetCodecStatus(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetCodecError(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetMemAreaConfig(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapClearMemArea(pxRmapCh)) {
				bInitFail = TRUE;
			}
			
			if (!bInitFail) {
				bStatus = TRUE;
			}
		}
	}
	return bStatus;
}

//! [public functions]

//! [private functions]
//! [private functions]
