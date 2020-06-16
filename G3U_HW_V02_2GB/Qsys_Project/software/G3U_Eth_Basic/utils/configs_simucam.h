/*
 * configs_simucam.h
 *
 *  Created on: 26/11/2018
 *      Author: Tiago-Low
 */

#ifndef CONFIGS_SIMUCAM_H_
#define CONFIGS_SIMUCAM_H_

#include "../simucam_definitions.h"
#include "sdcard_file_manager.h"
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <sys/alt_stdio.h>

#define ETH_FILE_NAME "IDEF/ETH"
#define RMAP_FILE_NAME "IDEF/RMAP"
#define DEBUG_FILE_NAME "IDEF/DEBUG"

typedef struct ConfEth{
	unsigned char ucIP[4];
	unsigned char ucGTW[4];
	unsigned char ucSubNet[4];
	unsigned char ucDNS[4];
	unsigned char ucMAC[6];
	unsigned short int siPort;
	bool bDHCP;
}TConfEth;

typedef struct ConfRmap{
	alt_u8 ucKey[8];
	alt_u8 ucLogicalAddr[8];
	alt_32 uliAddrOffset[8];
}TConfRmap;

typedef struct ConfDebug{
	unsigned short int usiDebugLevel;
	bool bSendEOP;
	bool bSendEEP;
}TConfDebug;

extern TConfEth xConfEth;
extern TConfRmap xConfRmap;
extern TConfDebug xConfDebug;

/*Functions*/
bool bLoadDefaultEthConf( void );
bool bLoadDefaultRmapConf( void );
bool bLoadDefaultDebugConf( void );

#if DEBUG_ON
	void vShowEthConfig( void );
	void vShowRmapConfig( void );
	void vShowDebugConfig( void );
#endif
#endif /* CONFIGS_SIMUCAM_H_ */
