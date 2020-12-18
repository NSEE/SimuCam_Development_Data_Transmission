/*
 * dcom_channel.c
 *
 *  Created on: 31/03/2019
 *      Author: rfranca
 */

#include "dcom_channel.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
bool bDcomSetGlobalIrqEn(bool bGlobalIrqEnable, alt_u8 ucDcomCh) {
	bool bStatus = FALSE;

	volatile TDcomChannel *vpxDcomChannel;

	switch (ucDcomCh) {
	case eDcomSpwCh1:
		vpxDcomChannel = (TDcomChannel *) DCOM_CH_1_BASE_ADDR;
		vpxDcomChannel->xDcomIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eDcomSpwCh2:
		vpxDcomChannel = (TDcomChannel *) DCOM_CH_2_BASE_ADDR;
		vpxDcomChannel->xDcomIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eDcomSpwCh3:
		vpxDcomChannel = (TDcomChannel *) DCOM_CH_3_BASE_ADDR;
		vpxDcomChannel->xDcomIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eDcomSpwCh4:
		vpxDcomChannel = (TDcomChannel *) DCOM_CH_4_BASE_ADDR;
		vpxDcomChannel->xDcomIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eDcomSpwCh5:
		vpxDcomChannel = (TDcomChannel *) DCOM_CH_5_BASE_ADDR;
		vpxDcomChannel->xDcomIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eDcomSpwCh6:
		vpxDcomChannel = (TDcomChannel *) DCOM_CH_6_BASE_ADDR;
		vpxDcomChannel->xDcomIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eDcomSpwCh7:
		vpxDcomChannel = (TDcomChannel *) DCOM_CH_7_BASE_ADDR;
		vpxDcomChannel->xDcomIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eDcomSpwCh8:
		vpxDcomChannel = (TDcomChannel *) DCOM_CH_8_BASE_ADDR;
		vpxDcomChannel->xDcomIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return bStatus;
}

bool bDcomInitCh(TDcomChannel *pxDcomCh, alt_u8 ucDcomCh) {
	bool bStatus = FALSE;
	bool bInitFail = FALSE;

	if (!bSpwcInitCh(&(pxDcomCh->xSpacewire), ucDcomCh)) {
		bInitFail = TRUE;
	}
	if (!bDschInitIrq(ucDcomCh)) {
		bInitFail = TRUE;
	}
	if (!bDschInitCh(&(pxDcomCh->xDataScheduler), ucDcomCh)) {
		bInitFail = TRUE;
	}
	if (!bRmapInitCh(&(pxDcomCh->xRmap), ucDcomCh)) {
		bInitFail = TRUE;
	}

	if (!bInitFail) {
		bStatus = TRUE;
	}

	return bStatus;
}

/**
 * @name set_spw_linkspeed
 * @brief Set SpW linkspeed
 * @ingroup command_control
 *
 * Set the linkspeed of specific SpW channel according to the
 * specified divider code
 *
 * @param 	[in] 	TDcomChannel *x_channel
 * @param	[in]	INT8U linkspeed_code
 * 0: 10Mbits, 1: 25Mbits, 2: 50Mbits, 3: 100Mbits
 * 	ref_clock = 200M -> spw_clock = ref_clock/(div+1)
 * @retval INT8U error_code 1 if OK
 **/
INT8U set_spw_linkspeed(TDcomChannel *x_channel, INT8U i_linkspeed_code) {
	INT8U error_code = 0;
	INT8U i_linkspeed_div = 1;

	switch (i_linkspeed_code) {
	case 0:
		/* 10 Mbits */
		i_linkspeed_div = 19;
		break;

	case 1:
		/* 25 Mbits */
		i_linkspeed_div = 7;
		break;

	case 2:
		/* 50 Mbits */
		i_linkspeed_div = 3;

		break;

	case 3:
		/* 100 Mbits */
		i_linkspeed_div = 1;
		break;

	default:
		i_linkspeed_div = 1;
		break;
	}

	bSpwcGetLinkConfig(&(x_channel->xSpacewire));
	x_channel->xSpacewire.xSpwcLinkConfig.ucTxDivCnt = i_linkspeed_div;
	bSpwcSetLinkConfig(&(x_channel->xSpacewire));

	return error_code;
}

//! [public functions]

//! [private functions]
//! [private functions]

