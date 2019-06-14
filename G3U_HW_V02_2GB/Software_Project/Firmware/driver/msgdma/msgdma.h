/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2014 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
*                                                                             *
******************************************************************************/

#ifndef __MSGDMA_H__
#define __MSGDMA_H__

#include <altera_msgdma.h>
#include "../../simucam_definitions.h"
//#include "../../utils/configs_simucam.h"

#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/*******************************************************************************
 *  Public API
 ******************************************************************************/

int iMsgdmaExtendedDescriptorAsyncTransfer(
	alt_msgdma_dev *pxDev,
	alt_msgdma_extended_descriptor *pxDesc);

int iMsgdmaConstructExtendedMmToMmDescriptor (
	alt_msgdma_dev *pxDev,
	alt_msgdma_extended_descriptor *pxDescriptor,
	alt_u32 *puliReadAddress,
	alt_u32 *puliWriteAddress,
	alt_u32 uliLength,
	alt_u32 uliControl,
	alt_u32 *puliReadAddressHigh,
	alt_u32 *puliWriteAddressHigh,
	alt_u16 usiSequenceNumber,
	alt_u8 ucReadBurstCount,
	alt_u8 ucWriteBurstCount,
	alt_u16 usiReadStride,
	alt_u16 usiWriteStride);

int iMsgdmaExtendedDescriptorSyncTransfer(
	alt_msgdma_dev *pxDev,
	alt_msgdma_extended_descriptor *pxDesc);

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __MSGDMA_H__ */
