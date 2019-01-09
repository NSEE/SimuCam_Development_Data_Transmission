/*
 * default_configs.c
 *
 *  Created on: 24/04/2018
 *      Author: rfranca
 */

#include "default_configs.h"

#include "../logic/eth/eth.h"
#include "../driver/leds/leds.h"
#include "../driver/seven_seg/seven_seg.h"

/* Isolation and LDVS drivers definitions*/
#include "../driver/ctrl_io_lvds/ctrl_io_lvds.h"

void Init_Simucam_Config(void){

	/* Turn Off all LEDs */
	LEDS_BOARD_DRIVE(LEDS_OFF, LEDS_BOARD_ALL_MASK);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_PAINEL_ALL_MASK);

	/* Turn On Power LED */
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_POWER_MASK);

	/* Release ETH Reset */
	v_Eth_Release_Reset();

	/* Configure Seven Segments Display */
	SSDP_CONFIG(SSDP_NORMAL_MODE);
	SSDP_UPDATE(0);

	/* Set the Isolation and LVDS driver boards*/
	enable_iso_drivers();
	enable_lvds_board();

	printf("[TEST] ISO and LVDS started\r\n");

}
