/*
 * periodic_HK_task.c
 *
 *  Created on: Dec 12, 2019
 *      Author: yuribunduki
 */

#include "periodic_HK_task.h"

void periodic_HK_task(void *task_data) {
//    unsigned short int usiResetDelayL = 0;
//    INT8U iErrorCodeL = 0;
	div_t xDlyAdjustedS;
	div_t xDlyAdjustedM;
	div_t xDlyAdjustedH;

	for (;;) {
		if (T_simucam.T_conf.luHKPeriod == 0) {
			OSTaskSuspend(PERIODIC_HK_TASK_PRIORITY);
		}
		/* Format the delay time */
		xDlyAdjustedS = div(T_simucam.T_conf.luHKPeriod, 1000);
		xDlyAdjustedM = div(xDlyAdjustedS.quot, 60);
		xDlyAdjustedH = div(xDlyAdjustedM.quot, 60);

		OSTimeDlyHMSM(xDlyAdjustedH.quot, xDlyAdjustedH.rem, xDlyAdjustedM.rem, xDlyAdjustedS.rem);

		for (INT8U xCount = 0; xCount < NB_CHANNELS; xCount++) {
			v_HK_creator(xCount);
		}
	}

}
