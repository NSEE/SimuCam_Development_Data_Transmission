/*
 * test_module_simucam.c
 *
 *  Created on: 21/10/2018
 *      Author: TiagoLow
 */

#include "test_module_simucam.h"

bool bDdr2MemoryFastTest ( void );

bool bTestSimucamCriticalHW( void ) {
	bool bSuccess;

	bSuccess = bIdmaInitM1Dma();
	if ( FALSE == bSuccess ) {
		#if DEBUG_ON
			fprintf(fp, "SimuCam Critical HW Test: CRITICAL! Could not initiate the DMA for DDR2 Memory 1!\n");
		#endif
		return (bSuccess);
	} else {
		#if DEBUG_ON
			fprintf(fp, "SimuCam Critical HW Test: DMA for DDR2 Memory 1 initiated.\n");
		#endif
	}

	bSuccess = bIdmaInitM2Dma();
	if ( FALSE == bSuccess ) {
		#if DEBUG_ON
			fprintf(fp, "SimuCam Critical HW Test: CRITICAL! Could not initiate the DMA for DDR2 Memory 2!\n");
		#endif
		return (bSuccess);
	} else {
		#if DEBUG_ON
			fprintf(fp, "SimuCam Critical HW Test: DMA for DDR2 Memory 2 initiated.\n");
		#endif
	}

	bDdr2MemoryFastTest();

	return (TRUE);
}

bool bDdr2MemoryFastTest ( void ) {
	bool bSuccess = FALSE;
	bool bM1Success = FALSE;
	bool bM2Success = FALSE;
	volatile alt_u32 *vpuliDdrMemAddr = NULL;

	/* Write data into ddr2 memory 1 and ddr2 memory 2 to check if they are working*/

	/* Ddr2 Memory 1 */
#if DEBUG_ON
		fprintf(fp, "SimuCam Critical HW Test: Testing DDR2 Memory 1... ");
#endif
	usleep(1000000);
	bDdr2SwitchMemory(DDR2_M1_ID);
	bSuccess = TRUE;
	vRstcHoldSimucamReset(0); /* Hold SimuCam Reset Signal - Enable "Watchdog" (t = 1000 ms) */
	vpuliDdrMemAddr = (alt_u32 *)0x00000000; *vpuliDdrMemAddr = (alt_u32)0xAAAAAAAA;
	if (*vpuliDdrMemAddr != (alt_u32)0xAAAAAAAA) { bSuccess = FALSE; }
	vpuliDdrMemAddr = (alt_u32 *)0x0FFFFFFF; *vpuliDdrMemAddr = (alt_u32)0x55555555;
	if (*vpuliDdrMemAddr != (alt_u32)0x55555555) { bSuccess = FALSE; }
	vpuliDdrMemAddr = (alt_u32 *)0x1FFFFFFF; *vpuliDdrMemAddr = (alt_u32)0xAAAAAAAA;
	if (*vpuliDdrMemAddr != (alt_u32)0xAAAAAAAA) { bSuccess = FALSE; }
	vpuliDdrMemAddr = (alt_u32 *)0x2FFFFFFF; *vpuliDdrMemAddr = (alt_u32)0x55555555;
	if (*vpuliDdrMemAddr != (alt_u32)0x55555555) { bSuccess = FALSE; }
	vpuliDdrMemAddr = (alt_u32 *)0x3FFFFFFF; *vpuliDdrMemAddr = (alt_u32)0xAAAAAAAA;
	if (*vpuliDdrMemAddr != (alt_u32)0xAAAAAAAA) { bSuccess = FALSE; }
	vpuliDdrMemAddr = (alt_u32 *)0x4FFFFFFF; *vpuliDdrMemAddr = (alt_u32)0x55555555;
	if (*vpuliDdrMemAddr != (alt_u32)0x55555555) { bSuccess = FALSE; }
	vpuliDdrMemAddr = (alt_u32 *)0x5FFFFFFF; *vpuliDdrMemAddr = (alt_u32)0xAAAAAAAA;
	if (*vpuliDdrMemAddr != (alt_u32)0xAAAAAAAA) { bSuccess = FALSE; }
	vpuliDdrMemAddr = (alt_u32 *)0x6FFFFFFF; *vpuliDdrMemAddr = (alt_u32)0x55555555;
	if (*vpuliDdrMemAddr != (alt_u32)0x55555555) { bSuccess = FALSE; }
	vpuliDdrMemAddr = (alt_u32 *)0x7FFFFFFF; *vpuliDdrMemAddr = (alt_u32)0xAAAAAAAA;
	if (*vpuliDdrMemAddr != (alt_u32)0xAAAAAAAA) { bSuccess = FALSE; }
	if (bSuccess) {
		bM1Success = TRUE;
		vRstcReleaseSimucamReset(0); /* Release SimuCam Reset Signal - Disable "Watchdog"*/
#if DEBUG_ON
			fprintf(fp, "DDR2 Memory 1 Passed!\n");
#endif
	} else {
#if DEBUG_ON
			fprintf(fp, "CRITICAL! DDR2 Memory 1 Failure!\n");
#endif
	}

	/* Ddr2 Memory 2 */
#if DEBUG_ON
		fprintf(fp, "SimuCam Critical HW Test: Testing DDR2 Memory 2... ");
#endif
	usleep(1000000);
	bDdr2SwitchMemory(DDR2_M2_ID);
	bSuccess = TRUE;
	vRstcHoldSimucamReset(0); /* Hold SimuCam Reset Signal - Enable "Watchdog" (t = 1000 ms) */
	vpuliDdrMemAddr = (alt_u32 *)0x00000000; *vpuliDdrMemAddr = (alt_u32)0xAAAAAAAA;
	if (*vpuliDdrMemAddr != (alt_u32)0xAAAAAAAA) { bSuccess = FALSE; }
	vpuliDdrMemAddr = (alt_u32 *)0x0FFFFFFF; *vpuliDdrMemAddr = (alt_u32)0x55555555;
	if (*vpuliDdrMemAddr != (alt_u32)0x55555555) { bSuccess = FALSE; }
	vpuliDdrMemAddr = (alt_u32 *)0x1FFFFFFF; *vpuliDdrMemAddr = (alt_u32)0xAAAAAAAA;
	if (*vpuliDdrMemAddr != (alt_u32)0xAAAAAAAA) { bSuccess = FALSE; }
	vpuliDdrMemAddr = (alt_u32 *)0x2FFFFFFF; *vpuliDdrMemAddr = (alt_u32)0x55555555;
	if (*vpuliDdrMemAddr != (alt_u32)0x55555555) { bSuccess = FALSE; }
	vpuliDdrMemAddr = (alt_u32 *)0x3FFFFFFF; *vpuliDdrMemAddr = (alt_u32)0xAAAAAAAA;
	if (*vpuliDdrMemAddr != (alt_u32)0xAAAAAAAA) { bSuccess = FALSE; }
	vpuliDdrMemAddr = (alt_u32 *)0x4FFFFFFF; *vpuliDdrMemAddr = (alt_u32)0x55555555;
	if (*vpuliDdrMemAddr != (alt_u32)0x55555555) { bSuccess = FALSE; }
	vpuliDdrMemAddr = (alt_u32 *)0x5FFFFFFF; *vpuliDdrMemAddr = (alt_u32)0xAAAAAAAA;
	if (*vpuliDdrMemAddr != (alt_u32)0xAAAAAAAA) { bSuccess = FALSE; }
	vpuliDdrMemAddr = (alt_u32 *)0x6FFFFFFF; *vpuliDdrMemAddr = (alt_u32)0x55555555;
	if (*vpuliDdrMemAddr != (alt_u32)0x55555555) { bSuccess = FALSE; }
	vpuliDdrMemAddr = (alt_u32 *)0x7FFFFFFF; *vpuliDdrMemAddr = (alt_u32)0xAAAAAAAA;
	if (*vpuliDdrMemAddr != (alt_u32)0xAAAAAAAA) { bSuccess = FALSE; }
	if (bSuccess) {
		bM2Success = TRUE;
		vRstcReleaseSimucamReset(0); /* Release SimuCam Reset Signal - Disable "Watchdog"*/
#if DEBUG_ON
			fprintf(fp, "DDR2 Memory 2 Passed!\n\n");
#endif
	} else {
#if DEBUG_ON
			fprintf(fp, "CRITICAL! DDR2 Memory 2 Failure!\n\n");
#endif
	}

	bSuccess = FALSE;
	if ((bM1Success) && (bM2Success)) { bSuccess = TRUE; }

	return ( bSuccess );
}
