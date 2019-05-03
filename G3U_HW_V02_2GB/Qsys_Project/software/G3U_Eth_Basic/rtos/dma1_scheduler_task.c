/*
 * dma1_scheduler_task.c
 *
 *  Created on: 03/05/2019
 *      Author: root
 */

#include "dma1_scheduler_task.h"

sub_config_t sub_config_send[8];

void dma1_scheduler_task(void *task_data) {
	INT8U error_code_dma_sched;
	INT8U i_dma_sched_controller;
	INT8U dma_nb = (INT8U) task_data;
	INT8U i_channel_buffer;

	while (1) {

		i_dma_sched_controller = (INT8U) OSQPend(
				p_dma_scheduler_controller_queue[dma_nb], 0,
				&error_code_dma_sched);

		if (error_code_dma_sched == OS_ERR_NONE) {
			switch (i_dma_sched_controller) {
			case simDMA1Back:
				T_simucam.T_status.has_dma_1 = true;
				i_channel_buffer = (INT32U) OSQPend(DMA_sched_queue[dma_nb], 1,
						&error_code_dma_sched);
				if (error_code_dma_sched == OS_ERR_NONE) {
					sub_config_send[i_channel_buffer].mode = subAccessDMA1;
					error_code_dma_sched = (INT8U) OSQPost(
							p_sub_unit_config_queue[i_channel_buffer],
							&(sub_config_send[i_channel_buffer]));
					alt_SSSErrorHandler(error_code_dma_sched, 0);
					T_simucam.T_status.has_dma_1 = false;
				} else {
					alt_uCOSIIErrorHandler(error_code_dma_sched, 0);
				}
				alt_uCOSIIErrorHandler(error_code_dma_sched, 0);
				break;

			case simDMA1Sched:
#if DEBUG_ON
				printf("[DMA1 Sched]DMA1 Sched\r\n");
#endif
				if (T_simucam.T_status.has_dma_1 == true) {
#if DEBUG_ON
					printf("[DMA1 Sched]Has DMA1\r\n");
#endif
					i_channel_buffer = (INT32U) OSQPend(DMA_sched_queue[dma_nb], 1,
							&error_code_dma_sched);
					if (error_code_dma_sched == OS_ERR_NONE) {
						sub_config_send[i_channel_buffer].mode = subAccessDMA1;
						error_code_dma_sched = (INT8U) OSQPost(
								p_sub_unit_config_queue[i_channel_buffer],
								&(sub_config_send[i_channel_buffer]));
						alt_SSSErrorHandler(error_code_dma_sched, 0);
						T_simucam.T_status.has_dma_1 = false;
					} else {
						alt_uCOSIIErrorHandler(error_code_dma_sched, 0);
					}
					alt_uCOSIIErrorHandler(error_code_dma_sched, 0);
				}
				break;

			}
		} else {
#if DEBUG_ON
			printf("[DMA1 Sched]cmd error\r\n");
#endif
		}
	}
}

void dma2_scheduler_task(void *task_data) {
	INT8U error_code_dma_sched;
	INT8U i_dma_sched_controller;
	INT8U dma_nb = (INT8U) task_data;
	INT8U i_channel_buffer;

	while (1) {

		i_dma_sched_controller = (INT8U) OSQPend(
				p_dma_scheduler_controller_queue[dma_nb], 0,
				&error_code_dma_sched);

		if (error_code_dma_sched == OS_ERR_NONE) {
			switch (i_dma_sched_controller) {
			case simDMA2Back:
				T_simucam.T_status.has_dma_2 = true;
				i_channel_buffer = (INT32U) OSQPend(DMA_sched_queue[dma_nb], 1,
						&error_code_dma_sched);
				if (error_code_dma_sched == OS_ERR_NONE) {
					sub_config_send[i_channel_buffer].mode = subAccessDMA2;
					error_code_dma_sched = (INT8U) OSQPost(
							p_sub_unit_config_queue[i_channel_buffer],
							&(sub_config_send[i_channel_buffer]));
					alt_SSSErrorHandler(error_code_dma_sched, 0);
					T_simucam.T_status.has_dma_2 = false;
				} else {
					alt_uCOSIIErrorHandler(error_code_dma_sched, 0);
				}
				alt_uCOSIIErrorHandler(error_code_dma_sched, 0);
				break;

			case simDMA2Sched:
#if DEBUG_ON
				printf("[DMA2 Sched]DMA2 Sched\r\n");
#endif
				if (T_simucam.T_status.has_dma_2 == true) {
#if DEBUG_ON
					printf("[DMA2 Sched]Has DMA2\r\n");
#endif
					i_channel_buffer = (INT32U) OSQPend(DMA_sched_queue[dma_nb], 1,
							&error_code_dma_sched);
					if (error_code_dma_sched == OS_ERR_NONE) {
						sub_config_send[i_channel_buffer].mode = subAccessDMA2;
						error_code_dma_sched = (INT8U) OSQPost(
								p_sub_unit_config_queue[i_channel_buffer],
								&(sub_config_send[i_channel_buffer]));
						alt_SSSErrorHandler(error_code_dma_sched, 0);
						T_simucam.T_status.has_dma_2 = false;
					} else {
						alt_uCOSIIErrorHandler(error_code_dma_sched, 0);
					}
					alt_uCOSIIErrorHandler(error_code_dma_sched, 0);
				}
				break;

			}
		} else {
#if DEBUG_ON
			printf("[DMA2 Sched]cmd error\r\n");
#endif
		}
	}
}

