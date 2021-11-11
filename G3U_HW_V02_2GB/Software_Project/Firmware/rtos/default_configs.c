/*
 * default_configs.c
 *
 *  Created on: 24/04/2018
 *      Author: rfranca
 */

#include "default_configs.h"

#include "../driver/leds/leds.h"
#include "../driver/seven_seg/seven_seg.h"
#include "../driver/ctrl_io_lvds/ctrl_io_lvds.h"

void Init_Simucam_Config(void) {

	/* Turn Off all LEDs */
	bSetBoardLeds(LEDS_OFF, LEDS_BOARD_ALL_MASK);
	bSetPainelLeds(LEDS_OFF, LEDS_PAINEL_ALL_MASK);

	/* Turn On Power LED */
	bSetPainelLeds(LEDS_ON, LEDS_POWER_MASK);

	/* Configure Seven Segments Display */
	bSSDisplayConfig(SSDP_NORMAL_MODE);
	bSSDisplayUpdate(0);

	/* Disable the Isolation and LVDS driver boards*/
	bDisableIsoLogic();
	bDisableIsoDrivers();
	bDisableLvdsBoard();

	/* Turn on all Panel Leds */
	bSetPainelLeds(LEDS_ON, LEDS_PAINEL_ALL_MASK);
	usleep(500000);
	bSetPainelLeds(LEDS_OFF, LEDS_PAINEL_ALL_MASK);
	bSetPainelLeds(LEDS_ON, LEDS_POWER_MASK);

	volatile alt_u16 *vpusiUartAddr = (alt_u16 *) UART_MODULE_TOP_0_BASE;
	vpusiUartAddr[4] = ((vpusiUartAddr[4] - 1) * 12) + 1;
//	fprintf(fp, "baud: %u \n", vpusiUartAddr[4]);

}
