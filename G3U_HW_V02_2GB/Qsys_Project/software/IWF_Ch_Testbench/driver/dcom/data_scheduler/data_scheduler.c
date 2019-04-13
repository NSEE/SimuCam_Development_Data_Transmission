/*
 * data_scheduler.c
 *
 *  Created on: 01/04/2019
 *      Author: rfranca
 */

#include "data_scheduler.h"

//! [private function prototypes]
static ALT_INLINE void ALT_ALWAYS_INLINE vDschWriteReg(alt_u32 *puliBaseAddr, alt_u32 uliRegOffset, alt_u32 uliRegValue);
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDschReadReg(alt_u32 *puliBaseAddr, alt_u32 uliRegOffset);
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDschSetRegCtrl(alt_u32 uliRegValue, alt_u32 uliCtrlMask, bool bCtrlValue);
static ALT_INLINE bool ALT_ALWAYS_INLINE bDschGetRegFlag(alt_u32 uliRegValue, alt_u32 uliFlagMask);
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDschSetRegField(alt_u32 uliRegValue, alt_u32 uliFieldMask, alt_u8 ucFieldOffset, alt_u32 uliFieldValue);
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDschGetRegField(alt_u32 uliRegValue, alt_u32 uliFieldMask, alt_u8 ucFieldOffset);
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
bool bDschSetTimerConfig(TDschChannel *pxDschCh){
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxDschCh != NULL) {
		uliReg = uliDschReadReg(pxDschCh->puliDschChAddr, (alt_u32)(DCOM_DATA_SCHTMR_CFG_REG_OFST));
		uliReg = uliDschSetRegCtrl(uliReg, (alt_u32)(DCOM_DATA_SCHTMR_CFG_STSYNC_MSK), pxDschCh->xTimerConfig.bStartOnSync);
		vDschWriteReg(pxDschCh->puliDschChAddr, (alt_u32)(DCOM_DATA_CRTLR_CFG_REG_OFST), uliReg);

		uliReg = uliDschReadReg(pxDschCh->puliDschChAddr, (alt_u32)(DCOM_DATA_SCHTMR_CLKDIV_REG_OFST));
		uliReg = uliDschSetRegField(uliReg, (alt_u32)(DCOM_DATA_SCHTMR_CLKDIV_MSK), 0, pxDschCh->xTimerConfig.uliTimerDiv);
		vDschWriteReg(pxDschCh->puliDschChAddr, (alt_u32)(DCOM_DATA_SCHTMR_CLKDIV_REG_OFST), uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDschGetTimerConfig(TDschChannel *pxDschCh){
		bool bStatus = FALSE;
		volatile alt_u32 uliReg = 0;

		if (pxDschCh != NULL) {
			uliReg = uliDschReadReg(pxDschCh->puliDschChAddr, (alt_u32)(DCOM_DATA_SCHTMR_CFG_REG_OFST));
			pxDschCh->xTimerConfig.bStartOnSync = bDschGetRegFlag(uliReg, (alt_u32)(DCOM_DATA_SCHTMR_CFG_STSYNC_MSK));

			uliReg = uliDschReadReg(pxDschCh->puliDschChAddr, (alt_u32)(DCOM_DATA_SCHTMR_CLKDIV_REG_OFST));
			pxDschCh->xTimerConfig.uliTimerDiv = uliDschGetRegField(uliReg, (alt_u32)(DCOM_DATA_SCHTMR_CLKDIV_MSK), 0);

			bStatus = TRUE;
		}

		return bStatus;
}

bool bDschGetTimerStatus(TDschChannel *pxDschCh){
		bool bStatus = FALSE;
		volatile alt_u32 uliReg = 0;

		if (pxDschCh != NULL) {
			uliReg = uliDschReadReg(pxDschCh->puliDschChAddr, (alt_u32)(DCOM_DATA_SCHTMR_STAT_REG_OFST));

			pxDschCh->xTimerStatus.bStopped = bDschGetRegFlag(uliReg, (alt_u32)(DCOM_DATA_SCHTMR_ST_STOPPED_MSK));
			pxDschCh->xTimerStatus.bStarted = bDschGetRegFlag(uliReg, (alt_u32)(DCOM_DATA_SCHTMR_ST_STARTED_MSK));
			pxDschCh->xTimerStatus.bRunning = bDschGetRegFlag(uliReg, (alt_u32)(DCOM_DATA_SCHTMR_ST_RUNNING_MSK));
			pxDschCh->xTimerStatus.bCleared = bDschGetRegFlag(uliReg, (alt_u32)(DCOM_DATA_SCHTMR_ST_CLEARED_MSK));

			bStatus = TRUE;
		}

		return bStatus;
}

bool bDschSetTime(TDschChannel *pxDschCh, alt_u32 uliTime){
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxDschCh != NULL) {
		uliReg = uliDschReadReg(pxDschCh->puliDschChAddr, (alt_u32)(DCOM_DATA_SCHTMR_TIME_REG_OFST));
		uliReg = uliDschSetRegField(uliReg, (alt_u32)(DCOM_DATA_SCHTMR_TIME_MSK), 0, uliTime);
		vDschWriteReg(pxDschCh->puliDschChAddr, (alt_u32)(DCOM_DATA_SCHTMR_TIME_REG_OFST), uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

alt_u32 uliDschGetTime(TDschChannel *pxDschCh){
	alt_u32 uliTime = 0;
	volatile alt_u32 uliReg = 0;

	if (pxDschCh != NULL) {
		uliReg = uliDschReadReg(pxDschCh->puliDschChAddr, (alt_u32)(DCOM_DATA_SCHTMR_TIME_REG_OFST));
		uliTime = uliDschGetRegField(uliReg, (alt_u32)(DCOM_DATA_SCHTMR_TIME_MSK), 0);
	}

	return uliTime;
}

bool bDschStartTimer(TDschChannel *pxDschCh){
		bool bStatus = FALSE;
		volatile alt_u32 uliReg = 0;

		if (pxDschCh != NULL) {
			uliReg = uliDschReadReg(pxDschCh->puliDschChAddr, (alt_u32)(DCOM_DATA_SCHTMR_CTRL_REG_OFST));

			uliReg = uliDschSetRegCtrl(uliReg, (alt_u32)(DCOM_DATA_SCHTMR_CTRL_START_MSK), TRUE);

			vDschWriteReg(pxDschCh->puliDschChAddr, (alt_u32)(DCOM_DATA_SCHTMR_CTRL_REG_OFST), uliReg);

			bStatus = TRUE;
		}

		return bStatus;
}

bool bDschRunTimer(TDschChannel *pxDschCh){
		bool bStatus = FALSE;
		volatile alt_u32 uliReg = 0;

		if (pxDschCh != NULL) {
			uliReg = uliDschReadReg(pxDschCh->puliDschChAddr, (alt_u32)(DCOM_DATA_SCHTMR_CTRL_REG_OFST));

			uliReg = uliDschSetRegCtrl(uliReg, (alt_u32)(DCOM_DATA_SCHTMR_CTRL_RUN_MSK), TRUE);

			vDschWriteReg(pxDschCh->puliDschChAddr, (alt_u32)(DCOM_DATA_SCHTMR_CTRL_REG_OFST), uliReg);

			bStatus = TRUE;
		}

		return bStatus;
}

bool bDschStopTimer(TDschChannel *pxDschCh){
		bool bStatus = FALSE;
		volatile alt_u32 uliReg = 0;

		if (pxDschCh != NULL) {
			uliReg = uliDschReadReg(pxDschCh->puliDschChAddr, (alt_u32)(DCOM_DATA_SCHTMR_CTRL_REG_OFST));

			uliReg = uliDschSetRegCtrl(uliReg, (alt_u32)(DCOM_DATA_SCHTMR_CTRL_STOP_MSK), TRUE);

			vDschWriteReg(pxDschCh->puliDschChAddr, (alt_u32)(DCOM_DATA_SCHTMR_CTRL_REG_OFST), uliReg);

			bStatus = TRUE;
		}

		return bStatus;
}

bool bDschClrTimer(TDschChannel *pxDschCh){
		bool bStatus = FALSE;
		volatile alt_u32 uliReg = 0;

		if (pxDschCh != NULL) {
			uliReg = uliDschReadReg(pxDschCh->puliDschChAddr, (alt_u32)(DCOM_DATA_SCHTMR_CTRL_REG_OFST));

			uliReg = uliDschSetRegCtrl(uliReg, (alt_u32)(DCOM_DATA_SCHTMR_CTRL_CLR_MSK), TRUE);

			vDschWriteReg(pxDschCh->puliDschChAddr, (alt_u32)(DCOM_DATA_SCHTMR_CTRL_REG_OFST), uliReg);

			bStatus = TRUE;
		}

		return bStatus;
}

bool bDschInitCh(TDschChannel *pxDschCh, alt_u8 ucDcomCh){
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;

	if (pxDschCh != NULL) {

		switch (ucDcomCh) {
		case eDcomSpwCh1:
			pxDschCh->puliDschChAddr = (alt_u32 *) DCOM_CH_1_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh2:
			pxDschCh->puliDschChAddr = (alt_u32 *) DCOM_CH_2_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh3:
			pxDschCh->puliDschChAddr = (alt_u32 *) DCOM_CH_3_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh4:
			pxDschCh->puliDschChAddr = (alt_u32 *) DCOM_CH_4_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh5:
			pxDschCh->puliDschChAddr = (alt_u32 *) DCOM_CH_5_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh6:
			pxDschCh->puliDschChAddr = (alt_u32 *) DCOM_CH_6_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh7:
			pxDschCh->puliDschChAddr = (alt_u32 *) DCOM_CH_7_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh8:
			pxDschCh->puliDschChAddr = (alt_u32 *) DCOM_CH_8_BASE_ADDR;
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}

		if (bValidCh) {
			if (!bDschGetTimerConfig(pxDschCh)) {
				bInitFail = TRUE;
			}
			if (!bDschGetTimerStatus(pxDschCh)) {
				bInitFail = TRUE;
			}
			if (!bDschSetTime(pxDschCh, 0)) {
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
static ALT_INLINE void ALT_ALWAYS_INLINE vDschWriteReg(alt_u32 *puliBaseAddr, alt_u32 uliRegOffset, alt_u32 uliRegValue) {
	*(puliBaseAddr + uliRegOffset) = uliRegValue;
}

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDschReadReg(alt_u32 *puliBaseAddr, alt_u32 uliRegOffset) {
	volatile alt_u32 uliRegValue;

	uliRegValue = *(puliBaseAddr + uliRegOffset);
	return uliRegValue;
}

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDschSetRegCtrl(alt_u32 uliRegValue, alt_u32 uliCtrlMask, bool bCtrlValue){
	alt_u32 uliReg = 0;

	if (bCtrlValue) {
		uliReg = uliRegValue | uliCtrlMask;
	} else {
		uliReg = uliRegValue & (~uliCtrlMask);
	}

	return uliReg;
}

static ALT_INLINE bool ALT_ALWAYS_INLINE bDschGetRegFlag(alt_u32 uliRegValue, alt_u32 uliFlagMask) {
	bool bFlag = FALSE;

	if (uliRegValue & uliFlagMask) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDschSetRegField(alt_u32 uliRegValue, alt_u32 uliFieldMask, alt_u8 ucFieldOffset, alt_u32 uliFieldValue){
	alt_u32 uliReg = 0;

	uliReg = uliRegValue & (~uliFieldMask);
	uliReg |= uliFieldMask & (uliFieldValue << ucFieldOffset);

	return uliReg;
}

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDschGetRegField(alt_u32 uliRegValue, alt_u32 uliFieldMask, alt_u8 ucFieldOffset) {
	alt_u32 uliFieldValue = 0;

	uliFieldValue = (uliRegValue & uliFieldMask) >> ucFieldOffset;

	return uliFieldValue;
}
//! [private functions]
