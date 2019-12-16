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

void long_to_int(int nb, int nb_bytes, INT8U* p_destination) {
//	def long_to_bytes(nb,n_bytes):
//	    p=0
//	    size = []
//	    while p < n_bytes:
//	        buff = nb//256
//	        size.append(nb%256)
//	        nb = buff
//	        p+=1
//	    return size[::-1]

	int p = nb_bytes;
	int k = 0;
	INT8U byte_buffer[nb_bytes];
	INT32U i_buffer;
	p_destination += nb_bytes;

#if DEBUG_ON
	fprintf(fp, "[longtoint]teste chegada: %i\r\n", (INT8U) *p_destination);
#endif

	while (p != 0) {
//		i_buffer = div(nb, 256).quot;
		*p_destination = div(nb, 256).rem;
//		byte_buffer[p] = div(nb, 256).rem;
		nb = div(nb, 256).quot;
		p_destination--;
		p--;
	}
#if DEBUG_ON
	fprintf(fp, "[LongToInt]Final Bytes ");
#endif
//	k = nb_bytes;
//	while (k != 0) {
//		*p_destination = byte_buffer[k];
//#if DEBUG_ON
//		fprintf(fp, "%i ",(INT8U) *p_destination);
//#endif
//		fprintf(fp, "%i \r\n", (INT8U) *p_destination);
//		p_destination++;
//		k--;
//	}
#if DEBUG_ON
	fprintf(fp, "\r\n");

	fprintf(fp, "[LongToInt]Byte buffer ");
	for (p = 0; p < nb_bytes; p++) {
		fprintf(fp, "%i ", byte_buffer[p]);
	}
	fprintf(fp, "\r\n");
#endif
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
 * @param 	[in] 	T_uart_payload* payload Struct
 * @param 	[in] 	INT8U error_code
 * @retval INT32U size
 **/
void v_ack_creator(T_uart_payload* p_error_response, INT8U error_code) {

	INT16U nb_id = T_simucam.T_status.TM_id;
	INT16U nb_id_pkt = p_error_response->packet_id;
	INT8U ack_buffer[64];
	INT32U ack_size = 14;
    INT16U usCRC = 0;

    /* memset buffer */
#if DEBUG_ON
	fprintf(fp, "[ACK CREATOR] Entered ack creator.\r\n");
#endif
	ack_buffer[0] = 2;

	/*
	 * Id to bytes
	 */
	ack_buffer[2] = div(nb_id, 256).rem;
	nb_id = div(nb_id, 256).quot;
	ack_buffer[1] = div(nb_id, 256).rem;

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

	ack_buffer[10] = p_error_response->type;
	ack_buffer[11] = error_code;
	
    /**
     * Calculate and add CRC
     */
    usCRC = crc__CRC16CCITT(ack_buffer);

    ack_buffer[13] = div(usCRC, 256).rem;
	usCRC = div(usCRC, 256).quot;
	ack_buffer[12] = div(usCRC, 256).rem;

	for (int f = 0; f < ack_size; f++){
		printf("%c", ack_buffer[f]);
	}

	T_simucam.T_status.TM_id++;
}


void v_HK_creator(INT8U i_channel) {

	INT8U chann_buff = i_channel;
	INT16U usCRC;
	INT16U nb_id = T_simucam.T_status.TM_id;
	INT16U nb_counter_total = T_simucam.T_status.simucam_total_imagettes_sent;
	INT16U nb_counter_current =
			T_simucam.T_Sub[chann_buff].T_conf.i_imagette_control;
	INT16U imagettes_to_send =
			T_simucam.T_Sub[chann_buff].T_data.nb_of_imagettes;
	INT8U hk_buffer[HK_SIZE];
	bool b_link_enabled = false;

#if DEBUG_ON
	fprintf(fp, "[HK CREATOR] Entered hk creator for channel %i.\r\n", (INT8U)chann_buff);
#endif


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
	hk_buffer[27] = div(imagettes_to_send, 256).rem;
	imagettes_to_send = div(imagettes_to_send, 256).quot;
	hk_buffer[26] = div(imagettes_to_send, 256).rem;

	/**
	 * Calculating CRC
     * TODO
	 */
	usCRC = crc__CRC16CCITT(hk_buffer, HK_SIZE);

	hk_buffer[29] = div(usCRC, 256).rem;
	usCRC = div(usCRC, 256).quot;
	hk_buffer[28] = div(usCRC, 256).rem;
    
    /*
     * Send HK through serial
     */
    for (int f = 0; f < HK_SIZE; f++){
		printf("%c", hk_buffer[f]);
	}

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

	T_uart_payload payload_command;

	T_uart_payload *p_payload = &payload_command;

	INT8U i_channel_buffer = 0;

	/*
	 * Initialize DMA
	 */
	bIdmaInitM1Dma();
	bIdmaInitM2Dma();

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
	bSyncCtrCh6OutEnable(TRUE);
	bSyncCtrCh7OutEnable(TRUE);
	bSyncCtrCh8OutEnable(TRUE);

	T_simucam.T_status.simucam_mode = simModeInit;

	/* Address */
	xSimucamTimer.puliDschChAddr =
			(TDschChannel *) DUMB_COMMUNICATION_MODULE_V1_TIMER_BASE;
	/* Init Simucam Timer */
	bDschGetTimerConfig(&xSimucamTimer);
	bDschGetTimerStatus(&xSimucamTimer);
	bDschSetTime(&xSimucamTimer, 0);
	/* Config Simucam timer */
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
			if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
                fprintf(fp, "[CommandManagementTask]Init\r\n");
            }
#endif
//			data[0] = 33;
//			long_to_int(350, 2, &data);
//			fprintf(fp, "[CommandManagementTask]test long to int: %i %i\r\n",
//					data[0], data[1]);

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
			if (T_simucam.T_conf.usiDebugLevels <= xMajor ) {
                fprintf(fp, "[CommandManagementTask]Mode: toConfig\r\n");
            }
#endif

			T_simucam.T_status.simucam_mode = simModeConfig;
			break;

			/*
			 * Config mode
			 */
		case simModeConfig:
#if DEBUG_ON
			if (T_simucam.T_conf.usiDebugLevels <= xMajor ) {
                fprintf(fp, "[CommandManagementTask]Mode: Config\r\n");
            }
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
				if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
                    fprintf(fp, "[CommandManagementTask]Configure Sub-Unit\r\n");
                }
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
				if (T_simucam.T_conf.usiDebugLevels <= xVerbose ){
                    fprintf(fp, "[CommandManagementTask]Configurations sent: %i, %i, %i\r\n",
						(INT8U) sub_config_send[p_payload->data[0]].link_config,
						(INT8U) sub_config_send[p_payload->data[0]].linkspeed,
						(INT8U) sub_config_send[p_payload->data[0]].linkstatus_running);
                        }
#endif

				v_ack_creator(p_payload, xAckOk);

				break;

				/*
				 * Delete Data
				 * NUC
				 * char: g
				 */
			case 103:

				v_ack_creator(p_payload, xNotImplemented);

				break;

				/*
				 * Select data to send
				 * TODO Assign the memory spaces to the data
				 * instead of the sub
				 * char: h
				 */
			case 104:

				v_ack_creator(p_payload, xNotImplemented);

				break;

				/*
				 * Change Simucam Modes
				 * char: i
				 */
			case 105:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
                    fprintf(fp, "[CommandManagementTask]Change Mode\r\n");
                }
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

				/* Change to beggining of run */
				// v_ack_creator(p_payload, xAckOk);

#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
                    fprintf(fp, "[CommandManagementTask]Config sent to sub\n\r");
                }
#endif
				break;

				/*
				 * Clear RAM
				 */
			case 108:

				v_ack_creator(p_payload, xNotImplemented);
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
                        fprintf(fp, "[CommandManagementTask]Clear RAM\r\n");
                    }
#endif
				break;

				/*
				 * Get HK
				 */
			case 110:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
                    fprintf(fp, "[CommandManagementTask]Get HK\r\n");
                }
#endif
				i_channel_buffer = p_payload->data[0];

				v_HK_creator(i_channel_buffer);
                v_ack_creator(p_payload, xAckOk);
				break;

				/*
				 * Config MEB
				 */
			case typeConfigureMeb:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
                    fprintf(fp, "[CommandManagementTask]Config MEB\r\n");
                }
#endif

				T_simucam.T_conf.i_forward_data = p_payload->data[0];
				T_simucam.T_conf.echo_sent = p_payload->data[1];

				v_ack_creator(p_payload, xAckOk);
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xVerbose ){
                    fprintf(fp, "[CommandManagementTask]Meb configs: fwd: %i, echo: %i\r\n",
						(int) T_simucam.T_conf.i_forward_data,
						(int) T_simucam.T_conf.echo_sent);
                        }
#endif
				break;

				/*
				 * Set Recording
                 * TODO: Get details
				 */
			case typeSetRecording:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
                    fprintf(fp, "[CommandManagementTask]Set Recording\n\r");
                }
#endif
				v_ack_creator(p_payload, xNotImplemented);

				break;

                /**
                 * Periodic HK
                 */
            case typeSetPeriodicHK:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
                    fprintf(fp, "[CommandManagementTask]Set Periodic HK\n\r");
                }
#endif
                T_simucam.T_conf.iPeriodicHK = p_payload->data[0];
                
                if(T_simucam.T_conf.iPeriodicHK){

                    T_simucam.T_conf.luHKPeriod = p_payload->data[4]
                                                + 256 * p_payload->data[3]
                                                + 65536 * p_payload->data[2]
                                                + 4294967296 * p_payload->data[1];
                
                   error_code = OSTaskResume (PERIODIC_HK_TASK_PRIORITY);
                } else{
                    error_code = OSTaskSuspend(PERIODIC_HK_TASK_PRIORITY);
                    T_simucam.T_conf.luHKPeriod = 0;
                }
                if(error_code == OS_NO_ERR){
                    v_ack_creator(p_payload, xAckOk);
                } else{
                    v_ack_creator(p_payload, xOSError);
                }
                
            break;

            case typeReset:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
                    fprintf(fp, "[CommandManagementTask]Ethernet Reset\n\r");
                }
#endif
                v_ack_creator(p_payload, xNotImplemented);
            break;

			default:
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
                    fprintf(fp, "[CommandManagementTask]Command not identified...\n\r");
                }
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
			fprintf(fp, "[CommandManagementTask RUNNING]Mode to RUN\r\n");
#endif

			/*
			 * Clear and start simucam timer, NOT RUNNING
			 */
			bDschClrTimer(&xSimucamTimer);
			bDschStartTimer(&xSimucamTimer);

			T_simucam.T_status.simucam_mode = simModeRun;
			break;

		case simModeRun:
#if DEBUG_ON
			fprintf(fp, "[CommandManagementTask RUNNING]Mode RUN\r\n");
#endif

#if DEBUG_ON
			fprintf(fp, "[CommandManagementTask RUNNING]Waiting command...\r\n");
#endif
			/*
			 * Start simucam timer counting
			 */
			error_code = bDschRunTimer(&xSimucamTimer);
            if(error_code == OS_NO_ERR){
                v_ack_creator(p_payload, xAckOk);
            } else
            {
                v_ack_creator(p_payload, xTimerError);
            }
            
			p_payload = OSQPend(p_simucam_command_q, 0, &error_code);

			/*
			 * SYNC cmd
			 */
			if (p_payload->type == 106) {

				bSyncCtrOneShot();

				v_ack_creator(p_payload, xAckOk);
            /*
             * TODO Start HK timer if needed
             */
#if DEBUG_ON
				fprintf(fp, "[CommandManagementTask]Starting timer\r\n");
#endif
			} else {

				switch (p_payload->type) {

				/*
				 * Change Simucam Mode
				 */
				case 105:

#if DEBUG_ON
					fprintf(fp, "[CommandManagementTask]MEB status to: %i\r\n",
							(INT8U) p_payload->data[0]);
#endif

					if (p_payload->data[0] == 0) {
						T_simucam.T_status.simucam_running_time = 1;
						T_simucam.T_status.simucam_mode = simModetoConfig;

#if DEBUG_ON
						fprintf(fp, 
								"[CommandManagementTask]Sending change mode command...\r\n");
#endif

						/*
						 * Stop Simucam Timer
						 */
						error_code = bDschStopTimer(&xSimucamTimer);
                        if(error_code != OS_NO_ERR){
                            v_ack_creator(p_payload, xTimerError);
                        }
						/*
						 * Stop and clear channel timers
						 */
						for (i_channel_for = 0; i_channel_for < NB_CHANNELS;
								i_channel_for++) {

							error_code = bDschStopTimer(
									&(xCh[i_channel_for].xDataScheduler));
                            if(error_code != OS_NO_ERR){
                                v_ack_creator(p_payload, xTimerError);
                            }
							error_code = bDschClrTimer(&(xCh[i_channel_for].xDataScheduler));
							if(error_code != OS_NO_ERR){
                                v_ack_creator(p_payload, xTimerError);
                            }
                            sub_config_send[i_channel_for].mode = subChangeMode;
							error_code = OSQPost(
									p_sub_unit_config_queue[i_channel_for],
									&sub_config_send[i_channel_for]);
                            if(error_code != OS_NO_ERR){
                                v_ack_creator(p_payload, xOSError);
                            }
                        }

					}
					if (error_code == OS_NO_ERR){
                        v_ack_creator(p_payload, xAckOk);
                    }
					break;

					/*
					 * Abort Sending
					 */
				case 107:
#if DEBUG_ON
					fprintf(fp, "[CommandManagementTask]Selected command: %i\n\r",
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
                    if (error_code == OS_NO_ERR){
                        v_ack_creator(p_payload, xAckOk);
                    }else {
                        v_ack_creator(p_payload, xOSError);
                    }
					break;

					/*
					 * Direct send
					 */
				case 109:
#if DEBUG_ON
					fprintf(fp, "[CommandManagementTask]Direct Send to %c\n\r",
							(char) (p_payload->data[0] + ASCII_A));
#endif
					/*
					 * Direct Send needs replaning
					 */
                    v_ack_creator(p_payload, xCommandNotFound);
					break;

					/*
					 * Get HK
					 */
				case 110:
#if DEBUG_ON
					fprintf(fp, "[CommandManagementTask]Get HK\r\n");
#endif
					v_HK_creator(p_payload->data[0]);
					break;

				default:
#if DEBUG_ON
					fprintf(fp, 
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
			fprintf(fp, "[CommandManagementTask]MEB status error\n\r");
#endif
			break;
		}
	}
}
