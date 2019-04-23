/*
 * sub_unit_control_task_1.c
 *
 *  Created on: 16/04/2019
 *      Author: root
 */

#include "sub_unit_control_task_1.h"

/*
 * Control task for sub-unit operation[yb]
 */
void sub_unit_control_task_1(void *task_data) {
	INT8U error_code; /*uCOS error code*/
	INT8U exec_error; /*Internal error code for the command module*/
	INT16U i_imagette_length = 0;
	INT16U i_dma_counter = 0;
	INT32U i_mem_pointer_buffer;

	INT8U c_spw_channel = (INT8U) task_data;

	sub_config_t *p_config;

	Timagette_control imagette_buffer;
	Timagette_control *p_imagette_buffer = &imagette_buffer;
	static _ethernet_payload xTemp_sub;

//	p_config->mode = 0;
//	p_config->RMAP_handling = 0;
//	p_config->forward_data = 0;
//	p_config->link_config = 0;
//	p_config->sub_status_sending = 0;
//	p_config->linkstatus_running = 1;
//	p_config->linkspeed = 3;

	T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModeInit;

	while (1) {
		switch (T_simucam.T_Sub[c_spw_channel].T_conf.mode) {

		case subModeInit:
			/*
			 * Default subUnit config
			 */
			T_simucam.T_Sub[c_spw_channel].T_conf.RMAP_handling = 0;
			T_simucam.T_Sub[c_spw_channel].T_conf.forward_data = 0;
			T_simucam.T_Sub[c_spw_channel].T_conf.link_config = 0;
			T_simucam.T_Sub[c_spw_channel].T_conf.sub_status_sending = 0;
			T_simucam.T_Sub[c_spw_channel].T_conf.linkstatus_running = 0;
			T_simucam.T_Sub[c_spw_channel].T_conf.linkspeed = 3;

			/*
			 * Initializing the timer
			 */
			bDschGetTimerConfig(&(xCh[c_spw_channel].xDataScheduler));
			xCh[c_spw_channel].xDataScheduler.xTimerConfig.bStartOnSync = TRUE;
			xCh[c_spw_channel].xDataScheduler.xTimerConfig.uliTimerDiv =
			TIMER_CLOCK_DIV_1MS;
			bDschSetTimerConfig(&(xCh[c_spw_channel].xDataScheduler));

			bDcomSetGlobalIrqEn(TRUE, c_spw_channel);
			bDctrGetIrqControl(&(xCh[c_spw_channel].xDataController));
			xCh[c_spw_channel].xDataController.xIrqControl.bTxBeginEn = TRUE;
			xCh[c_spw_channel].xDataController.xIrqControl.bTxEndEn = TRUE;
			bDctrSetIrqControl(&(xCh[c_spw_channel].xDataController));

			T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModetoConfig;
			break;

		case subModetoConfig:

			/*
			 * Stop timer for ChA
			 */
			bDschStopTimer(&(xCh[c_spw_channel].xDataScheduler));
			bDschClrTimer(&(xCh[c_spw_channel].xDataScheduler));

			/*
			 * Disabling SpW channel
			 */
			bSpwcGetLink(&(xCh[c_spw_channel].xSpacewire));
			xCh[c_spw_channel].xSpacewire.xLinkConfig.bAutostart = FALSE;
			xCh[c_spw_channel].xSpacewire.xLinkConfig.bLinkStart = FALSE;
			xCh[c_spw_channel].xSpacewire.xLinkConfig.bDisconnect = TRUE;
			bSpwcSetLink(&(xCh[c_spw_channel].xSpacewire));

			T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModeConfig;
			T_simucam.T_Sub[c_spw_channel].T_data.i_imagette = 0;
			break;

		case subModeConfig:
			p_config = (sub_config_t *) OSQPend(
					p_sub_unit_config_queue[c_spw_channel], 0, &error_code);
			if (error_code == OS_ERR_NONE) {

				T_simucam.T_Sub[c_spw_channel].T_conf.mode = p_config->mode;
				T_simucam.T_Sub[c_spw_channel].T_conf.RMAP_handling =
						p_config->RMAP_handling;
				T_simucam.T_Sub[c_spw_channel].T_conf.forward_data =
						p_config->forward_data;
				T_simucam.T_Sub[c_spw_channel].T_conf.link_config =
						p_config->link_config;
				T_simucam.T_Sub[c_spw_channel].T_conf.linkstatus_running =
						p_config->linkstatus_running;
				T_simucam.T_Sub[c_spw_channel].T_conf.linkspeed =
						p_config->linkspeed;

			} else {
#if DEBUG_ON
				printf("[SUBUNIT]Sub-unit config queue error\r\n");
#endif
			}
			if (T_simucam.T_Sub[c_spw_channel].T_conf.linkstatus_running == 0) {
				T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModetoConfig;
			}

			break;

		case subModetoRun:
#if DEBUG_ON
			printf("[SUBUNIT]Sub-unit toRun\r\n");
#endif
			/*
			 * Stop timer for ChA
			 */
			bDschStopTimer(&(xCh[c_spw_channel].xDataScheduler));
			bDschClrTimer(&(xCh[c_spw_channel].xDataScheduler));
			T_simucam.T_Sub[c_spw_channel].T_conf.i_imagette_control = 0;

			/*
			 * Start timer for ChA
			 * NOT STARTING THE TIMER
			 */
			bDschStartTimer(&(xCh[c_spw_channel].xDataScheduler));

			T_simucam.T_Sub[c_spw_channel].T_data.i_imagette = 0;

			/*
			 * Set link interface status according to
			 * link_config
			 */
			if (T_simucam.T_Sub[c_spw_channel].T_conf.linkstatus_running == 0) {
#if DEBUG_ON
				printf("[SUBUNIT]Channel disabled\r\n");
#endif
				T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModetoConfig;
				break;
			} else {

				T_simucam.T_Sub[c_spw_channel].T_data.p_iterador =
						(T_Imagette *) T_simucam.T_Sub[c_spw_channel].T_data.addr_init;

				/*
				 * TODO change to append all of the buffer
				 */
				OSMutexPend(xMutexDMA[(unsigned char) c_spw_channel / 4], 0,
						&error_code);
				while (T_simucam.T_Sub[c_spw_channel].T_data.i_imagette
						< T_simucam.T_Sub[c_spw_channel].T_data.nb_of_imagettes) {

#if DEBUG_ON
					printf("[SUBUNIT]Printinf offset %i & %x\r\n",
							(INT32U) T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->offset,
							(INT32U) T_simucam.T_Sub[c_spw_channel].T_data.p_iterador);
#endif
					if (uiDatbGetBuffersFreeSpace(
							&(xCh[c_spw_channel].xDataBuffer))
							>= (T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
									+ DMA_OFFSET)) {
						if (((unsigned char) c_spw_channel / 4) == 0) {
							bDdr2SwitchMemory(DDR2_M1_ID);
						} else {
							bDdr2SwitchMemory(DDR2_M2_ID);
						}

						if (error_code != OS_NO_ERR) {
#if DEBUG_ON
							printf("[SUBUNIT] Mutex error.");
#endif
						}
						error_code =
								bIdmaDmaM1Transfer(
										(INT32U*) (T_simucam.T_Sub[c_spw_channel].T_data.p_iterador),
										T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
												+ DMA_OFFSET, c_spw_channel);

						if (error_code == TRUE) {
							i_mem_pointer_buffer =
									(INT32U) T_simucam.T_Sub[c_spw_channel].T_data.p_iterador
											+ T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
											+ DMA_OFFSET;
							if ((i_mem_pointer_buffer % 8)) {
								i_mem_pointer_buffer = ((((i_mem_pointer_buffer)
										>> 3) + 1) << 3);
							}
							T_simucam.T_Sub[c_spw_channel].T_data.p_iterador =
									(T_Imagette *) i_mem_pointer_buffer;

							T_simucam.T_Sub[c_spw_channel].T_data.i_imagette++;
						} else {
#if DEBUG_ON
							printf("[SUBUNIT]DMA ERROR\r\n");
#endif
						}
					} else {
#if DEBUG_ON
						printf("[SUBUNIT]End of Dataset scheduling\r\n");
#endif
						xTemp_sub.type = simDMA1Back;
						OSQPost(p_simucam_command_q, &xTemp_sub);
					}

				}
				OSMutexPost(xMutexDMA[(unsigned char) c_spw_channel / 4]);


				set_spw_linkspeed(&(xCh[c_spw_channel].xSpacewire), T_simucam.T_Sub.T_conf.linkspeed);

				/*
				 * init SpW links
				 */
				if (T_simucam.T_Sub[c_spw_channel].T_conf.link_config == 0) {

					/*
					 * Set link to autostart
					 */
#if DEBUG_ON
					printf("[SUBUNIT]Channel autostart\r\n");
#endif

					bSpwcGetLink(&(xCh[c_spw_channel].xSpacewire));
					xCh[c_spw_channel].xSpacewire.xLinkConfig.bAutostart = TRUE;
					xCh[c_spw_channel].xSpacewire.xLinkConfig.bLinkStart =
					FALSE;
					xCh[c_spw_channel].xSpacewire.xLinkConfig.bDisconnect =
					FALSE;
					bSpwcSetLink(&(xCh[c_spw_channel].xSpacewire));

#if DEBUG_ON
					printf("error_code: %i", exec_error);
#endif

				} else {

					/*
					 * Set link to start
					 */
#if DEBUG_ON
					printf("[SUBUNIT]Channel start\r\n");
#endif

					bSpwcGetLink(&(xCh[c_spw_channel].xSpacewire));
					xCh[c_spw_channel].xSpacewire.xLinkConfig.bAutostart =
					FALSE;
					xCh[c_spw_channel].xSpacewire.xLinkConfig.bLinkStart = TRUE;
					xCh[c_spw_channel].xSpacewire.xLinkConfig.bDisconnect =
					FALSE;
					bSpwcSetLink(&(xCh[c_spw_channel].xSpacewire));
#if DEBUG_ON
					printf("error_code: %i", exec_error);
#endif
				}

				/*
				 * Sub-Unit RUN
				 */
				T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModeRun;
			}
			break;

		case subModeRun:
#if DEBUG_ON
			printf("[SUBUNIT]Sub-unit Run\r\n");
#endif
			p_config = (sub_config_t *) OSQPend(
					p_sub_unit_config_queue[c_spw_channel], 0, &error_code);
			if (error_code == OS_ERR_NONE) {

				switch (p_config->mode) {

				case subAccessDMA1:
#if DEBUG_ON
					printf("[SUBUNIT] Access DMA\r\n");
#endif
					if (T_simucam.T_Sub[c_spw_channel].T_data.i_imagette
							< T_simucam.T_Sub[c_spw_channel].T_data.nb_of_imagettes) {
						OSMutexPend(
								xMutexDMA[(unsigned char) c_spw_channel / 4], 0,
								&error_code);
						if (error_code != OS_NO_ERR) {
#if DEBUG_ON
							printf("[SUBUNIT] Mutex error.");
#endif
						}

						if (uiDatbGetBuffersFreeSpace(
								&(xCh[c_spw_channel].xDataBuffer))
								>= (T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
										+ DMA_OFFSET)) {
							if (((unsigned char) c_spw_channel / 4) == 0) {
								bDdr2SwitchMemory(DDR2_M1_ID);
							} else {
								bDdr2SwitchMemory(DDR2_M2_ID);
							}

							error_code =
									bIdmaDmaM1Transfer(
											(INT32U*) (T_simucam.T_Sub[c_spw_channel].T_data.p_iterador),
											T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
													+ DMA_OFFSET,
											c_spw_channel);
							OSMutexPost(
									xMutexDMA[(unsigned char) c_spw_channel / 4]);
							if (error_code == true) {
								/*
								 * Signal cmd that DMA is free
								 */
								xTemp_sub.type = simDMA1Back;
								OSQPost(p_simucam_command_q, &xTemp_sub);

								i_mem_pointer_buffer =
										(INT32U) T_simucam.T_Sub[c_spw_channel].T_data.p_iterador
												+ T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
												+ DMA_OFFSET;
								if ((i_mem_pointer_buffer % 8)) {
									i_mem_pointer_buffer =
											((((i_mem_pointer_buffer) >> 3) + 1)
													<< 3);
								}
								T_simucam.T_Sub[c_spw_channel].T_data.p_iterador =
										(T_Imagette *) i_mem_pointer_buffer;
								T_simucam.T_Sub[c_spw_channel].T_data.i_imagette++;
							} else {
#if DEBUG_ON
								printf("[SUBUNIT]DMA ERROR\r\n");
#endif
							}
						} else {
#if DEBUG_ON
							printf("[SUBUNIT]Buffer Full\r\n");
#endif
							/* Return Mutex */
							OSMutexPost(
									xMutexDMA[(unsigned char) c_spw_channel / 4]);
							/* Schedule */
							OSQPost(
									DMA_sched_queue[(unsigned char) c_spw_channel
											/ 4], c_spw_channel);
							/*
							 * Signal cmd that DMA is free
							 */
							xTemp_sub.type = simDMA1Back;
							OSQPost(p_simucam_command_q, &xTemp_sub);
						}
					} else {
						/*
						 * End of dataset
						 */
#if DEBUG_ON
						printf("[SUBUNIT]End of Dataset scheduling\r\n");
#endif
					}
					break;

					/*
					 * Abort and EoT
					 */
				case subAbort:
					T_simucam.T_Sub[c_spw_channel].T_conf.b_abort = false;
				case subEOT:
#if DEBUG_ON
					printf("[SUBUNIT]Sub Abort\r\n");
#endif

					T_simucam.T_Sub[c_spw_channel].T_data.i_imagette = 0;
					T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModetoRun;

					break;

				case subChangeMode:
#if DEBUG_ON
					printf("[SUBUNIT]Change mode\r\n");
#endif
					T_simucam.T_Sub[c_spw_channel].T_conf.mode =
							subModetoConfig;
					break;

				default:
#if DEBUG_ON
					printf("[SUBUNIT]Sub-unit Default run trap\r\n");
#endif
					break;
				}
			}
			break;
		default:
#if DEBUG_ON
			printf("[SUBUNIT]Sub-unit default error!\r\n");
#endif
			break;
		}
	}
}
