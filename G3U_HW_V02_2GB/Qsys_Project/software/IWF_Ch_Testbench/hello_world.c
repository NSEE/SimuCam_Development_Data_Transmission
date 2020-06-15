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
#include "driver/sync/sync.h"
#include "api_driver/iwf_simucam_dma/iwf_simucam_dma.h"
#include "api_driver/ddr2/ddr2.h"
#include "utils/initialization_simucam.h"
#include "utils/test_module_simucam.h"

typedef struct Data {
	alt_u32 uliTime;
	alt_u16 uiLength;
	alt_u8 ucData[25];
} TData;

int main() {

	/* Debug device initialization - JTAG USB */
	#if DEBUG_ON
	    fp = fopen(JTAG_UART_0_NAME, "r+");
	#endif

	#if DEBUG_ON
		printf("Main entry point.\n");
	#endif

	/* Initialization of core HW */
	if (bInitSimucamCoreHW()){
#if DEBUG_ON
		printf("\n");
		printf("SimuCam Release: %s\n", SIMUCAM_RELEASE);
		printf("SimuCam HW Version: %s.%s\n", SIMUCAM_RELEASE, SIMUCAM_HW_VERSION);
		printf("SimuCam FW Version: %s.%s.%s\n", SIMUCAM_RELEASE, SIMUCAM_HW_VERSION, SIMUCAM_FW_VERSION);
		printf("\n");
#endif
	} else {
#if DEBUG_ON
		printf("\n");
		printf("CRITICAL HW FAILURE: Hardware TimeStamp or System ID does not match the expected! SimuCam will be halted.\n");
		printf("CRITICAL HW FAILURE: Expected HW release: %s.%s\n", SIMUCAM_RELEASE, SIMUCAM_HW_VERSION);
		printf("CRITICAL HW FAILURE: SimuCam will be halted.\n");
		printf("\n");
#endif
		while (1) {}
	}

	/* Test of some critical IPCores HW interfaces in the Simucam */
	if (!bTestSimucamCriticalHW()) {
		printf("CRITICAL HW FAILURE: SimuCam will be halted.\n");
		printf("\n");
		while (1) {}
	}

	/* Initialization of basic HW */
	vInitSimucamBasicHW();

	bSetPainelLeds( LEDS_OFF , LEDS_ST_ALL_MASK );
	bSetPainelLeds( LEDS_ON , LEDS_POWER_MASK );

	printf("Starting Channels...\n");

	bEnableIsoDrivers();
	bEnableLvdsBoard();

	TDcomChannel xChannelA;
	if (bDcomInitCh(&xChannelA, eDcomSpwCh1)){
		printf("Channel A initialized.\n");
	}
	bSpwcGetLinkConfig(&(xChannelA.xSpacewire));
	xChannelA.xSpacewire.xSpwcLinkConfig.bAutostart = TRUE;
	xChannelA.xSpacewire.xSpwcLinkConfig.bLinkStart = TRUE;
	xChannelA.xSpacewire.xSpwcLinkConfig.bDisconnect = FALSE;
	xChannelA.xSpacewire.xSpwcLinkConfig.ucTxDivCnt = 1;
	bSpwcSetLinkConfig(&(xChannelA.xSpacewire));
	bDschStartTimer(&(xChannelA.xDataScheduler));

	TDcomChannel xChannelB;
	if (bDcomInitCh(&xChannelB, eDcomSpwCh2)){
		printf("Channel B initialized.\n");
	}
	bSpwcGetLinkConfig(&(xChannelB.xSpacewire));
	xChannelB.xSpacewire.xSpwcLinkConfig.bAutostart = TRUE;
	xChannelB.xSpacewire.xSpwcLinkConfig.bLinkStart = TRUE;
	xChannelB.xSpacewire.xSpwcLinkConfig.bDisconnect = FALSE;
	xChannelB.xSpacewire.xSpwcLinkConfig.ucTxDivCnt = 1;
	bSpwcSetLinkConfig(&(xChannelB.xSpacewire));
	bDschStartTimer(&(xChannelB.xDataScheduler));

	TDcomChannel xChannelC;
	if (bDcomInitCh(&xChannelC, eDcomSpwCh3)){
		printf("Channel C initialized.\n");
	}
	bSpwcGetLinkConfig(&(xChannelC.xSpacewire));
	xChannelC.xSpacewire.xSpwcLinkConfig.bAutostart = TRUE;
	xChannelC.xSpacewire.xSpwcLinkConfig.bLinkStart = TRUE;
	xChannelC.xSpacewire.xSpwcLinkConfig.bDisconnect = FALSE;
	xChannelC.xSpacewire.xSpwcLinkConfig.ucTxDivCnt = 1;
	bSpwcSetLinkConfig(&(xChannelC.xSpacewire));
	bDschStartTimer(&(xChannelC.xDataScheduler));

	TDcomChannel xChannelD;
	if (bDcomInitCh(&xChannelD, eDcomSpwCh4)){
		printf("Channel D initialized.\n");
	}
	bSpwcGetLinkConfig(&(xChannelD.xSpacewire));
	xChannelD.xSpacewire.xSpwcLinkConfig.bAutostart = TRUE;
	xChannelD.xSpacewire.xSpwcLinkConfig.bLinkStart = TRUE;
	xChannelD.xSpacewire.xSpwcLinkConfig.bDisconnect = FALSE;
	xChannelD.xSpacewire.xSpwcLinkConfig.ucTxDivCnt = 1;
	bSpwcSetLinkConfig(&(xChannelD.xSpacewire));
	bDschStartTimer(&(xChannelD.xDataScheduler));

	TDcomChannel xChannelE;
	if (bDcomInitCh(&xChannelE, eDcomSpwCh5)){
		printf("Channel E initialized.\n");
	}
	bSpwcGetLinkConfig(&(xChannelE.xSpacewire));
	xChannelE.xSpacewire.xSpwcLinkConfig.bAutostart = TRUE;
	xChannelE.xSpacewire.xSpwcLinkConfig.bLinkStart = TRUE;
	xChannelE.xSpacewire.xSpwcLinkConfig.bDisconnect = FALSE;
	xChannelE.xSpacewire.xSpwcLinkConfig.ucTxDivCnt = 1;
	bSpwcSetLinkConfig(&(xChannelE.xSpacewire));
	bDschStartTimer(&(xChannelE.xDataScheduler));

	TDcomChannel xChannelF;
	if (bDcomInitCh(&xChannelF, eDcomSpwCh6)){
		printf("Channel F initialized.\n");
	}
	bSpwcGetLinkConfig(&(xChannelF.xSpacewire));
	xChannelF.xSpacewire.xSpwcLinkConfig.bAutostart = TRUE;
	xChannelF.xSpacewire.xSpwcLinkConfig.bLinkStart = TRUE;
	xChannelF.xSpacewire.xSpwcLinkConfig.bDisconnect = FALSE;
	xChannelF.xSpacewire.xSpwcLinkConfig.ucTxDivCnt = 1;
	bSpwcSetLinkConfig(&(xChannelF.xSpacewire));
	bDschStartTimer(&(xChannelF.xDataScheduler));

	TDcomChannel xChannelG;
	if (bDcomInitCh(&xChannelG, eDcomSpwCh7)){
		printf("Channel G initialized.\n");
	}
	bSpwcGetLinkConfig(&(xChannelG.xSpacewire));
	xChannelG.xSpacewire.xSpwcLinkConfig.bAutostart = TRUE;
	xChannelG.xSpacewire.xSpwcLinkConfig.bLinkStart = TRUE;
	xChannelG.xSpacewire.xSpwcLinkConfig.bDisconnect = FALSE;
	xChannelG.xSpacewire.xSpwcLinkConfig.ucTxDivCnt = 1;
	bSpwcSetLinkConfig(&(xChannelG.xSpacewire));
	bDschStartTimer(&(xChannelG.xDataScheduler));

	TDcomChannel xChannelH;
	if (bDcomInitCh(&xChannelH, eDcomSpwCh8)){
		printf("Channel H initialized.\n");
	}
	bSpwcGetLinkConfig(&(xChannelH.xSpacewire));
	xChannelH.xSpacewire.xSpwcLinkConfig.bAutostart = TRUE;
	xChannelH.xSpacewire.xSpwcLinkConfig.bLinkStart = TRUE;
	xChannelH.xSpacewire.xSpwcLinkConfig.bDisconnect = FALSE;
	xChannelH.xSpacewire.xSpwcLinkConfig.ucTxDivCnt = 1;
	bSpwcSetLinkConfig(&(xChannelH.xSpacewire));
	bDschStartTimer(&(xChannelH.xDataScheduler));

	printf("\n");
	printf("Initiating Data for M1... ");
	bDdr2SwitchMemory(DDR2_M1_ID);
	TData *xData = (TData *) DDR2_EXT_ADDR_WINDOWED_BASE;
	xData->uliTime = 0;
	xData->uiLength = 25;
	xData->ucData[0] ='H';
	xData->ucData[1] ='E';
	xData->ucData[2] ='L';
	xData->ucData[3] ='L';
	xData->ucData[4] ='O';
	xData->ucData[5] ='_';
	xData->ucData[6] ='W';
	xData->ucData[7] ='O';
	xData->ucData[8] ='R';
	xData->ucData[9] ='L';
	xData->ucData[10] ='D';
	xData->ucData[11] ='_';
	xData->ucData[12] ='F';
	xData->ucData[13] ='R';
	xData->ucData[14] ='O';
	xData->ucData[15] ='M';
	xData->ucData[16] ='_';
	xData->ucData[17] ='S';
	xData->ucData[18] ='I';
	xData->ucData[19] ='M';
	xData->ucData[20] ='U';
	xData->ucData[21] ='C';
	xData->ucData[22] ='A';
	xData->ucData[23] ='M';
	xData->ucData[24] ='\0';
	printf("Data for M1 initialized !!\n");

	printf("Transferring Data from M1 to Channel A... ");
	if (bIdmaDmaM1Transfer((alt_u32 *) (DDR2_EXT_ADDR_WINDOWED_BASE), 31, eIdmaCh1Buffer)) {
		printf("Transfer for Channel A Complete!! \n");
	} else {
		printf("Transfer for Channel A Failed!! ERROR!! \n");
	}
	usleep(1000000);

	printf("Transferring Data from M1 to Channel B... ");
	if (bIdmaDmaM1Transfer((alt_u32 *) (DDR2_EXT_ADDR_WINDOWED_BASE), 31, eIdmaCh2Buffer)) {
		printf("Transfer for Channel B Complete!! \n");
	} else {
		printf("Transfer for Channel B Failed!! ERROR!! \n");
	}
	usleep(1000000);

	printf("Transferring Data from M1 to Channel C... ");
	if (bIdmaDmaM1Transfer((alt_u32 *) (DDR2_EXT_ADDR_WINDOWED_BASE), 31, eIdmaCh3Buffer)) {
		printf("Transfer for Channel C Complete!! \n");
	} else {
		printf("Transfer for Channel C Failed!! ERROR!! \n");
	}
	usleep(1000000);

	printf("Transferring Data from M1 to Channel D... ");
	if (bIdmaDmaM1Transfer((alt_u32 *) (DDR2_EXT_ADDR_WINDOWED_BASE), 31, eIdmaCh4Buffer)) {
		printf("Transfer for Channel D Complete!! \n");
	} else {
		printf("Transfer for Channel D Failed!! ERROR!! \n");
	}
	usleep(1000000);

	printf("Transferring Data from M1 to Channel E... ");
	if (bIdmaDmaM1Transfer((alt_u32 *) (DDR2_EXT_ADDR_WINDOWED_BASE), 31, eIdmaCh5Buffer)) {
		printf("Transfer for Channel E Complete!! \n");
	} else {
		printf("Transfer for Channel E Failed!! ERROR!! \n");
	}
	usleep(1000000);

	printf("Transferring Data from M1 to Channel F... ");
	if (bIdmaDmaM1Transfer((alt_u32 *) (DDR2_EXT_ADDR_WINDOWED_BASE), 31, eIdmaCh6Buffer)) {
		printf("Transfer for Channel F Complete!! \n");
	} else {
		printf("Transfer for Channel F Failed!! ERROR!! \n");
	}
	usleep(1000000);

	printf("Transferring Data from M1 to Channel G... ");
	if (bIdmaDmaM1Transfer((alt_u32 *) (DDR2_EXT_ADDR_WINDOWED_BASE), 31, eIdmaCh7Buffer)) {
		printf("Transfer for Channel G Complete!! \n");
	} else {
		printf("Transfer for Channel G Failed!! ERROR!! \n");
	}
	usleep(1000000);

	printf("Transferring Data from M1 to Channel H... ");
	if (bIdmaDmaM1Transfer((alt_u32 *) (DDR2_EXT_ADDR_WINDOWED_BASE), 31, eIdmaCh8Buffer)) {
		printf("Transfer for Channel H Complete!! \n");
	} else {
		printf("Transfer for Channel H Failed!! ERROR!! \n");
	}

	printf("\n");
	printf("Initiating Data for M2... ");
	bDdr2SwitchMemory(DDR2_M2_ID);
	xData = (TData *) DDR2_EXT_ADDR_WINDOWED_BASE;
	xData->uliTime = 0;
	xData->uiLength = 25;
	xData->ucData[0] ='H';
	xData->ucData[1] ='E';
	xData->ucData[2] ='L';
	xData->ucData[3] ='L';
	xData->ucData[4] ='O';
	xData->ucData[5] ='_';
	xData->ucData[6] ='W';
	xData->ucData[7] ='O';
	xData->ucData[8] ='R';
	xData->ucData[9] ='L';
	xData->ucData[10] ='D';
	xData->ucData[11] ='_';
	xData->ucData[12] ='F';
	xData->ucData[13] ='R';
	xData->ucData[14] ='O';
	xData->ucData[15] ='M';
	xData->ucData[16] ='_';
	xData->ucData[17] ='S';
	xData->ucData[18] ='I';
	xData->ucData[19] ='M';
	xData->ucData[20] ='U';
	xData->ucData[21] ='C';
	xData->ucData[22] ='A';
	xData->ucData[23] ='M';
	xData->ucData[24] ='\0';
	printf("Data for M2 initialized !!\n");

	printf("Transferring Data from M2 to Channel A... ");
	if (bIdmaDmaM2Transfer((alt_u32 *) (DDR2_EXT_ADDR_WINDOWED_BASE), 31, eIdmaCh1Buffer)) {
		printf("Transfer for Channel A Complete!! \n");
	} else {
		printf("Transfer for Channel A Failed!! ERROR!! \n");
	}
	usleep(1000000);

	printf("Transferring Data from M2 to Channel B... ");
	if (bIdmaDmaM2Transfer((alt_u32 *) (DDR2_EXT_ADDR_WINDOWED_BASE), 31, eIdmaCh2Buffer)) {
		printf("Transfer for Channel B Complete!! \n");
	} else {
		printf("Transfer for Channel B Failed!! ERROR!! \n");
	}
	usleep(1000000);

	printf("Transferring Data from M2 to Channel C... ");
	if (bIdmaDmaM2Transfer((alt_u32 *) (DDR2_EXT_ADDR_WINDOWED_BASE), 31, eIdmaCh3Buffer)) {
		printf("Transfer for Channel C Complete!! \n");
	} else {
		printf("Transfer for Channel C Failed!! ERROR!! \n");
	}
	usleep(1000000);

	printf("Transferring Data from M2 to Channel D... ");
	if (bIdmaDmaM2Transfer((alt_u32 *) (DDR2_EXT_ADDR_WINDOWED_BASE), 31, eIdmaCh4Buffer)) {
		printf("Transfer for Channel D Complete!! \n");
	} else {
		printf("Transfer for Channel D Failed!! ERROR!! \n");
	}
	usleep(1000000);

	printf("Transferring Data from M2 to Channel E... ");
	if (bIdmaDmaM2Transfer((alt_u32 *) (DDR2_EXT_ADDR_WINDOWED_BASE), 31, eIdmaCh5Buffer)) {
		printf("Transfer for Channel E Complete!! \n");
	} else {
		printf("Transfer for Channel E Failed!! ERROR!! \n");
	}

	usleep(1000000);
	printf("Transferring Data from M2 to Channel F... ");
	if (bIdmaDmaM2Transfer((alt_u32 *) (DDR2_EXT_ADDR_WINDOWED_BASE), 31, eIdmaCh6Buffer)) {
		printf("Transfer for Channel F Complete!! \n");
	} else {
		printf("Transfer for Channel F Failed!! ERROR!! \n");
	}
	usleep(1000000);

	printf("Transferring Data from M2 to Channel G... ");
	if (bIdmaDmaM2Transfer((alt_u32 *) (DDR2_EXT_ADDR_WINDOWED_BASE), 31, eIdmaCh7Buffer)) {
		printf("Transfer for Channel G Complete!! \n");
	} else {
		printf("Transfer for Channel G Failed!! ERROR!! \n");
	}
	usleep(1000000);

	printf("Transferring Data from M2 to Channel H... ");
	if (bIdmaDmaM2Transfer((alt_u32 *) (DDR2_EXT_ADDR_WINDOWED_BASE), 31, eIdmaCh8Buffer)) {
		printf("Transfer for Channel H Complete!! \n");
	} else {
		printf("Transfer for Channel H Failed!! ERROR!! \n");
	}
	usleep(1000000);

	printf("\n");
	printf("Configuring Sync OneShot for Subunits... ");
	if (bSyncConfigOstSubunits(SYNC_DEFAULT_SUBUNIT_OST)) {
		printf("Subunit Sync configured!! \n");
		printf("Sending OneShot command to start transmission on all Subunits. \n");
		bSyncCtrOneShot();
	} else {
		printf("Subunit Sync not configured!! ERROR!! \n");
		printf("Will not send OneShot command to Subunits. \n");
	}

	printf("\n");
	printf("Finished Testbench, S2\n");

	while (1) {}

	return 0;
}
