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
alt_msgdma_dev *pxDmaM1Dev = NULL;
alt_msgdma_dev *pxDmaM2Dev = NULL;
//! [data memory public global variables]

//! [public functions]
bool bIdmaInitM1Dma(void) {
	bool bStatus = FALSE;
	bool bFailDispatcher = FALSE;
	alt_u16 usiCounter = 0;

	// open dma device
	pxDmaM1Dev = alt_msgdma_open((char *) IDMA_DMA_M1_NAME);

	// check if the device was opened
	if (pxDmaM1Dev != NULL) {
		// device opened
		// reset the dispatcher
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaM1Dev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		while (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaM1Dev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK) {
			usleep(1);
			usiCounter++;
			if (5000 <= usiCounter) { //wait at most 5ms for the device to be reseted
				bFailDispatcher = TRUE;
				break;
			}
		}
		if (bFailDispatcher == FALSE)
			bStatus = TRUE;
	}

	return bStatus;
}

bool bIdmaInitM2Dma(void) {
	bool bStatus = FALSE;
	bool bFailDispatcher = FALSE;
	alt_u16 usiCounter = 0;

	// open dma device
	pxDmaM2Dev = alt_msgdma_open((char *) IDMA_DMA_M2_NAME);

	// check if the device was opened
	if (pxDmaM2Dev == NULL) {
		// device not opened
		bStatus = FALSE;
	} else {
		// device opened
		// reset the dispatcher
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaM2Dev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		while (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaM2Dev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK) {
			usleep(1);
			usiCounter++;
			if (5000 <= usiCounter) { //wait at most 5ms for the device to be reseted
				bFailDispatcher = TRUE;
				break;
			}
		}
		if (bFailDispatcher == FALSE)
			bStatus = TRUE;
	}
	return bStatus;
}

bool bIdmaDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBytes, alt_u8 ucChBufferId) {
	bool bStatus;

	alt_msgdma_extended_descriptor xDmaExtendedDescriptor;

	alt_u32 uliDestAddrLow = 0;
	alt_u32 uliDestAddrHigh = 0;

	alt_u32 uliSrcAddrLow = 0;
	alt_u32 uliSrcAddrHigh = 0;

	alt_u32 uliControlBits = 0x00000000;
	bool bChannelFlag;

	/* Assuming that the channel selected exist, change to FALSE if doesn't */
	bChannelFlag = TRUE;
	bStatus = FALSE;
	switch (ucChBufferId) {
	case eIdmaCh1Buffer:
		uliDestAddrLow = (alt_u32) IDMA_CH_1_BUFF_BASE_ADDR_LOW;
		uliDestAddrHigh = (alt_u32) IDMA_CH_1_BUFF_BASE_ADDR_HIGH;
		break;
	case eIdmaCh2Buffer:
		uliDestAddrLow = (alt_u32) IDMA_CH_2_BUFF_BASE_ADDR_LOW;
		uliDestAddrHigh = (alt_u32) IDMA_CH_2_BUFF_BASE_ADDR_HIGH;
		break;
	case eIdmaCh3Buffer:
		uliDestAddrLow = (alt_u32) IDMA_CH_3_BUFF_BASE_ADDR_LOW;
		uliDestAddrHigh = (alt_u32) IDMA_CH_3_BUFF_BASE_ADDR_HIGH;
		break;
	case eIdmaCh4Buffer:
		uliDestAddrLow = (alt_u32) IDMA_CH_4_BUFF_BASE_ADDR_LOW;
		uliDestAddrHigh = (alt_u32) IDMA_CH_4_BUFF_BASE_ADDR_HIGH;
		break;
	case eIdmaCh5Buffer:
		uliDestAddrLow = (alt_u32) IDMA_CH_5_BUFF_BASE_ADDR_LOW;
		uliDestAddrHigh = (alt_u32) IDMA_CH_5_BUFF_BASE_ADDR_HIGH;
		break;
	case eIdmaCh6Buffer:
		uliDestAddrLow = (alt_u32) IDMA_CH_6_BUFF_BASE_ADDR_LOW;
		uliDestAddrHigh = (alt_u32) IDMA_CH_6_BUFF_BASE_ADDR_HIGH;
		break;
	case eIdmaCh7Buffer:
		uliDestAddrLow = (alt_u32) IDMA_CH_7_BUFF_BASE_ADDR_LOW;
		uliDestAddrHigh = (alt_u32) IDMA_CH_7_BUFF_BASE_ADDR_HIGH;
		break;
	case eIdmaCh8Buffer:
		uliDestAddrLow = (alt_u32) IDMA_CH_8_BUFF_BASE_ADDR_LOW;
		uliDestAddrHigh = (alt_u32) IDMA_CH_8_BUFF_BASE_ADDR_HIGH;
		break;
	default:
		bChannelFlag = FALSE;
		break;
	}

	uliSrcAddrLow = (alt_u32) IDMA_M1_BASE_ADDR_LOW	+ (alt_u32) uliDdrInitialAddr;
	uliSrcAddrHigh = (alt_u32) IDMA_M1_BASE_ADDR_HIGH;

	if (bChannelFlag) {

		if (pxDmaM1Dev != NULL) {
			// hold transfers for descriptor fifo space
			while (0 != (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaM1Dev->csr_base) & ALTERA_MSGDMA_CSR_DESCRIPTOR_BUFFER_FULL_MASK)) {
				alt_busy_sleep(1); /* delay 1us */
			}
			/* Success = 0 */
			if (0 == iMsgdmaConstructExtendedMmToMmDescriptor(pxDmaM1Dev,
					&xDmaExtendedDescriptor, (alt_u32 *) uliSrcAddrLow, (alt_u32 *) uliDestAddrLow,
					usiTransferSizeInBytes, uliControlBits,	(alt_u32 *) uliSrcAddrHigh, (alt_u32 *) uliDestAddrHigh,
					1, 1, 1, 1, 1)	) {
				/* Success = 0 */
				if (0 == iMsgdmaExtendedDescriptorAsyncTransfer(pxDmaM1Dev,	&xDmaExtendedDescriptor)) {
					bStatus = TRUE;
				}
			}
		}
	}
	return bStatus;
}

bool bIdmaDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBytes, alt_u8 ucChBufferId) {
	bool bStatus;

	alt_msgdma_extended_descriptor xDmaExtendedDescriptor;

	alt_u32 uliDestAddrLow = 0;
	alt_u32 uliDestAddrHigh = 0;

	alt_u32 uliSrcAddrLow = 0;
	alt_u32 uliSrcAddrHigh = 0;

	alt_u32 uliControlBits = 0x00000000;
	bool bChannelFlag;


	/* Assuming that the channel selected exist, change to FALSE if doesn't */
	bChannelFlag = TRUE;
	bStatus = FALSE;
	switch (ucChBufferId) {
	case eIdmaCh1Buffer:
		uliDestAddrLow = (alt_u32) IDMA_CH_1_BUFF_BASE_ADDR_LOW;
		uliDestAddrHigh = (alt_u32) IDMA_CH_1_BUFF_BASE_ADDR_HIGH;
		break;
	case eIdmaCh2Buffer:
		uliDestAddrLow = (alt_u32) IDMA_CH_2_BUFF_BASE_ADDR_LOW;
		uliDestAddrHigh = (alt_u32) IDMA_CH_2_BUFF_BASE_ADDR_HIGH;
		break;
	case eIdmaCh3Buffer:
		uliDestAddrLow = (alt_u32) IDMA_CH_3_BUFF_BASE_ADDR_LOW;
		uliDestAddrHigh = (alt_u32) IDMA_CH_3_BUFF_BASE_ADDR_HIGH;
		break;
	case eIdmaCh4Buffer:
		uliDestAddrLow = (alt_u32) IDMA_CH_4_BUFF_BASE_ADDR_LOW;
		uliDestAddrHigh = (alt_u32) IDMA_CH_4_BUFF_BASE_ADDR_HIGH;
		break;
	case eIdmaCh5Buffer:
		uliDestAddrLow = (alt_u32) IDMA_CH_5_BUFF_BASE_ADDR_LOW;
		uliDestAddrHigh = (alt_u32) IDMA_CH_5_BUFF_BASE_ADDR_HIGH;
		break;
	case eIdmaCh6Buffer:
		uliDestAddrLow = (alt_u32) IDMA_CH_6_BUFF_BASE_ADDR_LOW;
		uliDestAddrHigh = (alt_u32) IDMA_CH_6_BUFF_BASE_ADDR_HIGH;
		break;
	case eIdmaCh7Buffer:
		uliDestAddrLow = (alt_u32) IDMA_CH_7_BUFF_BASE_ADDR_LOW;
		uliDestAddrHigh = (alt_u32) IDMA_CH_7_BUFF_BASE_ADDR_HIGH;
		break;
	case eIdmaCh8Buffer:
		uliDestAddrLow = (alt_u32) IDMA_CH_8_BUFF_BASE_ADDR_LOW;
		uliDestAddrHigh = (alt_u32) IDMA_CH_8_BUFF_BASE_ADDR_HIGH;
		break;
	default:
		bChannelFlag = FALSE;
		break;
	}

	uliSrcAddrLow = (alt_u32) IDMA_M2_BASE_ADDR_LOW	+ (alt_u32) uliDdrInitialAddr;
	uliSrcAddrHigh = (alt_u32) IDMA_M2_BASE_ADDR_HIGH;

	if (bChannelFlag) {
		if (pxDmaM2Dev != NULL) {

			while (0 != (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaM2Dev->csr_base) & ALTERA_MSGDMA_CSR_DESCRIPTOR_BUFFER_FULL_MASK)) {
				alt_busy_sleep(1); /* delay 1us */
			}
			/* Success = 0 */
			if ( 0 == iMsgdmaConstructExtendedMmToMmDescriptor(pxDmaM2Dev,
					&xDmaExtendedDescriptor, (alt_u32 *) uliSrcAddrLow, (alt_u32 *) uliDestAddrLow,
					usiTransferSizeInBytes, uliControlBits, (alt_u32 *) uliSrcAddrHigh, (alt_u32 *) uliDestAddrHigh,
					1, 1, 1, 1, 1)) {
				/* Success = 0 */
				if ( 0 == iMsgdmaExtendedDescriptorSyncTransfer(pxDmaM2Dev,
						&xDmaExtendedDescriptor)) {
					bStatus = TRUE;
				}
			}
		}
	}
	return bStatus;
}
//! [public functions]

//! [private functions]
//! [private functions]
