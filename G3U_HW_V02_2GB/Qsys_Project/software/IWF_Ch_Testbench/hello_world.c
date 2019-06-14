/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include "simucam_definitions.h"
#include "driver/dcom/dcom_channel.h"
#include "api_driver/iwf_simucam_dma/iwf_simucam_dma.h"
#include "api_driver/ddr2/ddr2.h"
#include "driver/ctrl_io_lvds/ctrl_io_lvds.h"
#include "driver/reset/reset.h"

alt_u32 uliReadReg(alt_u32 *puliBaseAddr, alt_u32 uliRegOffset);

typedef struct Data {
	alt_u32 uliTime;
	alt_u16 uiLength;
	alt_u8 ucData[58];
} TData;

//typedef struct Data {
//	alt_u8 ucData[640];
//} TData;

int main() {
	printf("Hello from Nios II!\n");

	printf("Starting Channel\n");

	bEnableIsoDrivers();
	bEnableLvdsBoard();

//	printf("Waiting 10s... \n");
//	usleep(10000000);

	TDcomChannel xChannelH;
	if (bDcomInitCh(&xChannelH, eDcomSpwCh8)) {
		printf("Channel Initializated \n");
	}

	bSpwcGetLink(&(xChannelH.xSpacewire));
	xChannelH.xSpacewire.xLinkConfig.bAutostart = TRUE;
	xChannelH.xSpacewire.xLinkConfig.bLinkStart = TRUE;
	xChannelH.xSpacewire.xLinkConfig.bDisconnect = FALSE;
	xChannelH.xSpacewire.xLinkConfig.ucTxDivCnt = 1;
	bSpwcSetLink(&(xChannelH.xSpacewire));

	bDschStartTimer(&(xChannelH.xDataScheduler));

	printf("Waiting 10s... \n");
	usleep(10000000);

	printf("Initiating DMA... \n");
	bIdmaInitM1Dma();

	printf("Initiating Data... \n");
	bDdr2SwitchMemory(DDR2_M1_ID);
	TData *xData = (TData *) DDR2_EXT_ADDR_WINDOWED_BASE;

//	int j = 0;
//	for (j = 0; j < 640; j++){
//		xData->ucData[j] = 0;
//	}
//
//	printf("Clear Data... \n");
//	if (bIdmaDmaM1Transfer((alt_u32 *) DDR2_EXT_ADDR_WINDOWED_BASE, 640, eIdmaCh8Buffer)){
//		printf("Clear Complete!! \n");
//	} else {
//		printf("Clear Failed!! \n");
//	}
//
//	for (j = 0; j < 640; j++){
//		xData->ucData[j] = (alt_u8)(j & 0x00FF);
//	}

	xData->uliTime = 0;
	xData->uiLength = 58;
	int j = 0;
	for (j = 0; j < 58; j++) {
		xData->ucData[j] = (alt_u8) (j & 0x00FF);
	}

	printf("Transferring Data... \n");
	if (bIdmaDmaM1Transfer((alt_u32 *) (DDR2_EXT_ADDR_WINDOWED_BASE), 64,
			eIdmaCh8Buffer)) {
		printf("Transfer Complete!! \n");
	} else {
		printf("Transfer Failed!! \n");
	}

//	printf("Starting Avalon Dump... \n");
//
//	int i = 0;
//
//	for (i = 0; i < 255; i++) {
//		printf("Avalon reg [%d] = 0x%08lX \n", i,
//				uliReadReg(xChannelH.xSpacewire.puliSpwcChAddr, i));
//	}
//	printf("Avalon Dump Finished!! \n");

	while (1) {
	}

	return 0;
}

alt_u32 uliReadReg(alt_u32 *puliBaseAddr, alt_u32 uliRegOffset) {
	volatile alt_u32 uliRegValue;

	uliRegValue = *(puliBaseAddr + uliRegOffset);
	return uliRegValue;
}
