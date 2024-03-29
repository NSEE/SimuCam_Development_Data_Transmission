/*
 * reset.c
 *
 *  Created on: 28/12/2018
 *      Author: rfranca
 */

#include "reset.h"

//! [private function prototypes]
static void vRstcWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue);
static alt_u32 uliRstReadReg(alt_u32 *puliAddr, alt_u32 uliOffset);
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
void vRstcSimucamReset(alt_u16 usiRstCnt) {
	alt_u32 uliReg = 0;

	uliReg |= (alt_u32) (usiRstCnt & RSTC_SIMUCAM_RST_TMR_MSK);
	uliReg |= (alt_u32) RSTC_SIMUCAM_RST_CTRL_MSK;
	vRstcWriteReg((alt_u32*) RSTC_CONTROLLER_BASE_ADDR,
	RSTC_SIMUCAM_RESET_REG_OFFSET, uliReg);
}

void vRstcReleaseDeviceReset(alt_u32 usiRstMask) {
	alt_u32 uliReg = 0;

	uliReg = uliRstReadReg((alt_u32*) RSTC_CONTROLLER_BASE_ADDR,
	RSTC_DEVICE_RESET_REG_OFFSET);
	uliReg &= ~((alt_u32) usiRstMask);
	vRstcWriteReg((alt_u32*) RSTC_CONTROLLER_BASE_ADDR,
	RSTC_DEVICE_RESET_REG_OFFSET, uliReg);
}

void vRstcHoldDeviceReset(alt_u32 usiRstMask) {
	alt_u32 uliReg = 0;

	uliReg = uliRstReadReg((alt_u32*) RSTC_CONTROLLER_BASE_ADDR,
	RSTC_DEVICE_RESET_REG_OFFSET);
	uliReg |= (alt_u32) usiRstMask;
	vRstcWriteReg((alt_u32*) RSTC_CONTROLLER_BASE_ADDR,
	RSTC_DEVICE_RESET_REG_OFFSET, uliReg);
}
//! [public functions]

//! [private functions]
static void vRstcWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue) {
	*(puliAddr + uliOffset) = uliValue;
}

static alt_u32 uliRstReadReg(alt_u32 *puliAddr, alt_u32 uliOffset) {
	alt_u32 uliValue;

	uliValue = *(puliAddr + uliOffset);
	return uliValue;
}
//! [private functions]

