/*
 * data_buffers.c
 *
 *  Created on: 31/03/2019
 *      Author: rfranca
 */

#include "data_buffers.h"

//! [private function prototypes]
static ALT_INLINE void ALT_ALWAYS_INLINE vDatbWriteReg(alt_u32 *puliBaseAddr, alt_u32 uliRegOffset, alt_u32 uliRegValue);
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDatbReadReg(alt_u32 *puliBaseAddr, alt_u32 uliRegOffset);
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDatbSetRegCtrl(alt_u32 uliRegValue, alt_u32 uliCtrlMask, bool bCtrlValue);
static ALT_INLINE bool ALT_ALWAYS_INLINE bDatbGetRegFlag(alt_u32 uliRegValue, alt_u32 uliFlagMask);
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDatbSetRegField(alt_u32 uliRegValue, alt_u32 uliFieldMask, alt_u8 ucFieldOffset, alt_u32 uliFieldValue);
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDatbGetRegField(alt_u32 uliRegValue, alt_u32 uliFieldMask, alt_u8 ucFieldOffset);
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
const alt_u16 cuiDataBufferSize = 0;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
bool bDatbGetBuffersStatus(TDatbChannel *pxDatbCh){
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxDatbCh != NULL) {
		uliReg = uliDatbReadReg(pxDatbCh->puliDatbChAddr, (alt_u32)(DCOM_DATA_BUFF_STAT_REG_OFST));

		pxDatbCh->xBufferStatus.bDataBufferFull  = bDatbGetRegFlag(uliReg, (alt_u32)(DCOM_DATA_BUFF_STAT_FULL_MSK));
		pxDatbCh->xBufferStatus.bDataBufferEmpty = bDatbGetRegFlag(uliReg, (alt_u32)(DCOM_DATA_BUFF_STAT_EMPTY_MSK));
		pxDatbCh->xBufferStatus.uiDataBufferUsed = (alt_u16)(uliDatbGetRegField(uliReg, (alt_u32)(DCOM_DATA_BUFF_STAT_USED_MSK), 0));
		pxDatbCh->xBufferStatus.uiDataBufferFree = cuiDataBufferSize - pxDatbCh->xBufferStatus.uiDataBufferUsed;

		bStatus = TRUE;
	}

	return (bStatus);
}

bool bDatbInitCh(TDatbChannel *pxDatbCh, alt_u8 ucDcomCh){
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;

	if (pxDatbCh != NULL) {

		switch (ucDcomCh) {
		case eDcomSpwCh1:
			pxDatbCh->puliDatbChAddr = (alt_u32 *) DCOM_CH_1_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh2:
			pxDatbCh->puliDatbChAddr = (alt_u32 *) DCOM_CH_2_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh3:
			pxDatbCh->puliDatbChAddr = (alt_u32 *) DCOM_CH_3_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh4:
			pxDatbCh->puliDatbChAddr = (alt_u32 *) DCOM_CH_4_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh5:
			pxDatbCh->puliDatbChAddr = (alt_u32 *) DCOM_CH_5_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh6:
			pxDatbCh->puliDatbChAddr = (alt_u32 *) DCOM_CH_6_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh7:
			pxDatbCh->puliDatbChAddr = (alt_u32 *) DCOM_CH_7_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh8:
			pxDatbCh->puliDatbChAddr = (alt_u32 *) DCOM_CH_8_BASE_ADDR;
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}

		if (bValidCh) {
			if (!bDatbGetBuffersStatus(pxDatbCh)) {
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
static ALT_INLINE void ALT_ALWAYS_INLINE vDatbWriteReg(alt_u32 *puliBaseAddr, alt_u32 uliRegOffset, alt_u32 uliRegValue) {
	*(puliBaseAddr + uliRegOffset) = uliRegValue;
}

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDatbReadReg(alt_u32 *puliBaseAddr, alt_u32 uliRegOffset) {
	volatile alt_u32 uliRegValue;

	uliRegValue = *(puliBaseAddr + uliRegOffset);
	return uliRegValue;
}

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDatbSetRegCtrl(alt_u32 uliRegValue, alt_u32 uliCtrlMask, bool bCtrlValue){
	alt_u32 uliReg = 0;

	if (bCtrlValue) {
		uliReg = uliRegValue | uliCtrlMask;
	} else {
		uliReg = uliRegValue & (~uliCtrlMask);
	}

	return uliReg;
}

static ALT_INLINE bool ALT_ALWAYS_INLINE bDatbGetRegFlag(alt_u32 uliRegValue, alt_u32 uliFlagMask) {
	bool bFlag = FALSE;

	if (uliRegValue & uliFlagMask) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDatbSetRegField(alt_u32 uliRegValue, alt_u32 uliFieldMask, alt_u8 ucFieldOffset, alt_u32 uliFieldValue){
	alt_u32 uliReg = 0;

	uliReg = uliRegValue & (~uliFieldMask);
	uliReg |= uliFieldMask & (uliFieldValue << ucFieldOffset);

	return uliReg;
}

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDatbGetRegField(alt_u32 uliRegValue, alt_u32 uliFieldMask, alt_u8 ucFieldOffset) {
	alt_u32 uliFieldValue = 0;

	uliFieldValue = (uliRegValue & uliFieldMask) >> ucFieldOffset;

	return uliFieldValue;
}
//! [private functions]
