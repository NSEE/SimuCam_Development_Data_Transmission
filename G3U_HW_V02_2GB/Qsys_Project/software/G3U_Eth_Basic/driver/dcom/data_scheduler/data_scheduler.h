/*
 * data_scheduler.h
 *
 *  Created on: 19/12/2018
 *      Author: rfranca
 */

#ifndef DATA_SCHEDULER_H_
#define DATA_SCHEDULER_H_

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
#define DSCH_DATA_ACCESS_WIDTH_BYTES     (alt_u32)8
#define DSCH_DATA_TRANSFER_SIZE_MASK     (alt_u32)0xFFFFFFF8
#define DSCH_DATA_BUFFER_LENGTH_BYTES    (alt_u16)16384
//! [constants definition]

//! [public module structs definition]
//! [public module structs definition]

//! [public function prototypes]
void vDschCh1HandleIrq(void* pvContext);
void vDschCh2HandleIrq(void* pvContext);
void vDschCh3HandleIrq(void* pvContext);
void vDschCh4HandleIrq(void* pvContext);
void vDschCh5HandleIrq(void* pvContext);
void vDschCh6HandleIrq(void* pvContext);
void vDschCh7HandleIrq(void* pvContext);
void vDschCh8HandleIrq(void* pvContext);

bool bDschInitIrq(alt_u8 ucDcomCh);

// Get functions -> get data from hardware to channel variable
// Set functions -> set data from channel variable to hardware

bool bDschGetTimerControl(TDschChannel *pxDschCh);
bool bDschSetTimerControl(TDschChannel *pxDschCh);

bool bDschGetTimerConfig(TDschChannel *pxDschCh);
bool bDschSetTimerConfig(TDschChannel *pxDschCh);

bool bDschGetTimerStatus(TDschChannel *pxDschCh);

bool bDschGetPacketConfig(TDschChannel *pxDschCh);
bool bDschSetPacketConfig(TDschChannel *pxDschCh);

bool bDschGetBufferStatus(TDschChannel *pxDschCh);

bool bDschGetDataControl(TDschChannel *pxDschCh);
bool bDschSetDataControl(TDschChannel *pxDschCh);

bool bDschDataEepInjection(TDschChannel *pxDschCh, alt_u32 uliEepErrorInjectionCnt);

bool bDschGetDataStatus(TDschChannel *pxDschCh);

bool bDschGetIrqControl(TDschChannel *pxDschCh);
bool bDschSetIrqControl(TDschChannel *pxDschCh);

bool bDschGetIrqFlags(TDschChannel *pxDschCh);

bool bDschStartTimer(TDschChannel *pxDschCh);
bool bDschRunTimer(TDschChannel *pxDschCh);
bool bDschStopTimer(TDschChannel *pxDschCh);
bool bDschClrTimer(TDschChannel *pxDschCh);

alt_u16 usiDschGetBuffersUsedSpace(TDschChannel *pxDschCh);
alt_u16 usiDschGetBuffersFreeSpace(TDschChannel *pxDschCh);

bool bDschInitCh(TDschChannel *pxDschCh, alt_u8 ucDcomCh);

//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* DATA_SCHEDULER_H_ */
