/*
 * initialization_simucam.c
 *
 *  Created on: 20/10/2018
 *      Author: TiagoLow
 */

#include "initialization_simucam.h"

bool bInitSimucamCoreHW(void) {
	bool bSuccess = FALSE;

	/* Release SimuCam Reset Signal */
	vRstcReleaseSimucamReset(0);

	/* Check System ID and Timestamp */
	TSidpRegisters *pxSidpRegisters = (TSidpRegisters *) (SYSID_QSYS_BASE);

	if (( SYSID_QSYS_ID == pxSidpRegisters->uliId) && ( SYSID_QSYS_TIMESTAMP == pxSidpRegisters->uliTimestamp)) {
		bSuccess = TRUE;
	}

	return (bSuccess);
}

void vInitSimucamBasicHW(void) {

	/* Turn Off all LEDs */
	bSetBoardLeds(LEDS_OFF, LEDS_BOARD_ALL_MASK);
	bSetPainelLeds(LEDS_OFF, LEDS_PAINEL_ALL_MASK);

	/* Turn On Power LED */
	bSetPainelLeds(LEDS_ON, LEDS_POWER_MASK);

	/* Configure Seven Segments Display */
	bSSDisplayConfig(SSDP_NORMAL_MODE);
	bSSDisplayUpdate(0);

//	/* Disable the Isolation and LVDS driver boards*/
//	bDisableIsoDrivers();
//	bDisableLvdsBoard();

	/* Enable the Isolation and LVDS driver boards*/
	bEnableIsoDrivers();
	bEnableLvdsBoard();

	/* Turn on all Panel Leds */
	bSetPainelLeds( LEDS_ON, LEDS_PAINEL_ALL_MASK);
	usleep(5000000);
	/* initial values for the Leds */
	bSetPainelLeds( LEDS_OFF, LEDS_PAINEL_ALL_MASK);
	bSetPainelLeds( LEDS_ON, LEDS_POWER_MASK);

}
