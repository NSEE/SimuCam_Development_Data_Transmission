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
static ALT_INLINE void ALT_ALWAYS_INLINE vDcomWriteReg(alt_u32 *puliBaseAddr,
		alt_u32 uliRegOffset, alt_u32 uliRegValue);
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDcomReadReg(
		alt_u32 *puliBaseAddr, alt_u32 uliRegOffset);
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
bool bDcomSetGlobalIrqEn(bool bGlobalIrqEnable, alt_u8 ucDcomCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	volatile alt_u32 uliReg = 0;
	alt_u32 *puliDcomAddr = 0;

	switch (ucDcomCh) {
	case eDcomSpwCh1:
		puliDcomAddr = (alt_u32 *) DCOM_CH_1_BASE_ADDR;
		bValidCh = TRUE;
		break;
	case eDcomSpwCh2:
		puliDcomAddr = (alt_u32 *) DCOM_CH_2_BASE_ADDR;
		bValidCh = TRUE;
		break;
	case eDcomSpwCh3:
		puliDcomAddr = (alt_u32 *) DCOM_CH_3_BASE_ADDR;
		bValidCh = TRUE;
		break;
	case eDcomSpwCh4:
		puliDcomAddr = (alt_u32 *) DCOM_CH_4_BASE_ADDR;
		bValidCh = TRUE;
		break;
	case eDcomSpwCh5:
		puliDcomAddr = (alt_u32 *) DCOM_CH_5_BASE_ADDR;
		bValidCh = TRUE;
		break;
	case eDcomSpwCh6:
		puliDcomAddr = (alt_u32 *) DCOM_CH_6_BASE_ADDR;
		bValidCh = TRUE;
		break;
	case eDcomSpwCh7:
		puliDcomAddr = (alt_u32 *) DCOM_CH_7_BASE_ADDR;
		bValidCh = TRUE;
		break;
	case eDcomSpwCh8:
		puliDcomAddr = (alt_u32 *) DCOM_CH_8_BASE_ADDR;
		bValidCh = TRUE;
		break;
	default:
		bValidCh = FALSE;
		break;
	}

	if (bValidCh) {
		uliReg = uliDcomReadReg(puliDcomAddr, DCOM_IRQ_CTRL_REG_OFST);

		if (bGlobalIrqEnable) {
			uliReg |= DCOM_IRQ_CTRL_GLOBAL_EN_MSK;
		} else {
			uliReg &= (~DCOM_IRQ_CTRL_GLOBAL_EN_MSK);
		}

		vDcomWriteReg(puliDcomAddr, DCOM_IRQ_CTRL_REG_OFST, uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDcomInitCh(TDcomChannel *pxDcomCh, alt_u8 ucDcomCh) {
	bool bStatus = FALSE;
	bool bInitFail = FALSE;

	if (!bDatbInitCh(&(pxDcomCh->xDataBuffer), ucDcomCh)) {
		bInitFail = TRUE;
	}
	if (!bDctrInitCh(&(pxDcomCh->xDataController), ucDcomCh)) {
		bInitFail = TRUE;
	}
	if (!vDctrInitIrq(ucDcomCh)) {
		bInitFail = TRUE;
	}
	if (!bDschInitCh(&(pxDcomCh->xDataScheduler), ucDcomCh)) {
		bInitFail = TRUE;
	}
	if (!bSpwcInitCh(&(pxDcomCh->xSpacewire), ucDcomCh)) {
		bInitFail = TRUE;
	}

	if (!bInitFail) {
		bStatus = TRUE;
	}

	return bStatus;
}
//! [public functions]

//! [private functions]
static ALT_INLINE void ALT_ALWAYS_INLINE vDcomWriteReg(alt_u32 *puliBaseAddr,
		alt_u32 uliRegOffset, alt_u32 uliRegValue) {
	*(puliBaseAddr + uliRegOffset) = uliRegValue;
}

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDcomReadReg(
		alt_u32 *puliBaseAddr, alt_u32 uliRegOffset) {
	volatile alt_u32 uliRegValue;

	uliRegValue = *(puliBaseAddr + uliRegOffset);
	return uliRegValue;
}
//! [private functions]
