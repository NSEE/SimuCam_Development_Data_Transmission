/*
 * sub_unit_control.c
 *
 *  Created on: Oct 22, 2018
 *      Author: Yuri Bunduki
 */

#include "sub_unit_control_task.h"

/*
 * Creation of the sub-unit communication queue [yb]
 */
OS_EVENT *p_sub_unit_config_queue[8];
void *p_sub_unit_config_queue_tbl_0[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/
void *p_sub_unit_config_queue_tbl_1[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/
void *p_sub_unit_config_queue_tbl_2[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/
void *p_sub_unit_config_queue_tbl_3[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/
void *p_sub_unit_config_queue_tbl_4[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/
void *p_sub_unit_config_queue_tbl_5[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/
void *p_sub_unit_config_queue_tbl_6[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/
void *p_sub_unit_config_queue_tbl_7[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/

/*
 * Creation of the schedulerQueue
 */
OS_EVENT *DMA_sched_queue[2];
void *DMA1_sched_queue_tbl[DMA_SCHED_BUFFER]; /*Storage for sub_unit queue*/
void *DMA2_sched_queue_tbl[DMA_SCHED_BUFFER]; /*Storage for sub_unit queue*/

/*
 * Creation of the DMA scheduler controller
 */
OS_EVENT *p_dma_scheduler_controller_queue[2];
void *p_dma_scheduler_controller_queue_tbl_0[SUBUNIT_BUFFER];
void *p_dma_scheduler_controller_queue_tbl_1[SUBUNIT_BUFFER];

/*
 * Create the sub-unit defined data structures and queues
 */
void sub_unit_create_os_data_structs(void) {

	DMA_sched_queue[0] = OSQCreate(&DMA1_sched_queue_tbl[0],
	DMA_SCHED_BUFFER);
	if (!DMA_sched_queue[0]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_sub_unit_queue.\n");
	}

	DMA_sched_queue[1] = OSQCreate(&DMA2_sched_queue_tbl[0],
	DMA_SCHED_BUFFER);
	if (!DMA_sched_queue[1]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_sub_unit_queue.\n");
	}

	/*
	 * Create the sub-unit config queue [yb]
	 */
	p_sub_unit_config_queue[0] = OSQCreate(&p_sub_unit_config_queue_tbl_0[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue[0]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_sub_unit_queue.\n");
	}

	p_sub_unit_config_queue[1] = OSQCreate(&p_sub_unit_config_queue_tbl_1[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue[1]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_sub_unit_queue.\n");
	}

	p_sub_unit_config_queue[2] = OSQCreate(&p_sub_unit_config_queue_tbl_2[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue[2]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_sub_unit_queue.\n");
	}

	p_sub_unit_config_queue[3] = OSQCreate(&p_sub_unit_config_queue_tbl_3[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue[3]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_sub_unit_queue.\n");
	}

	p_sub_unit_config_queue[4] = OSQCreate(&p_sub_unit_config_queue_tbl_4[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue[4]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_sub_unit_queue.\n");
	}

	p_sub_unit_config_queue[5] = OSQCreate(&p_sub_unit_config_queue_tbl_5[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue[5]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_sub_unit_queue.\n");
	}

	p_sub_unit_config_queue[6] = OSQCreate(&p_sub_unit_config_queue_tbl_6[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue[6]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_sub_unit_queue.\n");
	}

	p_sub_unit_config_queue[7] = OSQCreate(&p_sub_unit_config_queue_tbl_7[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue[7]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_sub_unit_queue.\n");
	}

	p_dma_scheduler_controller_queue[0] = OSQCreate(
			&p_dma_scheduler_controller_queue_tbl_0[0],
			SUBUNIT_BUFFER);

	/*
	 * Creation of the DMA scheduller queues
	 */
	if (!p_dma_scheduler_controller_queue[0]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_dma_scheduler_controller_queue 0.\n");
	}

	p_dma_scheduler_controller_queue[1] = OSQCreate(
			&p_dma_scheduler_controller_queue_tbl_1[0],
			SUBUNIT_BUFFER);

	if (!p_dma_scheduler_controller_queue[1]) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_dma_scheduler_controller_queue 1.\n");
	}
}

/**
 * @name set_spw_linkspeed
 * @brief Set SpW linkspeed
 * @ingroup command_control
 *
 * Set the linkspeed of specific SpW channel according to the
 * specified divider code
 *
 * @param 	[in] 	TDcomChannel *x_channel
 * @param	[in]	INT8U linkspeed_code
 * 0: 10Mbits, 1: 25Mbits, 2: 50Mbits, 3: 100Mbits
 * 	ref_clock = 200M -> spw_clock = ref_clock/(div+1)
 * @retval INT8U error_code 1 if OK
 **/
INT8U set_spw_linkspeed(TDcomChannel *x_channel, INT8U i_linkspeed_code) {
	INT8U error_code = 0;
	INT8U i_linkspeed_div = 1;

	switch (i_linkspeed_code) {
	case 0:
		/* 10 Mbits */
		i_linkspeed_div = 19;
		break;

	case 1:
		/* 25 Mbits */
		i_linkspeed_div = 7;
		break;

	case 2:
		/* 50 Mbits */
		i_linkspeed_div = 3;

		break;

	case 3:
		/* 100 Mbits */
		i_linkspeed_div = 1;
		break;

	default:
		i_linkspeed_div = 1;
		break;
	}

	bSpwcGetLink(&(x_channel->xSpacewire));
	x_channel->xSpacewire.xLinkConfig.ucTxDivCnt = i_linkspeed_div;
	bSpwcSetLink(&(x_channel->xSpacewire));

	return error_code;
}

/*
 * Echo data creation function
 */

/*void i_echo_dataset(Timagette_control* p_imagette, INT8U* tx_buffer) {
 //	static INT8U tx_buffer[SSS_TX_BUF_SIZE];
 INT8U i = 0;
 INT32U i_imagette_counter_echo = i_imagette_counter;
 INT32U k;
 INT32U nb_size = p_imagette->imagette_length[i_imagette_number]
 + ECHO_CMD_OVERHEAD;
 INT32U nb_time = i_running_timer_counter;
 INT16U nb_id = i_id_accum;
 INT16U crc;

 tx_buffer[0] = 2;


 * Id to bytes

 tx_buffer[2] = div(nb_id, 256).rem;
 nb_id = div(nb_id, 256).quot;
 tx_buffer[1] = div(nb_id, 256).rem;


 * Type

 tx_buffer[3] = 203;


 * size to bytes

 tx_buffer[7] = div(nb_size, 256).rem;
 nb_size = div(nb_size, 256).quot;
 tx_buffer[6] = div(nb_size, 256).rem;
 nb_size = div(nb_size, 256).quot;
 tx_buffer[5] = div(nb_size, 256).rem;
 nb_size = div(nb_size, 256).quot;
 tx_buffer[4] = div(nb_size, 256).rem;


 * Timer to bytes

 tx_buffer[11] = div(nb_time, 256).rem;
 nb_time = div(nb_time, 256).quot;
 tx_buffer[10] = div(nb_time, 256).rem;
 nb_time = div(nb_time, 256).quot;
 tx_buffer[9] = div(nb_time, 256).rem;
 nb_time = div(nb_time, 256).quot;
 tx_buffer[8] = div(nb_time, 256).rem;

 tx_buffer[12] = 0;

 while (i < p_imagette->imagette_length[i_imagette_number]) {
 tx_buffer[i + (ECHO_CMD_OVERHEAD - 2)] =
 p_imagette->imagette[i_imagette_counter_echo];
 i++;
 i_imagette_counter_echo++;
 }

 crc = crc16(tx_buffer, (p_imagette->size - 11) + ECHO_CMD_OVERHEAD);

 tx_buffer[i + (ECHO_CMD_OVERHEAD - 1)] = div(crc, 256).rem;
 crc = div(crc, 256).quot;
 tx_buffer[i + (ECHO_CMD_OVERHEAD - 2)] = div(crc, 256).rem;

 //	tx_buffer[i + (ECHO_CMD_OVERHEAD - 2)] = 0;	//crc
 //	tx_buffer[i + (ECHO_CMD_OVERHEAD - 1)] = 7;	//crc

 i_id_accum++;

 #if DEBUG_ON
 printf("[Echo DEBUG]Printing buffer = ");

 for (int k = 0;
 k
 < p_imagette->imagette_length[i_imagette_number]
 + ECHO_CMD_OVERHEAD; k++) {
 printf("%i ", (INT8U) tx_buffer[k]);
 }

 printf("\r\n");
 #endif

 }*/

/*
 * Control task for sub-unit operation[yb]
 */
void sub_unit_control_task(void *task_data) {
	INT8U error_code; /*uCOS error code*/
	INT32U i_mem_pointer_buffer;
	INT8U i_temp_sched;
	INT8U i_dma_flag = 1;

	/*
	 * Assign channel code from task descriptor
	 */
	INT8U c_spw_channel = (INT8U) task_data;

	sub_config_t *p_config;

	static _ethernet_payload xTemp_sub;

	T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModeInit;

	while (1) {
		switch (T_simucam.T_Sub[c_spw_channel].T_conf.mode) {

		case subModeInit:
#if DEBUG_ON
			printf("[SUBUNIT%i]Sub-unit mode Init\r\n",(INT8U)c_spw_channel);
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
#if DEBUG_ON
			printf("[SUBUNIT%i]Sub-unit mode toConfig\r\n",(INT8U)c_spw_channel);
#endif
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

			/*
			 * Sub-Unit Config mode
			 */
		case subModeConfig:
#if DEBUG_ON
			printf("[SUBUNIT%i]Sub-unit mode Config\r\n",(INT8U)c_spw_channel);
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
				printf("[SUBUNIT%i]Sub-unit config queue error\r\n",(INT8U)c_spw_channel);
#endif
			}
			if (T_simucam.T_Sub[c_spw_channel].T_conf.linkstatus_running == 0) {
				T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModetoConfig;
			}
			break;

		case subModetoRun:
#if DEBUG_ON
			printf("[SUBUNIT%i]Sub-unit toRun\r\n",(INT8U)c_spw_channel);
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
				printf("[SUBUNIT%i]Channel disabled\r\n",(INT8U)c_spw_channel);
#endif
				T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModetoConfig;
				break;
			} else {

				T_simucam.T_Sub[c_spw_channel].T_data.p_iterador =
						(T_Imagette *) T_simucam.T_Sub[c_spw_channel].T_data.addr_init;
				/*
				 * Reset DMA full flag and switch to the right memory
				 */
				i_dma_flag = 1;
				bDdr2SwitchMemory((unsigned char) c_spw_channel / 4);

				while ((T_simucam.T_Sub[c_spw_channel].T_data.i_imagette
						< T_simucam.T_Sub[c_spw_channel].T_data.nb_of_imagettes)
						&& i_dma_flag) {
#if DEBUG_ON
					printf("[SUBUNIT%i]Printinf offset %i & %x\r\n",(INT8U)c_spw_channel,
							(INT32U) T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->offset,
							(INT32U) T_simucam.T_Sub[c_spw_channel].T_data.p_iterador);
					INT16U teste_limit = uiDatbGetBuffersFreeSpace(&(xCh[c_spw_channel].xDataBuffer));
#endif
					/*
					 * Verify if there's still space in the DMA buffer
					 */
					bDdr2SwitchMemory((unsigned char) c_spw_channel / 4);
					if (uiDatbGetBuffersFreeSpace(
							&(xCh[c_spw_channel].xDataBuffer))
							>= (T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
									+ DMA_OFFSET)) {
						/*
						 * Try to get the mutex
						 */
						OSMutexPend(
								xMutexDMA[(unsigned char) c_spw_channel / 4], 0,
								&error_code);

						if (error_code != OS_NO_ERR) {
#if DEBUG_ON
							printf("[SUBUNIT%i] Mutex error.\r\n",(INT8U)c_spw_channel);
#endif
						} else {
							/*
							 * TODO
							 * changed for testing
							 */
#if DEBUG_ON
							printf("[SUBUNIT%i] length antes while: %lu\r\n",
									(INT8U) c_spw_channel,
									T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length);
#endif
							/*
							 * Assign the correct memory access depending on ch
							 */
							if (((unsigned char) c_spw_channel / 4) == 0) {
								bDdr2SwitchMemory(DDR2_M1_ID);
#if DEBUG_ON
								printf(
										"[SUBUNIT%i] length antes da transf.: %lu\r\n",
										(INT8U) c_spw_channel,
										T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length);
#endif
								error_code =
										bIdmaDmaM1Transfer(
												(INT32U*) (T_simucam.T_Sub[c_spw_channel].T_data.p_iterador),
												T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
														+ DMA_OFFSET,
												c_spw_channel);
							} else {
								bDdr2SwitchMemory(DDR2_M2_ID);
								error_code =
										bIdmaDmaM2Transfer(
												(INT32U*) (T_simucam.T_Sub[c_spw_channel].T_data.p_iterador),
												T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
														+ DMA_OFFSET,
												c_spw_channel);
							}
							OSMutexPost(
									xMutexDMA[(unsigned char) c_spw_channel / 4]);

							if (error_code == TRUE) {
#if DEBUG_ON
								printf(
										"[SUBUNIT%i] length antes correcao de end: %lu\r\n",
										(INT8U) c_spw_channel,
										T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length);
#endif

								/*Calculate next imagette addr*/
								i_mem_pointer_buffer =
										(INT32U) T_simucam.T_Sub[c_spw_channel].T_data.p_iterador
												+ T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
												+ DMA_OFFSET;
								if ((i_mem_pointer_buffer % 8)) {
									i_mem_pointer_buffer =
											((((i_mem_pointer_buffer) >> 3) + 1)
													<< 3);
								}

								/*Reassign the pointer to the next imagette addrs */

								T_simucam.T_Sub[c_spw_channel].T_data.p_iterador =
										(T_Imagette *) i_mem_pointer_buffer;

								T_simucam.T_Sub[c_spw_channel].T_data.i_imagette++;
							} else {
#if DEBUG_ON
								printf("[SUBUNIT%i]DMA ERROR\r\n",(INT8U)c_spw_channel);
#endif
							}/* end error code DMA verif*/

						}/*End of mutex pend*/

					} else {
						/*
						 * Exit while if buffer is full
						 */
						i_dma_flag = 0;
						printf("[SUBUNIT%i]Buffer is full\r\n",
								(INT8U) c_spw_channel);
#if DEBUG_ON
						printf("[SUBUNIT%i]Buffer is full\r\n",(INT8U)c_spw_channel);
#endif
					}
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
					printf("[SUBUNIT%i]Channel autostart\r\n",(INT8U)c_spw_channel);
#endif

					bSpwcGetLink(&(xCh[c_spw_channel].xSpacewire));
					xCh[c_spw_channel].xSpacewire.xLinkConfig.bAutostart =
					TRUE;
					xCh[c_spw_channel].xSpacewire.xLinkConfig.bLinkStart =
					FALSE;
					xCh[c_spw_channel].xSpacewire.xLinkConfig.bDisconnect =
					FALSE;
					bSpwcSetLink(&(xCh[c_spw_channel].xSpacewire));

				} else {

					/*
					 * Set link to start
					 */
#if DEBUG_ON
					printf("[SUBUNIT%i]Channel start\r\n",(INT8U)c_spw_channel);
#endif

					bSpwcGetLink(&(xCh[c_spw_channel].xSpacewire));
					xCh[c_spw_channel].xSpacewire.xLinkConfig.bAutostart =
					FALSE;
					xCh[c_spw_channel].xSpacewire.xLinkConfig.bLinkStart =
					TRUE;
					xCh[c_spw_channel].xSpacewire.xLinkConfig.bDisconnect =
					FALSE;
					bSpwcSetLink(&(xCh[c_spw_channel].xSpacewire));

				}

				/*
				 * Sub-Unit RUN
				 */
				T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModeRun;
			}
			break;

		case subModeRun:
#if DEBUG_ON
			printf("[SUBUNIT%i]Sub-unit Run\r\n",(INT8U)c_spw_channel);
#endif
			p_config = (sub_config_t *) OSQPend(
					p_sub_unit_config_queue[c_spw_channel], 0, &error_code);
			if (error_code == OS_ERR_NONE) {

				switch (p_config->mode) {

				case subAccessDMA1:
#if DEBUG_ON
					printf("[SUBUNIT%i] Access DMA\r\n",(INT8U)c_spw_channel);
#endif
					if (T_simucam.T_Sub[c_spw_channel].T_data.i_imagette
							< T_simucam.T_Sub[c_spw_channel].T_data.nb_of_imagettes) {
						/*
						 * Switch to the right RAM stick, to prevent
						 * data crossover
						 */
						bDdr2SwitchMemory((unsigned char) c_spw_channel / 4);
						OSMutexPend(
								xMutexDMA[(unsigned char) c_spw_channel / 4], 0,
								&error_code);

						if (error_code != OS_NO_ERR) {
#if DEBUG_ON
							printf("[SUBUNIT%i] Mutex error.",(INT8U)c_spw_channel);
#endif
						}
						if (uiDatbGetBuffersFreeSpace(
								&(xCh[c_spw_channel].xDataBuffer))
								>= (T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
										+ DMA_OFFSET)) {
							if (((unsigned char) c_spw_channel / 4) == 0) {
								bDdr2SwitchMemory(DDR2_M1_ID);
								error_code =
										bIdmaDmaM1Transfer(
												(INT32U*) (T_simucam.T_Sub[c_spw_channel].T_data.p_iterador),
												T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
														+ DMA_OFFSET,
												c_spw_channel);
							} else {
								bDdr2SwitchMemory(DDR2_M2_ID);
								error_code =
										bIdmaDmaM2Transfer(
												(INT32U*) (T_simucam.T_Sub[c_spw_channel].T_data.p_iterador),
												T_simucam.T_Sub[c_spw_channel].T_data.p_iterador->imagette_length
														+ DMA_OFFSET,
												c_spw_channel);
							}
							OSMutexPost(
									xMutexDMA[(unsigned char) c_spw_channel / 4]);
							if (error_code == true) {
								/*
								 * Signal cmd that DMA is free
								 */
								i_temp_sched = simDMA1Back;
								OSQPost(
										p_dma_scheduler_controller_queue[(unsigned char) c_spw_channel
												/ 4], i_temp_sched);

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
								printf("[SUBUNIT%i]DMA ERROR\r\n",(INT8U)c_spw_channel);
#endif
							}
						} else {
#if DEBUG_ON
							printf("[SUBUNIT%i]Buffer Full\r\n",(INT8U)c_spw_channel);
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
							i_temp_sched = simDMA1Back;
							OSQPost(
									p_dma_scheduler_controller_queue[(unsigned char) c_spw_channel
											/ 4], i_temp_sched);
						}
					} else {
						/*
						 * End of dataset
						 */
#if DEBUG_ON
						printf("[SUBUNIT%i]End of Dataset scheduling\r\n",(INT8U)c_spw_channel);
#endif
						/*
						 * Signal cmd that DMA is free
						 */
						i_temp_sched = simDMA1Back;
						OSQPost(
								p_dma_scheduler_controller_queue[(unsigned char) c_spw_channel
										/ 4], i_temp_sched);
					}
					break;

					/*
					 * Abort and EoT
					 */
				case subAbort:
					T_simucam.T_Sub[c_spw_channel].T_conf.b_abort = false;
				case subEOT:
#if DEBUG_ON
					printf("[SUBUNIT%i]Sub Abort\r\n",(INT8U)c_spw_channel);
#endif

					T_simucam.T_Sub[c_spw_channel].T_data.i_imagette = 0;
					T_simucam.T_Sub[c_spw_channel].T_conf.mode = subModetoRun;

					break;

				case subChangeMode:
#if DEBUG_ON
					printf("[SUBUNIT%i]Change mode\r\n",(INT8U)c_spw_channel);
#endif
					T_simucam.T_Sub[c_spw_channel].T_conf.mode =
							subModetoConfig;
					break;

				default:
#if DEBUG_ON
					printf("[SUBUNIT%i]Sub-unit Default run trap\r\n",(INT8U)c_spw_channel);
#endif
					break;
				}
			}
			break;
		default:
#if DEBUG_ON
			printf("[SUBUNIT%i]Sub-unit default error!\r\n",(INT8U)c_spw_channel);
#endif
			break;
		}
	}
}
