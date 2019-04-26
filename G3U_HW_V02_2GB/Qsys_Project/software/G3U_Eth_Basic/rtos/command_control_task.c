/*
 ************************************************************************************************
 *                                              NSEE
 *                                             Address
 *
 *                                       All Rights Reserved
 *
 *
 * Filename     : command_control_task.c
 * Programmer(s): Yuri Bunduki
 * Created on: Apr 26, 2018
 * Description  : Source file for the command control management task.
 ************************************************************************************************
 */
/*$PAGE*/

#include "command_control_task.h"

sub_config_t sub_config_send[8];

Timagette_control img_struct;
Timagette_control *p_img_control;

INT8U data[MAX_IMAGETTES];
INT8U *p_data_pos = &data[0];

//volatile INT32U i_running_timer_counter = 1;

//volatile INT32U i_central_timer_counter = 1;
INT8U exec_error;

INT16U i_id_accum = 1;

int abort_flag = 1;
int i_return_config_flag = 2;

/*
 * Simucam Global Values
 */

T_Simucam T_simucam;

TDschChannel xSimucamTimer;

/**
 * @name long_to_int
 * @brief transforms an int to a byte array
 * @ingroup UTIL
 *
 * @param 	[in]	int 	number
 * @param	[in]	int 	number of bytes
 * @param	[in]	INT8U	*destination array
 *
 * @retval INT16U crc
 **/

//void long_to_int(int nb, int nb_bytes, INT8U* p_destination) {
////	def long_to_bytes(nb,n_bytes):
////	    p=0
////	    size = []
////	    while p < n_bytes:
////	        buff = nb//256
////	        size.append(nb%256)
////	        nb = buff
////	        p+=1
////	    return size[::-1]
//
//	int p = 0;
//	int k = 0;
//	INT8U byte_buffer[nb_bytes];
//	INT32U i_buffer;
//
//	while (p < nb_bytes) {
//		i_buffer = div(nb, 256).quot;
//		byte_buffer[p] = div(nb, 256).rem;
//		nb = i_buffer;
//		p++;
//	}
//#if DEBUG_ON
//	printf("[LongToInt]Final Bytes ");
//#endif
//	while (p != 0) {
//		p_destination[p] = byte_buffer[k];
//#if DEBUG_ON
//		printf("%i ", p_destination[p]);
//#endif
//		p--;
//		k++;
//	}
//#if DEBUG_ON
//	printf("\r\n");
//#endif
//
//#if DEBUG_ON
//	printf("[LongToInt]Byte buffer ");
//	for (p = 0; p < nb_bytes; p++) {
//		printf("%i ", byte_buffer[p]);
//	}
//	printf("\r\n");
//#endif
//}
/**
 * @name i_echo_dataset_direct_send
 * @brief Send direct-send echo
 * @ingroup command_control_task
 *
 *
 * @param 	[in] 	x_ethernet_payload 	*Imagette
 * @param	[in]	INT8U				*tx_buffer
 * @retval void
 **/
void i_echo_dataset_direct_send(struct x_ethernet_payload* p_imagette,
		INT8U* tx_buffer) {
//	static INT8U tx_buffer[SSS_TX_BUF_SIZE];
	INT8U i = 0;
//	INT32U i_imagette_counter_echo = i_imagette_counter;
//	INT32U k;
	INT32U nb_size = (p_imagette->size - 11) + ECHO_CMD_OVERHEAD;
	INT32U nb_time = 0; /* Will be set with a uliDschGetTime() and sent via queue*/
	INT16U crc;

//	INT8U buffer_size[4];
//	INT8U *p_buffer_size;
//	p_buffer_size = &buffer_size[0];

	tx_buffer[0] = 2;
	tx_buffer[1] = 0;
//	tx_buffer[2] = T_simucam.T_status.TM_id;
	tx_buffer[3] = 203;

//	long_to_int((p_imagette->size - 11) + ECHO_CMD_OVERHEAD, 4, p_buffer_size);
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

//	tx_buffer[8] = 0;
//	tx_buffer[9] = 0;
//	tx_buffer[10] = 0;
//	tx_buffer[11] = i_running_timer_counter;

	tx_buffer[12] = 0;			//channel info

	while (i < p_imagette->size - 11) {
		tx_buffer[i + (ECHO_CMD_OVERHEAD - 2)] = p_imagette->data[i + 1];
		i++;
	}

	crc = crc16(tx_buffer, (p_imagette->size - 11) + ECHO_CMD_OVERHEAD);

	tx_buffer[i + (ECHO_CMD_OVERHEAD - 1)] = div(crc, 256).rem;
	crc = div(crc, 256).quot;
	tx_buffer[i + (ECHO_CMD_OVERHEAD - 2)] = div(crc, 256).rem;

	T_simucam.T_status.TM_id++;

#if DEBUG_ON
	printf("[Echo DEBUG]Printing buffer = ");
	for (int k = 0; k < (p_imagette->size - 11) + ECHO_CMD_OVERHEAD; k++) {
		printf("%i ", (INT8U) tx_buffer[k]);
	}
	printf("\r\n");
#endif
//	return *tx_buffer;

}

/**
 * @name v_ack_creator
 * @brief Computes the size of the payload
 * @ingroup UTIL
 *
 * This routine computes the size of the payload based in the received
 * string via ethernet telnet. Depending on the command protocol, there is an
 * offset to read the good values. It can be changed in the header file. All the
 * byte as supposed to be in ASCII form.
 *
 * @param 	[in] 	*INT8U Data array
 * @retval INT32U size
 **/
void v_ack_creator(_ethernet_payload* p_error_response, int error_code) {

	INT16U nb_id = T_simucam.T_status.TM_id;
	INT16U nb_id_pkt = p_error_response->packet_id;
	INT8U ack_buffer[64];
	INT32U ack_size = 14;

	ack_buffer[0] = 2;

	/*
	 * Id to bytes
	 */
	ack_buffer[2] = div(nb_id, 256).rem;
	nb_id = div(nb_id, 256).quot;
	ack_buffer[1] = div(nb_id, 256).rem;

//	p_error_response->data[1] = 0;
//	p_error_response->data[2] = i_id_accum;
	ack_buffer[3] = 201;
	ack_buffer[4] = 0;
	ack_buffer[5] = 0;
	ack_buffer[6] = 0;
	ack_buffer[7] = 14;

	/*
	 * Packet id to bytes
	 */
	ack_buffer[9] = div(nb_id_pkt, 256).rem;
	nb_id_pkt = div(nb_id_pkt, 256).quot;
	ack_buffer[8] = div(nb_id_pkt, 256).rem;

//	p_error_response->data[8] = 0;
//	p_error_response->data[9] = p_error_response->packet_id;

	ack_buffer[10] = p_error_response->type;
	ack_buffer[11] = error_code;
	ack_buffer[12] = 0;
	ack_buffer[13] = 89;
//	p_error_response->size = 14;

	send(conn.fd, ack_buffer, ack_size, 0);

	T_simucam.T_status.TM_id++;
}
/*
 * TODO remove pointer ref
 */

void v_HK_creator(struct x_ethernet_payload* p_HK, INT8U i_channel) {

	INT8U chann_buff = i_channel;
	INT16U crc;
	INT16U nb_id = T_simucam.T_status.TM_id;
	INT16U nb_counter_total = T_simucam.T_status.simucam_total_imagettes_sent;
	INT16U nb_counter_current =
			T_simucam.T_Sub[chann_buff].T_conf.i_imagette_control;
	INT16U nb_counter_left = nb_counter_total - nb_counter_current;

	INT8U hk_buffer[HK_SIZE];
	bool b_link_enabled = false;
	/*
	 * Update SpW status flags
	 */
	bSpwcGetLinkStatus(&(xCh[chann_buff].xSpacewire));
	bSpwcGetLinkError(&(xCh[chann_buff].xSpacewire));

	if (T_simucam.T_Sub[i_channel].T_conf.mode == subModeRun) {
		b_link_enabled = true;
	} else {
		b_link_enabled = false;
	}

	hk_buffer[0] = 2;

	/*
	 * Id to bytes
	 */
	hk_buffer[2] = div(nb_id, 256).rem;
	nb_id = div(nb_id, 256).quot;
	hk_buffer[1] = div(nb_id, 256).rem;

	hk_buffer[3] = 204;
	hk_buffer[4] = 0;
	hk_buffer[5] = 0;
	hk_buffer[6] = 0;
	hk_buffer[7] = 30;
	hk_buffer[8] = chann_buff; /**channel*/
	hk_buffer[9] = T_simucam.T_status.simucam_mode; /**meb mode*/
	hk_buffer[10] = T_simucam.T_Sub[i_channel].T_conf.linkstatus_running; /**Sub_config_enabled*/
	hk_buffer[11] = T_simucam.T_Sub[i_channel].T_conf.link_config; /**sub_config_linkstatus*/
	hk_buffer[12] = T_simucam.T_Sub[i_channel].T_conf.linkspeed; /**sub_config_linkspeed*/
	hk_buffer[13] = xCh[chann_buff].xSpacewire.xLinkStatus.bRunning; /**sub_status_linkrunning*/ // TODO
	hk_buffer[14] = T_simucam.T_Sub[i_channel].T_conf.linkstatus_running; /**link enabled*/
	hk_buffer[15] = T_simucam.T_Sub[i_channel].T_conf.sub_status_sending;
	hk_buffer[16] = 0; /**TODO link errors*/
	hk_buffer[17] = 0;
	hk_buffer[18] = 0;
	hk_buffer[19] = 0;

	/*
	 * Sent Packets
	 */
	hk_buffer[21] = div(nb_counter_total, 256).rem;
	nb_counter_total = div(nb_counter_total, 256).quot;
	hk_buffer[20] = div(nb_counter_total, 256).rem;

	hk_buffer[22] = 0; /**Received packets 1*/
	hk_buffer[23] = 0; /**Received packets 0*/

	/**
	 * Current packet nb
	 */
	hk_buffer[25] = div(nb_counter_current, 256).rem;
	nb_counter_current = div(nb_counter_current, 256).quot;
	hk_buffer[24] = div(nb_counter_current, 256).rem;

	/**
	 * Packets to send
	 */
	hk_buffer[26] = div(nb_counter_left, 256).rem;
	nb_counter_left = div(nb_counter_left, 256).quot;
	hk_buffer[27] = div(nb_counter_left, 256).rem;
	//p_HK->size = 30;

	/**
	 * Calculating CRC
	 */
	crc = crc16(p_HK->data, p_HK->size - 2);

	hk_buffer[29] = div(crc, 256).rem;
	crc = div(crc, 256).quot;
	hk_buffer[28] = div(crc, 256).rem;

	send(conn.fd, hk_buffer, HK_SIZE, 0);

	T_simucam.T_status.TM_id++;

}
/**
 * @name i_compute_size
 * @brief Computes the size of the payload
 * @ingroup UTIL
 *
 * This routine computes the size of the payload based in the received
 * string via ethernet telnet. Depending on the command protocol, there is an
 * offset to read the good values. It can be changed in the header file. All the
 * byte as supposed to be in ASCII form.
 *
 * @param 	[in] 	*INT8U Data array
 * @retval INT32U size
 **/
INT32U i_compute_size(INT8U *p_length) {
	INT32U size = 0;
	size = toInt(p_length[3 + LENGTH_OFFSET])
			+ 256 * toInt(p_length[2 + LENGTH_OFFSET])
			+ 65536 * toInt(p_length[1 + LENGTH_OFFSET])
			+ 4294967296 * toInt(p_length[LENGTH_OFFSET]);
	return size;
}

/*
 * Task body
 */

void CommandManagementTask() {

	INT8U error_code; /*uCOS error code*/

	INT8U i_channel_for;

	_ethernet_payload payload_command;

	_ethernet_payload *p_payload = &payload_command;

	INT8U i_channel_buffer = 0;

	/*
	 * Initialize DMA
	 */
	bIdmaInitM1Dma();
	bIdmaInitM2Dma();

	/*
	 * Assigning imagette struct to RAM
	 * Maybe the switch is not needed here
	 */

	bDdr2SwitchMemory(DDR2_M1_ID);

	T_simucam.T_Sub[0].T_data.addr_init = DDR2_BASE_ADDR_DATASET_1;
	T_simucam.T_Sub[4].T_data.addr_init = DDR2_BASE_ADDR_DATASET_1;
	T_simucam.T_Sub[1].T_data.addr_init = DDR2_BASE_ADDR_DATASET_2;
	T_simucam.T_Sub[5].T_data.addr_init = DDR2_BASE_ADDR_DATASET_2;
	T_simucam.T_Sub[2].T_data.addr_init = DDR2_BASE_ADDR_DATASET_3;
	T_simucam.T_Sub[6].T_data.addr_init = DDR2_BASE_ADDR_DATASET_3;
	T_simucam.T_Sub[3].T_data.addr_init = DDR2_BASE_ADDR_DATASET_4;
	T_simucam.T_Sub[7].T_data.addr_init = DDR2_BASE_ADDR_DATASET_4;

	struct x_telemetry x_telemetry_buffer;

	/*
	 * Init and config of sync functionality
	 */
	bSyncSetOst(25e6);
	bSyncSetPolarity(FALSE);
	bSyncCtrExtnIrq(TRUE);
	bSyncCtrReset();
	bSyncCtrCh1OutEnable(TRUE);
	bSyncCtrCh2OutEnable(TRUE);
	bSyncCtrCh3OutEnable(TRUE);
	bSyncCtrCh4OutEnable(TRUE);
	bSyncCtrCh5OutEnable(TRUE);

	T_simucam.T_status.simucam_mode = simModeInit;
	/*
	 * Initialize Simucam Timer
	 * TODO
	 */

	/* Address */
	xSimucamTimer.puliDschChAddr =
			(TDschChannel *) DUMB_COMMUNICATION_MODULE_V1_TIMER_BASE;
	/* Init */
	bDschGetTimerConfig(&xSimucamTimer);
	bDschGetTimerStatus(&xSimucamTimer);
	bDschSetTime(&xSimucamTimer, 0);
	/* Configs */
	xSimucamTimer.xTimerConfig.bStartOnSync = false;
	xSimucamTimer.xTimerConfig.uliTimerDiv = TIMER_CLOCK_DIV_1MS;
	bDschSetTimerConfig(&xSimucamTimer);

	while (1) {

		switch (T_simucam.T_status.simucam_mode) {

		/*
		 * Initializing the system
		 */
		case simModeInit:
#if DEBUG_ON
			printf("[CommandManagementTask]Init\r\n");
#endif

			/*
			 * Configuring done inside the sub-unit modules
			 */
			for (i_channel_for = 0; i_channel_for < NB_CHANNELS;
					i_channel_for++) {
				sub_config_send[i_channel_for].RMAP_handling = 0;
				sub_config_send[i_channel_for].forward_data = 0;
				sub_config_send[i_channel_for].link_config = 0;
				sub_config_send[i_channel_for].sub_status_sending = 0;
				sub_config_send[i_channel_for].linkstatus_running = 0;
				sub_config_send[i_channel_for].linkspeed = 3;
			}

			T_simucam.T_status.simucam_mode = simModetoConfig;
			T_simucam.T_status.has_dma_1 = true;
			T_simucam.T_status.has_dma_2 = true;
			break;

		case simModetoConfig:
#if DEBUG_ON
			printf("[CommandManagementTask]Mode: toConfig\r\n");
#endif

			T_simucam.T_status.simucam_mode = simModeConfig;
			break;

			/*
			 * Config mode
			 */
		case simModeConfig:
#if DEBUG_ON
			printf("[CommandManagementTask]Mode: Config\r\n");
#endif
			p_payload = OSQPend(p_simucam_command_q, 0, &error_code);
			alt_uCOSIIErrorHandler(error_code, 0);

			switch (p_payload->type) { /*Selector for commands and actions*/

			/*
			 * Sub-Unit config command
			 * char: e
			 */
			case 101:
#if DEBUG_ON
				printf("[CommandManagementTask]Configure Sub-Unit\r\n");
#endif

				/*
				 * data[0] is the channel input
				 */
				sub_config_send[p_payload->data[0]].link_config =
						p_payload->data[1];
				sub_config_send[p_payload->data[0]].linkspeed =
						p_payload->data[2];
				sub_config_send[p_payload->data[0]].linkstatus_running =
						p_payload->data[3];
				/*
				 * TODO complete listing
				 */

#if DEBUG_ON
				printf("[CommandManagementTask]Configurations sent: %i, %i, %i\r\n",
						(INT8U) sub_config_send[p_payload->data[0]].link_config,
						(INT8U) sub_config_send[p_payload->data[0]].linkspeed,
						(INT8U) sub_config_send[p_payload->data[0]].linkstatus_running);
#endif

				v_ack_creator(p_payload, ACK_OK);

				break;

				/*
				 * Delete Data
				 * TODO
				 * char: g
				 */
			case 103:

				v_ack_creator(p_payload, NOT_IMPLEMENTED);

				break;

				/*
				 * Select data to send
				 * TODO Assign the memory spaces to the data
				 * instead of the sub
				 * char: h
				 */
			case 104:

				v_ack_creator(p_payload, NOT_IMPLEMENTED);

				break;

				/*
				 * Change Simucam Modes
				 * char: i
				 */
			case 105:
#if DEBUG_ON
				printf("[CommandManagementTask]Change Mode\r\n");
#endif

				if (p_payload->data[0] == 1) {

					for (i_channel_for = 0; i_channel_for < NB_CHANNELS;
							i_channel_for++) {

						sub_config_send[i_channel_for].mode = subModetoRun;
						error_code = (INT8U) OSQPost(
								p_sub_unit_config_queue[i_channel_for],
								&sub_config_send[i_channel_for]);
						alt_SSSErrorHandler(error_code, 0);
					}
					T_simucam.T_status.simucam_mode = simModetoRun;
				}

				v_ack_creator(p_payload, ACK_OK);

#if DEBUG_ON
				printf("[CommandManagementTask]Config sent to sub\n\r");
#endif
				break;

				/*
				 * Clear RAM
				 */
			case 108:

				v_ack_creator(p_payload, NOT_IMPLEMENTED);
#if DEBUG_ON
				printf("[CommandManagementTask]Clear RAM\r\n");
#endif
				break;

				/*
				 * Get HK
				 */
			case 110:
#if DEBUG_ON
				printf("[CommandManagementTask]Get HK\r\n");
#endif
				i_channel_buffer = p_payload->data[0];

				v_HK_creator(p_payload, i_channel_buffer);

				break;

				/*
				 * Config MEB
				 */
			case 111:
#if DEBUG_ON
				printf("[CommandManagementTask]Config MEB\r\n");
#endif

				T_simucam.T_conf.i_forward_data = p_payload->data[0];
				T_simucam.T_conf.echo_sent = p_payload->data[1];

				v_ack_creator(p_payload, ACK_OK);
#if DEBUG_ON
				printf("[CommandManagementTask]Meb configs: fwd: %i, echo: %i\r\n",
						(int) T_simucam.T_conf.i_forward_data,
						(int) T_simucam.T_conf.echo_sent);
#endif
				break;

				/*
				 * Set Recording
				 */
			case 112:
#if DEBUG_ON
				printf("[CommandManagementTask]Selected command: %c\n\r",
						(int) p_payload->type);
#endif
				v_ack_creator(p_payload, NOT_IMPLEMENTED);

				break;

			default:
#if DEBUG_ON
				printf("[CommandManagementTask]Nenhum comando identificado\n\r");
#endif

				if (p_payload->type == 106 || p_payload->type == 106
						|| p_payload->type == 107 || p_payload->type == 109) {
					v_ack_creator(p_payload, COMMAND_NOT_ACCEPTED);
				} else {
					v_ack_creator(p_payload, COMMAND_NOT_FOUND);
				}

				break;

			}
			break;

		case simModetoRun:
#if DEBUG_ON
			printf("[CommandManagementTask RUNNING]Mode to RUN\r\n");
#endif

			/*
			 * Clear and start simucam timer
			 */
			bDschClrTimer(&xSimucamTimer);
			bDschStartTimer(&xSimucamTimer);

			T_simucam.T_status.simucam_mode = simModeRun;
			break;

		case simModeRun:
#if DEBUG_ON
			printf("[CommandManagementTask RUNNING]Mode RUN\\n");
#endif

#if DEBUG_ON
			printf("[CommandManagementTask RUNNING]Waiting command...\r\n");
#endif
			/*
			 * start simucam timer counting
			 */
			bDschRunTimer(&xSimucamTimer);

			p_payload = OSQPend(p_simucam_command_q, 0, &error_code);
			/*
			 * SYNC cmd
			 */
			if (p_payload->type == 106) {

				bSyncCtrOneShot();

				v_ack_creator(p_payload, ACK_OK);
#if DEBUG_ON
				printf("[CommandManagementTask]Starting timer\r\n");
#endif
			} else {

				switch (p_payload->type) {

				case simDMA1Sched:
#if DEBUG_ON
					printf("[CommandManagementTask]DMA1 Sched\r\n");
#endif
					if (T_simucam.T_status.has_dma_1 == true) {
#if DEBUG_ON
						printf("[CommandManagementTask]Has DMA1\r\n");
#endif
						i_channel_buffer = (INT32U) OSQPend(DMA_sched_queue[0],
								1, &error_code);
						if (error_code == OS_ERR_NONE) {
							sub_config_send[i_channel_buffer].mode =
									subAccessDMA1;
							error_code = (INT8U) OSQPost(
									p_sub_unit_config_queue[i_channel_buffer],
									&(sub_config_send[i_channel_buffer]));
							alt_SSSErrorHandler(error_code, 0);
							T_simucam.T_status.has_dma_1 = false;
						} else {
							alt_uCOSIIErrorHandler(error_code, 0);
						}
						alt_uCOSIIErrorHandler(error_code, 0);
					}
					break;

				case simDMA1Back:
					T_simucam.T_status.has_dma_1 = true;
					i_channel_buffer = (INT32U) OSQPend(DMA_sched_queue[0], 1,
							&error_code);
					if (error_code == OS_ERR_NONE) {
						sub_config_send[i_channel_buffer].mode = subAccessDMA1;
						error_code = (INT8U) OSQPost(
								p_sub_unit_config_queue[i_channel_buffer],
								&(sub_config_send[i_channel_buffer]));
						alt_SSSErrorHandler(error_code, 0);
						T_simucam.T_status.has_dma_1 = false;
					} else {
						alt_uCOSIIErrorHandler(error_code, 0);
					}
					alt_uCOSIIErrorHandler(error_code, 0);
					break;

					/*
					 * TODO Verif DMA2 functions
					 */
				case simDMA2Sched:
#if DEBUG_ON
					printf("[CommandManagementTask]DMA2 Sched\r\n");
#endif
					if (T_simucam.T_status.has_dma_2 == true) {
#if DEBUG_ON
						printf("[CommandManagementTask]Has DMA2\r\n");
#endif
						i_channel_buffer = (INT32U) OSQPend(DMA_sched_queue[1],
								1, &error_code);
						if (error_code == OS_ERR_NONE) {
							sub_config_send[i_channel_buffer].mode =
									subAccessDMA2;
							error_code = (INT8U) OSQPost(
									p_sub_unit_config_queue[i_channel_buffer],
									&(sub_config_send[i_channel_buffer]));
							alt_SSSErrorHandler(error_code, 0);
							T_simucam.T_status.has_dma_2 = false;
						} else {
							alt_uCOSIIErrorHandler(error_code, 0);
						}
						alt_uCOSIIErrorHandler(error_code, 0);
					}
					break;

				case simDMA2Back:
					T_simucam.T_status.has_dma_2 = true;
					i_channel_buffer = (INT32U) OSQPend(DMA_sched_queue[1], 1,
							&error_code);
					if (error_code == OS_ERR_NONE) {
						sub_config_send[i_channel_buffer].mode = subAccessDMA2;
						error_code = (INT8U) OSQPost(
								p_sub_unit_config_queue[i_channel_buffer],
								&(sub_config_send[i_channel_buffer]));
						alt_SSSErrorHandler(error_code, 0);
						T_simucam.T_status.has_dma_2 = false;
					} else {
						alt_uCOSIIErrorHandler(error_code, 0);
					}
					alt_uCOSIIErrorHandler(error_code, 0);
					break;

					/*
					 * Change Simucam Mode
					 */
				case 105:

#if DEBUG_ON
					printf("[CommandManagementTask]MEB status to: %i\r\n",
							(INT8U) p_payload->data[0]);
#endif

					if (p_payload->data[0] == 0) {
						T_simucam.T_status.simucam_running_time = 1;
						T_simucam.T_status.simucam_mode = simModetoConfig;

#if DEBUG_ON
						printf(
								"[CommandManagementTask]Sending change mode command...\r\n");
#endif

						/*
						 * Stop Simucam Timer
						 */
						bDschStopTimer(&xSimucamTimer);

						/*
						 * Stop and clear ChA timer
						 */
						for (i_channel_for = 0; i_channel_for < NB_CHANNELS;
								i_channel_for++) {

							bDschStopTimer(
									&(xCh[i_channel_for].xDataScheduler));
							bDschClrTimer(&(xCh[i_channel_for].xDataScheduler));
							sub_config_send[i_channel_for].mode = subChangeMode;
							error_code = OSQPost(
									p_sub_unit_config_queue[i_channel_for],
									&sub_config_send[i_channel_for]);
						}
					}

					v_ack_creator(p_payload, ACK_OK);
					break;

					/*
					 * Abort Sending
					 */
				case 107:
#if DEBUG_ON
					printf("[CommandManagementTask]Selected command: %i\n\r",
							(int) p_payload->type);
#endif

					for (i_channel_for = 0; i_channel_for < NB_CHANNELS;
							i_channel_for++) {

						T_simucam.T_Sub[i_channel_for].T_conf.b_abort = true;
						sub_config_send[i_channel_for].mode = subAbort;
						error_code = OSQPost(
								p_sub_unit_config_queue[i_channel_for],
								&sub_config_send[i_channel_for]);
					}

					v_ack_creator(p_payload, ACK_OK);
					break;

					/*
					 * Direct send
					 */
				case 109:
#if DEBUG_ON
					printf("[CommandManagementTask]Direct Send to %c\n\r",
							(char) (p_payload->data[0] + ASCII_A));
#endif
					/*
					 * Direct Send needs replaning
					 */

					break;

					/*
					 * Get HK
					 */
				case 110:
#if DEBUG_ON
					printf("[CommandManagementTask]Get HK\r\n");
#endif
					v_HK_creator(p_payload, p_payload->data[0]);
					break;

				default:
#if DEBUG_ON
					printf(
							"[CommandManagementTask]Nenhum comando aceito em modo running\n\r");
#endif
					if (p_payload->type == 101 || p_payload->type == 102
							|| p_payload->type == 103 || p_payload->type == 104
							|| p_payload->type == 108
							|| p_payload->type == 111) {
						v_ack_creator(p_payload, COMMAND_NOT_ACCEPTED);
					} else {
						v_ack_creator(p_payload, COMMAND_NOT_FOUND);
					}
					break;

				}

			}

			break;

		default:
#if DEBUG_ON
			printf("[CommandManagementTask]MEB status error\n\r");
#endif
			break;
		}
	}
}
