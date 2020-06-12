/*
 ************************************************************************************************
 *                                              NSEE
 *                                             Address
 *
 *                                       All Rights Reserved
 *
 *
 * Filename     : sub_unit_control.c
 * Programmer(s): Yuri Bunduki
 * Created on: Apr 17, 2019
 * Description  : Source file for the sub-unit simulation and management task.
 ************************************************************************************************
 */
/*$PAGE*/

#include "sub_unit_control_task_3.h"

/*
 * Control task for sub-unit operation[yb]
 */
void sub_unit_control_task_3(void *task_data) {
	INT8U error_code; /*uCOS error code*/
	INT32U i_mem_pointer_buffer;
	INT8U i_temp_sched;
	INT16U i_buffer_size = 0;
	INT16U i_transferred = 0;

	/*
	 * Assign channel code from task descriptor
	 */
	INT8U c_spw_channel = (INT8U) task_data;
	unsigned char c_DMA_nb = c_spw_channel / 4;
	sub_config_t *p_config;

	T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModeInit;

	while (1) {
		switch (T_simucam.T_Sub[c_spw_channel].T_conf.mode) {

		case subModeInit:
#if DEBUG_ON
			fprintf(fp, "[SUBUNIT%i]Sub-unit mode Init\r\n",(INT8U)c_spw_channel);
#endif
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
			xCh[c_spw_channel].xDataScheduler.xDschTimerConfig.bStartOnSync = TRUE;
			xCh[c_spw_channel].xDataScheduler.xDschTimerConfig.uliClockDiv =
			TIMER_CLOCK_DIV_1MS;
			bDschSetTimerConfig(&(xCh[c_spw_channel].xDataScheduler));

			bDcomSetGlobalIrqEn(TRUE, c_spw_channel);
			bDschGetIrqControl(&(xCh[c_spw_channel].xDataScheduler));
			xCh[c_spw_channel].xDataScheduler.xDschIrqControl.bTxBeginEn = TRUE;
			xCh[c_spw_channel].xDataScheduler.xDschIrqControl.bTxEndEn = TRUE;
			bDschSetIrqControl(&(xCh[c_spw_channel].xDataScheduler));

			T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModetoConfig;
			break;

		case subModetoConfig:
#if DEBUG_ON
			fprintf(fp, "[SUBUNIT%i]Sub-unit mode toConfig\r\n",(INT8U)c_spw_channel);
#endif
			/*
			 * Stop timer for ChA
			 */
			bDschStopTimer(&(xCh[c_spw_channel].xDataScheduler));
			bDschClrTimer(&(xCh[c_spw_channel].xDataScheduler));

			/*
			 * Disabling SpW channel
			 */
			bSpwcGetLinkConfig(&(xCh[c_spw_channel].xSpacewire));
			xCh[c_spw_channel].xSpacewire.xSpwcLinkConfig.bAutostart = FALSE;
			xCh[c_spw_channel].xSpacewire.xSpwcLinkConfig.bLinkStart = FALSE;
			xCh[c_spw_channel].xSpacewire.xSpwcLinkConfig.bDisconnect = TRUE;
			bSpwcSetLinkConfig(&(xCh[c_spw_channel].xSpacewire));

			T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModeConfig;
			T_simucam.T_Sub[c_spw_channel].T_data.i_imagette = 0;
			break;

			/*
			 * Sub-Unit Config mode
			 */
		case subModeConfig:
#if DEBUG_ON
			fprintf(fp, "[SUBUNIT%i]Sub-unit mode Config\r\n",(INT8U)c_spw_channel);
#endif
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
				fprintf(fp, "[SUBUNIT%i]Sub-unit config queue error\r\n",(INT8U)c_spw_channel);
#endif
			}
			if (T_simucam.T_Sub[c_spw_channel].T_conf.linkstatus_running == 0) {
				T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModetoConfig;
			}
			break;

		case subModetoRun:
#if DEBUG_ON
			fprintf(fp, "[SUBUNIT%i]Sub-unit toRun\r\n",(INT8U)c_spw_channel);
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
				fprintf(fp, "[SUBUNIT%i]Channel disabled\r\n",(INT8U)c_spw_channel);
#endif
				T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModetoConfig;
				break;
			} else {

				T_simucam.T_Sub[c_spw_channel].T_data.p_iterador =
						(T_Imagette *) T_simucam.T_Sub[c_spw_channel].T_data.addr_init;

				/*
				 * Acquire status and do manual space control
				 */

				i_buffer_size = usiDschGetBuffersFreeSpace(&(xCh[c_spw_channel].xDataScheduler));
				bDdr2SwitchMemory(c_DMA_nb);

				/*
				 * Pre-schedule the buffer before simucam goes to running
				 */
				while ((T_simucam.T_Sub[c_spw_channel].T_data.i_imagette
						< T_simucam.T_Sub[c_spw_channel].T_data.nb_of_imagettes)
						&& (i_buffer_size
								> (T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
										+ DMA_OFFSET))) {
#if DEBUG_ON
					fprintf(fp, "[SUBUNIT%i]Printinf offset %i & %x\r\n",(INT8U)c_spw_channel,
							(INT32U) T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->offset,
							(INT32U) T_simucam.T_Sub[c_spw_channel].T_data.p_iterador);
					INT16U teste_limit = usiDschGetBuffersFreeSpace(&(xCh[c_spw_channel].xDataScheduler));
#endif
					/*
					 * Try to get the mutex
					 */
					OSMutexPend(xMutexDMA[c_DMA_nb], 0, &error_code);

					if (error_code != OS_NO_ERR) {
						OSMutexPost(xMutexDMA[c_DMA_nb]);
#if DEBUG_ON
						fprintf(fp, "[SUBUNIT%i] Mutex error.\r\n",(INT8U)c_spw_channel);
#endif
					} else {
#if DEBUG_ON
						fprintf(fp, "[SUBUNIT%i] length antes while: %lu\r\n",
								(INT8U) c_spw_channel,
								T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length);
#endif
						/*
						 * Assign the correct memory access depending on ch
						 */
						if (c_DMA_nb == 0) {
							bDdr2SwitchMemory(DDR2_M1_ID);
#if DEBUG_ON
							fprintf(fp, 
									"[SUBUNIT%i] length antes da transf.: %lu\r\n",
									(INT8U) c_spw_channel,
									T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length);
#endif
							i_transferred =
									bIdmaDmaM1Transfer(
											(INT32U*) (T_simucam.T_Sub[c_spw_channel].T_data.p_iterador),
											T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
													+ DMA_OFFSET,
											c_spw_channel);
						} else {
							bDdr2SwitchMemory(DDR2_M2_ID);
							i_transferred =
									bIdmaDmaM2Transfer(
											(INT32U*) (T_simucam.T_Sub[c_spw_channel].T_data.p_iterador),
											T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
													+ DMA_OFFSET,
											c_spw_channel);
						}
						OSMutexPost(xMutexDMA[c_DMA_nb]);

						if (i_transferred != 0) {
#if DEBUG_ON
							fprintf(fp, 
									"[SUBUNIT%i] length antes correcao de end: %lu\r\n",
									(INT8U) c_spw_channel,
									T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length);
#endif
							/*
							 * Manually decrease free buffer size
							 */
							i_buffer_size -= i_transferred;
#if DEBUG_ON
//							if (i_buffer_size =< 0) {
//								fprintf(fp,
//										"[SUBUNIT%i] Buffer fully scheduled\r\n",
//										(INT8U) c_spw_channel);
//							}
#endif
							/*Calculate next imagette addr*/
							i_mem_pointer_buffer =
									(INT32U) T_simucam.T_Sub[c_spw_channel].T_data.p_iterador
											+ T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
											+ DMA_OFFSET;
							if ((i_mem_pointer_buffer % 8)) {
								i_mem_pointer_buffer = ((((i_mem_pointer_buffer)
										>> 3) + 1) << 3);
							}

							/*Reassign the pointer to the next imagette addrs */

							T_simucam.T_Sub[c_spw_channel].T_data.p_iterador =
									(T_Imagette *) i_mem_pointer_buffer;

							T_simucam.T_Sub[c_spw_channel].T_data.i_imagette++;
						} else {
#if DEBUG_ON
							fprintf(fp, "[SUBUNIT%i]DMA ERROR\r\n",(INT8U)c_spw_channel);
#endif
						}/* end error code DMA verif*/

					}/*End of mutex pend*/

				}/*end while*/

				set_spw_linkspeed(&(xCh[c_spw_channel]),
						T_simucam.T_Sub[c_spw_channel].T_conf.linkspeed);

				/*
				 * init SpW links
				 */
				if (T_simucam.T_Sub[c_spw_channel].T_conf.link_config == 0) {

					/*
					 * Set link to autostart
					 */
#if DEBUG_ON
					fprintf(fp, "[SUBUNIT%i]Channel autostart\r\n",(INT8U)c_spw_channel);
#endif

					bSpwcGetLinkConfig(&(xCh[c_spw_channel].xSpacewire));
					xCh[c_spw_channel].xSpacewire.xSpwcLinkConfig.bAutostart = TRUE;
					xCh[c_spw_channel].xSpacewire.xSpwcLinkConfig.bLinkStart = FALSE;
					xCh[c_spw_channel].xSpacewire.xSpwcLinkConfig.bDisconnect = FALSE;
					bSpwcSetLinkConfig(&(xCh[c_spw_channel].xSpacewire));

				} else {

					/*
					 * Set link to start
					 */
#if DEBUG_ON
					fprintf(fp, "[SUBUNIT%i]Channel start\r\n",(INT8U)c_spw_channel);
#endif

					bSpwcGetLinkConfig(&(xCh[c_spw_channel].xSpacewire));
					xCh[c_spw_channel].xSpacewire.xSpwcLinkConfig.bAutostart = FALSE;
					xCh[c_spw_channel].xSpacewire.xSpwcLinkConfig.bLinkStart = TRUE;
					xCh[c_spw_channel].xSpacewire.xSpwcLinkConfig.bDisconnect = FALSE;
					bSpwcSetLinkConfig(&(xCh[c_spw_channel].xSpacewire));

				}

				/*
				 * Sub-Unit RUN
				 */
				T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModeRun;
			}
			break;

		case subModeRun:
#if DEBUG_ON
			fprintf(fp, "[SUBUNIT%i]Sub-unit Run\r\n",(INT8U)c_spw_channel);
#endif
			p_config = (sub_config_t *) OSQPend(
					p_sub_unit_config_queue[c_spw_channel], 0, &error_code);
			if (error_code == OS_ERR_NONE) {

				switch (p_config->mode) {

				case subAccessDMA:
#if DEBUG_ON
					fprintf(fp, "[SUBUNIT%i] Access DMA\r\n",(INT8U)c_spw_channel);
#endif
					if (T_simucam.T_Sub[c_spw_channel].T_data.i_imagette
							< T_simucam.T_Sub[c_spw_channel].T_data.nb_of_imagettes) {
						/*
						 * Switch to the right RAM stick, to prevent
						 * data crossover
						 */
						bDdr2SwitchMemory(c_DMA_nb);
						OSMutexPend(xMutexDMA[c_DMA_nb], 0, &error_code);

						if (error_code != OS_NO_ERR) {
#if DEBUG_ON
							fprintf(fp, "[SUBUNIT%i] Mutex error.",(INT8U)c_spw_channel);
#endif
						}
						if (usiDschGetBuffersFreeSpace(&(xCh[c_spw_channel].xDataScheduler))
								>= (T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
										+ DMA_OFFSET)) {
							if (c_DMA_nb == 0) {
								bDdr2SwitchMemory(DDR2_M1_ID);
								i_transferred =
										bIdmaDmaM1Transfer(
												(INT32U*) (T_simucam.T_Sub[c_spw_channel].T_data.p_iterador),
												T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
														+ DMA_OFFSET,
												c_spw_channel);
							} else {
								bDdr2SwitchMemory(DDR2_M2_ID);
								i_transferred =
										bIdmaDmaM2Transfer(
												(INT32U*) (T_simucam.T_Sub[c_spw_channel].T_data.p_iterador),
												T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
														+ DMA_OFFSET,
												c_spw_channel);
							}
							OSMutexPost(xMutexDMA[c_DMA_nb]);
							if (i_transferred != 0) {
								/*
								 * Signal cmd that DMA is free
								 */
								i_temp_sched = simDMABack;
								OSQPost(
										p_dma_scheduler_controller_queue[c_DMA_nb],
										i_temp_sched);

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
								fprintf(fp, "[SUBUNIT%i]DMA ERROR\r\n",(INT8U)c_spw_channel);
#endif
							}
						} else {
#if DEBUG_ON
							fprintf(fp, "[SUBUNIT%i]Buffer Full\r\n",(INT8U)c_spw_channel);
#endif
							/* Return Mutex */
							OSMutexPost(xMutexDMA[c_DMA_nb]);
							/* Schedule */
							OSQPost(DMA_sched_queue[c_DMA_nb], c_spw_channel);
							/*
							 * Signal cmd that DMA is free
							 */
							i_temp_sched = simDMABack;
							OSQPost(p_dma_scheduler_controller_queue[c_DMA_nb],
									i_temp_sched);
						}
					} else {
						/*
						 * End of dataset
						 */
#if DEBUG_ON
						fprintf(fp, "[SUBUNIT%i]End of Dataset scheduling\r\n",(INT8U)c_spw_channel);
#endif
						/*
						 * Signal cmd that DMA is free
						 */
						i_temp_sched = simDMABack;
						OSQPost(p_dma_scheduler_controller_queue[c_DMA_nb],
								i_temp_sched);
					}
					break;

					/*
					 * Abort and EoT
					 */
				case subAbort:
					T_simucam.T_Sub[c_spw_channel].T_conf.b_abort = false;
				case subEOT:
#if DEBUG_ON
					fprintf(fp, "[SUBUNIT%i]Sub Abort\r\n",(INT8U)c_spw_channel);
#endif

					T_simucam.T_Sub[c_spw_channel].T_data.i_imagette = 0;
					T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModetoRun;

					break;

				case subChangeMode:
#if DEBUG_ON
					fprintf(fp, "[SUBUNIT%i]Change mode\r\n",(INT8U)c_spw_channel);
#endif
					T_simucam.T_Sub[c_spw_channel].T_conf.mode =
							subModetoConfig;
					break;

				default:
#if DEBUG_ON
					fprintf(fp, "[SUBUNIT%i]Sub-unit Default run trap\r\n",(INT8U)c_spw_channel);
#endif
					break;
				}
			}
			break;
		default:
#if DEBUG_ON
			fprintf(fp, "[SUBUNIT%i]Sub-unit default error!\r\n",(INT8U)c_spw_channel);
#endif
			break;
		}
	}
}
