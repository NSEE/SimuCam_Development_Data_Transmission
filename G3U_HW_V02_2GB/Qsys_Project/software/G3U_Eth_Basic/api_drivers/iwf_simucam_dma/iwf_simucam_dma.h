/*
 * iwf_simucam_dma.h
 *
 *  Created on: 01/04/2019
 *      Author: rfranca
 */

#ifndef IWF_SIMUCAM_DMA_H_
#define IWF_SIMUCAM_DMA_H_

#include "../../simucam_definitions.h"
#include "../../driver/msgdma/msgdma.h"

//! [constants definition]
// address
// spw channel 1 [a]
#define IDMA_CH_1_BUFF_BASE_ADDR_LOW  0x00000000
#define IDMA_CH_1_BUFF_BASE_ADDR_HIGH 0x00000001
#define IDMA_CH_1_BUFF_SPAN           0x7FFF
// spw channel 2 [b]
#define IDMA_CH_2_BUFF_BASE_ADDR_LOW  0x00010000
#define IDMA_CH_2_BUFF_BASE_ADDR_HIGH 0x00000001
#define IDMA_CH_2_BUFF_SPAN           0x7FFF
// spw channel 3 [c]
#define IDMA_CH_3_BUFF_BASE_ADDR_LOW  0x00020000
#define IDMA_CH_3_BUFF_BASE_ADDR_HIGH 0x00000001
#define IDMA_CH_3_BUFF_SPAN           0x7FFF
// spw channel 4 [d]
#define IDMA_CH_4_BUFF_BASE_ADDR_LOW  0x00030000
#define IDMA_CH_4_BUFF_BASE_ADDR_HIGH 0x00000001
#define IDMA_CH_4_BUFF_SPAN           0x7FFF
// spw channel 5 [e]
#define IDMA_CH_5_BUFF_BASE_ADDR_LOW  0x00040000
#define IDMA_CH_5_BUFF_BASE_ADDR_HIGH 0x00000001
#define IDMA_CH_5_BUFF_SPAN           0x7FFF
// spw channel 6 [f]
#define IDMA_CH_6_BUFF_BASE_ADDR_LOW  0x00050000
#define IDMA_CH_6_BUFF_BASE_ADDR_HIGH 0x00000001
#define IDMA_CH_6_BUFF_SPAN           0x7FFF
// spw channel 7 [g]
#define IDMA_CH_7_BUFF_BASE_ADDR_LOW  0x00060000
#define IDMA_CH_7_BUFF_BASE_ADDR_HIGH 0x00000001
#define IDMA_CH_7_BUFF_SPAN           0x7FFF
// spw channel 8 [h]
#define IDMA_CH_8_BUFF_BASE_ADDR_LOW  0x00070000
#define IDMA_CH_8_BUFF_BASE_ADDR_HIGH 0x00000001
#define IDMA_CH_8_BUFF_SPAN           0x7FFF
// ddr mem
#define IDMA_M1_BASE_ADDR_LOW           0x00000000
#define IDMA_M1_BASE_ADDR_HIGH          0x00000000
#define IDMA_M1_SPAN                    0x7FFFFFFF
#define IDMA_M2_BASE_ADDR_LOW           0x80000000
#define IDMA_M2_BASE_ADDR_HIGH          0x00000000
#define SDMA_M2_SPAN                    0x7FFFFFFF
//
#define IDMA_DMA_M1_NAME                DMA_DDR_M1_CSR_NAME
#define IDMA_DMA_M2_NAME                DMA_DDR_M2_CSR_NAME
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
bool bIdmaInitM1Dma(void);
bool bIdmaInitM2Dma(void);
alt_u16 bIdmaDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBytes, alt_u8 ucChBufferId);
alt_u16 bIdmaDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBytes, alt_u8 ucChBufferId);
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
