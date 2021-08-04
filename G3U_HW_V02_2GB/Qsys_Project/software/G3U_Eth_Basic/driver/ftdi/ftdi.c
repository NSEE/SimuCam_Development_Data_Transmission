/*
 * ftdi.c
 *
 *  Created on: 5 de set de 2019
 *      Author: rfranca
 */

#include "ftdi.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
// A variable to hold the context of interrupt
static volatile int viRxBuffHoldContext;
static volatile int viTxBuffHoldContext;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]

void vFtdiRxIrqHandler(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* viRxBuffHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*viRxBuffHoldContext = ...;
	// if (*viRxBuffHoldContext == '0') {}...
	// App logic sequence...

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;

	/* Rx Half-CCD Received Flag */
	if (vpxFtdiModule->xFtdiRxIrqFlag.bRxHccdReceivedIrqFlag) {
		vpxFtdiModule->xFtdiRxIrqFlagClr.bRxHccdReceivedIrqFlagClr = TRUE;

		/* Rx Buffer Last Empty flag treatment */

	}

	/* Rx Half-CCD Communication Error Flag */
	if (vpxFtdiModule->xFtdiRxIrqFlag.bRxHccdCommErrIrqFlag) {
		vpxFtdiModule->xFtdiRxIrqFlagClr.bRxHccdCommErrIrqFlagClr = TRUE;

		/* Rx Communication Error flag treatment */

	}

}

void vFtdiTxIrqHandler(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* viTxBuffHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*viTxBuffHoldContext = ...;
	// if (*viTxBuffHoldContext == '0') {}...
	// App logic sequence...

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;

	/* Tx Finished Transmission Flag */
	if (vpxFtdiModule->xFtdiTxIrqFlag.bTxLutFinishedIrqFlag) {
		vpxFtdiModule->xFtdiTxIrqFlagClr.bTxLutFinishedIrqFlagClr = TRUE;

		/* Tx Finished Transmission flag treatment */

	}

	/* Tx Communication Error Flag */
	if (vpxFtdiModule->xFtdiTxIrqFlag.bTxLutCommErrIrqFlag) {
		vpxFtdiModule->xFtdiTxIrqFlagClr.bTxLutCommErrIrqFlagClr = TRUE;

		/* Tx Communication Error flag treatment */

	}

}

bool bFtdiRxIrqInit(void) {
	bool bStatus = FALSE;
	void* pvHoldContext;
	// Recast the hold_context pointer to match the alt_irq_register() function
	// prototype.
	pvHoldContext = (void*) &viRxBuffHoldContext;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	// Clear all flags
	vpxFtdiModule->xFtdiRxIrqFlagClr.bRxHccdReceivedIrqFlagClr = TRUE;
	vpxFtdiModule->xFtdiRxIrqFlagClr.bRxHccdCommErrIrqFlagClr = TRUE;
	// Register the interrupt handler
	if (0 == alt_irq_register(FTDI_RX_BUFFER_IRQ, pvHoldContext, vFtdiRxIrqHandler)) {
		bStatus = TRUE;
	}
	return bStatus;
}

bool bFtdiTxIrqInit(void) {
	bool bStatus = FALSE;
	void* pvHoldContext;
	// Recast the hold_context pointer to match the alt_irq_register() function
	// prototype.
	pvHoldContext = (void*) &viTxBuffHoldContext;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	// Clear all flags
	vpxFtdiModule->xFtdiTxIrqFlagClr.bTxLutFinishedIrqFlagClr = TRUE;
	vpxFtdiModule->xFtdiTxIrqFlagClr.bTxLutCommErrIrqFlagClr = TRUE;
	// Register the interrupt handler
	if (0 == alt_irq_register(FTDI_TX_BUFFER_IRQ, pvHoldContext, vFtdiTxIrqHandler)) {
		bStatus = TRUE;
	}
	return bStatus;
}

bool bFtdiRequestGenImgette(void) {
	bool bStatus = FALSE;

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;

	if ((FTDI_TRANSFER_MIN_BYTES <= FTDI_GEN_IMGT_SIZE_BYTES) && (FTDI_TRANSFER_MAX_BYTES >= FTDI_GEN_IMGT_SIZE_BYTES)) {
		/* Rounding up the size to the nearest multiple of FTDI_DATA_ACCESS_WIDTH_BYTES (FTDI_DATA_ACCESS_WIDTH_BYTES = 32 bytes = 256b = size of memory access) */
		if (FTDI_GEN_IMGT_SIZE_BYTES % FTDI_DATA_ACCESS_WIDTH_BYTES) {
			/* Transfer size is not a multiple of DSCH_DATA_ACCESS_WIDTH_BYTES */
			vpxFtdiModule->xFtdiPayloadConfig.uliRxPayRdForceLenBytes = (alt_u32) ((FTDI_GEN_IMGT_SIZE_BYTES & FTDI_DATA_TRANSFER_SIZE_MASK ) + FTDI_DATA_ACCESS_WIDTH_BYTES );
		} else {
			vpxFtdiModule->xFtdiPayloadConfig.uliRxPayRdForceLenBytes = FTDI_GEN_IMGT_SIZE_BYTES;
		}
	}

	vpxFtdiModule->xFtdiHalfCcdReqControl.ucHalfCcdFeeNumber   = 0;
	vpxFtdiModule->xFtdiHalfCcdReqControl.ucHalfCcdCcdNumber   = 0;
	vpxFtdiModule->xFtdiHalfCcdReqControl.ucHalfCcdCcdSide     = 1; /* Use to invert the Dwords Bytes! */
	vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdExpNumber  = 0;
	vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdCcdWidth   = 0;
	vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdCcdHeight  = 0;
	vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdReqTimeout = FTDI_GEN_IMGT_REQ_TIMEOUT;
	vpxFtdiModule->xFtdiPayloadConfig.usiRxPayRdQqwordDly      = 0;
	vpxFtdiModule->xFtdiHalfCcdReqControl.bRequestHalfCcd      = TRUE;
	bStatus = TRUE;

	return bStatus;
}

void vFtdiResetGenImgette(void) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiHalfCcdReqControl.bRstHalfCcdController = TRUE;
}

void vFtdiChangeGenImgtHeaderEndianness(alt_u8 *pucHeaderByteAddr) {
	alt_u8 ucNewEndianessBytes[8] = {0, 0, 0, 0, 0, 0, 0, 0};
	ucNewEndianessBytes[0] = pucHeaderByteAddr[3];
	ucNewEndianessBytes[1] = pucHeaderByteAddr[2];
	ucNewEndianessBytes[2] = pucHeaderByteAddr[1];
	ucNewEndianessBytes[3] = pucHeaderByteAddr[0];
	ucNewEndianessBytes[4] = pucHeaderByteAddr[7];
	ucNewEndianessBytes[5] = pucHeaderByteAddr[6];
	ucNewEndianessBytes[6] = pucHeaderByteAddr[5];
	ucNewEndianessBytes[7] = pucHeaderByteAddr[4];
	pucHeaderByteAddr[0] = ucNewEndianessBytes[0];
	pucHeaderByteAddr[1] = ucNewEndianessBytes[1];
	pucHeaderByteAddr[2] = ucNewEndianessBytes[2];
	pucHeaderByteAddr[3] = ucNewEndianessBytes[3];
	pucHeaderByteAddr[4] = ucNewEndianessBytes[4];
	pucHeaderByteAddr[5] = ucNewEndianessBytes[5];
	pucHeaderByteAddr[6] = ucNewEndianessBytes[6];
	pucHeaderByteAddr[7] = ucNewEndianessBytes[7];
}

alt_u8 ucFtdiGetRxErrorCode(void) {
	alt_u8 ucErrorCode = 0;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	ucErrorCode = (alt_u8) (vpxFtdiModule->xFtdiRxCommError.usiRxCommErrCode);
	return ucErrorCode;
}

alt_u8 ucFtdiGetTxErrorCode(void) {
	alt_u8 ucErrorCode = 0;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	ucErrorCode = (alt_u8) (vpxFtdiModule->xFtdiTxCommError.usiTxLutCommErrCode);
	return ucErrorCode;
}

alt_u16 usiFtdiRxBufferUsedBytes(void) {
	alt_u32 usiBufferUsedBytes = 0;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	usiBufferUsedBytes = vpxFtdiModule->xFtdiRxBufferStatus.usiRxBuffUsedBytes;
	return usiBufferUsedBytes;
}

alt_u16 usiFtdiTxBufferUsedBytes(void) {
	alt_u32 usiBufferUsedBytes = 0;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	usiBufferUsedBytes = vpxFtdiModule->xFtdiTxBufferStatus.usiTxBuffUsedBytes;
	return usiBufferUsedBytes;
}

void vFtdiResetModule(alt_u32 uliWaitTimeUs) {
	IOWR_ALTERA_AVALON_PIO_DATA(PIO_ISO_LOGIC_SIGNAL_ENABLE_BASE, 0x00000001);
	usleep(uliWaitTimeUs);
	IOWR_ALTERA_AVALON_PIO_DATA(PIO_ISO_LOGIC_SIGNAL_ENABLE_BASE, 0x00000000);
}

void vFtdiStopModule(void) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiFtdiModuleControl.bModuleStop = TRUE;
}

void vFtdiStartModule(void) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiFtdiModuleControl.bModuleStart = TRUE;
}

void vFtdiClearModule(void) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiFtdiModuleControl.bModuleClear = TRUE;
}

void vFtdiAbortOperation(void) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiHalfCcdReqControl.bAbortHalfCcdReq = TRUE;
	vpxFtdiModule->xFtdiLutTransControl.bAbortLutTrans = TRUE;
}

void vFtdiIrqGlobalEn(bool bEnable) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiFtdiIrqControl.bFtdiGlobalIrqEn = bEnable;
}

void vFtdiIrqRxGenImgtReceivedEn(bool bEnable) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiRxIrqControl.bRxHccdReceivedIrqEn = bEnable;
}

void vFtdiIrqRxGenImgtCommErrEn(bool bEnable) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiRxIrqControl.bRxHccdCommErrIrqEn = bEnable;
}

//! [public functions]

//! [private functions]
//! [private functions]
