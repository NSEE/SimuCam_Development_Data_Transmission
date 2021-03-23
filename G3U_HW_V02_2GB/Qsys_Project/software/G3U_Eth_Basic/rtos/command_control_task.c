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

INT8U exec_error;

INT16U i_id_accum = 1;

int abort_flag = 1;
int i_return_config_flag = 2;

/*
 * Simucam Global Values
 */

T_Simucam T_simucam;

TDschChannel xSimucamTimer;	// It's a general timer used in echo and HK

/**
 * @name v_ack_creator
 * @brief External Comm ACK generator
 * @ingroup UTIL
 *
 * @param 	[in] 	T_uart_payload* payload Struct
 * @param 	[in] 	INT8U error_code
 * @retval  void
 **/
void v_ack_creator(T_uart_payload* p_error_response, INT8U error_code) {

	INT16U nb_id = T_simucam.T_status.TM_id;
	INT16U nb_id_pkt = p_error_response->packet_id;
	INT8U ack_buffer[64];
	INT32U ack_size = 14;
	INT16U usCRC = 0;

	/* memset buffer */
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
	fprintf(fp, "[ACK CREATOR] Entered ack creator.\r\n");
}
#endif
	ack_buffer[0] = 2;

	/*
	 * Id to bytes
	 */
	ack_buffer[2] = div(nb_id, 256).rem;
	nb_id = div(nb_id, 256).quot;
	ack_buffer[1] = div(nb_id, 256).rem;

	ack_buffer[3] = typeAckExt;
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

	ack_buffer[10] = p_error_response->type;
	ack_buffer[11] = error_code;

	/**
	 * Calculate and add CRC
	 */
	usCRC = crc__CRC16CCITT(ack_buffer, 12);

	ack_buffer[13] = div(usCRC, 256).rem;
	usCRC = div(usCRC, 256).quot;
	ack_buffer[12] = div(usCRC, 256).rem;

//	vUartWriteBuffer(ack_buffer, ack_size);
	for (int f = 0; f < ack_size; f++) {
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
		fprintf(fp, "%c", ack_buffer[f]);
}
#endif
		vUartWriteCharBlocking(ack_buffer[f]);
	}

	T_simucam.T_status.TM_id++;
}

/**
 * @name v_ack_int
 * @brief Internal Comm ACK generator
 * @ingroup UTIL
 *
 * @param 	[in] 	T_uart_payload* payload Struct
 * @param 	[in] 	INT8U error_code
 * 
 * @retval void
 **/
void v_ack_int(T_uart_payload* p_error_response, INT8U error_code) {

	INT16U nb_id = T_simucam.T_status.TM_id;
	INT16U nb_id_pkt = p_error_response->packet_id;
	INT8U ack_buffer[64];
	INT32U ack_size = 14;
	INT16U usCRC = 0;

	/* memset buffer */
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
	fprintf(fp, "[ACK CREATOR] Entered ack creator.\r\n");
}
#endif
	ack_buffer[0] = 4;

	/*
	 * Id to bytes
	 */
	ack_buffer[2] = div(nb_id, 256).rem;
	nb_id = div(nb_id, 256).quot;
	ack_buffer[1] = div(nb_id, 256).rem;

	ack_buffer[3] = typeAckInt;
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

	ack_buffer[10] = p_error_response->type;
	ack_buffer[11] = error_code;

	/**
	 * Calculate and add CRC
	 */
	usCRC = crc__CRC16CCITT(ack_buffer, 12);

	ack_buffer[13] = div(usCRC, 256).rem;
	usCRC = div(usCRC, 256).quot;
	ack_buffer[12] = div(usCRC, 256).rem;

	for (int f = 0; f < ack_size; f++) {
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
		fprintf(fp, "%c", ack_buffer[f]);
}
#endif
		vUartWriteCharBlocking(ack_buffer[f]);
	}

	T_simucam.T_status.TM_id++;
}

/**
 * @name v_HK_creator
 * @brief HK generator
 * @ingroup UTIL
 *
 * @param 	[in] 	INT8U Channel
 * 
 * @retval void
 **/
void v_HK_creator(INT8U i_channel) {

	INT8U chann_buff = i_channel;
	INT16U usCRC;
	INT16U nb_id = T_simucam.T_status.TM_id;
	INT16U nb_counter_total = T_simucam.T_status.simucam_total_imagettes_sent;
	INT16U nb_counter_current = T_simucam.T_Sub[chann_buff].T_conf.i_imagette_control;
	INT16U imagettes_to_send = T_simucam.T_Sub[chann_buff].T_data.nb_of_imagettes;
	INT8U hk_buffer[HK_SIZE];
//	bool b_link_enabled = false;

#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
	fprintf(fp, "[HK CREATOR] Entered hk creator for channel %i.\r\n", (INT8U) chann_buff);
}
#endif

	/*
	 * Update SpW status flags
	 */
	bSpwcGetLinkStatus(&(xCh[chann_buff].xSpacewire));
	bSpwcGetLinkError(&(xCh[chann_buff].xSpacewire));

//	if (T_simucam.T_Sub[i_channel].T_conf.mode == subModeRun) {
//		b_link_enabled = true;
//	} else {
//		b_link_enabled = false;
//	}

	hk_buffer[0] = 2;

	/*
	 * Id to bytes
	 */
	hk_buffer[2] = div(nb_id, 256).rem;
	nb_id = div(nb_id, 256).quot;
	hk_buffer[1] = div(nb_id, 256).rem;

	hk_buffer[3] = typeHK;
	hk_buffer[4] = 0;
	hk_buffer[5] = 0;
	hk_buffer[6] = 0;
	hk_buffer[7] = HK_SIZE;
	hk_buffer[8] = chann_buff; /**channel*/
	hk_buffer[9] = T_simucam.T_status.simucam_mode; /**meb mode*/
	hk_buffer[10] = T_simucam.T_Sub[i_channel].T_conf.linkstatus_running; /**Sub_config_enabled*/
	hk_buffer[11] = T_simucam.T_Sub[i_channel].T_conf.link_config; /**sub_config_linkstatus*/
	hk_buffer[12] = T_simucam.T_Sub[i_channel].T_conf.linkspeed; /**sub_config_linkspeed*/
	hk_buffer[13] = xCh[chann_buff].xSpacewire.xSpwcLinkStatus.bRunning;
	hk_buffer[14] = T_simucam.T_Sub[i_channel].T_conf.linkstatus_running; /**link enabled*/
	hk_buffer[15] = T_simucam.T_Sub[i_channel].T_conf.sub_status_sending;
	hk_buffer[16] = T_simucam.T_Sub[i_channel].T_sub_status.usi_disconnect_err_cnt;
	hk_buffer[17] = T_simucam.T_Sub[i_channel].T_sub_status.usi_parity_err_cnt;
	hk_buffer[18] = T_simucam.T_Sub[i_channel].T_sub_status.usi_escape_err_cnt;
	hk_buffer[19] = T_simucam.T_Sub[i_channel].T_sub_status.usi_credit_err_cnt;

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
	hk_buffer[27] = div(imagettes_to_send, 256).rem;
	imagettes_to_send = div(imagettes_to_send, 256).quot;
	hk_buffer[26] = div(imagettes_to_send, 256).rem;

	/**
	 * Calculating CRC
	 */
	usCRC = crc__CRC16CCITT(hk_buffer, HK_SIZE - 2);

	hk_buffer[29] = div(usCRC, 256).rem;
	usCRC = div(usCRC, 256).quot;
	hk_buffer[28] = div(usCRC, 256).rem;

	/*
	 * Send HK through serial
	 */
	for (int f = 0; f < HK_SIZE; f++) {
//		fprintf(fp, "%c", hk_buffer[f]);
		vUartWriteCharBlocking(hk_buffer[f]);
	}

	T_simucam.T_status.TM_id++;

}

/**
 * @name v_p_event_creator
 * @brief External Comm ACK generator
 * @ingroup UTIL
 *
 * @param 	[in] 	INT8U EID Code
 * @retval  void
 **/
void v_p_event_creator(INT8U usi_eid) {

	INT16U nb_id = T_simucam.T_status.TM_id;
	INT8U ack_buffer[32];
	INT16U usCRC = 0;

	/* memset buffer */
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
	fprintf(fp, "[ACK CREATOR] Entered ack creator.\r\n");
}
#endif
	ack_buffer[0] = 2;

	/*
	 * Id to bytes
	 */
	ack_buffer[2] = div(nb_id, 256).rem;
	nb_id = div(nb_id, 256).quot;
	ack_buffer[1] = div(nb_id, 256).rem;

	ack_buffer[3] = typeProgEvent;
	ack_buffer[4] = 0;
	ack_buffer[5] = 0;
	ack_buffer[6] = 0;
	ack_buffer[7] = P_EVENT_SIZE;

	ack_buffer[8] = usi_eid;

	/**
	 * Calculate and add CRC
	 */
	usCRC = crc__CRC16CCITT(ack_buffer, P_EVENT_SIZE-2);

	ack_buffer[10] = div(usCRC, 256).rem;
	usCRC = div(usCRC, 256).quot;
	ack_buffer[9] = div(usCRC, 256).rem;

	for (int f = 0; f < P_EVENT_SIZE; f++) {
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
		fprintf(fp, "%c", ack_buffer[f]);
}
#endif
		vUartWriteCharBlocking(ack_buffer[f]);
	}

	T_simucam.T_status.TM_id++;
}

/**
 * @name v_p_event_creator
 * @brief External Comm ACK generator
 * @ingroup UTIL
 *
 * @param 	[in] 	INT8U EID Code
 * @retval  void
 **/
void v_p_event_timecode_creator(INT8U usi_timecode, INT8U usi_channel) {

	INT16U nb_id = T_simucam.T_status.TM_id;
	INT8U ack_buffer[32];
	INT16U usCRC = 0;

	/* memset buffer */
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
	fprintf(fp, "[ACK CREATOR] Entered ack creator.\r\n");
}
#endif
	ack_buffer[0] = 2;

	/*
	 * Id to bytes
	 */
	ack_buffer[2] = div(nb_id, 256).rem;
	nb_id = div(nb_id, 256).quot;
	ack_buffer[1] = div(nb_id, 256).rem;

	ack_buffer[3] = typeErrorEvent;
	ack_buffer[4] = 0;
	ack_buffer[5] = 0;
	ack_buffer[6] = 0;
	ack_buffer[7] = TIMECODE_EVENT_SIZE;

	ack_buffer[8] = usi_timecode;
	ack_buffer[9] = usi_channel;

	/**
	 * Calculate and add CRC
	 */
	usCRC = crc__CRC16CCITT(ack_buffer, TIMECODE_EVENT_SIZE-2);

	ack_buffer[11] = div(usCRC, 256).rem;
	usCRC = div(usCRC, 256).quot;
	ack_buffer[10] = div(usCRC, 256).rem;

	for (int f = 0; f < TIMECODE_EVENT_SIZE; f++) {
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
		fprintf(fp, "%c", ack_buffer[f]);
}
#endif
		vUartWriteCharBlocking(ack_buffer[f]);
	}

	T_simucam.T_status.TM_id++;
}

/**
 * @name v_p_event_creator
 * @brief External Comm ACK generator
 * @ingroup UTIL
 *
 * @param 	[in] 	INT8U EID Code
 * @retval  void
 **/
void v_error_event_creator(INT8U usi_eid, INT8U usi_data) {

	INT16U nb_id = T_simucam.T_status.TM_id;
	INT8U ack_buffer[32];
	INT16U usCRC = 0;

	/* memset buffer */
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
	fprintf(fp, "[ACK CREATOR] Entered ack creator.\r\n");
}
#endif
	ack_buffer[0] = 2;

	/*
	 * Id to bytes
	 */
	ack_buffer[2] = div(nb_id, 256).rem;
	nb_id = div(nb_id, 256).quot;
	ack_buffer[1] = div(nb_id, 256).rem;

	ack_buffer[3] = typeErrorEvent;
	ack_buffer[4] = 0;
	ack_buffer[5] = 0;
	ack_buffer[6] = 0;
	ack_buffer[7] = ERROR_EVENT_SIZE;

	ack_buffer[8] = usi_eid;
	ack_buffer[9] = usi_data;

	/**
	 * Calculate and add CRC
	 */
	usCRC = crc__CRC16CCITT(ack_buffer, ERROR_EVENT_SIZE-2);

	ack_buffer[11] = div(usCRC, 256).rem;
	usCRC = div(usCRC, 256).quot;
	ack_buffer[10] = div(usCRC, 256).rem;

//	vUartWriteBuffer(ack_buffer, ERROR_EVENT_SIZE);
	for (int f = 0; f < ERROR_EVENT_SIZE; f++) {
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
		fprintf(fp, "%c", ack_buffer[f]);
}
#endif
		vUartWriteCharBlocking(ack_buffer[f]);
	}

	T_simucam.T_status.TM_id++;
}

/**
 * @name vSendETHConfig
 * @brief Send the SD Card eth conf to NUC
 * @ingroup UTIL
 *
 * @param 	[in] 	TConfEth xEthConf
 * @retval          void
 **/
void vSendETHConfig(TConfEth xEthConf) {
	INT8U iETHBuffer[32];
	INT16U nb_id = T_simucam.T_status.TM_id;
	INT16U usCRC;
	INT16U portNb = xEthConf.siPort;

	/* Header */
	iETHBuffer[0] = 4;

	/*
	 * Id to bytes
	 */
	iETHBuffer[2] = div(nb_id, 256).rem;
	nb_id = div(nb_id, 256).quot;
	iETHBuffer[1] = div(nb_id, 256).rem;

	iETHBuffer[3] = typeStaticIp;

	/* Length */
	iETHBuffer[4] = 0;
	iETHBuffer[5] = 0;
	iETHBuffer[6] = 0;
	iETHBuffer[7] = IP_CONFIG_SIZE;

	iETHBuffer[8] = xEthConf.bDHCP;
	iETHBuffer[10] = div(portNb, 256).rem;
	portNb = div(portNb, 256).quot;
	iETHBuffer[9] = div(portNb, 256).rem;

#if DEBUG_ON
	if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
		fprintf(fp, "SDCard IP:");
	}
#endif

	for (INT8U h = 0; h < 4; h++) {
		iETHBuffer[11 + h] = xEthConf.ucIP[h];
		iETHBuffer[15 + h] = xEthConf.ucGTW[h];
		iETHBuffer[19 + h] = xEthConf.ucSubNet[h];
#if DEBUG_ON
		if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
			fprintf(fp, " %i", xEthConf.ucIP[h]);
		}
#endif
	}
#if DEBUG_ON
	if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
		fprintf(fp, "\r\n");
	}
#endif

	for (INT8U f = 0; f < 6; f++) {
		iETHBuffer[23 + f] = xEthConf.ucMAC[f];
	}
	iETHBuffer[29] = T_simucam.T_conf.usiDebugLevels;
	usCRC = crc__CRC16CCITT(iETHBuffer, IP_CONFIG_SIZE - 2);

	iETHBuffer[IP_CONFIG_SIZE - 1] = div(usCRC, 256).rem;
	usCRC = div(usCRC, 256).quot;
	iETHBuffer[IP_CONFIG_SIZE - 2] = div(usCRC, 256).rem;

	/*
	 * Send Eth Config through serial
	 */
#if DEBUG_ON
	if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
		fprintf(fp, "alive cmd:");
	}
#endif
	for (int f = 0; f < IP_CONFIG_SIZE; f++) {
#if DEBUG_ON
	if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
		fprintf(fp, " %i", iETHBuffer[f]);
	}
#endif
		vUartWriteCharBlocking(iETHBuffer[f]);
	}
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
	fprintf(fp, "\r\n");
}
#endif
	T_simucam.T_status.TM_id++;
}

/**
 * @name vClearRam
 * @brief Clears the RAM
 * @ingroup UTIL
 *
 * @param 	[in] 	void
 * @retval          void
 **/
//void vClearRam(void) {
//	for (INT8U s = 0; s < NB_CHANNELS; s++) {
//		/*
//		 * Switch to the right memory stick
//		 */
//		if (((unsigned char) s / 4) == 0) {
//			bDdr2SwitchMemory(DDR2_M1_ID);
//		} else {
//			bDdr2SwitchMemory(DDR2_M2_ID);
//		}
//		memset((INT32U *) T_simucam.T_Sub[s].T_data.addr_init, 0, (0x20000000 - 1));
//	}
//}
void vClearRam(void) {

	const alt_u32 uliMemData[8] = {
			0x00000000, 0x00000000, 0x00000000, 0x00000000,
			0x00000000, 0x00000000, 0x00000000, 0x00000000
	};

	bMfilSetWrData(uliMemData);

	for (INT8U s = 0; s < NB_CHANNELS; s++) {

		bMfilResetDma(TRUE);

		/*
		 * Switch to the right memory stick
		 */
		if (((unsigned char) s / 4) == 0) {
			if (bMfilDmaTransfer(eDdr2Memory1, (INT32U *) T_simucam.T_Sub[s].T_data.addr_init, 0x20000000)) {
				while ( ( TRUE == bMfilGetWrBusy() ) && ( FALSE == bMfilGetWrTimeoutErr() ) ) {
					usleep(100);
				}
			}
		} else {
			if (bMfilDmaTransfer(eDdr2Memory2, (INT32U *) T_simucam.T_Sub[s].T_data.addr_init, 0x20000000)) {
				while ( ( TRUE == bMfilGetWrBusy() ) && ( FALSE == bMfilGetWrTimeoutErr() ) ) {
					usleep(100);
				}
			}
		}

	}
}

void vResetSimucam() {
	INT8U iResetCmd[8];
	iResetCmd[0] = 255;
	iResetCmd[1] = 255;
	iResetCmd[2] = 255;
	iResetCmd[3] = 255;
	iResetCmd[4] = 255;
	iResetCmd[5] = 255;
	iResetCmd[6] = 255;
	iResetCmd[7] = 255;

	for (int f = 0; f < 8; f++) {
		vUartWriteCharBlocking(iResetCmd[f]);
	}

	vRstcHoldSimucamReset(0);
}

/**
 * @name iCompareTags
 * @brief Clears the RAM
 * @ingroup UTIL
 *
 * @param 	[in] 	void
 * @retval          void
 **/
INT8U iCompareTags(INT8U iTagA[], INT8U iTagB[]) {
	INT8U iRetVal = 1;
	for (INT8U i = 0; i < 8; i++) {
		if (iTagA[i] != iTagB[i]) {
			iRetVal = 0;
			break;
		}
	}
	return iRetVal;
}

/**
 * @name vClearRam
 * @brief Clears the RAM
 * @ingroup UTIL
 *
 * @param 	[in] 	void
 * @retval          void
 **/
void vDataSelector(T_uart_payload* pPayload){

	/* NOT IMPLEMENTED */
    // for (INT8U i = 0; i < NB_CHANNELS; i++)
    // {
    // 	if(iCompareTags((INT8U *) ((INT32U) pPayload->data[10]), T_simucam.T_Sub[i].T_data.tag) == 1){

    //     }
    // }
}

/**
 * @name i_clear_echo
 * @brief Clears the Echo queue
 *
 * @param 	[in] 	void
 * @retval          INT8U error code
 **/
INT8U i_clear_echo(){
#if DEBUG_ON
	if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
	fprintf(fp, "[CommandManagementTask]Clearing Echo Queue.\r\n");
	}
#endif

	T_simucam.T_conf.echo_sent = 0;
	return OSQFlush(p_echo_queue);
}

/*
 * Task body
 */

void CommandManagementTask() {

	INT8U error_code; /*uCOS error code*/

	INT8U i_channel_for;

	T_uart_payload payload_command;

	T_uart_payload *p_payload = &payload_command;

	INT8U i_channel_buffer = 0;

#if DEBUG_ON
	if (T_simucam.T_conf.usiDebugLevels <= xMajor) {
	fprintf(fp, "[CommandManagementTask]Task init\r\n");
	}
#endif
	T_simucam.T_conf.usiDebugLevels = xConfDebug.usiDebugLevel;
	/*
	 * Initialize DMA
	 */
//	bIdmaInitM1Dma();
//	bIdmaInitM2Dma();
	/* Init HK period */
	T_simucam.T_conf.luHKPeriod = 0;

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

//	struct x_telemetry x_telemetry_buffer;

	/*
	 * Init and config of sync functionality
	 */
	bSyncConfigOstSubunits(SYNC_DEFAULT_SUBUNIT_OST);

	T_simucam.T_status.simucam_mode = simModeInit;

	/* Address */
	xSimucamTimer.xDschDevAddr.uliDschBaseAddr = (alt_u32) DUMB_COMMUNICATION_MODULE_V2_TIMER_BASE;
	/* Init Simucam Timer */
	bDschGetTimerControl(&xSimucamTimer);
	bDschGetTimerConfig(&xSimucamTimer);
	bDschGetTimerStatus(&xSimucamTimer);
	/* Config Simucam timer */
	xSimucamTimer.xDschTimerConfig.uliStartTime = 0;
	xSimucamTimer.xDschTimerConfig.bRunOnSync = FALSE;
	xSimucamTimer.xDschTimerConfig.uliClockDiv = TIMER_CLOCK_DIV_1MS;
	bDschSetTimerConfig(&xSimucamTimer);

	while (1) {

		switch (T_simucam.T_status.simucam_mode) {

		/*
		 * Initializing the system
		 */
		case simModeInit:
#if DEBUG_ON
			if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
				fprintf(fp, "[CommandManagementTask]Init\r\n");
			}
#endif

			/*
			 * Configuring done inside the sub-unit modules
			 * TODO Function
			 */
			for (i_channel_for = 0; i_channel_for < NB_CHANNELS; i_channel_for++) {
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
			if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
				fprintf(fp, "[CommandManagementTask]Mode: toConfig\r\n");
			}
#endif
			/* Disable the Isolation and LVDS driver boards*/
			bDisableIsoDrivers();
			bDisableLvdsBoard();

			T_simucam.T_status.simucam_mode = simModeConfig;
			v_p_event_creator(eidMebConfig);
			break;

			/*
			 * Config mode
			 */
		case simModeConfig:
#if DEBUG_ON
			if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
				fprintf(fp, "[CommandManagementTask]Mode: Config\r\n");
			}
#endif
			p_payload = OSQPend(p_simucam_command_q, 0, &error_code);
			alt_uCOSIIErrorHandler(error_code, 0);

			switch (p_payload->type) { /*Selector for commands and actions*/

			/**
			 * Send Ethernet config to NUC when it is booted
			 */
			case typeGetIP:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[CommandManagementTask]NUC alive, sending Eth conf\r\n");
				}
#endif
				/* Send ETH settings to NUC, no ACK expected */
				vSendETHConfig(xConfEth);
				break;

				/*
				 * Sub-Unit config command
				 */
			case typeConfigureSub:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[CommandManagementTask]Configure Sub-Unit\r\n");
				}
#endif

				/*
				 * data[0] is the channel input
				 */
				sub_config_send[p_payload->data[0]].link_config = p_payload->data[1];
				sub_config_send[p_payload->data[0]].linkspeed = p_payload->data[2];
				sub_config_send[p_payload->data[0]].linkstatus_running = p_payload->data[3];

#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[CommandManagementTask]Configurations sent: %i, %i, %i\r\n", (INT8U) sub_config_send[p_payload->data[0]].link_config,
							(INT8U) sub_config_send[p_payload->data[0]].linkspeed, (INT8U) sub_config_send[p_payload->data[0]].linkstatus_running);
				}
#endif

				v_ack_creator(p_payload, xExecOk);

				break;

				/*
				 * Change Simucam Modes
				 * char: i
				 */
			case typeChangeSimucamMode:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[CommandManagementTask]Change Mode\r\n");
				}
#endif

				if (p_payload->data[0] == 1) {

					for (i_channel_for = 0; i_channel_for < NB_CHANNELS; i_channel_for++) {

						sub_config_send[i_channel_for].mode = subModetoRun;
						error_code = (INT8U) OSQPost(p_sub_unit_config_queue[i_channel_for], &sub_config_send[i_channel_for]);
						alt_SSSErrorHandler(error_code, 0);
					}
					T_simucam.T_status.simucam_mode = simModetoRun;
#if DEBUG_ON
					if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
						fprintf(fp, "[CommandManagementTask]Config sent to sub\n\r");
					}
#endif
				}
				if (p_payload->data[0] == 0) {
					v_ack_creator(p_payload, xExecOk);
				}

				break;

				/*
				 * Clear RAM
				 */
			case typeClearRam:
				if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[CommandManagementTask]Clear Ram\n\r");
				}
				TSimStates x_prev_mode = T_simucam.T_status.simucam_mode;
				T_simucam.T_status.simucam_mode = simClearMem;
				i_clear_echo();
				vClearRam();
				v_ack_creator(p_payload, xExecOk);
				T_simucam.T_status.simucam_mode = x_prev_mode;
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[CommandManagementTask]Clear RAM\r\n");
				}
#endif

				v_p_event_creator(eidClrRam);
				break;

				/*
				 * Get HK
				 */
			case typeGetHK:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[CommandManagementTask]Get HK\r\n");
				}
#endif
				i_channel_buffer = p_payload->data[0];

				v_ack_creator(p_payload, xExecOk);
				v_HK_creator(i_channel_buffer);
				break;

				/*
				 * Config MEB
				 */
			case typeConfigureMeb:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[CommandManagementTask]Config MEB\r\n");
				}
#endif

				T_simucam.T_conf.i_forward_data = p_payload->data[0];
				if (T_simucam.T_conf.echo_sent != p_payload->data[1]){
					i_clear_echo();
				}
				T_simucam.T_conf.echo_sent = p_payload->data[1];

				v_ack_creator(p_payload, xExecOk);
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[CommandManagementTask]Meb configs: fwd: %i, echo: %i\r\n", (int) T_simucam.T_conf.i_forward_data, (int) T_simucam.T_conf.echo_sent);
				}
#endif
				break;

				/*
				 * Set Recording
				 */
// 			case typeSetRecording:
// #if DEBUG_ON
// 				if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
// 					fprintf(fp, "[CommandManagementTask]Set Recording\n\r");
// 				}
// #endif
// 				T_simucam.T_conf.iLog = p_payload->data[0];
// 				v_ack_creator(p_payload, xExecOk);
// 				break;

				/**
				 * Periodic HK
				 */
			case typeSetPeriodicHK:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[CommandManagementTask]Set Periodic HK\n\r");
				}
#endif
				T_simucam.T_conf.iPeriodicHK = p_payload->data[0];

				if (T_simucam.T_conf.iPeriodicHK) {
					if(T_simucam.T_conf.luHKPeriod != 0){
						error_code = OSTaskSuspend(PERIODIC_HK_TASK_PRIORITY);
					}
					T_simucam.T_conf.luHKPeriod = p_payload->data[4] + 256 * p_payload->data[3] + 65536 * p_payload->data[2] + 4294967296 * p_payload->data[1];

					error_code = OSTaskResume(PERIODIC_HK_TASK_PRIORITY);
				} else {
					error_code = OSTaskSuspend(PERIODIC_HK_TASK_PRIORITY);
					T_simucam.T_conf.luHKPeriod = 0;
				}
				if (error_code == OS_NO_ERR) {
					v_ack_creator(p_payload, xExecOk);
				} else {
					v_ack_creator(p_payload, xOSError);
				}

				break;

			case typeReset:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[CommandManagementTask]Ethernet Reset\n\r");
				}
#endif
				// ACK in NUC
				vResetSimucam();
            break;

			/* Eth Disconnect */
			case typeDisc:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[CommandManagementTask]Ethernet Disconnect\n\r");
				}
#endif
				error_code = OSTaskSuspend(PERIODIC_HK_TASK_PRIORITY);
				T_simucam.T_conf.luHKPeriod = 0;
				T_simucam.T_conf.i_forward_data = 0;
				T_simucam.T_conf.echo_sent = 0;
			break;
			
			case typeSetProgressEvent: //TODO Set on NUC
#if DEBUG_ON
			if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
				fprintf(fp, "[CommandManagementTask]Set Progress Eventst\n\r");
			}
#endif
				T_simucam.T_conf.usiProgressEvent = p_payload->data[0];
				v_ack_creator(p_payload, xExecOk);
			break;

			case typeEnableEchoing:
				bRmapGetEchoingMode(&xCh[p_payload->data[0]].xRmap);
				xCh[p_payload->data[0]].xRmap.xRmapEchoingModeConfig.bRmapEchoingModeEn = p_payload->data[1];
				xCh[p_payload->data[0]].xRmap.xRmapEchoingModeConfig.bRmapEchoingIdEn = p_payload->data[2];
				bRmapSetEchoingMode(&xCh[p_payload->data[0]].xRmap);
				v_ack_creator(p_payload, xExecOk);
				if(p_payload->data[1])
					v_p_event_creator(eidEchEn+p_payload->data[0]);
				else
					v_p_event_creator(eidEchDis+p_payload->data[0]);
			break;

			default:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xMajor) {
					fprintf(fp, "[CommandManagementTask]Command not identified...\n\r");
				}
#endif
				if (p_payload->type == typeStartSending || p_payload->type == typeAbortSending || p_payload->type == typeDirectSend) {
					v_ack_creator(p_payload, xCommandNotAccepted);
				} else {
					v_ack_creator(p_payload, xCommandNotFound);
				}

				break;

			}
			break;

		case simModetoRun:
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
			fprintf(fp, "[CommandManagementTask RUNNING]Mode to RUN\r\n");
}
#endif
			/* Enable the Isolation and LVDS driver boards*/
			bEnableIsoDrivers();
			bEnableLvdsBoard();

			/*
			 * Clear and start simucam timer, NOT RUNNING
			 */
			bDschClrTimer(&xSimucamTimer);
			bDschStartTimer(&xSimucamTimer);

			T_simucam.T_status.simucam_mode = simModeRun;
			v_ack_creator(p_payload, xExecOk);
			v_p_event_creator(eidMebRun);	
			break;

		case simModeRun:
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xMajor) {
			fprintf(fp, "[CommandManagementTask RUNNING]Mode RUN\r\n");
}
#endif

#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
			fprintf(fp, "[CommandManagementTask RUNNING]Waiting command...\r\n");
}
#endif
			/*
			 * Start simucam timer counting
			 */
			error_code = bDschRunTimer(&xSimucamTimer);
			if (error_code != TRUE){
				v_ack_creator(p_payload, xTimerError);
				// TODO Change to progress?
			}
			// if (error_code == TRUE) {
			// 	v_ack_creator(p_payload, xExecOk);
			// } else {
			// 	v_ack_creator(p_payload, xTimerError);
			// }

			p_payload = OSQPend(p_simucam_command_q, 0, &error_code);

			/*
			 * SYNC cmd
			 */
			if (p_payload->type == typeStartSending) {
				
					/*
					* Stop and clear channel timers
					*/
				for (i_channel_for = 0; i_channel_for < NB_CHANNELS; i_channel_for++) {
					if (T_simucam.T_Sub[i_channel_for].T_conf.mode > subModeConfig) {
						bDschGetIrqControl(&(xCh[i_channel_for].xDataScheduler));
						xCh[i_channel_for].xDataScheduler.xDschIrqControl.bTxBeginEn = TRUE;
						xCh[i_channel_for].xDataScheduler.xDschIrqControl.bTxEndEn = TRUE;
						bDschSetIrqControl(&(xCh[i_channel_for].xDataScheduler));
					}
				}

				bSyncCtrOneShot();

				v_ack_creator(p_payload, xExecOk);
				v_p_event_creator(eidSyncRcv);
				/*
				 * TODO Start HK timer if needed
				 */
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
				fprintf(fp, "[CommandManagementTask]Starting timer\r\n");
}
#endif
			} else {

				switch (p_payload->type) {

				/*
				 * Change Simucam Mode
				 */
				case typeChangeSimucamMode:

#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[CommandManagementTask]MEB status to: %i\r\n", (INT8U) p_payload->data[0]);
}
#endif

					if (p_payload->data[0] == 0) {
						T_simucam.T_status.simucam_running_time = 1;
						T_simucam.T_status.simucam_mode = simModetoConfig;

#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
						fprintf(fp, "[CommandManagementTask]Sending change mode command...\r\n");
}
#endif

						/*
						 * Stop Simucam Timer
						 */
						error_code = bDschStopTimer(&xSimucamTimer);
						if (error_code != TRUE) {
							#if DEBUG_ON
							if (T_simucam.T_conf.usiDebugLevels <= xCritical) {
								fprintf(fp, "simucam timer prob \n");
							}
							#endif
							v_ack_creator(p_payload, xTimerError);
							break;
						}
						/*
						 * Stop and clear channel timers
						 */
						for (i_channel_for = 0; i_channel_for < NB_CHANNELS; i_channel_for++) {
							if (T_simucam.T_Sub[i_channel_for].T_conf.mode > subModeConfig) {
								error_code = bDschStopTimer(&(xCh[i_channel_for].xDataScheduler));
								if (error_code != TRUE) {
#if DEBUG_ON
									if (T_simucam.T_conf.usiDebugLevels <= xCritical) {
									fprintf(fp, "problem sub %i\n", i_channel_for);
									}
#endif
									v_ack_creator(p_payload, xTimerError);
									break;
								}
								error_code = bDschClrTimer(&(xCh[i_channel_for].xDataScheduler));
								if (error_code != TRUE) {
#if DEBUG_ON
									if (T_simucam.T_conf.usiDebugLevels <= xCritical) {
									fprintf(fp, "problem sub %i\n", i_channel_for);
									}
#endif
									v_ack_creator(p_payload, xTimerError);
									break;
								}
								sub_config_send[i_channel_for].mode = subChangeMode;
								error_code = OSQPost(p_sub_unit_config_queue[i_channel_for], &sub_config_send[i_channel_for]);
								if (error_code != OS_NO_ERR) {
#if DEBUG_ON
									if (T_simucam.T_conf.usiDebugLevels <= xCritical) {
									fprintf(fp, "problem sub %i\n", i_channel_for);
									}
#endif
									v_ack_creator(p_payload, xOSError);
									break;
								}
							}
						}
						v_ack_creator(p_payload, xExecOk);
					}
					if (p_payload->data[0] == 1) {
						v_ack_creator(p_payload, xExecOk);
					}
					break;

					/*
					 * Abort Sending
					 */
				case typeAbortSending:
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[CommandManagementTask]Selected command: %i\n\r", (int) p_payload->type);
}
#endif

					for (i_channel_for = 0; i_channel_for < NB_CHANNELS; i_channel_for++) {

						T_simucam.T_Sub[i_channel_for].T_conf.b_abort = true;
						sub_config_send[i_channel_for].mode = subAbort;
						error_code = OSQPost(p_sub_unit_config_queue[i_channel_for], &sub_config_send[i_channel_for]);
					}
					if (error_code == OS_NO_ERR) {
						v_ack_creator(p_payload, xExecOk);
					} else {
					 	v_ack_creator(p_payload, xOSError);
					 }
					break;

					/*
					 * Direct send
					 */
				case typeDirectSend:
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[CommandManagementTask]Direct Send to %c\n\r", (char) (p_payload->data[0] + ASCII_A));
}
#endif
					/*
					 * todo: Direct Send needs replaning
					 */
					v_ack_creator(p_payload, xNotImplemented);
					break;

					/*
					 * Get HK
					 */
				case typeGetHK:
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[CommandManagementTask]Get HK\r\n");
}
#endif
					v_ack_creator(p_payload, xExecOk);
					v_HK_creator(p_payload->data[0]);
					break;

				case typeReset:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xVerbose ){
                    fprintf(fp, "[CommandManagementTask]Ethernet Reset\n\r");
                }
#endif
				vResetSimucam(); /* Hold SimuCam Reset Signal */
            	break;

				case typeErrorInjectionSpw:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xVerbose ){
                    fprintf(fp, "[CommandManagementTask]Error Injection\n\r");
                }
#endif
				// Get channel and error type
				switch (p_payload->data[0]){
					
					case spwErrParity:
						// xCh[p_payload->data[1]].xSpacewire
						/* Force the stop of any ongoing SpW Codec Errors */
						bSpwcGetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bStartErrInj = FALSE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bResetErrInj = TRUE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.ucErrInjErrCode = eSpwcSpwCodecErrIdNone;
						bSpwcSetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						/* Wait SpW Codec Errors controller to be ready */
						bSpwcGetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						while (FALSE == xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bErrInjReady) {
							bSpwcGetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						}
						/* Inject the selected SpW Codec Error */
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bStartErrInj = TRUE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bResetErrInj = FALSE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.ucErrInjErrCode = eSpwcSpwCodecErrIdParity;
						bSpwcSetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						break;
						
					case spwErrDisconnect:
						/* Force the stop of any ongoing SpW Codec Errors */
						bSpwcGetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bStartErrInj = FALSE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bResetErrInj = TRUE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.ucErrInjErrCode = eSpwcSpwCodecErrIdNone;
						bSpwcSetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						/* Wait SpW Codec Errors controller to be ready */
						bSpwcGetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						while (FALSE == xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bErrInjReady) {
							bSpwcGetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						}
						/* Inject the selected SpW Codec Error */
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bStartErrInj = TRUE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bResetErrInj = FALSE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.ucErrInjErrCode = eSpwcSpwCodecErrIdDiscon;
						bSpwcSetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						break;

					case spwErrEscape_sequence:
						/* Force the stop of any ongoing SpW Codec Errors */
						bSpwcGetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bStartErrInj = FALSE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bResetErrInj = TRUE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.ucErrInjErrCode = eSpwcSpwCodecErrIdNone;
						bSpwcSetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						/* Wait SpW Codec Errors controller to be ready */
						bSpwcGetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						while (FALSE == xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bErrInjReady) {
							bSpwcGetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						}
						/* Inject the selected SpW Codec Error */
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bStartErrInj = TRUE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bResetErrInj = FALSE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.ucErrInjErrCode = eSpwcSpwCodecErrIdEscape;
						bSpwcSetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						break;

					case spwErrCharacter_sequence:
						/* Force the stop of any ongoing SpW Codec Errors */
						bSpwcGetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bStartErrInj = FALSE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bResetErrInj = TRUE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.ucErrInjErrCode = eSpwcSpwCodecErrIdNone;
						bSpwcSetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						/* Wait SpW Codec Errors controller to be ready */
						bSpwcGetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						while (FALSE == xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bErrInjReady) {
							bSpwcGetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						}
						/* Inject the selected SpW Codec Error */
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bStartErrInj = TRUE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bResetErrInj = FALSE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.ucErrInjErrCode = eSpwcSpwCodecErrIdChar;
						bSpwcSetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						break;

					case spwErrCredit:
						/* Force the stop of any ongoing SpW Codec Errors */
						bSpwcGetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bStartErrInj = FALSE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bResetErrInj = TRUE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.ucErrInjErrCode = eSpwcSpwCodecErrIdNone;
						bSpwcSetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						/* Wait SpW Codec Errors controller to be ready */
						bSpwcGetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						while (FALSE == xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bErrInjReady) {
							bSpwcGetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						}
						/* Inject the selected SpW Codec Error */
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bStartErrInj = TRUE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bResetErrInj = FALSE;
						xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.ucErrInjErrCode = eSpwcSpwCodecErrIdCredit;
						bSpwcSetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						break;

					case spwErrEEP:
						bDschGetPacketConfig(&xCh[p_payload->data[1]].xDataScheduler);
						if (xCh[p_payload->data[1]].xDataScheduler.xDschPacketConfig.bSendEep) {
							xCh[p_payload->data[1]].xDataScheduler.xDschPacketConfig.bSendEep = FALSE;
							xCh[p_payload->data[1]].xDataScheduler.xDschPacketConfig.bSendEop = TRUE;
						} else {
							xCh[p_payload->data[1]].xDataScheduler.xDschPacketConfig.bSendEep = TRUE;
							xCh[p_payload->data[1]].xDataScheduler.xDschPacketConfig.bSendEop = FALSE;
						}
						bDschSetPacketConfig(&xCh[p_payload->data[1]].xDataScheduler);
						break;

					// case spwErrInvalidDestination:
						// /* Force the stop of any ongoing SpW Codec Errors */
						// bSpwcGetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						// xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bStartErrInj = FALSE;
						// xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bResetErrInj = TRUE;
						// xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.ucErrInjErrCode = eSpwcSpwCodecErrIdNone;
						// bSpwcSetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						// /* Wait SpW Codec Errors controller to be ready */
						// bSpwcGetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						// while (FALSE == xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bErrInjReady) {
						// 	bSpwcGetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						// }
						// /* Inject the selected SpW Codec Error */
						// xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bStartErrInj = TRUE;
						// xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.bResetErrInj = FALSE;
						// xCh[p_payload->data[1]].xSpacewire.xSpwcSpwCodecErrInj.ucErrInjErrCode = eSpwcSpwCodecErrIdDiscon;
						// bSpwcSetSpwCodecErrInj(&xCh[p_payload->data[1]].xSpacewire);
						// v_ack_creator(p_payload, xNotImplemented);
						// break;
					
					default:
						break;

				}

				// No ack executed
				break;

				case typeErrorInjectionRmap:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xVerbose ){
                    fprintf(fp, "[CommandManagementTask]Error Injection\n\r");
                }
#endif

				bRmapGetRmapErrInj(&xCh[p_payload->data[1]].xRmap);
				xCh[p_payload->data[1]].xRmap.xRmapRmapErrInj.bTriggerErr = TRUE;
				xCh[p_payload->data[1]].xRmap.xRmapRmapErrInj.ucErrorId   = p_payload->data[0];
				xCh[p_payload->data[1]].xRmap.xRmapRmapErrInj.uliValue    = (alt_u32) (p_payload->data[5] + 256 * p_payload->data[4] + 65536 * p_payload->data[3] + 4294967296 * p_payload->data[2]);
				xCh[p_payload->data[1]].xRmap.xRmapRmapErrInj.usiRepeats  = 0;
				bRmapSetRmapErrInj(&xCh[p_payload->data[1]].xRmap);

				break;

				/* Eth Disconnect */
				case typeDisc:
#if DEBUG_ON
					if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
						fprintf(fp, "[CommandManagementTask]Ethernet Disconnect\n\r");
					}
#endif
					error_code = OSTaskSuspend(PERIODIC_HK_TASK_PRIORITY);
					T_simucam.T_conf.luHKPeriod = 0;
					T_simucam.T_conf.i_forward_data = 0;
					T_simucam.T_conf.echo_sent = 0;
				break;

				default:
#if DEBUG_ON
					fprintf(fp, "[CommandManagementTask]Nenhum comando aceito em modo running\n\r");
#endif
					if (p_payload->type == typeConfigureSub || p_payload->type == typeNewData || p_payload->type == typeDeleteData || p_payload->type == typeSelectDataToSend
							|| p_payload->type == typeClearRam || p_payload->type == typeConfigureMeb || p_payload->type == typeSetPeriodicHK || p_payload->type == typeSetProgressEvent) {
						v_ack_creator(p_payload, xCommandNotAccepted);
					} else {
						v_ack_creator(p_payload, xCommandNotFound);
					}
					break;
				}

			}

			break;

		default:
#if DEBUG_ON
if (T_simucam.T_conf.usiDebugLevels <= xCritical) {
			fprintf(fp, "[CommandManagementTask]MEB status error\n\r");
}
#endif
			break;
		}
	}
}
