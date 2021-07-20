/*
 * iwf_simucam_dma.c
 *
 *  Created on: 01/04/2019
 *      Author: rfranca
 */

#include "iwf_simucam_dma.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [public functions]
bool bIdmaInitCh1Dma(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bIdmaInitCh2Dma(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bIdmaInitCh3Dma(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bIdmaInitCh4Dma(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bIdmaInitCh5Dma(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bIdmaInitCh6Dma(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bIdmaInitCh7Dma(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bIdmaInitCh8Dma(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bIdmaResetChDma(alt_u8 ucChBufferId, bool bWait) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel = NULL;

	switch (ucChBufferId) {
	case eIdmaCh1Buffer:
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_1_BASE_ADDR);
		break;
	case eIdmaCh2Buffer:
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_2_BASE_ADDR);
		break;
	case eIdmaCh3Buffer:
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_3_BASE_ADDR);
		break;
	case eIdmaCh4Buffer:
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_4_BASE_ADDR);
		break;
	case eIdmaCh5Buffer:
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_5_BASE_ADDR);
		break;
	case eIdmaCh6Buffer:
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_6_BASE_ADDR);
		break;
	case eIdmaCh7Buffer:
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_7_BASE_ADDR);
		break;
	case eIdmaCh8Buffer:
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_8_BASE_ADDR);
		break;
	default:
		vpxDcomChannel = NULL;
		break;
	}

	if (vpxDcomChannel != NULL) {

		vpxDcomChannel->xDataScheduler.xDschDataControl.bRdReset = TRUE;
		if (bWait) {
			/* wait for the avm controller to be free */
			while (vpxDcomChannel->xDataScheduler.xDschDataStatus.bRdBusy) {
				alt_busy_sleep(1); /* delay 1us */
			}
		}
		bStatus = TRUE;

	}

	return bStatus;
}

bool bSdmaResetFtdiDma(bool bWait) {
	bool bStatusRx = FALSE;
	bool bStatusTx = FALSE;
	bool bStatus = FALSE;

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) (FTDI_MODULE_BASE_ADDR);

	vpxFtdiModule->xFtdiRxDataControl.bRxWrReset = TRUE;
	if (bWait) {
		// wait for the avm controller to be free
		while (vpxFtdiModule->xFtdiRxDataStatus.bRxWrBusy) {
			alt_busy_sleep(1); /* delay 1us */
		}
	}
	bStatusRx = TRUE;

	vpxFtdiModule->xFtdiTxDataControl.bTxRdReset = TRUE;
	if (bWait) {
		// wait for the avm controller to be free
		while (vpxFtdiModule->xFtdiTxDataStatus.bTxRdBusy) {
			alt_busy_sleep(1); /* delay 1us */
		}
	}
	bStatusTx = TRUE;

	if ((bStatusRx) && (bStatusTx)) {
		bStatus = TRUE;
	}

	return (bStatus);
}

alt_u32 uliIdmaChDmaTransfer(alt_u8 ucDdrMemId, alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBytes, alt_u8 ucChBufferId) {
	alt_u32 uliProgramedTransferSize = 0;

	volatile TDcomChannel *vpxDcomChannel = NULL;

	union Ddr2MemoryAddress unMemoryAddress;

	bool bMemoryFlag = FALSE;
	bool bAddressFlag = FALSE;
	bool bChannelFlag = FALSE;
	;
	bool bNotBusyFlag = FALSE;

	alt_u32 uliRoundedTransferSizeInBytes = 0;

	switch (ucDdrMemId) {
	case eDdr2Memory1:
		unMemoryAddress.ulliMemAddr64b = DDR2_M1_BASE_ADDR + (alt_u64) ((alt_u32) uliDdrInitialAddr);
		bMemoryFlag = TRUE;
		break;
	case eDdr2Memory2:
		unMemoryAddress.ulliMemAddr64b = DDR2_M2_BASE_ADDR + (alt_u64) ((alt_u32) uliDdrInitialAddr);
		bMemoryFlag = TRUE;
		break;
	default:
		bMemoryFlag = FALSE;
		break;
	}

	/* Verify if the base address is a multiple o DSCH_DATA_ACCESS_WIDTH_BYTES (DSCH_DATA_ACCESS_WIDTH_BYTES = 8 bytes = 64b = size of memory access) */
	if (unMemoryAddress.ulliMemAddr64b % DSCH_DATA_ACCESS_WIDTH_BYTES) {
		/* Address is not a multiple of DSCH_DATA_ACCESS_WIDTH_BYTES */
		bAddressFlag = FALSE;
	} else {
		bAddressFlag = TRUE;
	}

	switch (ucChBufferId) {
	case eIdmaCh1Buffer:
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_1_BASE_ADDR);
		bChannelFlag = TRUE;
		break;
	case eIdmaCh2Buffer:
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_2_BASE_ADDR);
		bChannelFlag = TRUE;
		break;
	case eIdmaCh3Buffer:
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_3_BASE_ADDR);
		bChannelFlag = TRUE;
		break;
	case eIdmaCh4Buffer:
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_4_BASE_ADDR);
		bChannelFlag = TRUE;
		break;
	case eIdmaCh5Buffer:
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_5_BASE_ADDR);
		bChannelFlag = TRUE;
		break;
	case eIdmaCh6Buffer:
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_6_BASE_ADDR);
		bChannelFlag = TRUE;
		break;
	case eIdmaCh7Buffer:
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_7_BASE_ADDR);
		bChannelFlag = TRUE;
		break;
	case eIdmaCh8Buffer:
		vpxDcomChannel = (TDcomChannel *) (DCOM_CH_8_BASE_ADDR);
		bChannelFlag = TRUE;
		break;
	default:
		bChannelFlag = FALSE;
		break;
	}

	if (!vpxDcomChannel->xDataScheduler.xDschDataStatus.bRdBusy) {
		bNotBusyFlag = TRUE;
	}

	/* Rounding up the size to the nearest multiple of DSCH_DATA_ACCESS_WIDTH_BYTES (DSCH_DATA_ACCESS_WIDTH_BYTES = 8 bytes = 64b = size of memory access) */
	if (uliTransferSizeInBytes % DSCH_DATA_ACCESS_WIDTH_BYTES) {
		/* Transfer size is not a multiple of DSCH_DATA_ACCESS_WIDTH_BYTES */
		uliRoundedTransferSizeInBytes = (alt_u32) ((uliTransferSizeInBytes & DSCH_DATA_TRANSFER_SIZE_MASK ) + DSCH_DATA_ACCESS_WIDTH_BYTES );
	} else {
		uliRoundedTransferSizeInBytes = uliTransferSizeInBytes;
	}

	if ((bMemoryFlag) && (bAddressFlag) && (bChannelFlag) && (bNotBusyFlag)) {

		/* reset the avm controller */
		bIdmaResetChDma(ucChBufferId, TRUE);

		/* start new transfer */
		vpxDcomChannel->xDataScheduler.xDschDataControl.uliRdInitAddrLowDword = unMemoryAddress.uliMemAddr32b[0];
		vpxDcomChannel->xDataScheduler.xDschDataControl.uliRdInitAddrHighDword = unMemoryAddress.uliMemAddr32b[1];
		/* HW use zero as reference for transfer size, need to decrement one word from the total transfer size */
		vpxDcomChannel->xDataScheduler.xDschDataControl.uliRdDataLenghtBytes = uliRoundedTransferSizeInBytes - DSCH_DATA_ACCESS_WIDTH_BYTES;
		vpxDcomChannel->xDataScheduler.xDschDataControl.bRdStart = TRUE;
		uliProgramedTransferSize = uliRoundedTransferSizeInBytes;

	}
	return (uliProgramedTransferSize);
}

bool bSdmaFtdiDmaTransfer(alt_u8 ucDdrMemId, alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBytes, alt_u8 ucFtdiOperation) {
	bool bStatus = FALSE;

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) (FTDI_MODULE_BASE_ADDR);

	union Ddr2MemoryAddress unMemoryAddress;

	bool bMemoryFlag = FALSE;
	bool bAddressFlag = FALSE;
	bool bOperationFlag = FALSE;
	bool bNotBusyFlag = FALSE;
	bool bTransferSizeFlag = FALSE;

	alt_u32 uliRoundedTransferSizeInBytes = 0;

	switch (ucDdrMemId) {
	case eDdr2Memory1:
		unMemoryAddress.ulliMemAddr64b = DDR2_M1_BASE_ADDR + (alt_u64) ((alt_u32) uliDdrInitialAddr);
		bMemoryFlag = TRUE;
		break;
	case eDdr2Memory2:
		unMemoryAddress.ulliMemAddr64b = DDR2_M2_BASE_ADDR + (alt_u64) ((alt_u32) uliDdrInitialAddr);
		bMemoryFlag = TRUE;
		break;
	default:
		bMemoryFlag = FALSE;
		break;
	}

	/* Verify if the base address is a multiple o FTDI_DATA_ACCESS_WIDTH_BYTES (DSCH_DATA_ACCESS_WIDTH_BYTES = 32 bytes = 256b = size of memory access) */
	if (unMemoryAddress.ulliMemAddr64b % FTDI_DATA_ACCESS_WIDTH_BYTES) {
		/* Address is not a multiple of FTDI_DATA_ACCESS_WIDTH_BYTES */
		bAddressFlag = FALSE;
	} else {
		bAddressFlag = TRUE;
	}

	switch (ucFtdiOperation) {
	case eSdmaTxFtdi:
		bOperationFlag = TRUE;
		bNotBusyFlag = !(vpxFtdiModule->xFtdiTxDataStatus.bTxRdBusy);
		break;
	case eSdmaRxFtdi:
		bOperationFlag = TRUE;
		bNotBusyFlag = !(vpxFtdiModule->xFtdiRxDataStatus.bRxWrBusy);
		break;
	default:
		bOperationFlag = FALSE;
		bNotBusyFlag = FALSE;
		break;
	}

	if ((FTDI_TRANSFER_MIN_BYTES <= uliTransferSizeInBytes) && (FTDI_TRANSFER_MAX_BYTES >= uliTransferSizeInBytes)) {
		bTransferSizeFlag = TRUE;
		/* Rounding up the size to the nearest multiple of FTDI_DATA_ACCESS_WIDTH_BYTES (FTDI_DATA_ACCESS_WIDTH_BYTES = 32 bytes = 256b = size of memory access) */
		if (uliTransferSizeInBytes % FTDI_DATA_ACCESS_WIDTH_BYTES) {
			/* Transfer size is not a multiple of DSCH_DATA_ACCESS_WIDTH_BYTES */
			uliRoundedTransferSizeInBytes = (alt_u32) ((uliTransferSizeInBytes & FTDI_DATA_TRANSFER_SIZE_MASK ) + FTDI_DATA_ACCESS_WIDTH_BYTES );
		} else {
			uliRoundedTransferSizeInBytes = uliTransferSizeInBytes;
		}
	}

	if ((bMemoryFlag) && (bAddressFlag) && (bOperationFlag) && (bNotBusyFlag) && (bTransferSizeFlag)) {

		// reset the avm controller
		bSdmaResetFtdiDma(TRUE);

		if (eSdmaTxFtdi == ucFtdiOperation) {
			// start new transfer
			vpxFtdiModule->xFtdiTxDataControl.uliTxRdInitAddrLowDword = unMemoryAddress.uliMemAddr32b[0];
			vpxFtdiModule->xFtdiTxDataControl.uliTxRdInitAddrHighDword = unMemoryAddress.uliMemAddr32b[1];
			/* HW use zero as reference for transfer size, need to decrement one word from the total transfer size */
			vpxFtdiModule->xFtdiTxDataControl.uliTxRdDataLenghtBytes = uliRoundedTransferSizeInBytes - FTDI_DATA_ACCESS_WIDTH_BYTES;
			vpxFtdiModule->xFtdiTxDataControl.bTxRdStart = TRUE;
			bStatus = TRUE;
		} else {
			// start new transfer
			vpxFtdiModule->xFtdiRxDataControl.uliRxWrInitAddrLowDword = unMemoryAddress.uliMemAddr32b[0];
			vpxFtdiModule->xFtdiRxDataControl.uliRxWrInitAddrHighDword = unMemoryAddress.uliMemAddr32b[1];
			/* HW use zero as reference for transfer size, need to decrement one word from the total transfer size */
			vpxFtdiModule->xFtdiRxDataControl.uliRxWrDataLenghtBytes = uliRoundedTransferSizeInBytes - FTDI_DATA_ACCESS_WIDTH_BYTES;
			vpxFtdiModule->xFtdiRxDataControl.bRxWrStart = TRUE;
			bStatus = TRUE;
		}

	}

	return (bStatus);
}

//! [public functions]

//! [private functions]
//! [private functions]
