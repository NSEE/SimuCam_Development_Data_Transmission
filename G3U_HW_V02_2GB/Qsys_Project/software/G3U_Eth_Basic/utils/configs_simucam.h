/*
 * configs_simucam.h
 *
 *  Created on: 26/11/2018
 *      Author: Tiago-Low
 */

#ifndef CONFIGS_SIMUCAM_H_
#define CONFIGS_SIMUCAM_H_

//#include "../simucam_definitions.h"
#include "sdcard_file_manager.h"
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <sys/alt_stdio.h>

#define ETH_FILE_NAME "DEF/ETH"
#define DEBUG_FILE_NAME "DEF/DEBUG"

typedef struct ConfEth{
	unsigned char ucIP[4];
	unsigned char ucGTW[4];
	unsigned char ucSubNet[4];
	unsigned char ucMAC[6];
	unsigned short int siPort;
	bool bDHCP;
}TConfEth;

typedef struct Defaults{
	unsigned short int usiDebugLevel;
	bool bSendEOP;
	bool bSendEEP;
}TDefaults;

extern TConfEth xConfEth;
extern TDefaults xDefaults;

/*Functions*/
bool vLoadDefaultETHConf( void );
bool vLoadDebugConfs( void );

#if DEBUG_ON
	void vShowEthConfig( void );
#endif
#endif /* CONFIGS_SIMUCAM_H_ */
