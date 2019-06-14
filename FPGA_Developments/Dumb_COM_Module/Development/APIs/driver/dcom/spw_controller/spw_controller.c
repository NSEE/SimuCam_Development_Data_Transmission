/*
 * spw_controller.c
 *
 *  Created on: 01/04/2019
 *      Author: rfranca
 */

#include "spw_controller.h"

//! [private function prototypes]
static ALT_INLINE void ALT_ALWAYS_INLINE vSpwcWriteReg(alt_u32 *puliBaseAddr, alt_u32 uliRegOffset, alt_u32 uliRegValue);
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliSpwcReadReg(alt_u32 *puliBaseAddr, alt_u32 uliRegOffset);
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliSpwcSetRegCtrl(alt_u32 uliRegValue, alt_u32 uliCtrlMask, bool bCtrlValue);
static ALT_INLINE bool ALT_ALWAYS_INLINE bSpwcGetRegFlag(alt_u32 uliRegValue, alt_u32 uliFlagMask);
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliSpwcSetRegField(alt_u32 uliRegValue, alt_u32 uliFieldMask, alt_u8 ucFieldOffset, alt_u32 uliFieldValue);
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliSpwcGetRegField(alt_u32 uliRegValue, alt_u32 uliFieldMask, alt_u8 ucFieldOffset);
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
bool bSpwcSetLink(TSpwcChannel *pxSpwcCh){
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxSpwcCh != NULL) {
		uliReg = uliSpwcReadReg(pxSpwcCh->puliSpwcChAddr, (alt_u32)(DCOM_LINK_CFG_STAT_REG_OFST));

		uliReg = uliSpwcSetRegCtrl(uliReg, (alt_u32)(DCOM_SPW_LNKCFG_DISCONNECT_MSK), pxSpwcCh->xLinkConfig.bDisconnect);
		uliReg = uliSpwcSetRegCtrl(uliReg, (alt_u32)(DCOM_SPW_LNKCFG_LINKSTART_MSK), pxSpwcCh->xLinkConfig.bLinkStart);
		uliReg = uliSpwcSetRegCtrl(uliReg, (alt_u32)(DCOM_SPW_LNKCFG_AUTOSTART_MSK), pxSpwcCh->xLinkConfig.bAutostart);
		uliReg = uliSpwcSetRegField(uliReg, (alt_u32)(DCOM_SPW_LNKCFG_TXDIVCNT_MSK), 24, (alt_u32)(pxSpwcCh->xLinkConfig.ucTxDivCnt));

		vSpwcWriteReg(pxSpwcCh->puliSpwcChAddr, (alt_u32)(DCOM_LINK_CFG_STAT_REG_OFST), uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bSpwcGetLink(TSpwcChannel *pxSpwcCh){
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxSpwcCh != NULL) {
		uliReg = uliSpwcReadReg(pxSpwcCh->puliSpwcChAddr, (alt_u32)(DCOM_LINK_CFG_STAT_REG_OFST));

		pxSpwcCh->xLinkConfig.bDisconnect = bSpwcGetRegFlag(uliReg, (alt_u32)(DCOM_SPW_LNKCFG_DISCONNECT_MSK));
		pxSpwcCh->xLinkConfig.bLinkStart = bSpwcGetRegFlag(uliReg, (alt_u32)(DCOM_SPW_LNKCFG_LINKSTART_MSK));
		pxSpwcCh->xLinkConfig.bAutostart = bSpwcGetRegFlag(uliReg, (alt_u32)(DCOM_SPW_LNKCFG_AUTOSTART_MSK));
		pxSpwcCh->xLinkConfig.ucTxDivCnt = (alt_u8)(uliSpwcGetRegField(uliReg, (alt_u32)(DCOM_SPW_LNKCFG_TXDIVCNT_MSK), 24));

		bStatus = TRUE;
	}

	return bStatus;
}

bool bSpwcGetLinkError(TSpwcChannel *pxSpwcCh){
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxSpwcCh != NULL) {
		uliReg = uliSpwcReadReg(pxSpwcCh->puliSpwcChAddr, (alt_u32)(DCOM_LINK_CFG_STAT_REG_OFST));

		pxSpwcCh->xLinkError.bDisconnect = bSpwcGetRegFlag(uliReg, (alt_u32)(DCOM_SPW_LNKERR_DISCONNECT_MSK));
		pxSpwcCh->xLinkError.bParity = bSpwcGetRegFlag(uliReg, (alt_u32)(DCOM_SPW_LNKERR_PARITY_MSK));
		pxSpwcCh->xLinkError.bEscape = bSpwcGetRegFlag(uliReg, (alt_u32)(DCOM_SPW_LNKERR_ESCAPE_MSK));
		pxSpwcCh->xLinkError.bCredit = bSpwcGetRegFlag(uliReg, (alt_u32)(DCOM_SPW_LNKERR_CREDIT_MSK));

		bStatus = TRUE;
	}

	return bStatus;
}

bool bSpwcGetLinkStatus(TSpwcChannel *pxSpwcCh){
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxSpwcCh != NULL) {
		uliReg = uliSpwcReadReg(pxSpwcCh->puliSpwcChAddr, (alt_u32)(DCOM_LINK_CFG_STAT_REG_OFST));

		pxSpwcCh->xLinkStatus.bRunning = bSpwcGetRegFlag(uliReg, (alt_u32)(DCOM_SPW_LNKSTAT_RUNNING_MSK));
		pxSpwcCh->xLinkStatus.bConnecting = bSpwcGetRegFlag(uliReg, (alt_u32)(DCOM_SPW_LNKSTAT_CONNECTING_MSK));
		pxSpwcCh->xLinkStatus.bStarted = bSpwcGetRegFlag(uliReg, (alt_u32)(DCOM_SPW_LNKSTAT_STARTED_MSK));

		bStatus = TRUE;
	}

	return bStatus;
}

bool bSpwcSetTxTimecode(TSpwcChannel *pxSpwcCh){
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxSpwcCh != NULL) {
		uliReg = uliSpwcReadReg(pxSpwcCh->puliSpwcChAddr, (alt_u32)(DCOM_TIMECODE_REG_OFST));

		uliReg = uliSpwcSetRegField(uliReg, (alt_u32)(DCOM_TC_TX_TIME_MSK), 0, (alt_u32)(pxSpwcCh->xTxTimecode.ucCounter));
		uliReg = uliSpwcSetRegField(uliReg, (alt_u32)(DCOM_TC_TX_CONTROL_MSK), 6, (alt_u32)(pxSpwcCh->xTxTimecode.ucControl));
		uliReg = uliSpwcSetRegCtrl(uliReg, (alt_u32)(DCOM_TC_TX_SEND_MSK), pxSpwcCh->xTxTimecode.bTransmit);

		vSpwcWriteReg(pxSpwcCh->puliSpwcChAddr, (alt_u32)(DCOM_TIMECODE_REG_OFST), uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bSpwcGetTxTimecode(TSpwcChannel *pxSpwcCh){
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxSpwcCh != NULL) {
		uliReg = uliSpwcReadReg(pxSpwcCh->puliSpwcChAddr, (alt_u32)(DCOM_TIMECODE_REG_OFST));

		pxSpwcCh->xTxTimecode.ucCounter = (alt_u8)(uliSpwcGetRegField(uliReg, (alt_u32)(DCOM_TC_TX_TIME_MSK), 0));
		pxSpwcCh->xTxTimecode.ucControl = (alt_u8)(uliSpwcGetRegField(uliReg, (alt_u32)(DCOM_TC_TX_CONTROL_MSK), 6));
		pxSpwcCh->xTxTimecode.bTransmit = bSpwcGetRegFlag(uliReg, (alt_u32)(DCOM_TC_TX_SEND_MSK));

		bStatus = TRUE;
	}

	return bStatus;
}

bool bSpwcGetRxTimecode(TSpwcChannel *pxSpwcCh){
		bool bStatus = FALSE;
		volatile alt_u32 uliReg = 0;

		if (pxSpwcCh != NULL) {
			uliReg = uliSpwcReadReg(pxSpwcCh->puliSpwcChAddr, (alt_u32)(DCOM_TIMECODE_REG_OFST));

			pxSpwcCh->xRxTimecode.ucCounter = (alt_u8)(uliSpwcGetRegField(uliReg, (alt_u32)(DCOM_TC_RX_TIME_MSK), 16));
			pxSpwcCh->xRxTimecode.ucControl = (alt_u8)(uliSpwcGetRegField(uliReg, (alt_u32)(DCOM_TC_RX_CONTROL_MSK), 22));
			pxSpwcCh->xRxTimecode.bReceived = bSpwcGetRegFlag(uliReg, (alt_u32)(DCOM_TC_RX_RECEIVED_MSK));

			uliReg = uliSpwcSetRegCtrl(uliReg, (alt_u32)(DCOM_TC_RX_RECEIVED_MSK), TRUE);
			vSpwcWriteReg(pxSpwcCh->puliSpwcChAddr, (alt_u32)(DCOM_TIMECODE_REG_OFST), uliReg);

			bStatus = TRUE;
		}

		return bStatus;
}

bool bSpwcInitCh(TSpwcChannel *pxSpwcCh, alt_u8 ucDcomCh){
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;

	if (pxSpwcCh != NULL) {

		switch (ucDcomCh) {
		case eDcomSpwCh1:
			pxSpwcCh->puliSpwcChAddr = (alt_u32 *) DCOM_CH_1_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh2:
			pxSpwcCh->puliSpwcChAddr = (alt_u32 *) DCOM_CH_2_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh3:
			pxSpwcCh->puliSpwcChAddr = (alt_u32 *) DCOM_CH_3_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh4:
			pxSpwcCh->puliSpwcChAddr = (alt_u32 *) DCOM_CH_4_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh5:
			pxSpwcCh->puliSpwcChAddr = (alt_u32 *) DCOM_CH_5_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh6:
			pxSpwcCh->puliSpwcChAddr = (alt_u32 *) DCOM_CH_6_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh7:
			pxSpwcCh->puliSpwcChAddr = (alt_u32 *) DCOM_CH_7_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh8:
			pxSpwcCh->puliSpwcChAddr = (alt_u32 *) DCOM_CH_8_BASE_ADDR;
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}

		if (bValidCh) {
			if (!bSpwcGetLink(pxSpwcCh)) {
				bInitFail = TRUE;
			}
			if (!bSpwcGetLinkError(pxSpwcCh)) {
				bInitFail = TRUE;
			}
			if (!bSpwcGetLinkStatus(pxSpwcCh)) {
				bInitFail = TRUE;
			}
			if (!bSpwcGetTxTimecode(pxSpwcCh)) {
				bInitFail = TRUE;
			}
			if (!bSpwcGetRxTimecode(pxSpwcCh)) {
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
static ALT_INLINE void ALT_ALWAYS_INLINE vSpwcWriteReg(alt_u32 *puliBaseAddr, alt_u32 uliRegOffset, alt_u32 uliRegValue) {
	*(puliBaseAddr + uliRegOffset) = uliRegValue;
}

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliSpwcReadReg(alt_u32 *puliBaseAddr, alt_u32 uliRegOffset) {
	volatile alt_u32 uliRegValue;

	uliRegValue = *(puliBaseAddr + uliRegOffset);
	return uliRegValue;
}

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliSpwcSetRegCtrl(alt_u32 uliRegValue, alt_u32 uliCtrlMask, bool bCtrlValue){
	alt_u32 uliReg = 0;

	if (bCtrlValue) {
		uliReg = uliRegValue | uliCtrlMask;
	} else {
		uliReg = uliRegValue & (~uliCtrlMask);
	}

	return uliReg;
}

static ALT_INLINE bool ALT_ALWAYS_INLINE bSpwcGetRegFlag(alt_u32 uliRegValue, alt_u32 uliFlagMask) {
	bool bFlag = FALSE;

	if (uliRegValue & uliFlagMask) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliSpwcSetRegField(alt_u32 uliRegValue, alt_u32 uliFieldMask, alt_u8 ucFieldOffset, alt_u32 uliFieldValue){
	alt_u32 uliReg = 0;

	uliReg = uliRegValue & (~uliFieldMask);
	uliReg |= uliFieldMask & (uliFieldValue << ucFieldOffset);

	return uliReg;
}

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliSpwcGetRegField(alt_u32 uliRegValue, alt_u32 uliFieldMask, alt_u8 ucFieldOffset) {
	alt_u32 uliFieldValue = 0;

	uliFieldValue = (uliRegValue & uliFieldMask) >> ucFieldOffset;

	return uliFieldValue;
}
//! [private functions]
