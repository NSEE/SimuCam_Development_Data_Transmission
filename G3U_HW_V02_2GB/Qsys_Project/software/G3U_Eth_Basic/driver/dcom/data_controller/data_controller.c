/*
 * data_controller.c
 *
 *  Created on: 31/03/2019
 *      Author: rfranca
 */

#include "data_controller.h"

//! [private function prototypes]
static ALT_INLINE void ALT_ALWAYS_INLINE vDctrWriteReg(alt_u32 *puliBaseAddr,
		alt_u32 uliRegOffset, alt_u32 uliRegValue);
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDctrReadReg(
		alt_u32 *puliBaseAddr, alt_u32 uliRegOffset);
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDctrSetRegCtrl(
		alt_u32 uliRegValue, alt_u32 uliCtrlMask, bool bCtrlValue);
static ALT_INLINE bool ALT_ALWAYS_INLINE bDctrGetRegFlag(alt_u32 uliRegValue,
		alt_u32 uliFlagMask);
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDctrSetRegField(
		alt_u32 uliRegValue, alt_u32 uliFieldMask, alt_u8 ucFieldOffset,
		alt_u32 uliFieldValue);
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDctrGetRegField(
		alt_u32 uliRegValue, alt_u32 uliFieldMask, alt_u8 ucFieldOffset);
//! [private function prototypes]

//! [data memory public global variables]
const alt_u8 cucDctrIrqFlagsQtd = 2;
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
// A variable to hold the context of interrupt
static volatile int viCh1HoldContext;
static volatile int viCh2HoldContext;
static volatile int viCh3HoldContext;
static volatile int viCh4HoldContext;
static volatile int viCh5HoldContext;
static volatile int viCh6HoldContext;
static volatile int viCh7HoldContext;
static volatile int viCh8HoldContext;
//! [data memory private global variables]
static _ethernet_payload xTemp;
static sub_config_t xSubTemp;

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
void vDctrCh1HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	// Get Irq Flags
	bool bIrqFlags[cucDctrIrqFlagsQtd];
	vDctrCh1IrqFlag(bIrqFlags);

	// Check Irq Buffer Empty Flags
	if (bIrqFlags[eTxEndFlag]) {

		/* Action to perform when Tx end Irq ocurred */
		T_simucam.T_Sub[0].T_conf.i_imagette_control++;
		T_simucam.T_Sub[0].T_conf.sub_status_sending = 0;

		if (T_simucam.T_Sub[0].T_conf.i_imagette_control
				>= T_simucam.T_Sub[0].T_data.nb_of_imagettes) {
			xSubTemp.mode = subAbort;
			OSQPost(p_sub_unit_config_queue[0], &xSubTemp);
		}

		vDctrCh1IrqFlagClr(eTxEndFlag);
	}
	if (bIrqFlags[eTxBeginFlag]) {
		T_simucam.T_Sub[0].T_conf.sub_status_sending = 1;
		/* Action to perform when Tx begin Irq ocurred */
		if (T_simucam.T_Sub[0].T_data.i_imagette
				< T_simucam.T_Sub[0].T_data.nb_of_imagettes) {
			OSQPost(DMA_sched_queue[0], 0);
			xTemp.type = simDMA1Sched;
			OSQPost(p_simucam_command_q, &xTemp);
		}

		vDctrCh1IrqFlagClr(eTxBeginFlag);
	}

}

void vDctrCh2HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	// Get Irq Flags
	bool bIrqFlags[cucDctrIrqFlagsQtd];
	vDctrCh2IrqFlag(bIrqFlags);

	// Check Irq Buffer Empty Flags
	if (bIrqFlags[eTxEndFlag]) {

		/* Action to perform when Tx end Irq ocurred */

		T_simucam.T_Sub[1].T_conf.i_imagette_control++;
		T_simucam.T_Sub[1].T_conf.sub_status_sending = 0;
		if (T_simucam.T_Sub[1].T_conf.i_imagette_control
				>= T_simucam.T_Sub[1].T_data.nb_of_imagettes) {
			xSubTemp.mode = subAbort;
			OSQPost(p_sub_unit_config_queue[1], &xSubTemp);
			T_simucam.T_Sub[1].T_conf.i_imagette_control = 0;
		}
		vDctrCh2IrqFlagClr(eTxEndFlag);
	}
	if (bIrqFlags[eTxBeginFlag]) {
		T_simucam.T_Sub[1].T_conf.sub_status_sending = 1;
		/* Action to perform when Tx begin Irq ocurred */
		if (T_simucam.T_Sub[1].T_data.i_imagette
				< T_simucam.T_Sub[1].T_data.nb_of_imagettes) {
			OSQPost(DMA_sched_queue[0], 1);
			xTemp.type = simDMA1Sched;
			OSQPost(p_simucam_command_q, &xTemp);
		}

		vDctrCh2IrqFlagClr(eTxBeginFlag);
	}

}

void vDctrCh3HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...

	// Get Irq Flags
	bool bIrqFlags[cucDctrIrqFlagsQtd];
	vDctrCh3IrqFlag(bIrqFlags);

	// Check Irq Buffer Empty Flags
	if (bIrqFlags[eTxEndFlag]) {

		/* Action to perform when Tx end Irq ocurred */
		T_simucam.T_Sub[2].T_conf.i_imagette_control++;
		T_simucam.T_Sub[2].T_conf.sub_status_sending = 0;
		if (T_simucam.T_Sub[2].T_conf.i_imagette_control
				>= T_simucam.T_Sub[2].T_data.nb_of_imagettes) {
			xSubTemp.mode = subAbort;
			OSQPost(p_sub_unit_config_queue[2], &xSubTemp);
		}

		vDctrCh3IrqFlagClr(eTxEndFlag);
	}
	if (bIrqFlags[eTxBeginFlag]) {
		T_simucam.T_Sub[2].T_conf.sub_status_sending = 1;
		/* Action to perform when Tx begin Irq ocurred */
		if (T_simucam.T_Sub[2].T_data.i_imagette
				< T_simucam.T_Sub[2].T_data.nb_of_imagettes) {
			OSQPost(DMA_sched_queue[0], 2);
			xTemp.type = simDMA1Sched;
			OSQPost(p_simucam_command_q, &xTemp);
		}

		vDctrCh3IrqFlagClr(eTxBeginFlag);
	}

}

void vDctrCh4HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...

	// Get Irq Flags
	bool bIrqFlags[cucDctrIrqFlagsQtd];
	vDctrCh4IrqFlag(bIrqFlags);

	// Check Irq Buffer Empty Flags
	if (bIrqFlags[eTxEndFlag]) {

		/* Action to perform when Tx end Irq ocurred */
		T_simucam.T_Sub[3].T_conf.i_imagette_control++;
		T_simucam.T_Sub[3].T_conf.sub_status_sending = 0;
		if (T_simucam.T_Sub[3].T_conf.i_imagette_control
				>= T_simucam.T_Sub[3].T_data.nb_of_imagettes) {
			xSubTemp.mode = subAbort;
			OSQPost(p_sub_unit_config_queue[3], &xSubTemp);
		}

		vDctrCh4IrqFlagClr(eTxEndFlag);
	}
	if (bIrqFlags[eTxBeginFlag]) {
		T_simucam.T_Sub[3].T_conf.sub_status_sending = 1;
		/* Action to perform when Tx begin Irq ocurred */
		if (T_simucam.T_Sub[3].T_data.i_imagette
				< T_simucam.T_Sub[3].T_data.nb_of_imagettes) {
			OSQPost(DMA_sched_queue[0], 3);
			xTemp.type = simDMA1Sched;
			OSQPost(p_simucam_command_q, &xTemp);
		}

		vDctrCh4IrqFlagClr(eTxBeginFlag);
	}

}

void vDctrCh5HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...

	// Get Irq Flags
	bool bIrqFlags[cucDctrIrqFlagsQtd];
	vDctrCh5IrqFlag(bIrqFlags);

	// Check Irq Buffer Empty Flags
	if (bIrqFlags[eTxEndFlag]) {

		/* Action to perform when Tx end Irq ocurred */
		T_simucam.T_Sub[4].T_conf.i_imagette_control++;
		T_simucam.T_Sub[4].T_conf.sub_status_sending = 0;
		if (T_simucam.T_Sub[4].T_conf.i_imagette_control
				>= T_simucam.T_Sub[4].T_data.nb_of_imagettes) {
			xSubTemp.mode = subAbort;
			OSQPost(p_sub_unit_config_queue[4], &xSubTemp);
		}

		vDctrCh5IrqFlagClr(eTxEndFlag);
	}
	if (bIrqFlags[eTxBeginFlag]) {
		T_simucam.T_Sub[4].T_conf.sub_status_sending = 1;
		/* Action to perform when Tx begin Irq ocurred */
		if (T_simucam.T_Sub[4].T_data.i_imagette
				< T_simucam.T_Sub[4].T_data.nb_of_imagettes) {
			OSQPost(DMA_sched_queue[1], 4);
			xTemp.type = simDMA2Sched;
			OSQPost(p_simucam_command_q, &xTemp);
		}

		vDctrCh5IrqFlagClr(eTxBeginFlag);
	}

}

void vDctrCh6HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...

	// Get Irq Flags
	bool bIrqFlags[cucDctrIrqFlagsQtd];
	vDctrCh6IrqFlag(bIrqFlags);

	// Check Irq Buffer Empty Flags
	if (bIrqFlags[eTxEndFlag]) {

		/* Action to perform when Tx end Irq ocurred */
		T_simucam.T_Sub[5].T_conf.i_imagette_control++;
		T_simucam.T_Sub[5].T_conf.sub_status_sending = 0;
		if (T_simucam.T_Sub[5].T_conf.i_imagette_control
				>= T_simucam.T_Sub[5].T_data.nb_of_imagettes) {
			xSubTemp.mode = subAbort;
			OSQPost(p_sub_unit_config_queue[5], &xSubTemp);
		}

		vDctrCh6IrqFlagClr(eTxEndFlag);
	}
	if (bIrqFlags[eTxBeginFlag]) {
		T_simucam.T_Sub[5].T_conf.sub_status_sending = 1;
		/* Action to perform when Tx begin Irq ocurred */
		if (T_simucam.T_Sub[5].T_data.i_imagette
				< T_simucam.T_Sub[5].T_data.nb_of_imagettes) {
			OSQPost(DMA_sched_queue[1], 5);
			xTemp.type = simDMA2Sched;
			OSQPost(p_simucam_command_q, &xTemp);
		}

		vDctrCh6IrqFlagClr(eTxBeginFlag);
	}

}

void vDctrCh7HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...

	// Get Irq Flags
	bool bIrqFlags[cucDctrIrqFlagsQtd];
	vDctrCh7IrqFlag(bIrqFlags);

	// Check Irq Buffer Empty Flags
	if (bIrqFlags[eTxEndFlag]) {

		/* Action to perform when Tx end Irq ocurred */

		vDctrCh7IrqFlagClr(eTxEndFlag);
	}
	if (bIrqFlags[eTxBeginFlag]) {

		/* Action to perform when Tx begin Irq ocurred */

		vDctrCh7IrqFlagClr(eTxBeginFlag);
	}

}

void vDctrCh8HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...

	// Get Irq Flags
	bool bIrqFlags[cucDctrIrqFlagsQtd];
	vDctrCh8IrqFlag(bIrqFlags);

	// Check Irq Buffer Empty Flags
	if (bIrqFlags[eTxEndFlag]) {

		/* Action to perform when Tx end Irq ocurred */

		vDctrCh8IrqFlagClr(eTxEndFlag);
	}
	if (bIrqFlags[eTxBeginFlag]) {

		/* Action to perform when Tx begin Irq ocurred */

		vDctrCh8IrqFlagClr(eTxBeginFlag);
	}

}

void vDctrCh1IrqFlagClr(alt_u8 ucIrqFlag) {
	alt_u32 uliFlagClearMask = 0;

	switch (ucIrqFlag) {
	case eTxEndFlag:
		uliFlagClearMask = (alt_u32) (DCOM_IRQ_FC_TX_END_FLG_CLR_MSK);
		break;
	case eTxBeginFlag:
		uliFlagClearMask = (alt_u32) (DCOM_IRQ_FC_TX_BEGIN_FLG_CLR_MSK);
		break;
	default:
		uliFlagClearMask = 0;
		break;
	}

	vDctrWriteReg((alt_u32*) DCOM_CH_1_BASE_ADDR,
			(alt_u32) (DCOM_IRQ_FLAG_CLR_REG_OFST), uliFlagClearMask);
}

void vDctrCh2IrqFlagClr(alt_u8 ucIrqFlag) {
	alt_u32 uliFlagClearMask = 0;

	switch (ucIrqFlag) {
	case eTxEndFlag:
		uliFlagClearMask = (alt_u32) (DCOM_IRQ_FC_TX_END_FLG_CLR_MSK);
		break;
	case eTxBeginFlag:
		uliFlagClearMask = (alt_u32) (DCOM_IRQ_FC_TX_BEGIN_FLG_CLR_MSK);
		break;
	default:
		uliFlagClearMask = 0;
		break;
	}

	vDctrWriteReg((alt_u32*) DCOM_CH_2_BASE_ADDR,
			(alt_u32) (DCOM_IRQ_FLAG_CLR_REG_OFST), uliFlagClearMask);
}

void vDctrCh3IrqFlagClr(alt_u8 ucIrqFlag) {
	alt_u32 uliFlagClearMask = 0;

	switch (ucIrqFlag) {
	case eTxEndFlag:
		uliFlagClearMask = (alt_u32) (DCOM_IRQ_FC_TX_END_FLG_CLR_MSK);
		break;
	case eTxBeginFlag:
		uliFlagClearMask = (alt_u32) (DCOM_IRQ_FC_TX_BEGIN_FLG_CLR_MSK);
		break;
	default:
		uliFlagClearMask = 0;
		break;
	}

	vDctrWriteReg((alt_u32*) DCOM_CH_3_BASE_ADDR,
			(alt_u32) (DCOM_IRQ_FLAG_CLR_REG_OFST), uliFlagClearMask);
}

void vDctrCh4IrqFlagClr(alt_u8 ucIrqFlag) {
	alt_u32 uliFlagClearMask = 0;

	switch (ucIrqFlag) {
	case eTxEndFlag:
		uliFlagClearMask = (alt_u32) (DCOM_IRQ_FC_TX_END_FLG_CLR_MSK);
		break;
	case eTxBeginFlag:
		uliFlagClearMask = (alt_u32) (DCOM_IRQ_FC_TX_BEGIN_FLG_CLR_MSK);
		break;
	default:
		uliFlagClearMask = 0;
		break;
	}

	vDctrWriteReg((alt_u32*) DCOM_CH_4_BASE_ADDR,
			(alt_u32) (DCOM_IRQ_FLAG_CLR_REG_OFST), uliFlagClearMask);
}

void vDctrCh5IrqFlagClr(alt_u8 ucIrqFlag) {
	alt_u32 uliFlagClearMask = 0;

	switch (ucIrqFlag) {
	case eTxEndFlag:
		uliFlagClearMask = (alt_u32) (DCOM_IRQ_FC_TX_END_FLG_CLR_MSK);
		break;
	case eTxBeginFlag:
		uliFlagClearMask = (alt_u32) (DCOM_IRQ_FC_TX_BEGIN_FLG_CLR_MSK);
		break;
	default:
		uliFlagClearMask = 0;
		break;
	}

	vDctrWriteReg((alt_u32*) DCOM_CH_5_BASE_ADDR,
			(alt_u32) (DCOM_IRQ_FLAG_CLR_REG_OFST), uliFlagClearMask);
}

void vDctrCh6IrqFlagClr(alt_u8 ucIrqFlag) {
	alt_u32 uliFlagClearMask = 0;

	switch (ucIrqFlag) {
	case eTxEndFlag:
		uliFlagClearMask = (alt_u32) (DCOM_IRQ_FC_TX_END_FLG_CLR_MSK);
		break;
	case eTxBeginFlag:
		uliFlagClearMask = (alt_u32) (DCOM_IRQ_FC_TX_BEGIN_FLG_CLR_MSK);
		break;
	default:
		uliFlagClearMask = 0;
		break;
	}

	vDctrWriteReg((alt_u32*) DCOM_CH_6_BASE_ADDR,
			(alt_u32) (DCOM_IRQ_FLAG_CLR_REG_OFST), uliFlagClearMask);
}

void vDctrCh7IrqFlagClr(alt_u8 ucIrqFlag) {
	alt_u32 uliFlagClearMask = 0;

	switch (ucIrqFlag) {
	case eTxEndFlag:
		uliFlagClearMask = (alt_u32) (DCOM_IRQ_FC_TX_END_FLG_CLR_MSK);
		break;
	case eTxBeginFlag:
		uliFlagClearMask = (alt_u32) (DCOM_IRQ_FC_TX_BEGIN_FLG_CLR_MSK);
		break;
	default:
		uliFlagClearMask = 0;
		break;
	}

	vDctrWriteReg((alt_u32*) DCOM_CH_7_BASE_ADDR,
			(alt_u32) (DCOM_IRQ_FLAG_CLR_REG_OFST), uliFlagClearMask);
}

void vDctrCh8IrqFlagClr(alt_u8 ucIrqFlag) {
	alt_u32 uliFlagClearMask = 0;

	switch (ucIrqFlag) {
	case eTxEndFlag:
		uliFlagClearMask = (alt_u32) (DCOM_IRQ_FC_TX_END_FLG_CLR_MSK);
		break;
	case eTxBeginFlag:
		uliFlagClearMask = (alt_u32) (DCOM_IRQ_FC_TX_BEGIN_FLG_CLR_MSK);
		break;
	default:
		uliFlagClearMask = 0;
		break;
	}

	vDctrWriteReg((alt_u32*) DCOM_CH_8_BASE_ADDR,
			(alt_u32) (DCOM_IRQ_FLAG_CLR_REG_OFST), uliFlagClearMask);
}

void vDctrCh1IrqFlag(bool *pbIrqFlags) {
	volatile alt_u32 uliIrqFlagsReg = 0;

	if (pbIrqFlags != NULL) {

		uliIrqFlagsReg = uliDctrReadReg((alt_u32*) DCOM_CH_1_BASE_ADDR,
		DCOM_IRQ_FLAG_REG_OFST);

		pbIrqFlags[eTxEndFlag] = bDctrGetRegFlag(uliIrqFlagsReg,
				(alt_u32) (DCOM_IRQ_FLG_TX_END_FLAG_MSK));
		pbIrqFlags[eTxBeginFlag] = bDctrGetRegFlag(uliIrqFlagsReg,
				(alt_u32) (DCOM_IRQ_FLG_TX_BEGIN_FLAG_MSK));
	}

}

void vDctrCh2IrqFlag(bool *pbIrqFlags) {
	volatile alt_u32 uliIrqFlagsReg = 0;

	if (pbIrqFlags != NULL) {

		uliIrqFlagsReg = uliDctrReadReg((alt_u32*) DCOM_CH_2_BASE_ADDR,
		DCOM_IRQ_FLAG_REG_OFST);

		pbIrqFlags[eTxEndFlag] = bDctrGetRegFlag(uliIrqFlagsReg,
				(alt_u32) (DCOM_IRQ_FLG_TX_END_FLAG_MSK));
		pbIrqFlags[eTxBeginFlag] = bDctrGetRegFlag(uliIrqFlagsReg,
				(alt_u32) (DCOM_IRQ_FLG_TX_BEGIN_FLAG_MSK));
	}

}

void vDctrCh3IrqFlag(bool *pbIrqFlags) {
	volatile alt_u32 uliIrqFlagsReg = 0;

	if (pbIrqFlags != NULL) {

		uliIrqFlagsReg = uliDctrReadReg((alt_u32*) DCOM_CH_3_BASE_ADDR,
		DCOM_IRQ_FLAG_REG_OFST);

		pbIrqFlags[eTxEndFlag] = bDctrGetRegFlag(uliIrqFlagsReg,
				(alt_u32) (DCOM_IRQ_FLG_TX_END_FLAG_MSK));
		pbIrqFlags[eTxBeginFlag] = bDctrGetRegFlag(uliIrqFlagsReg,
				(alt_u32) (DCOM_IRQ_FLG_TX_BEGIN_FLAG_MSK));
	}

}

void vDctrCh4IrqFlag(bool *pbIrqFlags) {
	volatile alt_u32 uliIrqFlagsReg = 0;

	if (pbIrqFlags != NULL) {

		uliIrqFlagsReg = uliDctrReadReg((alt_u32*) DCOM_CH_4_BASE_ADDR,
		DCOM_IRQ_FLAG_REG_OFST);

		pbIrqFlags[eTxEndFlag] = bDctrGetRegFlag(uliIrqFlagsReg,
				(alt_u32) (DCOM_IRQ_FLG_TX_END_FLAG_MSK));
		pbIrqFlags[eTxBeginFlag] = bDctrGetRegFlag(uliIrqFlagsReg,
				(alt_u32) (DCOM_IRQ_FLG_TX_BEGIN_FLAG_MSK));
	}

}

void vDctrCh5IrqFlag(bool *pbIrqFlags) {
	volatile alt_u32 uliIrqFlagsReg = 0;

	if (pbIrqFlags != NULL) {

		uliIrqFlagsReg = uliDctrReadReg((alt_u32*) DCOM_CH_5_BASE_ADDR,
		DCOM_IRQ_FLAG_REG_OFST);

		pbIrqFlags[eTxEndFlag] = bDctrGetRegFlag(uliIrqFlagsReg,
				(alt_u32) (DCOM_IRQ_FLG_TX_END_FLAG_MSK));
		pbIrqFlags[eTxBeginFlag] = bDctrGetRegFlag(uliIrqFlagsReg,
				(alt_u32) (DCOM_IRQ_FLG_TX_BEGIN_FLAG_MSK));
	}

}

void vDctrCh6IrqFlag(bool *pbIrqFlags) {
	volatile alt_u32 uliIrqFlagsReg = 0;

	if (pbIrqFlags != NULL) {

		uliIrqFlagsReg = uliDctrReadReg((alt_u32*) DCOM_CH_6_BASE_ADDR,
		DCOM_IRQ_FLAG_REG_OFST);

		pbIrqFlags[eTxEndFlag] = bDctrGetRegFlag(uliIrqFlagsReg,
				(alt_u32) (DCOM_IRQ_FLG_TX_END_FLAG_MSK));
		pbIrqFlags[eTxBeginFlag] = bDctrGetRegFlag(uliIrqFlagsReg,
				(alt_u32) (DCOM_IRQ_FLG_TX_BEGIN_FLAG_MSK));
	}

}

void vDctrCh7IrqFlag(bool *pbIrqFlags) {
	volatile alt_u32 uliIrqFlagsReg = 0;

	if (pbIrqFlags != NULL) {

		uliIrqFlagsReg = uliDctrReadReg((alt_u32*) DCOM_CH_7_BASE_ADDR,
		DCOM_IRQ_FLAG_REG_OFST);

		pbIrqFlags[eTxEndFlag] = bDctrGetRegFlag(uliIrqFlagsReg,
				(alt_u32) (DCOM_IRQ_FLG_TX_END_FLAG_MSK));
		pbIrqFlags[eTxBeginFlag] = bDctrGetRegFlag(uliIrqFlagsReg,
				(alt_u32) (DCOM_IRQ_FLG_TX_BEGIN_FLAG_MSK));
	}

}

void vDctrCh8IrqFlag(bool *pbIrqFlags) {
	volatile alt_u32 uliIrqFlagsReg = 0;

	if (pbIrqFlags != NULL) {

		uliIrqFlagsReg = uliDctrReadReg((alt_u32*) DCOM_CH_8_BASE_ADDR,
		DCOM_IRQ_FLAG_REG_OFST);

		pbIrqFlags[eTxEndFlag] = bDctrGetRegFlag(uliIrqFlagsReg,
				(alt_u32) (DCOM_IRQ_FLG_TX_END_FLAG_MSK));
		pbIrqFlags[eTxBeginFlag] = bDctrGetRegFlag(uliIrqFlagsReg,
				(alt_u32) (DCOM_IRQ_FLG_TX_BEGIN_FLAG_MSK));
	}

}

bool vDctrInitIrq(alt_u8 ucDcomCh) {
	bool bStatus = FALSE;
	void* pvHoldContext;
	switch (ucDcomCh) {
	case eDcomSpwCh1:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh1HoldContext;
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_1_TX_IRQ, pvHoldContext, vDctrCh1HandleIrq);

		bStatus = TRUE;
		break;
	case eDcomSpwCh2:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh2HoldContext;
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_2_TX_IRQ, pvHoldContext, vDctrCh2HandleIrq);
		bStatus = TRUE;
		break;
	case eDcomSpwCh3:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh3HoldContext;
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_3_TX_IRQ, pvHoldContext, vDctrCh3HandleIrq);
		bStatus = TRUE;
		break;
	case eDcomSpwCh4:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh4HoldContext;
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_4_TX_IRQ, pvHoldContext, vDctrCh4HandleIrq);
		bStatus = TRUE;
		break;
	case eDcomSpwCh5:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh5HoldContext;
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_5_TX_IRQ, pvHoldContext, vDctrCh5HandleIrq);
		bStatus = TRUE;
		break;
	case eDcomSpwCh6:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh6HoldContext;
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_6_TX_IRQ, pvHoldContext, vDctrCh6HandleIrq);
		bStatus = TRUE;
		break;
	case eDcomSpwCh7:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh7HoldContext;
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_7_TX_IRQ, pvHoldContext, vDctrCh7HandleIrq);
		bStatus = TRUE;
		break;
	case eDcomSpwCh8:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh8HoldContext;
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_8_TX_IRQ, pvHoldContext, vDctrCh8HandleIrq);
		bStatus = TRUE;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return bStatus;
}

bool bDctrSetIrqControl(TDctrChannel *pxDctrCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxDctrCh != NULL) {
		uliReg = uliDctrReadReg(pxDctrCh->puliDctrChAddr,
				(alt_u32) (DCOM_IRQ_CTRL_REG_OFST));

		uliReg = uliDctrSetRegCtrl(uliReg,
				(alt_u32) (DCOM_IRQ_CTRL_TX_END_EN_MSK),
				pxDctrCh->xIrqControl.bTxEndEn);
		uliReg = uliDctrSetRegCtrl(uliReg,
				(alt_u32) (DCOM_IRQ_CTRL_TX_BEGIN_EN_MSK),
				pxDctrCh->xIrqControl.bTxBeginEn);

		vDctrWriteReg(pxDctrCh->puliDctrChAddr,
				(alt_u32) (DCOM_IRQ_CTRL_REG_OFST), uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDctrGetIrqControl(TDctrChannel *pxDctrCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxDctrCh != NULL) {
		uliReg = uliDctrReadReg(pxDctrCh->puliDctrChAddr,
				(alt_u32) (DCOM_IRQ_CTRL_REG_OFST));

		pxDctrCh->xIrqControl.bTxEndEn = bDctrGetRegFlag(uliReg,
				(alt_u32) (DCOM_IRQ_CTRL_TX_END_EN_MSK));
		pxDctrCh->xIrqControl.bTxBeginEn = bDctrGetRegFlag(uliReg,
				(alt_u32) (DCOM_IRQ_CTRL_TX_BEGIN_EN_MSK));

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDctrGetIrqFlags(TDctrChannel *pxDctrCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxDctrCh != NULL) {
		uliReg = uliDctrReadReg(pxDctrCh->puliDctrChAddr,
				(alt_u32) (DCOM_IRQ_FLAG_REG_OFST));

		pxDctrCh->xIrqFlag.bTxEndFlag = bDctrGetRegFlag(uliReg,
				(alt_u32) (DCOM_IRQ_FLG_TX_END_FLAG_MSK));
		pxDctrCh->xIrqFlag.bTxBeginFlag = bDctrGetRegFlag(uliReg,
				(alt_u32) (DCOM_IRQ_FLG_TX_BEGIN_FLAG_MSK));

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDctrSetControllerConfig(TDctrChannel *pxDctrCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxDctrCh != NULL) {
		uliReg = uliDctrReadReg(pxDctrCh->puliDctrChAddr,
				(alt_u32) (DCOM_DATA_CRTLR_CFG_REG_OFST));

		uliReg = uliDctrSetRegCtrl(uliReg,
				(alt_u32) (DCOM_DATA_CTRLR_CFG_SEND_EOP_MSK),
				pxDctrCh->xControllerConfig.bSendEop);
		uliReg = uliDctrSetRegCtrl(uliReg,
				(alt_u32) (DCOM_DATA_CTRLR_CFG_SEND_EEP_MSK),
				pxDctrCh->xControllerConfig.bSendEep);

		vDctrWriteReg(pxDctrCh->puliDctrChAddr,
				(alt_u32) (DCOM_DATA_CRTLR_CFG_REG_OFST), uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDctrGetControllerConfig(TDctrChannel *pxDctrCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxDctrCh != NULL) {
		uliReg = uliDctrReadReg(pxDctrCh->puliDctrChAddr,
				(alt_u32) (DCOM_DATA_CRTLR_CFG_REG_OFST));

		pxDctrCh->xControllerConfig.bSendEop = bDctrGetRegFlag(uliReg,
				(alt_u32) (DCOM_DATA_CTRLR_CFG_SEND_EOP_MSK));
		pxDctrCh->xControllerConfig.bSendEep = bDctrGetRegFlag(uliReg,
				(alt_u32) (DCOM_DATA_CTRLR_CFG_SEND_EEP_MSK));

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDctrInitCh(TDctrChannel *pxDctrCh, alt_u8 ucDcomCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;

	if (pxDctrCh != NULL) {

		switch (ucDcomCh) {
		case eDcomSpwCh1:
			pxDctrCh->puliDctrChAddr = (alt_u32 *) DCOM_CH_1_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh2:
			pxDctrCh->puliDctrChAddr = (alt_u32 *) DCOM_CH_2_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh3:
			pxDctrCh->puliDctrChAddr = (alt_u32 *) DCOM_CH_3_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh4:
			pxDctrCh->puliDctrChAddr = (alt_u32 *) DCOM_CH_4_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh5:
			pxDctrCh->puliDctrChAddr = (alt_u32 *) DCOM_CH_5_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh6:
			pxDctrCh->puliDctrChAddr = (alt_u32 *) DCOM_CH_6_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh7:
			pxDctrCh->puliDctrChAddr = (alt_u32 *) DCOM_CH_7_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh8:
			pxDctrCh->puliDctrChAddr = (alt_u32 *) DCOM_CH_8_BASE_ADDR;
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}

		if (bValidCh) {
			if (!bDctrGetIrqControl(pxDctrCh)) {
				bInitFail = TRUE;
			}
			if (!bDctrGetIrqFlags(pxDctrCh)) {
				bInitFail = TRUE;
			}
			if (!bDctrGetControllerConfig(pxDctrCh)) {
				bInitFail = TRUE;
			}

			if (!bInitFail) {
				bStatus = TRUE;
			}
		}
	}
	return bStatus;
}
//! [public functions]

//! [private functions]
static ALT_INLINE void ALT_ALWAYS_INLINE vDctrWriteReg(alt_u32 *puliBaseAddr,
		alt_u32 uliRegOffset, alt_u32 uliRegValue) {
	*(puliBaseAddr + uliRegOffset) = uliRegValue;
}

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDctrReadReg(
		alt_u32 *puliBaseAddr, alt_u32 uliRegOffset) {
	volatile alt_u32 uliRegValue;

	uliRegValue = *(puliBaseAddr + uliRegOffset);
	return uliRegValue;
}

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDctrSetRegCtrl(
		alt_u32 uliRegValue, alt_u32 uliCtrlMask, bool bCtrlValue) {
	alt_u32 uliReg = 0;

	if (bCtrlValue) {
		uliReg = uliRegValue | uliCtrlMask;
	} else {
		uliReg = uliRegValue & (~uliCtrlMask);
	}

	return uliReg;
}

static ALT_INLINE bool ALT_ALWAYS_INLINE bDctrGetRegFlag(alt_u32 uliRegValue,
		alt_u32 uliFlagMask) {
	bool bFlag = FALSE;

	if (uliRegValue & uliFlagMask) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDctrSetRegField(
		alt_u32 uliRegValue, alt_u32 uliFieldMask, alt_u8 ucFieldOffset,
		alt_u32 uliFieldValue) {
	alt_u32 uliReg = 0;

	uliReg = uliRegValue & (~uliFieldMask);
	uliReg |= uliFieldMask & (uliFieldValue << ucFieldOffset);

	return uliReg;
}

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE uliDctrGetRegField(
		alt_u32 uliRegValue, alt_u32 uliFieldMask, alt_u8 ucFieldOffset) {
	alt_u32 uliFieldValue = 0;

	uliFieldValue = (uliRegValue & uliFieldMask) >> ucFieldOffset;

	return uliFieldValue;
}
//! [private functions]
