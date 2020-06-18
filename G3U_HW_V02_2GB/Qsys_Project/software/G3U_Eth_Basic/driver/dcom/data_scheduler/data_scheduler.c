/*
 * data_scheduler.c
 *
 *  Created on: 19/12/2018
 *      Author: rfranca
 */

#include "data_scheduler.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
// A variable to hold the context of interrupt
static volatile int viCh1HoldContext;
static volatile int viCh2HoldContext;
static volatile int viCh3HoldContext;
static volatile int viCh4HoldContext;
static volatile int viCh5HoldContext;
static volatile int viCh6HoldContext;
static volatile int viCh7HoldContext;
static volatile int viCh8HoldContext;

//! [data memory private global variables]
static sub_config_t xSubTemp;
static int i_echo_buffer_ctr = 0;
static x_echo x_echo_sent[ECHO_BUFFER];
INT8U queue_error;

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
void vDschCh1HandleIrq(void* pvContext) {
	/* Cast context to hold_context's type. It is important that this be
	 * declared volatile to avoid unwanted compiler optimization.
	 * volatile int* pviHoldContext = (volatile int*) pvContext;
	 * Use context value according to your app logic...
	 * *pviHoldContext = ...;
	 * if (*pviHoldContext == '0') {}...
	 * App logic sequence...
	 */

	volatile TDcomChannel *vpxDcomChannel = (TDcomChannel *)(DCOM_CH_1_BASE_ADDR);

	/* Check IRQ Tx Begin Flag */
	if (vpxDcomChannel->xDataScheduler.xDschIrqFlag.bTxBeginFlag) {
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxBeginFlagClr = TRUE;
		/* IRQ Tx Begin Flag ISR */

		T_simucam.T_Sub[0].T_conf.sub_status_sending = 1;
		if (T_simucam.T_Sub[0].T_data.i_imagette
				< T_simucam.T_Sub[0].T_data.nb_of_imagettes) {
			OSQPost(DMA_sched_queue[0], (void *) 0);
			OSQPost(p_dma_scheduler_controller_queue[0], (void *) simDMASched);
		}

	}

	/* Check IRQ Tx End Flag */
	if (vpxDcomChannel->xDataScheduler.xDschIrqFlag.bTxEndFlag) {
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxEndFlagClr = TRUE;
		/* IRQ Tx End Flag ISR */

		bDschGetTimerStatus(&xSimucamTimer);
		T_simucam.T_status.simucam_running_time = xSimucamTimer.xDschTimerStatus.uliCurrentTime;
		if (T_simucam.T_conf.echo_sent == 1 || T_simucam.T_conf.iLog == 1) {
			x_echo_sent[i_echo_buffer_ctr].channel = 0;
			x_echo_sent[i_echo_buffer_ctr].nb_imagette = T_simucam.T_Sub[0].T_conf.i_imagette_control;
			x_echo_sent[i_echo_buffer_ctr].simucam_time = T_simucam.T_status.simucam_running_time;
            if (T_simucam.T_conf.iLog == 1){
                for (INT8U m = 0; m < 8; m++){
                    x_echo_sent[i_echo_buffer_ctr].iTag[m] = T_simucam.T_Sub[0].T_data.tag[m];
                }
            }
			queue_error = OSQPost(p_echo_queue,&(x_echo_sent[i_echo_buffer_ctr]));
			if (queue_error == OS_ERR_NONE) {
				i_echo_buffer_ctr++;
#if DEBUG_ON
				fprintf(fp, "[SCHEDULER]Next buffer nb %i.\r\n", i_echo_buffer_ctr);
#endif
				if (i_echo_buffer_ctr == ECHO_BUFFER) {
#if DEBUG_ON
					fprintf(fp, "[SCHEDULER]Buffer limit attaigned.\r\n");
#endif
					i_echo_buffer_ctr = 0;
				}
			} else {
#if DEBUG_ON
				fprintf(fp, "[SCHEDULER]Queue limit attaigned.\r\n");
#endif
			}
		}

		T_simucam.T_Sub[0].T_conf.i_imagette_control++;
		T_simucam.T_status.simucam_total_imagettes_sent++;
		T_simucam.T_Sub[0].T_conf.sub_status_sending = 0;

		if (T_simucam.T_Sub[0].T_conf.i_imagette_control
				>= T_simucam.T_Sub[0].T_data.nb_of_imagettes) {
			xSubTemp.mode = subAbort;
			OSQPost(p_sub_unit_config_queue[0], &xSubTemp);
		} else {

		}

	}

}

void vDschCh2HandleIrq(void* pvContext) {
	/* Cast context to hold_context's type. It is important that this be
	 * declared volatile to avoid unwanted compiler optimization.
	 * volatile int* pviHoldContext = (volatile int*) pvContext;
	 * Use context value according to your app logic...
	 * *pviHoldContext = ...;
	 * if (*pviHoldContext == '0') {}...
	 * App logic sequence...
	 */

	volatile TDcomChannel *vpxDcomChannel = (TDcomChannel *)(DCOM_CH_2_BASE_ADDR);

	/* Check IRQ Tx Begin Flag */
	if (vpxDcomChannel->xDataScheduler.xDschIrqFlag.bTxBeginFlag) {
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxBeginFlagClr = TRUE;
		/* IRQ Tx Begin Flag ISR */

		T_simucam.T_Sub[1].T_conf.sub_status_sending = 1;
		if (T_simucam.T_Sub[1].T_data.i_imagette
				< T_simucam.T_Sub[1].T_data.nb_of_imagettes) {
			OSQPost(DMA_sched_queue[0], (void *) 1);
			OSQPost(p_dma_scheduler_controller_queue[0], (void *) simDMASched);
		}

	}

	/* Check IRQ Tx End Flag */
	if (vpxDcomChannel->xDataScheduler.xDschIrqFlag.bTxEndFlag) {
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxEndFlagClr = TRUE;
		/* IRQ Tx End Flag ISR */

		bDschGetTimerStatus(&xSimucamTimer);
		T_simucam.T_status.simucam_running_time = xSimucamTimer.xDschTimerStatus.uliCurrentTime;
		if (T_simucam.T_conf.echo_sent == 1 || T_simucam.T_conf.iLog == 1) {
			x_echo_sent[i_echo_buffer_ctr].channel = 1;
			x_echo_sent[i_echo_buffer_ctr].nb_imagette =
					T_simucam.T_Sub[1].T_conf.i_imagette_control;
			x_echo_sent[i_echo_buffer_ctr].simucam_time =
					T_simucam.T_status.simucam_running_time;
            if (T_simucam.T_conf.iLog == 1){
                for (INT8U m = 0; m < 8; m++){
                    x_echo_sent[i_echo_buffer_ctr].iTag[m] =
                            T_simucam.T_Sub[1].T_data.tag[m];
                }
            }
			queue_error = OSQPost(p_echo_queue,
					&(x_echo_sent[i_echo_buffer_ctr]));
			if (queue_error == OS_ERR_NONE) {
				i_echo_buffer_ctr++;
#if DEBUG_ON
				fprintf(fp, "[SCHEDULER]Next buffer nb %i.\r\n",
						i_echo_buffer_ctr);
#endif
				if (i_echo_buffer_ctr == ECHO_BUFFER) {
#if DEBUG_ON
					fprintf(fp, "[SCHEDULER]Buffer limit attaigned.\r\n");
#endif
					i_echo_buffer_ctr = 0;
				}
			} else {
#if DEBUG_ON
				fprintf(fp, "[SCHEDULER]Queue limit attaigned.\r\n");
#endif
			}
		}

		T_simucam.T_Sub[1].T_conf.i_imagette_control++;
		T_simucam.T_status.simucam_total_imagettes_sent++;
		T_simucam.T_Sub[1].T_conf.sub_status_sending = 0;

		if (T_simucam.T_Sub[1].T_conf.i_imagette_control
				>= T_simucam.T_Sub[1].T_data.nb_of_imagettes) {
			xSubTemp.mode = subAbort;
			OSQPost(p_sub_unit_config_queue[1], &xSubTemp);
			T_simucam.T_Sub[1].T_conf.i_imagette_control = 0;
		}

	}

}

void vDschCh3HandleIrq(void* pvContext) {
	/* Cast context to hold_context's type. It is important that this be
	 * declared volatile to avoid unwanted compiler optimization.
	 * volatile int* pviHoldContext = (volatile int*) pvContext;
	 * Use context value according to your app logic...
	 * *pviHoldContext = ...;
	 * if (*pviHoldContext == '0') {}...
	 * App logic sequence...
	 */

	volatile TDcomChannel *vpxDcomChannel = (TDcomChannel *)(DCOM_CH_3_BASE_ADDR);

	/* Check IRQ Tx Begin Flag */
	if (vpxDcomChannel->xDataScheduler.xDschIrqFlag.bTxBeginFlag) {
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxBeginFlagClr = TRUE;
		/* IRQ Tx Begin Flag ISR */

		T_simucam.T_Sub[2].T_conf.sub_status_sending = 1;
		if (T_simucam.T_Sub[2].T_data.i_imagette
				< T_simucam.T_Sub[2].T_data.nb_of_imagettes) {
			OSQPost(DMA_sched_queue[0], (void *) 2);
			OSQPost(p_dma_scheduler_controller_queue[0], (void *) simDMASched);
		}

	}

	/* Check IRQ Tx End Flag */
	if (vpxDcomChannel->xDataScheduler.xDschIrqFlag.bTxEndFlag) {
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxEndFlagClr = TRUE;
		/* IRQ Tx End Flag ISR */

		bDschGetTimerStatus(&xSimucamTimer);
		T_simucam.T_status.simucam_running_time = xSimucamTimer.xDschTimerStatus.uliCurrentTime;
		if (T_simucam.T_conf.echo_sent == 1 || T_simucam.T_conf.iLog == 1) {
			x_echo_sent[i_echo_buffer_ctr].channel = 2;
			x_echo_sent[i_echo_buffer_ctr].nb_imagette =
					T_simucam.T_Sub[2].T_conf.i_imagette_control;
			x_echo_sent[i_echo_buffer_ctr].simucam_time =
					T_simucam.T_status.simucam_running_time;
			if (T_simucam.T_conf.iLog == 1){
                for (INT8U m = 0; m < 8; m++){
                    x_echo_sent[i_echo_buffer_ctr].iTag[m] =
                            T_simucam.T_Sub[2].T_data.tag[m];
                }
            }
            queue_error = OSQPost(p_echo_queue,
					&(x_echo_sent[i_echo_buffer_ctr]));
			if (queue_error == OS_ERR_NONE) {
				i_echo_buffer_ctr++;
				if (i_echo_buffer_ctr == ECHO_BUFFER) {
					i_echo_buffer_ctr = 0;
				}
			} else {
#if DEBUG_ON
				fprintf(fp, "[SCHEDULER]Queue limit attaigned.\r\n");
#endif
			}
		}

		T_simucam.T_Sub[2].T_conf.i_imagette_control++;
		T_simucam.T_status.simucam_total_imagettes_sent++;
		T_simucam.T_Sub[2].T_conf.sub_status_sending = 0;

		if (T_simucam.T_Sub[2].T_conf.i_imagette_control
				>= T_simucam.T_Sub[2].T_data.nb_of_imagettes) {
			xSubTemp.mode = subAbort;
			OSQPost(p_sub_unit_config_queue[2], &xSubTemp);
		}

	}

}

void vDschCh4HandleIrq(void* pvContext) {
	/* Cast context to hold_context's type. It is important that this be
	 * declared volatile to avoid unwanted compiler optimization.
	 * volatile int* pviHoldContext = (volatile int*) pvContext;
	 * Use context value according to your app logic...
	 * *pviHoldContext = ...;
	 * if (*pviHoldContext == '0') {}...
	 * App logic sequence...
	 */

	volatile TDcomChannel *vpxDcomChannel = (TDcomChannel *)(DCOM_CH_4_BASE_ADDR);

	/* Check IRQ Tx Begin Flag */
	if (vpxDcomChannel->xDataScheduler.xDschIrqFlag.bTxBeginFlag) {
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxBeginFlagClr = TRUE;
		/* IRQ Tx Begin Flag ISR */

		T_simucam.T_Sub[3].T_conf.sub_status_sending = 1;
		if (T_simucam.T_Sub[3].T_data.i_imagette
				< T_simucam.T_Sub[3].T_data.nb_of_imagettes) {
			OSQPost(DMA_sched_queue[0], (void *) 3);
			OSQPost(p_dma_scheduler_controller_queue[0], (void *) simDMASched);
		}

	}

	/* Check IRQ Tx End Flag */
	if (vpxDcomChannel->xDataScheduler.xDschIrqFlag.bTxEndFlag) {
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxEndFlagClr = TRUE;
		/* IRQ Tx End Flag ISR */

		bDschGetTimerStatus(&xSimucamTimer);
		T_simucam.T_status.simucam_running_time = xSimucamTimer.xDschTimerStatus.uliCurrentTime;
		if (T_simucam.T_conf.echo_sent == 1 || T_simucam.T_conf.iLog == 1) {
			x_echo_sent[i_echo_buffer_ctr].channel = 3;
			x_echo_sent[i_echo_buffer_ctr].nb_imagette =
					T_simucam.T_Sub[3].T_conf.i_imagette_control;
			x_echo_sent[i_echo_buffer_ctr].simucam_time =
					T_simucam.T_status.simucam_running_time;
			if (T_simucam.T_conf.iLog == 1){
                for (INT8U m = 0; m < 8; m++){
                    x_echo_sent[i_echo_buffer_ctr].iTag[m] =
                            T_simucam.T_Sub[3].T_data.tag[m];
                }
            }
            queue_error = OSQPost(p_echo_queue,
					&(x_echo_sent[i_echo_buffer_ctr]));
			if (queue_error == OS_ERR_NONE) {
				i_echo_buffer_ctr++;
				if (i_echo_buffer_ctr == ECHO_BUFFER) {
					i_echo_buffer_ctr = 0;
				}
			} else {
#if DEBUG_ON
				fprintf(fp, "[SCHEDULER]Queue limit attaigned.\r\n");
#endif
			}
		}

		T_simucam.T_Sub[3].T_conf.i_imagette_control++;
		T_simucam.T_status.simucam_total_imagettes_sent++;
		T_simucam.T_Sub[3].T_conf.sub_status_sending = 0;

		if (T_simucam.T_Sub[3].T_conf.i_imagette_control
				>= T_simucam.T_Sub[3].T_data.nb_of_imagettes) {
			xSubTemp.mode = subAbort;
			OSQPost(p_sub_unit_config_queue[3], &xSubTemp);
		}

	}

}

void vDschCh5HandleIrq(void* pvContext) {
	/* Cast context to hold_context's type. It is important that this be
	 * declared volatile to avoid unwanted compiler optimization.
	 * volatile int* pviHoldContext = (volatile int*) pvContext;
	 * Use context value according to your app logic...
	 * *pviHoldContext = ...;
	 * if (*pviHoldContext == '0') {}...
	 * App logic sequence...
	 */

	volatile TDcomChannel *vpxDcomChannel = (TDcomChannel *)(DCOM_CH_5_BASE_ADDR);

	/* Check IRQ Tx Begin Flag */
	if (vpxDcomChannel->xDataScheduler.xDschIrqFlag.bTxBeginFlag) {
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxBeginFlagClr = TRUE;
		/* IRQ Tx Begin Flag ISR */

		T_simucam.T_Sub[4].T_conf.sub_status_sending = 1;
		if (T_simucam.T_Sub[4].T_data.i_imagette
				< T_simucam.T_Sub[4].T_data.nb_of_imagettes) {
			OSQPost(DMA_sched_queue[1], (void *) 4);
			OSQPost(p_dma_scheduler_controller_queue[1], (void *) simDMASched);
		}

	}

	/* Check IRQ Tx End Flag */
	if (vpxDcomChannel->xDataScheduler.xDschIrqFlag.bTxEndFlag) {
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxEndFlagClr = TRUE;
		/* IRQ Tx End Flag ISR */

		bDschGetTimerStatus(&xSimucamTimer);
		T_simucam.T_status.simucam_running_time = xSimucamTimer.xDschTimerStatus.uliCurrentTime;
		if (T_simucam.T_conf.echo_sent == 1 || T_simucam.T_conf.iLog == 1) {
			x_echo_sent[i_echo_buffer_ctr].channel = 4;
			x_echo_sent[i_echo_buffer_ctr].nb_imagette =
					T_simucam.T_Sub[4].T_conf.i_imagette_control;
			x_echo_sent[i_echo_buffer_ctr].simucam_time =
					T_simucam.T_status.simucam_running_time;
			if (T_simucam.T_conf.iLog == 1){
                for (INT8U m = 0; m < 8; m++){
                    x_echo_sent[i_echo_buffer_ctr].iTag[m] =
                            T_simucam.T_Sub[4].T_data.tag[m];
                }
            }
            queue_error = OSQPost(p_echo_queue,
					&(x_echo_sent[i_echo_buffer_ctr]));
			if (queue_error == OS_ERR_NONE) {
				i_echo_buffer_ctr++;
				if (i_echo_buffer_ctr == ECHO_BUFFER) {
					i_echo_buffer_ctr = 0;
				}
			} else {
#if DEBUG_ON
				fprintf(fp, "[SCHEDULER]Queue limit attaigned.\r\n");
#endif
			}
		}

		T_simucam.T_Sub[4].T_conf.i_imagette_control++;
		T_simucam.T_status.simucam_total_imagettes_sent++;
		T_simucam.T_Sub[4].T_conf.sub_status_sending = 0;

		if (T_simucam.T_Sub[4].T_conf.i_imagette_control
				>= T_simucam.T_Sub[4].T_data.nb_of_imagettes) {
			xSubTemp.mode = subAbort;
			OSQPost(p_sub_unit_config_queue[4], &xSubTemp);
		}

	}

}

void vDschCh6HandleIrq(void* pvContext) {
	/* Cast context to hold_context's type. It is important that this be
	 * declared volatile to avoid unwanted compiler optimization.
	 * volatile int* pviHoldContext = (volatile int*) pvContext;
	 * Use context value according to your app logic...
	 * *pviHoldContext = ...;
	 * if (*pviHoldContext == '0') {}...
	 * App logic sequence...
	 */

	volatile TDcomChannel *vpxDcomChannel = (TDcomChannel *)(DCOM_CH_6_BASE_ADDR);

	/* Check IRQ Tx Begin Flag */
	if (vpxDcomChannel->xDataScheduler.xDschIrqFlag.bTxBeginFlag) {
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxBeginFlagClr = TRUE;
		/* IRQ Tx Begin Flag ISR */

		T_simucam.T_Sub[5].T_conf.sub_status_sending = 1;
		if (T_simucam.T_Sub[5].T_data.i_imagette
				< T_simucam.T_Sub[5].T_data.nb_of_imagettes) {
			OSQPost(DMA_sched_queue[1], (void *) 5);
			OSQPost(p_dma_scheduler_controller_queue[1], (void *) simDMASched);
		}

	}

	/* Check IRQ Tx End Flag */
	if (vpxDcomChannel->xDataScheduler.xDschIrqFlag.bTxEndFlag) {
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxEndFlagClr = TRUE;
		/* IRQ Tx End Flag ISR */

		bDschGetTimerStatus(&xSimucamTimer);
		T_simucam.T_status.simucam_running_time = xSimucamTimer.xDschTimerStatus.uliCurrentTime;
		if (T_simucam.T_conf.echo_sent == 1 || T_simucam.T_conf.iLog == 1) {
			x_echo_sent[i_echo_buffer_ctr].channel = 5;
			x_echo_sent[i_echo_buffer_ctr].nb_imagette =
					T_simucam.T_Sub[5].T_conf.i_imagette_control;
			x_echo_sent[i_echo_buffer_ctr].simucam_time =
					T_simucam.T_status.simucam_running_time;
			if (T_simucam.T_conf.iLog == 1){
                for (INT8U m = 0; m < 8; m++){
                    x_echo_sent[i_echo_buffer_ctr].iTag[m] =
                            T_simucam.T_Sub[5].T_data.tag[m];
                }
            }
            queue_error = OSQPost(p_echo_queue,
					&(x_echo_sent[i_echo_buffer_ctr]));
			if (queue_error == OS_ERR_NONE) {
				i_echo_buffer_ctr++;
				if (i_echo_buffer_ctr == ECHO_BUFFER) {
					i_echo_buffer_ctr = 0;
				}
			} else {
#if DEBUG_ON
				fprintf(fp, "[SCHEDULER]Queue limit attaigned.\r\n");
#endif
			}
		}

		T_simucam.T_Sub[5].T_conf.i_imagette_control++;
		T_simucam.T_status.simucam_total_imagettes_sent++;
		T_simucam.T_Sub[5].T_conf.sub_status_sending = 0;

		if (T_simucam.T_Sub[5].T_conf.i_imagette_control
				>= T_simucam.T_Sub[5].T_data.nb_of_imagettes) {
			xSubTemp.mode = subAbort;
			OSQPost(p_sub_unit_config_queue[5], &xSubTemp);
		}

	}

}

void vDschCh7HandleIrq(void* pvContext) {
	/* Cast context to hold_context's type. It is important that this be
	 * declared volatile to avoid unwanted compiler optimization.
	 * volatile int* pviHoldContext = (volatile int*) pvContext;
	 * Use context value according to your app logic...
	 * *pviHoldContext = ...;
	 * if (*pviHoldContext == '0') {}...
	 * App logic sequence...
	 */

	volatile TDcomChannel *vpxDcomChannel = (TDcomChannel *)(DCOM_CH_7_BASE_ADDR);

	/* Check IRQ Tx Begin Flag */
	if (vpxDcomChannel->xDataScheduler.xDschIrqFlag.bTxBeginFlag) {
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxBeginFlagClr = TRUE;
		/* IRQ Tx Begin Flag ISR */

		T_simucam.T_Sub[6].T_conf.sub_status_sending = 1;
		if (T_simucam.T_Sub[6].T_data.i_imagette
				< T_simucam.T_Sub[6].T_data.nb_of_imagettes) {
			OSQPost(DMA_sched_queue[1], (void *) 6);
			OSQPost(p_dma_scheduler_controller_queue[1], (void *) simDMASched);
		}

	}

	/* Check IRQ Tx End Flag */
	if (vpxDcomChannel->xDataScheduler.xDschIrqFlag.bTxEndFlag) {
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxEndFlagClr = TRUE;
		/* IRQ Tx End Flag ISR */

		bDschGetTimerStatus(&xSimucamTimer);
		T_simucam.T_status.simucam_running_time = xSimucamTimer.xDschTimerStatus.uliCurrentTime;
		if (T_simucam.T_conf.echo_sent == 1 || T_simucam.T_conf.iLog == 1) {
			x_echo_sent[i_echo_buffer_ctr].channel = 6;
			x_echo_sent[i_echo_buffer_ctr].nb_imagette =
					T_simucam.T_Sub[6].T_conf.i_imagette_control;
			x_echo_sent[i_echo_buffer_ctr].simucam_time =
					T_simucam.T_status.simucam_running_time;
			if (T_simucam.T_conf.iLog == 1){
                for (INT8U m = 0; m < 8; m++){
                    x_echo_sent[i_echo_buffer_ctr].iTag[m] =
                            T_simucam.T_Sub[6].T_data.tag[m];
                }
            }
            queue_error = OSQPost(p_echo_queue,
					&(x_echo_sent[i_echo_buffer_ctr]));
			if (queue_error == OS_ERR_NONE) {
				i_echo_buffer_ctr++;
				if (i_echo_buffer_ctr == ECHO_BUFFER) {
					i_echo_buffer_ctr = 0;
				}
			} else {
#if DEBUG_ON
				fprintf(fp, "[SCHEDULER]Queue limit attaigned.\r\n");
#endif
			}
		}

		T_simucam.T_Sub[6].T_conf.i_imagette_control++;
		T_simucam.T_status.simucam_total_imagettes_sent++;
		T_simucam.T_Sub[6].T_conf.sub_status_sending = 0;

		if (T_simucam.T_Sub[6].T_conf.i_imagette_control
				>= T_simucam.T_Sub[6].T_data.nb_of_imagettes) {
			xSubTemp.mode = subAbort;
			OSQPost(p_sub_unit_config_queue[6], &xSubTemp);
		}

	}

}

void vDschCh8HandleIrq(void* pvContext) {
	/* Cast context to hold_context's type. It is important that this be
	 * declared volatile to avoid unwanted compiler optimization.
	 * volatile int* pviHoldContext = (volatile int*) pvContext;
	 * Use context value according to your app logic...
	 * *pviHoldContext = ...;
	 * if (*pviHoldContext == '0') {}...
	 * App logic sequence...
	 */

	volatile TDcomChannel *vpxDcomChannel = (TDcomChannel *)(DCOM_CH_8_BASE_ADDR);

	/* Check IRQ Tx Begin Flag */
	if (vpxDcomChannel->xDataScheduler.xDschIrqFlag.bTxBeginFlag) {
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxBeginFlagClr = TRUE;
		/* IRQ Tx Begin Flag ISR */

		T_simucam.T_Sub[7].T_conf.sub_status_sending = 1;
		if (T_simucam.T_Sub[7].T_data.i_imagette
				< T_simucam.T_Sub[7].T_data.nb_of_imagettes) {
			OSQPost(DMA_sched_queue[1], (void *) 7);
			OSQPost(p_dma_scheduler_controller_queue[1], (void *) simDMASched);
		}

	}

	/* Check IRQ Tx End Flag */
	if (vpxDcomChannel->xDataScheduler.xDschIrqFlag.bTxEndFlag) {
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxEndFlagClr = TRUE;
		/* IRQ Tx End Flag ISR */

		bDschGetTimerStatus(&xSimucamTimer);
		T_simucam.T_status.simucam_running_time = xSimucamTimer.xDschTimerStatus.uliCurrentTime;
		if (T_simucam.T_conf.echo_sent == 1 || T_simucam.T_conf.iLog == 1) {
			x_echo_sent[i_echo_buffer_ctr].channel = 7;
			x_echo_sent[i_echo_buffer_ctr].nb_imagette =
					T_simucam.T_Sub[7].T_conf.i_imagette_control;
			x_echo_sent[i_echo_buffer_ctr].simucam_time =
					T_simucam.T_status.simucam_running_time;
			if (T_simucam.T_conf.iLog == 1){
                for (INT8U m = 0; m < 8; m++){
                    x_echo_sent[i_echo_buffer_ctr].iTag[m] =
                            T_simucam.T_Sub[7].T_data.tag[m];
                }
            }
            queue_error = OSQPost(p_echo_queue,
					&(x_echo_sent[i_echo_buffer_ctr]));
			if (queue_error == OS_ERR_NONE) {
				i_echo_buffer_ctr++;
				if (i_echo_buffer_ctr == ECHO_BUFFER) {
					i_echo_buffer_ctr = 0;
				}
			} else {
#if DEBUG_ON
				fprintf(fp, "[SCHEDULER]Queue limit attaigned.\r\n");
#endif
			}
		}

		T_simucam.T_Sub[7].T_conf.i_imagette_control++;
		T_simucam.T_status.simucam_total_imagettes_sent++;
		T_simucam.T_Sub[7].T_conf.sub_status_sending = 0;

		if (T_simucam.T_Sub[7].T_conf.i_imagette_control
				>= T_simucam.T_Sub[7].T_data.nb_of_imagettes) {
			xSubTemp.mode = subAbort;
			OSQPost(p_sub_unit_config_queue[7], &xSubTemp);
		}

	}

}

bool bDschInitIrq(alt_u8 ucDcomCh) {
	bool bStatus = FALSE;
	void* pvHoldContext;
	volatile TDcomChannel *vpxDcomChannel;
	switch (ucDcomCh) {
	case eDcomSpwCh1:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh1HoldContext;
		vpxDcomChannel = (TDcomChannel *)(DCOM_CH_1_BASE_ADDR);
		// Clear all flags
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxBeginFlagClr = TRUE;
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxEndFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_1_TX_IRQ, pvHoldContext, vDschCh1HandleIrq);
		bStatus = TRUE;
		break;
	case eDcomSpwCh2:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh2HoldContext;
		vpxDcomChannel = (TDcomChannel *)(DCOM_CH_2_BASE_ADDR);
		// Clear all flags
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxBeginFlagClr = TRUE;
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxEndFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_2_TX_IRQ, pvHoldContext, vDschCh2HandleIrq);
		bStatus = TRUE;
		break;
	case eDcomSpwCh3:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh3HoldContext;
		vpxDcomChannel = (TDcomChannel *)(DCOM_CH_3_BASE_ADDR);
		// Clear all flags
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxBeginFlagClr = TRUE;
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxEndFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_3_TX_IRQ, pvHoldContext, vDschCh3HandleIrq);
		bStatus = TRUE;
		break;
	case eDcomSpwCh4:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh4HoldContext;
		vpxDcomChannel = (TDcomChannel *)(DCOM_CH_4_BASE_ADDR);
		// Clear all flags
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxBeginFlagClr = TRUE;
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxEndFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_4_TX_IRQ, pvHoldContext, vDschCh4HandleIrq);
		bStatus = TRUE;
		break;
	case eDcomSpwCh5:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh5HoldContext;
		vpxDcomChannel = (TDcomChannel *)(DCOM_CH_5_BASE_ADDR);
		// Clear all flags
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxBeginFlagClr = TRUE;
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxEndFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_5_TX_IRQ, pvHoldContext, vDschCh5HandleIrq);
		bStatus = TRUE;
		break;
	case eDcomSpwCh6:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh6HoldContext;
		vpxDcomChannel = (TDcomChannel *)(DCOM_CH_6_BASE_ADDR);
		// Clear all flags
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxBeginFlagClr = TRUE;
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxEndFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_6_TX_IRQ, pvHoldContext, vDschCh6HandleIrq);
		bStatus = TRUE;
		break;
	case eDcomSpwCh7:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh7HoldContext;
		vpxDcomChannel = (TDcomChannel *)(DCOM_CH_7_BASE_ADDR);
		// Clear all flags
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxBeginFlagClr = TRUE;
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxEndFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_7_TX_IRQ, pvHoldContext, vDschCh7HandleIrq);
		bStatus = TRUE;
		break;
	case eDcomSpwCh8:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh8HoldContext;
		vpxDcomChannel = (TDcomChannel *)(DCOM_CH_8_BASE_ADDR);
		// Clear all flags
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxBeginFlagClr = TRUE;
		vpxDcomChannel->xDataScheduler.xDschIrqFlagClr.bTxEndFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(DCOM_CH_8_TX_IRQ, pvHoldContext, vDschCh8HandleIrq);
		bStatus = TRUE;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return bStatus;
}
bool bDschGetTimerControl(TDschChannel *pxDschCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		pxDschCh->xDschTimerControl = vpxDcomChannel->xDataScheduler.xDschTimerControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDschSetTimerControl(TDschChannel *pxDschCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		vpxDcomChannel->xDataScheduler.xDschTimerControl = pxDschCh->xDschTimerControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDschGetTimerConfig(TDschChannel *pxDschCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		pxDschCh->xDschTimerConfig = vpxDcomChannel->xDataScheduler.xDschTimerConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDschSetTimerConfig(TDschChannel *pxDschCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		vpxDcomChannel->xDataScheduler.xDschTimerConfig = pxDschCh->xDschTimerConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDschGetTimerStatus(TDschChannel *pxDschCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		pxDschCh->xDschTimerStatus = vpxDcomChannel->xDataScheduler.xDschTimerStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDschGetPacketConfig(TDschChannel *pxDschCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		pxDschCh->xDschPacketConfig = vpxDcomChannel->xDataScheduler.xDschPacketConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDschSetPacketConfig(TDschChannel *pxDschCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		vpxDcomChannel->xDataScheduler.xDschPacketConfig = pxDschCh->xDschPacketConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDschGetBufferStatus(TDschChannel *pxDschCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		pxDschCh->xDschBufferStatus = vpxDcomChannel->xDataScheduler.xDschBufferStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDschGetDataControl(TDschChannel *pxDschCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		pxDschCh->xDschDataControl = vpxDcomChannel->xDataScheduler.xDschDataControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDschSetDataControl(TDschChannel *pxDschCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		vpxDcomChannel->xDataScheduler.xDschDataControl = pxDschCh->xDschDataControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDschGetDataStatus(TDschChannel *pxDschCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		pxDschCh->xDschDataStatus = vpxDcomChannel->xDataScheduler.xDschDataStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDschGetIrqControl(TDschChannel *pxDschCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		pxDschCh->xDschIrqControl = vpxDcomChannel->xDataScheduler.xDschIrqControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDschSetIrqControl(TDschChannel *pxDschCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		vpxDcomChannel->xDataScheduler.xDschIrqControl = pxDschCh->xDschIrqControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDschGetIrqFlags(TDschChannel *pxDschCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		pxDschCh->xDschIrqFlag = vpxDcomChannel->xDataScheduler.xDschIrqFlag;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDschStartTimer(TDschChannel *pxDschCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		vpxDcomChannel->xDataScheduler.xDschTimerControl.bStart = TRUE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDschRunTimer(TDschChannel *pxDschCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		vpxDcomChannel->xDataScheduler.xDschTimerControl.bRun = TRUE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDschStopTimer(TDschChannel *pxDschCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		vpxDcomChannel->xDataScheduler.xDschTimerControl.bStop = TRUE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDschClrTimer(TDschChannel *pxDschCh) {
	bool bStatus = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		vpxDcomChannel->xDataScheduler.xDschTimerControl.bClear = TRUE;

		bStatus = TRUE;

	}

	return bStatus;
}

alt_u16 usiDschGetBuffersFreeSpace(TDschChannel *pxDschCh){
	alt_u16 usiFreeSpace = 0;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		vpxDcomChannel = (TDcomChannel *)(pxDschCh->xDschDevAddr.uliDschBaseAddr);

		/* If the buffer is full, the HW usedw goes to 0, so we need to check if the data buffer is already full */
		if (vpxDcomChannel->xDataScheduler.xDschBufferStatus.bFull) {
			/* Buufer is full, free space is zero*/
			usiFreeSpace = 0;
		} else {
			/* Used in HW is in range 0..2048, for 64b words. This value is converted in the range 0..16384, for 8b words */
			usiFreeSpace = DSCH_DATA_BUFFER_LENGTH_BYTES - vpxDcomChannel->xDataScheduler.xDschBufferStatus.usiUsedBytes;
		}

	}

	return (usiFreeSpace);
}

bool bDschInitCh(TDschChannel *pxDschCh, alt_u8 ucDcomCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;
	volatile TDcomChannel *vpxDcomChannel;

	if (pxDschCh != NULL) {

		switch (ucDcomCh) {
		case eDcomSpwCh1:
			pxDschCh->xDschDevAddr.uliDschBaseAddr = (alt_u32) DCOM_CH_1_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *)(DCOM_CH_1_BASE_ADDR);
			vpxDcomChannel->xDataScheduler.xDschDevAddr.uliDschBaseAddr = (alt_u32) DCOM_CH_1_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh2:
			pxDschCh->xDschDevAddr.uliDschBaseAddr = (alt_u32) DCOM_CH_2_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *)(DCOM_CH_2_BASE_ADDR);
			vpxDcomChannel->xDataScheduler.xDschDevAddr.uliDschBaseAddr = (alt_u32) DCOM_CH_2_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh3:
			pxDschCh->xDschDevAddr.uliDschBaseAddr = (alt_u32) DCOM_CH_3_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *)(DCOM_CH_3_BASE_ADDR);
			vpxDcomChannel->xDataScheduler.xDschDevAddr.uliDschBaseAddr = (alt_u32) DCOM_CH_3_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh4:
			pxDschCh->xDschDevAddr.uliDschBaseAddr = (alt_u32) DCOM_CH_4_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *)(DCOM_CH_4_BASE_ADDR);
			vpxDcomChannel->xDataScheduler.xDschDevAddr.uliDschBaseAddr = (alt_u32) DCOM_CH_4_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh5:
			pxDschCh->xDschDevAddr.uliDschBaseAddr = (alt_u32) DCOM_CH_5_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *)(DCOM_CH_5_BASE_ADDR);
			vpxDcomChannel->xDataScheduler.xDschDevAddr.uliDschBaseAddr = (alt_u32) DCOM_CH_5_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh6:
			pxDschCh->xDschDevAddr.uliDschBaseAddr = (alt_u32) DCOM_CH_6_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *)(DCOM_CH_6_BASE_ADDR);
			vpxDcomChannel->xDataScheduler.xDschDevAddr.uliDschBaseAddr = (alt_u32) DCOM_CH_6_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh7:
			pxDschCh->xDschDevAddr.uliDschBaseAddr = (alt_u32) DCOM_CH_7_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *)(DCOM_CH_7_BASE_ADDR);
			vpxDcomChannel->xDataScheduler.xDschDevAddr.uliDschBaseAddr = (alt_u32) DCOM_CH_7_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eDcomSpwCh8:
			pxDschCh->xDschDevAddr.uliDschBaseAddr = (alt_u32) DCOM_CH_8_BASE_ADDR;
			vpxDcomChannel = (TDcomChannel *)(DCOM_CH_8_BASE_ADDR);
			vpxDcomChannel->xDataScheduler.xDschDevAddr.uliDschBaseAddr = (alt_u32) DCOM_CH_8_BASE_ADDR;
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}

		if (bValidCh) {
			if (!bDschGetTimerControl(pxDschCh)) {
				bInitFail = TRUE;
			}
			if (!bDschGetTimerConfig(pxDschCh)) {
				bInitFail = TRUE;
			}
			if (!bDschGetTimerStatus(pxDschCh)) {
				bInitFail = TRUE;
			}
			if (!bDschGetPacketConfig(pxDschCh)) {
				bInitFail = TRUE;
			}
			if (!bDschGetBufferStatus(pxDschCh)) {
				bInitFail = TRUE;
			}
			if (!bDschGetDataControl(pxDschCh)) {
				bInitFail = TRUE;
			}
			if (!bDschGetDataStatus(pxDschCh)) {
				bInitFail = TRUE;
			}
			if (!bDschGetIrqControl(pxDschCh)) {
				bInitFail = TRUE;
			}
			if (!bDschGetIrqFlags(pxDschCh)) {
				bInitFail = TRUE;
			}

			if (!bInitFail) {
				bStatus = TRUE;
			}
		}
	}
	return bStatus;
}

//! [public functions]

//! [private functions]
//! [private functions]
