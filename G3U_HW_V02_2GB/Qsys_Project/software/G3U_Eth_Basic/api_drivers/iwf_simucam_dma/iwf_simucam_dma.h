/*
 * iwf_simucam_dma.h
 *
 *  Created on: 01/04/2019
 *      Author: rfranca
 */

#ifndef IWF_SIMUCAM_DMA_H_
#define IWF_SIMUCAM_DMA_H_

#include "../../simucam_definitions.h"
#include "../../api_drivers/ddr2/ddr2.h"
#include "../../driver/dcom/data_scheduler/data_scheduler.h"

//! [constants definition]
//! [constants definition]

//! [public module structs definition]
enum IdmaChBufferId {
	eIdmaCh1Buffer = 0,
	eIdmaCh2Buffer = 1,
	eIdmaCh3Buffer = 2,
	eIdmaCh4Buffer = 3,
	eIdmaCh5Buffer = 4,
	eIdmaCh6Buffer = 5,
	eIdmaCh7Buffer = 6,
	eIdmaCh8Buffer = 7
} EIdmaChBufferId;
//! [public module structs definition]

//! [public function prototypes]
bool bIdmaInitCh1Dma(void);
bool bIdmaInitCh2Dma(void);
bool bIdmaInitCh3Dma(void);
bool bIdmaInitCh4Dma(void);
bool bIdmaInitCh5Dma(void);
bool bIdmaInitCh6Dma(void);
bool bIdmaInitCh7Dma(void);
bool bIdmaInitCh8Dma(void);
bool bIdmaResetChDma(alt_u8 ucChBufferId, bool bWait);
alt_u32 uliIdmaChDmaTransfer(alt_u8 ucDdrMemId, alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBytes, alt_u8 ucChBufferId);
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]


#endif /* IWF_SIMUCAM_DMA_H_ */
