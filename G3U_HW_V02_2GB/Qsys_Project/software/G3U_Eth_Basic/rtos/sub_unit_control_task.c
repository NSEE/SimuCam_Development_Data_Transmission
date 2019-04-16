/*
 * sub_unit_control.c
 *
 *  Created on: Oct 22, 2018
 *      Author: Yuri Bunduki
 */

#include "sub_unit_control_task.h"

//extern sub_config_t sub_config;
INT16U i_imagette_number;
INT16U i_imagette_counter;

/*
 * Creation of the sub-unit communication queue [yb]
 */
OS_EVENT *p_sub_unit_config_queue;
void *p_sub_unit_config_queue_tbl[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/
//struct _sub_config

/*
 * Creation of the sub-unit command queue [yb]
 */
OS_EVENT *p_sub_unit_command_queue;
int *p_sub_unit_command_queue_tbl[2]; /*Storage for sub_unit queue*/

INT8U tx_buffer[SSS_TX_BUF_SIZE];
static INT8U *p_tx_buffer = &tx_buffer[0];

/*
 * Create the sub-unit defined data structures and queues
 */
void sub_unit_create_os_data_structs(void) {
	INT8U error_code;

	/*
	 * Create the sub-unit config queue [yb]
	 */
	p_sub_unit_config_queue = OSQCreate(&p_sub_unit_config_queue_tbl[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_sub_unit_queue.\n");
	}

	/*
	 * Create the sub-unit command queue [yb]
	 */
	p_sub_unit_command_queue = OSQCreate(&p_sub_unit_command_queue_tbl[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_command_queue) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_sub_unit_queue.\n");
	}

	/*
	 * Create Sub-Unit command semaphore, input set to 1 to create a binary semaphore
	 */
	sub_unit_command_semaphore = OSSemCreate(0);
}

/**
 * @name set_spw_linkspeed
 * @brief Set SpW linkspeed
 * @ingroup command_control
 *
 * Set the linkspeed of specific SpW channel according to the
 * specified divider code
 *
 * @param 	[in] 	INT8U channel_code
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

void i_echo_dataset(Timagette_control* p_imagette, INT8U* tx_buffer) {
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

	/*
	 * Id to bytes
	 */
	tx_buffer[2] = div(nb_id, 256).rem;
	nb_id = div(nb_id, 256).quot;
	tx_buffer[1] = div(nb_id, 256).rem;

	/*
	 * Type
	 */
	tx_buffer[3] = 203;

	/*
	 * size to bytes
	 */
	tx_buffer[7] = div(nb_size, 256).rem;
	nb_size = div(nb_size, 256).quot;
	tx_buffer[6] = div(nb_size, 256).rem;
	nb_size = div(nb_size, 256).quot;
	tx_buffer[5] = div(nb_size, 256).rem;
	nb_size = div(nb_size, 256).quot;
	tx_buffer[4] = div(nb_size, 256).rem;

	/*
	 * Timer to bytes
	 */
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

}

/*
 * Control task for sub-unit operation[yb]
 */
void sub_unit_control_task() {
	INT8U error_code; /*uCOS error code*/
	INT8U exec_error; /*Internal error code for the command module*/
	INT16U i_imagette_length = 0;
	INT16U i_dma_counter = 0;

	INT8U c_spw_channel = eIdmaCh1Buffer;

	sub_config_t *p_config;

	Timagette_control imagette_buffer;
	Timagette_control *p_imagette_buffer = &imagette_buffer;

	int i_command_control = 0;

//	p_config->mode = 0;
//	p_config->RMAP_handling = 0;
//	p_config->forward_data = 0;
//	p_config->link_config = 0;
//	p_config->sub_status_sending = 0;
//	p_config->linkstatus_running = 1;
//	p_config->linkspeed = 3;

	int b_sub_status = 0;

	struct x_ethernet_payload *p_sub_data;

	T_simucam.T_Sub[0].T_conf.mode = subModeInit;

	while (1) {
		switch (T_simucam.T_Sub[0].T_conf.mode) {

		case subModeInit:
			printf("[SUBUNIT]Sub-unit init\r\n");
			/*
			 * Default subUnit config
			 */
			T_simucam.T_Sub[c_spw_channel].T_conf.RMAP_handling = 0;
			T_simucam.T_Sub[c_spw_channel].T_conf.forward_data = 0;
			T_simucam.T_Sub[c_spw_channel].T_conf.link_config = 0;
			T_simucam.T_Sub[c_spw_channel].T_conf.sub_status_sending = 0;
			T_simucam.T_Sub[c_spw_channel].T_conf.linkstatus_running = 1;
			T_simucam.T_Sub[c_spw_channel].T_conf.linkspeed = 3;

			T_simucam.T_Sub[0].T_conf.mode = subModetoConfig;
			break;

		case subModetoConfig:
			printf("[SUBUNIT]Sub-unit toConfig\r\n");
			/*
			 * Disabling SpW channel
			 */
			bSpwcGetLink(&(xChA.xSpacewire));
			xChA.xSpacewire.xLinkConfig.bAutostart = FALSE;
			xChA.xSpacewire.xLinkConfig.bLinkStart = FALSE;
			xChA.xSpacewire.xLinkConfig.bDisconnect = TRUE;
			bSpwcSetLink(&(xChA.xSpacewire));

			T_simucam.T_Sub[0].T_conf.mode = subModeConfig;
			break;

		case subModeConfig:
			printf("[SUBUNIT]Sub-unit config\r\n");
			p_config = (sub_config_t *) OSQPend(p_sub_unit_config_queue, 0,
					&error_code);
			if (error_code == OS_ERR_NONE) {
				printf("[SUBUNIT]OK Pend\r\n");

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

			break;

		case subModetoRun:
#if DEBUG_ON
			printf("[SUBUNIT]Sub-unit toRun\r\n");
#endif
			/*
			 * Set link interface status according to
			 * link_config
			 */
			if (T_simucam.T_Sub[0].T_conf.linkstatus_running == 0) {
#if DEBUG_ON
				printf("[SUBUNIT]Channel disabled\r\n");
#endif
				T_simucam.T_Sub[0].T_conf.mode = subModetoConfig;
			}

			T_simucam.T_Sub[0].T_data.p_iterador = (T_Imagette *)T_simucam.T_Sub[0].T_data.addr_init;

			while (i_dma_counter < T_simucam.T_Sub[0].T_data.nb_of_imagettes) {

#if DEBUG_ON
				printf("[SUBUNIT]Printinf offset %i & %x\r\n",
						(INT32U)T_simucam.T_Sub[0].T_data.p_iterador->offset,
						(INT32U)T_simucam.T_Sub[0].T_data.p_iterador);
#endif

				error_code = bIdmaDmaM1Transfer(
						(INT32U*) (T_simucam.T_Sub[0].T_data.p_iterador),
						T_simucam.T_Sub[0].T_data.p_iterador->imagette_length
								+ DMA_OFFSET, 0);
				if (error_code == TRUE) {
					T_simucam.T_Sub[0].T_data.p_iterador +=
							T_simucam.T_Sub[0].T_data.p_iterador->imagette_length
									+ DMA_OFFSET;
					i_dma_counter++;
				} else {
#if DEBUG_ON
					printf("[SUBUNIT]DMA ERROR\r\n");
#endif
				}
			}

//			OSMutexPend(xMutexDMA, 0, &error_code);
//			if (error_code != OS_NO_ERR) {
//#if DEBUG_ON
//				printf("[SUBUNIT] Mutex error.",exec_error);
//#endif
//			}
//			OSMutexPost(xMutexDMA);

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

				bSpwcGetLink(&(xChA.xSpacewire));
				xChA.xSpacewire.xLinkConfig.bAutostart = TRUE;
				xChA.xSpacewire.xLinkConfig.bLinkStart = FALSE;
				xChA.xSpacewire.xLinkConfig.bDisconnect = FALSE;
				bSpwcSetLink(&(xChA.xSpacewire));

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

				bSpwcGetLink(&(xChA.xSpacewire));
				xChA.xSpacewire.xLinkConfig.bAutostart = FALSE;
				xChA.xSpacewire.xLinkConfig.bLinkStart = TRUE;
				xChA.xSpacewire.xLinkConfig.bDisconnect = FALSE;
				bSpwcSetLink(&(xChA.xSpacewire));
#if DEBUG_ON
				printf("error_code: %i", exec_error);
#endif
			}

			T_simucam.T_Sub[0].T_conf.mode = subModeRun;
			break;

		case subModeRun:
#if DEBUG_ON
			printf("[SUBUNIT]Sub-unit Run\r\n");
#endif
			OSSemPend(sub_unit_command_semaphore, 0, &exec_error);
			if (exec_error == OS_ERR_NONE) {
				printf("[SUBUNIT]Data sent\r\n");
			} else {
#if DEBUG_ON
				printf("[SUBUNIT]Sub-unit config queue error\r\n");
#endif
			}
			break;
		default:
			printf("[SUBUNIT]Sub-unit default error!\r\n");
			break;
		}
	}

	while (T_simucam.T_Sub[0].T_conf.mode == 0) {
#if DEBUG_ON
		printf("[SUBUNIT]Sub-unit in config mode\r\n");
#endif
		/*
		 * Disabling SpW channel
		 */
		bSpwcGetLink(&(xChA.xSpacewire));
		xChA.xSpacewire.xLinkConfig.bAutostart = FALSE;
		xChA.xSpacewire.xLinkConfig.bLinkStart = FALSE;
		xChA.xSpacewire.xLinkConfig.bDisconnect = TRUE;
		bSpwcSetLink(&(xChA.xSpacewire));

#if DEBUG_ON
		printf("[SUBUNIT]Sub-unit waiting config...\r\n");
#endif
		p_config = OSQPend(p_sub_unit_config_queue, 0, &error_code);
#if DEBUG_ON
		printf("[SUBUNIT]Sub-unit mode change to: %i\n\r",
				(INT8U) p_config->mode);
#endif
		T_simucam.T_Sub[0].T_conf.mode = p_config->mode;

		p_imagette_buffer = p_config->imagette;

		while (i_dma_counter < T_simucam.T_Sub[0].T_data.nb_of_imagettes) {

			bIdmaDmaM1Transfer((INT32U*) (T_simucam.T_Sub[0].T_data.p_iterador),
					T_simucam.T_Sub[0].T_data.p_iterador->imagette_length
							+ DMA_OFFSET, 0);
			T_simucam.T_Sub[0].T_data.p_iterador +=
					T_simucam.T_Sub[0].T_data.p_iterador->imagette_length
							+ DMA_OFFSET;
			i_dma_counter++;

		}

	}

	/*
	 * Sub-Unit in running mode
	 */
	while (T_simucam.T_Sub[0].T_conf.mode == 1) {
		INT8U error_code; /*uCOS error code*/

		i_imagette_counter = 0;
		i_imagette_number = 0;
		i_command_control = 0;

		int p;
		INT16U nb_of_imagettes = p_imagette_buffer->nb_of_imagettes;
		p++;
#if DEBUG_ON
		printf("[SUBUNIT]Sub-unit in running mode\r\n");
#endif

//		set_spw_linkspeed(&(xChA.xSpacewire),T_simucam.T_Sub[0].T_conf.linkspeed);
#if DEBUG_ON
		printf("[SUBUNIT]imagette counter and nb start: %i %i\r\n",
				(int) i_imagette_counter, (int) i_imagette_number);
#endif

		while (i_imagette_number < nb_of_imagettes) {
#if DEBUG_ON
			printf("[SUBUNIT]Entered while\r\n");

			printf("[SUBUNIT]Received imagette %i start byte: %i @ %x\r\n",
					i_imagette_number,
					p_imagette_buffer->imagette[i_imagette_counter],
					&(p_imagette_buffer->imagette[i_imagette_counter]));
#endif
//			i_imagette_length =
//					p_imagette_buffer->imagette_length[i_imagette_number];
#if DEBUG_ON
			printf(
					"[SUBUNIT]imagette length var: %i, imagette length p_config %i\r\n",
					(INT16U) i_imagette_length,
					(INT16U) p_imagette_buffer->imagette_length[i_imagette_number]);

			printf("[SUBUNIT]Waiting unblocked sub_unit_command_semaphore\r\n");
#endif
			printf("[SUBUNIT]Waiting unblocked sub_unit_command_semaphore\r\n");

			T_simucam.T_Sub[0].T_conf.sub_status_sending = 0;

			OSSemPend(sub_unit_command_semaphore, 0, &exec_error);
			i_command_control = (int) OSQAccept(p_sub_unit_command_queue,
					&error_code);

			//printf("[SUBUNIT]command_control: %i\r\n", (int) i_command_control);

			if (i_command_control != 0) {
#if DEBUG_ON
				printf("[SUBUNIT]Parsing command\r\n");
#endif
				switch (i_command_control) {
				case 1:
#if DEBUG_ON
					printf("[SUBUNIT]Abort Flag received\r\n");
#endif
					printf("[SUBUNIT]Abort Flag received\r\n");
					i_imagette_number = nb_of_imagettes;
					break;

				case 2:
#if DEBUG_ON
					printf("[SUBUNIT]Returning to config mode...\r\n");
#endif
					i_imagette_number = nb_of_imagettes;

					/*
					 * Disabling SpW channel
					 */

					bSpwcGetLink(&(xChA.xSpacewire));
					xChA.xSpacewire.xLinkConfig.bAutostart = FALSE;
					xChA.xSpacewire.xLinkConfig.bLinkStart = FALSE;
					xChA.xSpacewire.xLinkConfig.bDisconnect = TRUE;
					bSpwcSetLink(&(xChA.xSpacewire));

#if DEBUG_ON
					printf("[SUBUNIT]Sub-unit waiting config...\r\n");
#endif
					p_config = OSQPend(p_sub_unit_config_queue, 0, &error_code);
#if DEBUG_ON
					printf("[SUBUNIT]Sub-unit mode change to: %i\n\r",
							(INT8U) p_config->mode);
#endif
					b_sub_status = p_config->mode;
					p_imagette_buffer = p_config->imagette;
					break;
				default:
					break;
				}

			} else {

#if DMA_DEV
				while(buffer_space <= imagette_length) {
					//carregar imagette i no buffer
				}
#endif

				/*
				 * Echo command statement
				 */
				if (T_simucam.T_Sub[0].T_conf.echo_sent == 1) {

					i_echo_dataset(p_imagette_buffer, p_tx_buffer);
#if DEBUG_ON
					printf("[Echo in fct DEBUG]Printing buffer = ");
					for (int k = 0;
							k
									< p_imagette_buffer->imagette_length[i_imagette_number]
											+ ECHO_CMD_OVERHEAD; k++) {
						printf("%i ", (INT8U) tx_buffer[k]);
					}
					printf("\r\n");
#endif
//					send(conn.fd, p_tx_buffer,
//							p_imagette_buffer->imagette_length[i_imagette_number] + ECHO_CMD_OVERHEAD,
//							0);
				}

//				i_imagette_counter += i_imagette_length;
				i_imagette_number++;
#if DEBUG_ON
				printf("[SUBUNIT]imagette sent\r\n");
				printf("[SUBUNIT]imagette counter %i\r\n",
						(INT16U) i_imagette_counter);

				printf("[SUBUNIT]imagette nb %i\r\n",
						(INT16U) i_imagette_number);
#endif

				/*
				 * Restarting the timer when the transmission ends
				 */
				if (i_imagette_number == nb_of_imagettes) {

#if DEBUG_ON
					("[SUBUNIT]EOT timer restart\r\n");
#endif
					p_sub_data->type = 5;
					error_code = (INT8U) OSQPost(p_simucam_command_q,
							p_sub_data);
					alt_SSSErrorHandler(error_code, 0);

					INT16U i_dma_counter = 0;
					while (i_dma_counter < p_imagette_buffer->nb_of_imagettes) {

						bIdmaDmaM1Transfer(
								(INT32U*) (p_imagette_buffer->dataset[i_dma_counter]),
								p_imagette_buffer->dataset[i_dma_counter]->imagette_length
										+ DMA_OFFSET, 0);
						i_dma_counter++;
					}

				}

			}
		}
#if DEBUG_ON
		//printf("[SUBUNIT]End of sending\r\n");
#endif
	}
}
