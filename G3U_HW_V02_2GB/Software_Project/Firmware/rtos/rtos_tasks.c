/*
 * rtos_tasks.c
 *
 *  Created on: 24/04/2018
 *      Author: rfranca
 */

/* Includes */
#include "rtos_tasks.h"

#include "../alt_error_handler.h"

#include "../utils/util.h"
#include "../utils/meb_includes.h"

#include "../driver/i2c/i2c.h"
#include "../driver/leds/leds.h"
#include "../driver/power_spi/power_spi.h"
#include "../driver/rtcc_spi/rtcc_spi.h"
#include "../driver/seven_seg/seven_seg.h"

#include "../api_drivers/sense/sense.h"
#include "../api_drivers/ddr2/ddr2.h"

#include "../driver/dcom/dcom_channel.h"
//#include "sub_unit_control_task.h"

#include "../utils/configs_simucam.h"

TDcomChannel xCh[8];

/* OS Error Variables */
alt_u8 error_code = 0;

/* Log Variables */
alt_u8 tempFPGA = 0;
alt_u8 tempBoard = 0;

/* DMA Variables*/
alt_msgdma_dev *DMADev = NULL;

/* OS Tasks Variables */
OS_STK SPWLinkTaskStk[SIMUCAM_TASK_STACKSIZE];
OS_STK LogTaskStk[SIMUCAM_TASK_STACKSIZE];

/* SpW Functions */
void Set_SpW_Led(INT8U c_SpwID);

/* OS Tasks */

/* SPW Link Task, configure and monitor the SpW channel for incoming connections to set the status leds, update rate of 10 ms */
void SPWLinkTask(void *task_data) {
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xMajor) {
	fprintf(fp, "Created \"spw link\" Task (Prio:%d) \n", SPW_LINK_TASK_PRIORITY);
}
#endif

	INT8U ucSpwChCnt = 0;

	for (ucSpwChCnt = 0; ucSpwChCnt < 8; ucSpwChCnt++) {
		bDcomInitCh(&(xCh[ucSpwChCnt]), ucSpwChCnt);
		bDschGetPacketConfig(&(xCh[ucSpwChCnt].xDataScheduler));
		xCh[ucSpwChCnt].xDataScheduler.xDschPacketConfig.bSendEep = xConfDebug.bSendEEP;
		xCh[ucSpwChCnt].xDataScheduler.xDschPacketConfig.bSendEop = xConfDebug.bSendEOP;
		bDschSetPacketConfig(&(xCh[ucSpwChCnt].xDataScheduler));
	}

	while (1) {
		for (ucSpwChCnt = 0; ucSpwChCnt < 8; ucSpwChCnt++) {
			Set_SpW_Led(ucSpwChCnt);
		}
		OSTimeDlyHMSM(0, 0, 0, 10);
	}
}

/* Log Task, show the FPGA core temperature in the seven segments display, update rate of 1 s */
void LogTask(void *task_data) {
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xMajor) {
	fprintf(fp, "Created \"log\" Task (Prio:%d) \n", LOG_TASK_PRIORITY);
}
#endif
	while (1) {
		TEMP_Read((alt_8 *) &tempFPGA, (alt_8 *) &tempBoard);
		bSSDisplayUpdate(tempFPGA);
		OSTimeDlyHMSM(0, 0, 1, 0);
	}
}

/* Initialize the SimuCam Tasks */
void Init_Simucam_Tasks(void) {

	error_code = OSTaskCreateExt(SPWLinkTask,
	NULL, (void *) &SPWLinkTaskStk[SIMUCAM_TASK_STACKSIZE],
	SPW_LINK_TASK_PRIORITY,
	SPW_LINK_TASK_PRIORITY, SPWLinkTaskStk,
	SIMUCAM_TASK_STACKSIZE,
	NULL, 0);
	alt_uCOSIIErrorHandler(error_code, 0);

	error_code = OSTaskCreateExt(LogTask,
	NULL, (void *) &LogTaskStk[SIMUCAM_TASK_STACKSIZE],
	LOG_TASK_PRIORITY,
	LOG_TASK_PRIORITY, LogTaskStk,
	SIMUCAM_TASK_STACKSIZE,
	NULL, 0);
	alt_uCOSIIErrorHandler(error_code, 0);

}

void Set_SpW_Led(INT8U c_SpwID) {
	alt_u32 ui_leds_mask_r = 0;
	alt_u32 ui_leds_mask_g = 0;
	TDcomChannel *pxChannel = &(xCh[0]);
	switch (c_SpwID) {
	case 0:
		ui_leds_mask_r = LEDS_1R_MASK;
		ui_leds_mask_g = LEDS_1G_MASK;
		pxChannel = &(xCh[0]);
		break;
	case 1:
		ui_leds_mask_r = LEDS_2R_MASK;
		ui_leds_mask_g = LEDS_2G_MASK;
		pxChannel = &(xCh[1]);
		break;
	case 2:
		ui_leds_mask_r = LEDS_3R_MASK;
		ui_leds_mask_g = LEDS_3G_MASK;
		pxChannel = &(xCh[2]);
		break;
	case 3:
		ui_leds_mask_r = LEDS_4R_MASK;
		ui_leds_mask_g = LEDS_4G_MASK;
		pxChannel = &(xCh[3]);
		break;
	case 4:
		ui_leds_mask_r = LEDS_5R_MASK;
		ui_leds_mask_g = LEDS_5G_MASK;
		pxChannel = &(xCh[4]);
		break;
	case 5:
		ui_leds_mask_r = LEDS_6R_MASK;
		ui_leds_mask_g = LEDS_6G_MASK;
		pxChannel = &(xCh[5]);
		break;
	case 6:
		ui_leds_mask_r = LEDS_7R_MASK;
		ui_leds_mask_g = LEDS_7G_MASK;
		pxChannel = &(xCh[6]);
		break;
	case 7:
		ui_leds_mask_r = LEDS_8R_MASK;
		ui_leds_mask_g = LEDS_8G_MASK;
		pxChannel = &(xCh[7]);
		break;
	}
	bSpwcGetLinkStatus(&(pxChannel->xSpacewire));
	if (pxChannel->xSpacewire.xSpwcLinkStatus.bRunning) {
		bSetPainelLeds(LEDS_OFF, ui_leds_mask_r);
		bSetPainelLeds(LEDS_ON, ui_leds_mask_g);
	} else {
		bSetPainelLeds(LEDS_OFF, ui_leds_mask_g);
		bSetPainelLeds(LEDS_ON, ui_leds_mask_r);
	}
}
