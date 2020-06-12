/*
 * dcom.h
 *
 *  Created on: 31/03/2019
 *      Author: rfranca
 */

#ifndef DCOM_H_
#define DCOM_H_

#include "../../simucam_definitions.h"

//! [constants definition]
// irq numbers
#define DCOM_CH_1_TX_IRQ                8
#define DCOM_CH_2_TX_IRQ                9
#define DCOM_CH_3_TX_IRQ                11
#define DCOM_CH_4_TX_IRQ                10
#define DCOM_CH_5_TX_IRQ                12
#define DCOM_CH_6_TX_IRQ                14
#define DCOM_CH_7_TX_IRQ                13
#define DCOM_CH_8_TX_IRQ                15

// address
#define DCOM_CH_1_BASE_ADDR              DUMB_COMMUNICATION_MODULE_V2_1_BASE
#define DCOM_CH_2_BASE_ADDR              DUMB_COMMUNICATION_MODULE_V2_2_BASE
#define DCOM_CH_3_BASE_ADDR              DUMB_COMMUNICATION_MODULE_V2_3_BASE
#define DCOM_CH_4_BASE_ADDR              DUMB_COMMUNICATION_MODULE_V2_4_BASE
#define DCOM_CH_5_BASE_ADDR              DUMB_COMMUNICATION_MODULE_V2_5_BASE
#define DCOM_CH_6_BASE_ADDR              DUMB_COMMUNICATION_MODULE_V2_6_BASE
#define DCOM_CH_7_BASE_ADDR              DUMB_COMMUNICATION_MODULE_V2_7_BASE
#define DCOM_CH_8_BASE_ADDR              DUMB_COMMUNICATION_MODULE_V2_8_BASE

//! [constants definition]

//! [public module structs definition]
enum DcomSpwCh {
	eDcomSpwCh1 = 0,
	eDcomSpwCh2,
	eDcomSpwCh3,
	eDcomSpwCh4,
	eDcomSpwCh5,
	eDcomSpwCh6,
	eDcomSpwCh7,
	eDcomSpwCh8
} EDcomSpwCh;

/* Dcom Device Address Register Struct */
typedef struct DcomDevAddr {
	alt_u32 uliDevBaseAddr; /* Dcom Device Base Address */
} TDcomDevAddr;

/* Dcom IRQ Control Register Struct */
typedef struct DcomIrqControl {
	bool bGlobalIrqEn; /* Dcom Global IRQ Enable */
} TDcomIrqControl;

/* SpaceWire Device Address Register Struct */
typedef struct SpwcDevAddr {
	alt_u32 uliSpwcBaseAddr; /* SpaceWire Device Base Address */
} TSpwcDevAddr;

/* SpaceWire Link Config Register Struct */
typedef struct SpwcLinkConfig {
	bool bDisconnect; /* SpaceWire Link Config Disconnect */
	bool bLinkStart; /* SpaceWire Link Config Linkstart */
	bool bAutostart; /* SpaceWire Link Config Autostart */
	alt_u8 ucTxDivCnt; /* SpaceWire Link Config TxDivCnt */
} TSpwcLinkConfig;

/* SpaceWire Link Status Register Struct */
typedef struct SpwcLinkStatus {
	bool bRunning; /* SpaceWire Link Running */
	bool bConnecting; /* SpaceWire Link Connecting */
	bool bStarted; /* SpaceWire Link Started */
} TSpwcLinkStatus;

/* SpaceWire Link Status Register Struct */
typedef struct SpwcLinkError {
	bool bDisconnect; /* SpaceWire Error Disconnect */
	bool bParity; /* SpaceWire Error Parity */
	bool bEscape; /* SpaceWire Error Escape */
	bool bCredit; /* SpaceWire Error Credit */
} TSpwcLinkError;

/* SpaceWire Timecode Control Register Struct */
typedef struct SpwcTimecodeControl {
	alt_u8 ucTxTime; /* SpaceWire Timecode Tx Time */
	alt_u8 ucTxControl; /* SpaceWire Timecode Tx Control */
	bool bTxSend; /* SpaceWire Timecode Tx Send */
	bool bRxReceivedClr; /* SpaceWire Timecode Rx Received Clear */
} TSpwcTimecodeControl;

/* SpaceWire Timecode Status Register Struct */
typedef struct SpwcTimecodeStatus {
	alt_u8 ucRxTime; /* SpaceWire Timecode Rx Time */
	alt_u8 ucRxControl; /* SpaceWire Timecode Rx Control */
	bool bRxReceived; /* SpaceWire Timecode Rx Received */
} TSpwcTimecodeStatus;

/* Data Scheduler Device Address Register Struct */
typedef struct DschDevAddr {
	alt_u32 uliDschBaseAddr; /* Data Scheduler Device Base Address */
} TDschDevAddr;

/* Data Scheduler Timer Control Register Struct */
typedef struct DschTimerControl {
	bool bStart; /* Data Scheduler Timer Start */
	bool bRun; /* Data Scheduler Timer Run */
	bool bStop; /* Data Scheduler Timer Stop */
	bool bClear; /* Data Scheduler Timer Clear */
} TDschTimerControl;

/* Data Scheduler Timer Config Register Struct */
typedef struct DschTimerConfig {
	bool bStartOnSync; /* Data Scheduler Timer Start on Sync */
	alt_u32 uliClockDiv; /* Data Scheduler Timer Clock Div */
	alt_u32 uliStartTime; /* Data Scheduler Timer Start Time */
} TDschTimerConfig;

/* Data Scheduler Timer Status Register Struct */
typedef struct DschTimerStatus {
	bool bStopped; /* Data Scheduler Timer Stopped */
	bool bStarted; /* Data Scheduler Timer Started */
	bool bRunning; /* Data Scheduler Timer Running */
	bool bCleared; /* Data Scheduler Timer Cleared */
	alt_u32 uliCurrentTime; /* Data Scheduler Timer Time */
} TDschTimerStatus;

/* Data Scheduler Packet Config Register Struct */
typedef struct DschPacketConfig {
	bool bSendEop; /* Data Scheduler Send EOP with Packet */
	bool bSendEep; /* Data Scheduler Send EEP with Packet */
} TDschPacketConfig;

/* Data Scheduler Buffer Status Register Struct */
typedef struct DschBufferStatus {
	alt_u16 usiUsedBytes; /* Data Scheduler Buffer Used [Bytes] */
	bool bEmpty; /* Data Scheduler Buffer Empty */
	bool bFull; /* Data Scheduler Buffer Full */
} TDschBufferStatus;

/* Data Scheduler IRQ Control Register Struct */
typedef struct DschIrqControl {
	bool bTxEndEn; /* Data Scheduler Tx End IRQ Enable */
	bool bTxBeginEn; /* Data Scheduler Tx Begin IRQ Enable */
} TDschIrqControl;

/* Data Scheduler IRQ Flags Register Struct */
typedef struct DschIrqFlag {
	bool bTxEndFlag; /* Data Scheduler Tx End IRQ Flag */
	bool bTxBeginFlag; /* Data Scheduler Tx Begin IRQ Flag */
} TDschIrqFlag;

/* Data Scheduler IRQ Flags Clear Register Struct */
typedef struct DschIrqFlagClr {
	bool bTxEndFlagClr; /* Data Scheduler Tx End IRQ Flag Clear */
	bool bTxBeginFlagClr; /* Data Scheduler Tx Begin IRQ Flag Clear */
} TDschIrqFlagClr;

/* RMAP Device Address Register Struct */
typedef struct RmapDevAddr {
	alt_u32 uliRmapBaseAddr; /* RMAP Device Base Address */
} TRmapDevAddr;

/* RMAP Codec Config Register Struct */
typedef struct RmapCodecConfig {
	alt_u8 ucLogicalAddress; /* RMAP Target Logical Address */
	alt_u8 ucKey; /* RMAP Target Key */
} TRmapCodecConfig;

/* RMAP Codec Status Register Struct */
typedef struct RmapCodecStatus {
	bool bCommandReceived; /* RMAP Status Command Received */
	bool bWriteRequested; /* RMAP Status Write Requested */
	bool bWriteAuthorized; /* RMAP Status Write Authorized */
	bool bReadRequested; /* RMAP Status Read Requested */
	bool bReadAuthorized; /* RMAP Status Read Authorized */
	bool bReplySended; /* RMAP Status Reply Sended */
	bool bDiscardedPackage; /* RMAP Status Discarded Package */
} TRmapCodecStatus;

/* RMAP Codec Status Register Struct */
typedef struct RmapCodecError {
	bool bEarlyEop; /* RMAP Error Early EOP */
	bool bEep; /* RMAP Error EEP */
	bool bHeaderCRC; /* RMAP Error Header CRC */
	bool bUnusedPacketType; /* RMAP Error Unused Packet Type */
	bool bInvalidCommandCode; /* RMAP Error Invalid Command Code */
	bool bTooMuchData; /* RMAP Error Too Much Data */
	bool bInvalidDataCrc; /* RMAP Error Invalid Data CRC */
} TRmapCodecError;

/* RMAP Memory Area Config Struct */
typedef struct RmapMemAreaConfig {
	alt_u32 uliAddrOffset; /* RMAP Memory Area Address Offset */
} TRmapMemAreaConfig;

/* General Struct for SpW Channel Registers Access */
typedef struct SpwcChannel {
	TSpwcDevAddr xSpwcDevAddr;
	TSpwcLinkConfig xSpwcLinkConfig;
	TSpwcLinkStatus xSpwcLinkStatus;
	TSpwcLinkError xSpwcLinkError;
	TSpwcTimecodeControl xSpwcTimecodeControl;
	TSpwcTimecodeStatus xSpwcTimecodeStatus;
} TSpwcChannel;

/* General Struct for Data Scheduler Registers Access */
typedef struct DschChannel {
	TDschDevAddr xDschDevAddr;
	TDschTimerControl xDschTimerControl;
	TDschTimerConfig xDschTimerConfig;
	TDschTimerStatus xDschTimerStatus;
	TDschPacketConfig xDschPacketConfig;
	TDschBufferStatus xDschBufferStatus;
	TDschIrqControl xDschIrqControl;
	TDschIrqFlag xDschIrqFlag;
	TDschIrqFlagClr xDschIrqFlagClr;
} TDschChannel;

/* General Struct for RMAP Registers Access */
typedef struct RmapChannel {
	TRmapDevAddr xRmapDevAddr;
	TRmapCodecConfig xRmapCodecConfig;
	TRmapCodecStatus xRmapCodecStatus;
	TRmapCodecError xRmapCodecError;
	TRmapMemAreaConfig xRmapMemAreaConfig;
} TRmapChannel;

/* General Struct for Communication Module Registers Access */
typedef struct DcomChannel {
	TDcomDevAddr xDcomDevAddr;
	TDcomIrqControl xDcomIrqControl;
	TSpwcChannel xSpacewire;
	TDschChannel xDataScheduler;
	TRmapChannel xRmap;
} TDcomChannel;

//! [public module structs definition]

//! [public function prototypes]
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* DCOM_H_ */
