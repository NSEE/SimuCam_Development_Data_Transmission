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
#define DCOM_CH_1_BASE_ADDR              DUMB_COMMUNICATION_MODULE_V1_CHA_BASE
#define DCOM_CH_2_BASE_ADDR              DUMB_COMMUNICATION_MODULE_V1_CHB_BASE
#define DCOM_CH_3_BASE_ADDR              DUMB_COMMUNICATION_MODULE_V1_CHC_BASE
#define DCOM_CH_4_BASE_ADDR              DUMB_COMMUNICATION_MODULE_V1_CHD_BASE
#define DCOM_CH_5_BASE_ADDR              DUMB_COMMUNICATION_MODULE_V1_CHE_BASE
#define DCOM_CH_6_BASE_ADDR              DUMB_COMMUNICATION_MODULE_V1_CHF_BASE
#define DCOM_CH_7_BASE_ADDR              DUMB_COMMUNICATION_MODULE_V1_CHG_BASE
#define DCOM_CH_8_BASE_ADDR              DUMB_COMMUNICATION_MODULE_V1_CHH_BASE
// address offset
#define DCOM_LINK_CFG_STAT_REG_OFST      0x00
#define DCOM_TIMECODE_REG_OFST           0x01
#define DCOM_DATA_BUFF_STAT_REG_OFST     0x02
#define DCOM_DATA_CRTLR_CFG_REG_OFST     0x03
#define DCOM_DATA_SCHTMR_CFG_REG_OFST    0x04
#define DCOM_DATA_SCHTMR_CLKDIV_REG_OFST 0x05
#define DCOM_DATA_SCHTMR_STAT_REG_OFST   0x06
#define DCOM_DATA_SCHTMR_TIME_REG_OFST   0x07
#define DCOM_DATA_SCHTMR_CTRL_REG_OFST   0x08
#define DCOM_IRQ_CTRL_REG_OFST           0x09
#define DCOM_IRQ_FLAG_REG_OFST           0x0A
#define DCOM_IRQ_FLAG_CLR_REG_OFST       0x0B
// bit masks
#define DCOM_SPW_LNKCFG_DISCONNECT_MSK   (1 << 0)
#define DCOM_SPW_LNKCFG_LINKSTART_MSK    (1 << 1)
#define DCOM_SPW_LNKCFG_AUTOSTART_MSK    (1 << 2)
#define DCOM_SPW_LNKSTAT_RUNNING_MSK     (1 << 8)
#define DCOM_SPW_LNKSTAT_CONNECTING_MSK  (1 << 9)
#define DCOM_SPW_LNKSTAT_STARTED_MSK     (1 << 10)
#define DCOM_SPW_LNKERR_DISCONNECT_MSK   (1 << 16)
#define DCOM_SPW_LNKERR_PARITY_MSK       (1 << 17)
#define DCOM_SPW_LNKERR_ESCAPE_MSK       (1 << 18)
#define DCOM_SPW_LNKERR_CREDIT_MSK       (1 << 19)
#define DCOM_SPW_LNKCFG_TXDIVCNT_MSK     (0xFF << 24)

#define DCOM_TC_TX_TIME_MSK              (0b111111 << 0)
#define DCOM_TC_TX_CONTROL_MSK           (0b11 << 6)
#define DCOM_TC_TX_SEND_MSK              (1 << 8)
#define DCOM_TC_RX_TIME_MSK              (0b111111 << 16)
#define DCOM_TC_RX_CONTROL_MSK           (0b11 << 22)
#define DCOM_TC_RX_RECEIVED_MSK          (1 << 24)

#define DCOM_DATA_BUFF_STAT_USED_MSK     (0xFFFF << 0)
#define DCOM_DATA_BUFF_STAT_EMPTY_MSK    (1 << 16)
#define DCOM_DATA_BUFF_STAT_FULL_MSK     (1 << 17)

#define DCOM_DATA_CTRLR_CFG_SEND_EOP_MSK (1 << 0)
#define DCOM_DATA_CTRLR_CFG_SEND_EEP_MSK (1 << 1)

#define DCOM_DATA_SCHTMR_CFG_STSYNC_MSK  (1 << 0)

#define DCOM_DATA_SCHTMR_CLKDIV_MSK      (0xFFFFFFFF << 0)

#define DCOM_DATA_SCHTMR_ST_STOPPED_MSK  (1 << 0)
#define DCOM_DATA_SCHTMR_ST_STARTED_MSK  (1 << 1)
#define DCOM_DATA_SCHTMR_ST_RUNNING_MSK  (1 << 2)
#define DCOM_DATA_SCHTMR_ST_CLEARED_MSK  (1 << 3)

#define DCOM_DATA_SCHTMR_TIME_MSK        (0xFFFFFFFF << 0)

#define DCOM_DATA_SCHTMR_CTRL_START_MSK  (1 << 0)
#define DCOM_DATA_SCHTMR_CTRL_RUN_MSK    (1 << 1)
#define DCOM_DATA_SCHTMR_CTRL_STOP_MSK   (1 << 2)
#define DCOM_DATA_SCHTMR_CTRL_CLR_MSK    (1 << 3)

#define DCOM_IRQ_CTRL_TX_END_EN_MSK      (1 << 0)
#define DCOM_IRQ_CTRL_TX_BEGIN_EN_MSK    (1 << 1)
#define DCOM_IRQ_CTRL_GLOBAL_EN_MSK      (1 << 8)

#define DCOM_IRQ_FLG_TX_END_FLAG_MSK     (1 << 0)
#define DCOM_IRQ_FLG_TX_BEGIN_FLAG_MSK   (1 << 1)

#define DCOM_IRQ_FC_TX_END_FLG_CLR_MSK   (1 << 0)
#define DCOM_IRQ_FC_TX_BEGIN_FLG_CLR_MSK (1 << 1)
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
