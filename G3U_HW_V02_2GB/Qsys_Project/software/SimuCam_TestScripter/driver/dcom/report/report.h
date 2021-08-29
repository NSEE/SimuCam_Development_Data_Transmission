/*
 * report.h
 *
 *  Created on: 2 de fev de 2021
 *      Author: rfranca
 */

#ifndef DRIVER_DCOM_REPORT_REPORT_H_
#define DRIVER_DCOM_REPORT_REPORT_H_

#include "../dcom.h"

//! [constants definition]
//! [constants definition]

//! [public module structs definition]
//! [public module structs definition]

//! [public function prototypes]

void vRprtCh1IrqHandler(void* pvContext);
void vRprtCh2IrqHandler(void* pvContext);
void vRprtCh3IrqHandler(void* pvContext);
void vRprtCh4IrqHandler(void* pvContext);
void vRprtCh5IrqHandler(void* pvContext);
void vRprtCh6IrqHandler(void* pvContext);
void vRprtCh7IrqHandler(void* pvContext);
void vRprtCh8IrqHandler(void* pvContext);

bool bRprtInitIrq(alt_u8 ucDcomCh);

bool bRprtGetIrqControl(TRprtChannel *pxRprtCh);
bool bRprtSetIrqControl(TRprtChannel *pxRprtCh);

bool bRprtGetIrqFlags(TRprtChannel *pxRprtCh);

bool bRprtSetIrqFlagClr(TRprtChannel *pxRprtCh);

bool bRprtInitCh(TRprtChannel *pxRprtCh, alt_u8 ucDcomCh);

//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* DRIVER_DCOM_REPORT_REPORT_H_ */
