/*
 * data_controller.h
 *
 *  Created on: 31/03/2019
 *      Author: rfranca
 */

#ifndef DATA_CONTROLLER_H_
#define DATA_CONTROLLER_H_

#include "../dcom.h"
#include "../../../simucam_model.h"
#include "../data_scheduler/data_scheduler.h"

extern OS_EVENT *p_sub_unit_config_queue[8];
extern OS_EVENT *p_simucam_command_q;
extern OS_EVENT *p_dma_scheduler_controller_queue[2];
extern OS_EVENT *DMA_sched_queue[2];
extern OS_EVENT *p_echo_queue;
extern TDschChannel xSimucamTimer;
extern T_Simucam T_simucam;

//! [constants definition]
const alt_u8 cucDctrIrqFlagsQtd;
//! [constants definition]

//! [public module structs definition]
enum DctrIrqFlags {
	eTxEndFlag = 0,
	eTxBeginFlag
} EDctrIrqFlags;

typedef struct DctrIrqControl {
	bool bTxBeginEn;
	bool bTxEndEn;
} TDctrIrqControl;

typedef struct DctrIrqFlag {
	bool bTxBeginFlag;
	bool bTxEndFlag;
} TDctrIrqFlag;

typedef struct DctrControllerConfig {
	bool bSendEop;
	bool bSendEep;
} TDctrControllerConfig;

typedef struct DctrChannel {
	alt_u32 *puliDctrChAddr;
	TDctrIrqControl xIrqControl;
	TDctrIrqFlag xIrqFlag;
	TDctrControllerConfig xControllerConfig;
} TDctrChannel;
//! [public module structs definition]

//! [public function prototypes]
void vDctrCh1HandleIrq(void* pvContext);
void vDctrCh2HandleIrq(void* pvContext);
void vDctrCh3HandleIrq(void* pvContext);
void vDctrCh4HandleIrq(void* pvContext);
void vDctrCh5HandleIrq(void* pvContext);
void vDctrCh6HandleIrq(void* pvContext);
void vDctrCh7HandleIrq(void* pvContext);
void vDctrCh8HandleIrq(void* pvContext);

void vDctrCh1IrqFlagClr(alt_u8 ucIrqFlag);
void vDctrCh2IrqFlagClr(alt_u8 ucIrqFlag);
void vDctrCh3IrqFlagClr(alt_u8 ucIrqFlag);
void vDctrCh4IrqFlagClr(alt_u8 ucIrqFlag);
void vDctrCh5IrqFlagClr(alt_u8 ucIrqFlag);
void vDctrCh6IrqFlagClr(alt_u8 ucIrqFlag);
void vDctrCh7IrqFlagClr(alt_u8 ucIrqFlag);
void vDctrCh8IrqFlagClr(alt_u8 ucIrqFlag);

void vDctrCh1IrqFlag(bool *pbIrqFlags);
void vDctrCh2IrqFlag(bool *pbIrqFlags);
void vDctrCh3IrqFlag(bool *pbIrqFlags);
void vDctrCh4IrqFlag(bool *pbIrqFlags);
void vDctrCh5IrqFlag(bool *pbIrqFlags);
void vDctrCh6IrqFlag(bool *pbIrqFlags);
void vDctrCh7IrqFlag(bool *pbIrqFlags);
void vDctrCh8IrqFlag(bool *pbIrqFlags);

bool vDctrInitIrq(alt_u8 ucDcomCh);

// Set functions -> set data from channel variable to hardware
// Get functions -> get data from hardware to channel variable

bool bDctrSetIrqControl(TDctrChannel *pxDctrCh);
bool bDctrGetIrqControl(TDctrChannel *pxDctrCh);
bool bDctrGetIrqFlags(TDctrChannel *pxDctrCh);

bool bDctrSetControllerConfig(TDctrChannel *pxDctrCh);
bool bDctrGetControllerConfig(TDctrChannel *pxDctrCh);

bool bDctrInitCh(TDctrChannel *pxDctrCh, alt_u8 ucDcomCh);
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* DATA_CONTROLLER_H_ */
