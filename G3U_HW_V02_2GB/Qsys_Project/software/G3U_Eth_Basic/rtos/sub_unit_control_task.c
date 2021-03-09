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
 * Created on: Oct 22, 2018
 * Description  : Source file for the sub-unit simulation and management task.
 ************************************************************************************************
 */
/*$PAGE*/

#include "sub_unit_control_task.h"

/*
 * Control task for sub-unit operation[yb]
 */
void sub_unit_control_task(void *task_data) {
	INT8U error_code; /*uCOS error code*/
	INT32U i_mem_pointer_buffer;
	INT8U i_temp_sched;
	INT32U uliTotalImagettesLength = 0;

	/*
	 * Assign channel code from task descriptor
	 */
	INT8U c_spw_channel = (INT8U) ((INT32U) task_data);
	unsigned char c_DMA_nb = c_spw_channel / 4;
	sub_config_t *p_config;

	T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModeInit;

	while (1) {
		switch (T_simucam.T_Sub[c_spw_channel].T_conf.mode) {

		case subModeInit:
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xMajor) {
			fprintf(fp, "[SUBUNIT%i]Sub-unit mode Init\r\n", (INT8U) c_spw_channel);
}
#endif

			/*
			 * Channel initialization
			 */
			bDcomInitCh(&(xCh[c_spw_channel]), c_spw_channel);

			/* Enable Report IRQ */
			bRprtGetIrqControl(&(xCh[c_spw_channel].xReport));
			/* TODO: List all IRQs needed */
			xCh[c_spw_channel].xReport.xRprtIrqControl.bSpwLinkConnectedEn = TRUE;
			xCh[c_spw_channel].xReport.xRprtIrqControl.bSpwLinkDisconnectedEn = TRUE;
			xCh[c_spw_channel].xReport.xRprtIrqControl.bSpwErrDisconnectEn = TRUE;
			xCh[c_spw_channel].xReport.xRprtIrqControl.bSpwErrParityEn = TRUE;
			xCh[c_spw_channel].xReport.xRprtIrqControl.bSpwErrEscapeEn = TRUE;
			xCh[c_spw_channel].xReport.xRprtIrqControl.bSpwErrCreditEn = TRUE;
			xCh[c_spw_channel].xReport.xRprtIrqControl.bRmapErrEarlyEopEn = TRUE;
			xCh[c_spw_channel].xReport.xRprtIrqControl.bRmapErrEepen = TRUE;
			xCh[c_spw_channel].xReport.xRprtIrqControl.bRmapErrHeaderCrcEn = TRUE;
			xCh[c_spw_channel].xReport.xRprtIrqControl.bRmapErrInvalidCommandCodeEn = TRUE;
			xCh[c_spw_channel].xReport.xRprtIrqControl.bRmapErrInvalidDataCrcEn = TRUE;
			xCh[c_spw_channel].xReport.xRprtIrqControl.bRmapErrToomuchDataEn = TRUE;
			xCh[c_spw_channel].xReport.xRprtIrqControl.bRmapErrUnusedPacketTypeEn = TRUE;
			xCh[c_spw_channel].xReport.xRprtIrqControl.bRxTimecodeReceivedEn = TRUE;
			bRprtSetIrqControl(&(xCh[c_spw_channel].xReport));

			/*
			 * Debug Configuration
			 */
			bDschGetPacketConfig(&(xCh[c_spw_channel].xDataScheduler));
			xCh[c_spw_channel].xDataScheduler.xDschPacketConfig.bSendEep = xConfDebug.bSendEEP;
			xCh[c_spw_channel].xDataScheduler.xDschPacketConfig.bSendEop = xConfDebug.bSendEOP;
			bDschSetPacketConfig(&(xCh[c_spw_channel].xDataScheduler));

			/*
			 * RMAP Configuration
			 */
			bRmapGetCodecConfig(&(xCh[c_spw_channel].xRmap));
			xCh[c_spw_channel].xRmap.xRmapCodecConfig.ucLogicalAddress = xConfRmap.ucLogicalAddr[c_spw_channel];
			xCh[c_spw_channel].xRmap.xRmapCodecConfig.ucKey = xConfRmap.ucKey[c_spw_channel];
			bRmapSetCodecConfig(&(xCh[c_spw_channel].xRmap));
			bRmapGetMemAreaConfig(&(xCh[c_spw_channel].xRmap));
			xCh[c_spw_channel].xRmap.xRmapMemAreaConfig.uliAddrOffset = xConfRmap.uliAddrOffset[c_spw_channel];
			bRmapSetMemAreaConfig(&(xCh[c_spw_channel].xRmap));

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
			xCh[c_spw_channel].xDataScheduler.xDschTimerConfig.bRunOnSync = TRUE;
			xCh[c_spw_channel].xDataScheduler.xDschTimerConfig.uliClockDiv = TIMER_CLOCK_DIV_1MS;
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
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
			fprintf(fp, "[SUBUNIT%i]Sub-unit mode toConfig\r\n", (INT8U) c_spw_channel);
}
#endif
			/* Disable IRQ */
			bDschGetIrqControl(&(xCh[c_spw_channel].xDataScheduler));
			xCh[c_spw_channel].xDataScheduler.xDschIrqControl.bTxBeginEn = FALSE;
			xCh[c_spw_channel].xDataScheduler.xDschIrqControl.bTxEndEn = FALSE;
			bDschSetIrqControl(&(xCh[c_spw_channel].xDataScheduler));
			/*
			* Clear Scheduler
			*/
			bIdmaResetChDma(c_spw_channel, TRUE);

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

			/* Clearing errors */
			T_simucam.T_Sub[c_spw_channel].T_sub_status.usi_disconnect_err_cnt = 0; 
			T_simucam.T_Sub[c_spw_channel].T_sub_status.usi_parity_err_cnt = 0; 
			T_simucam.T_Sub[c_spw_channel].T_sub_status.usi_escape_err_cnt = 0; 
			T_simucam.T_Sub[c_spw_channel].T_sub_status.usi_credit_err_cnt = 0;
			break;

			/*
			 * Sub-Unit Config mode
			 */
		case subModeConfig:
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xMajor) {
			fprintf(fp, "[SUBUNIT%i]Sub-unit mode Config\r\n", (INT8U) c_spw_channel);
}
#endif
			p_config = (sub_config_t *) OSQPend(p_sub_unit_config_queue[c_spw_channel], 0, &error_code);
			if (error_code == OS_ERR_NONE) {

				T_simucam.T_Sub[c_spw_channel].T_conf.mode = p_config->mode;
				T_simucam.T_Sub[c_spw_channel].T_conf.RMAP_handling = p_config->RMAP_handling;
				T_simucam.T_Sub[c_spw_channel].T_conf.forward_data = p_config->forward_data;
				T_simucam.T_Sub[c_spw_channel].T_conf.link_config = p_config->link_config;
				T_simucam.T_Sub[c_spw_channel].T_conf.linkstatus_running = p_config->linkstatus_running;
				T_simucam.T_Sub[c_spw_channel].T_conf.linkspeed = p_config->linkspeed;

			} else {
#if DEBUG_ON
	if (T_simucam.T_conf.usiDebugLevels <= xCritical) {
				fprintf(fp, "[SUBUNIT%i]Sub-unit config queue error\r\n", (INT8U) c_spw_channel);
	}
#endif
			}
			if (T_simucam.T_Sub[c_spw_channel].T_conf.linkstatus_running == 0) {
				T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModetoConfig;
			}
			break;

		case subModetoRun:
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
			fprintf(fp, "[SUBUNIT%i]Sub-unit toRun\r\n", (INT8U) c_spw_channel);
}
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
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
				fprintf(fp, "[SUBUNIT%i]Channel disabled\r\n", (INT8U) c_spw_channel);
}
#endif
				T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModetoConfig;
				break;
			} else {

				T_simucam.T_Sub[c_spw_channel].T_data.p_iterador = (T_Imagette *) T_simucam.T_Sub[c_spw_channel].T_data.addr_init;

				/*
				 * Acquire status and do manual space control
				 */

				/*
				 * Calculate total imagettes length
				 */
				bDdr2SwitchMemory(c_DMA_nb);
				while ((T_simucam.T_Sub[c_spw_channel].T_data.i_imagette < T_simucam.T_Sub[c_spw_channel].T_data.nb_of_imagettes)) {

#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[SUBUNIT%i] Imagette %u : memory address = %08lX, time offset = %lu [ms], length = %u\r\n",
							(INT8U) c_spw_channel,
							(INT16U) T_simucam.T_Sub[c_spw_channel].T_data.i_imagette,
							(INT32U) T_simucam.T_Sub[c_spw_channel].T_data.p_iterador,
							(INT32U) T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->offset,
							(INT16U) T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length);
}
#endif

						/*Calculate next imagette addr*/
							i_mem_pointer_buffer = (INT32U) T_simucam.T_Sub[c_spw_channel].T_data.p_iterador + T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length + DMA_OFFSET;
							if ((i_mem_pointer_buffer % 8)) {
								i_mem_pointer_buffer = ((((i_mem_pointer_buffer) >> 3) + 1) << 3);
							}

							/*Reassign the pointer to the next imagette addr */
							T_simucam.T_Sub[c_spw_channel].T_data.p_iterador = (T_Imagette *) i_mem_pointer_buffer;
							T_simucam.T_Sub[c_spw_channel].T_data.i_imagette++;

				} /*end while*/
				uliTotalImagettesLength = (INT32U)(T_simucam.T_Sub[c_spw_channel].T_data.p_iterador) - (INT32U)(T_simucam.T_Sub[c_spw_channel].T_data.addr_init);

				/*
				 * Pre-schedule the buffer before simucam goes to running
				 */
				bDdr2SwitchMemory(c_DMA_nb);
				uliIdmaChDmaTransfer(
						c_DMA_nb,
						(INT32U*) (T_simucam.T_Sub[c_spw_channel].T_data.addr_init),
						uliTotalImagettesLength,
						c_spw_channel);

				set_spw_linkspeed(&(xCh[c_spw_channel]), T_simucam.T_Sub[c_spw_channel].T_conf.linkspeed);

				/*
				 * init SpW links
				 */
				if (T_simucam.T_Sub[c_spw_channel].T_conf.link_config == 0) {

					/*
					 * Set link to autostart
					 */
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[SUBUNIT%i]Channel autostart\r\n", (INT8U) c_spw_channel);
}
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
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[SUBUNIT%i]Channel start\r\n", (INT8U) c_spw_channel);
}
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
if (T_simucam.T_conf.usiDebugLevels <= xMajor) {
			fprintf(fp, "[SUBUNIT%i]Sub-unit Run\r\n", (INT8U) c_spw_channel);
}
#endif
			p_config = (sub_config_t *) OSQPend(p_sub_unit_config_queue[c_spw_channel], 0, &error_code);
			if (error_code == OS_ERR_NONE) {

				switch (p_config->mode) {

				case subAccessDMA:

					/*
					 * End of dataset
					 */
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[SUBUNIT%i]End of Dataset scheduling\r\n", (INT8U) c_spw_channel);
}
#endif
					/*
					 * Signal cmd that DMA is free
					 */
					i_temp_sched = simDMABack;
					OSQPost(p_dma_scheduler_controller_queue[c_DMA_nb], (void *) ((INT32U) i_temp_sched));

					break;

					/*
					 * Abort and EoT
					 */
				case subAbort:
					T_simucam.T_Sub[c_spw_channel].T_conf.b_abort = false;
				case subEOT:
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[SUBUNIT%i]Sub Abort\r\n", (INT8U) c_spw_channel);
}
#endif

					T_simucam.T_Sub[c_spw_channel].T_data.i_imagette = 0;
					T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModetoRun;

					break;

				case subChangeMode:
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[SUBUNIT%i]Change mode\r\n", (INT8U) c_spw_channel);
}
#endif
					T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModetoConfig;
					break;

				default:
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[SUBUNIT%i]Sub-unit Default run trap\r\n", (INT8U) c_spw_channel);
}
#endif
					break;
				}
			}
			break;
		default:
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
			fprintf(fp, "[SUBUNIT%i]Sub-unit default error!\r\n", (INT8U) c_spw_channel);
}
#endif
			break;
		}
	}
}
