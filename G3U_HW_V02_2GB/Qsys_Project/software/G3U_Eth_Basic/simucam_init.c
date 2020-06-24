/*
 ************************************************************************************************
 *                                              NSEE
 *                                             Address
 *
 *                                       All Rights Reserved
 *
 * TODO header format
 * Filename     : simucam_init.c
 * Programmer(s): Yuri Bunduki
 * Created on: May 27, 2019
 * Description  : Header file for the Simucam initialization task.
 ************************************************************************************************
 */
/*$PAGE*/

#include "rtos/simucam_init_task.h"
#include "simucam_definitions.h"
#include "utils/initialization_simucam.h"
#include "utils/test_module_simucam.h"

/* Declaring file for JTAG debug */
#if DEBUG_ON
FILE* fp;
#endif

/* 
 *  Main task
 */
int main(int argc, char* argv[], char* envp[]) {
//  INT8U error_code;

	/* Debug device initialization - JTAG USB */
#if DEBUG_ON
	fp = fopen(JTAG_UART_0_NAME, "r+");
#endif

#if DEBUG_ON
	fprintf(fp, "Main entry point.\n");
#endif

	/* Initialization of core HW */
	if (bInitSimucamCoreHW()) {
#if DEBUG_ON
		fprintf(fp, "\n");
		fprintf(fp, "SimuCam Release: %s\n", SIMUCAM_RELEASE);
		fprintf(fp, "SimuCam HW Version: %s.%s\n", SIMUCAM_RELEASE, SIMUCAM_HW_VERSION);
		fprintf(fp, "SimuCam FW Version: %s.%s.%s\n", SIMUCAM_RELEASE, SIMUCAM_HW_VERSION, SIMUCAM_FW_VERSION);
		fprintf(fp, "\n");
#endif
	} else {
#if DEBUG_ON
		fprintf(fp, "\n");
		fprintf(fp, "CRITICAL HW FAILURE: Hardware TimeStamp or System ID does not match the expected! SimuCam will be halted.\n");
		fprintf(fp, "CRITICAL HW FAILURE: Expected HW release: %s.%s\n", SIMUCAM_RELEASE, SIMUCAM_HW_VERSION);
		fprintf(fp, "CRITICAL HW FAILURE: SimuCam will be halted.\n");
		fprintf(fp, "\n");
#endif
		while (1) {
		}
	}

	/* Test of some critical IPCores HW interfaces in the Simucam */
	if (!bTestSimucamCriticalHW()) {
		fprintf(fp, "CRITICAL HW FAILURE: SimuCam will be halted.\n");
		fprintf(fp, "\n");
		while (1) {
		}
	}

	/* Initialization of basic HW */
	vInitSimucamBasicHW();

	/* Initialize SD Card */
	bInitializeSDCard();

	/* Load DEBUG Configurations from SD Card */
	bLoadDefaultDebugConf();

	/* Load RMAP Configurations from SD Card */
	bLoadDefaultRmapConf();

	/* Load ETH Configurations from SD Card */
	bLoadDefaultEthConf();

	/* Show loaded configurations from SD Card */
#if DEBUG_ON
	if (xConfDebug.usiDebugLevel <= xMajor) {
		vShowDebugConfig();
		vShowRmapConfig();
		vShowEthConfig();
	}
#endif

	/* Clear the RTOS timer */
	OSTimeSet(0);

#if DEBUG_ON
	if (xConfDebug.usiDebugLevel <= xMajor) {
		fprintf(fp, "\nSimucam Tasks initializing\n");
	}
#endif

	/*
	 * Create os data structures
	 */
	SimucamCreateOSQ();
	DataCreateOSQ();

	/*create the sub-units data structures*/
	sub_unit_create_os_data_structs();

	/* create the Simucam tasks */
	SimucamCreateTasks();

	/*
	 * Start the OS
	 */
	OSStart();

	while (1)
		; /* Correct Program Flow never gets here. */

	return -1;
}
