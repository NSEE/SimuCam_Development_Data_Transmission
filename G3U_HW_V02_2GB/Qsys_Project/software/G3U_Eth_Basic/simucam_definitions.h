/*
 * simucam_definitions.h
 *
 *  Created on: Mar 22, 2019
 *      Author: bndky
 */

#ifndef SIMUCAM_DEFINITIONS_H_
#define SIMUCAM_DEFINITIONS_H_


#define DEBUG_ON 1

#ifndef bool
	//typedef short int bool;
	//typedef enum e_bool { false = 0, true = 1 } bool;
	//#define false   0
	//#define true    1
	#define FALSE   0
	#define TRUE    1
#endif

typedef enum { dlFullMessage = 0, dlCustom0, dlMinorMessage, dlCustom1, dlMajorMessage, dlCustom2, dlJustMajorProgress, dlCriticalOnly } tDebugLevel;

/* Variable that will carry the debug JTAG device file descriptor*/
//#if DEBUG_ON
//    extern FILE* fp;
//#endif

#endif /* SIMUCAM_DEFINITIONS_H_ */
