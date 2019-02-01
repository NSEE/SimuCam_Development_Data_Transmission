/*
 * command_control.c
 *
 *  Created on: Apr 26, 2018
 *      Author: yuribunduki
 */

#include "command_control.h"

struct sub_config config_send_A;

struct imagette_control img_struct;
struct imagette_control *p_img_control;

struct _ethernet_payload *p_payload;

INT8U b_meb_status = 0; //default starting mode is config
INT8U i_forward_data = 0;
INT8U i_echo_sent_data = 0;

//INT32U i_imagette_counter_CC = 0;
INT32U i_total_imagette_counter = 0;

INT8U data[MAX_IMAGETTES];
INT8U *p_data_pos = &data[0];

INT32U i_central_timer_counter = 1;
INT8U exec_error;

INT16U i_id_accum = 1;

INT8U tx_buffer_CC[SSS_TX_BUF_SIZE];
INT8U *p_tx_buffer = &tx_buffer_CC[0];

void i_echo_dataset_direct_send(struct _ethernet_payload* p_imagette,
		INT8U* tx_buffer) {
//	static INT8U tx_buffer[SSS_TX_BUF_SIZE];
	INT8U i = 0;
//	INT32U i_imagette_counter_echo = i_imagette_counter;
//	INT32U k;

	tx_buffer[0] = 2;
	tx_buffer[1] = 0;
	tx_buffer[2] = i_id_accum;
	tx_buffer[3] = 203;
	tx_buffer[4] = 0;
	tx_buffer[5] = 0;
	tx_buffer[6] = 0;
	tx_buffer[7] = (p_imagette->size - 11) + ECHO_CMD_OVERHEAD;
	tx_buffer[8] = 0;
	tx_buffer[9] = 0;
	tx_buffer[10] = 0;
	tx_buffer[11] = i_central_timer_counter;
	tx_buffer[12] = 0;			//channel info

	while (i < p_imagette->size - 11) {
		tx_buffer[i + (ECHO_CMD_OVERHEAD - 2)] = p_imagette->data[i+1];
		i++;
	}

	tx_buffer[i + (ECHO_CMD_OVERHEAD - 2)] = 0;	//crc
	tx_buffer[i + (ECHO_CMD_OVERHEAD - 1)] = 7;	//crc

	i_id_accum++;

	printf("[Echo DEBUG]Printing buffer = ");
	for (int k = 0; k < (p_imagette->size - 11) + ECHO_CMD_OVERHEAD; k++) {
		printf("%i ", (INT8U) tx_buffer[k]);
	}
	printf("\r\n");

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
void v_ack_creator(struct _ethernet_payload* p_error_response, int error_code) {

	p_error_response->data[0] = 2;
	p_error_response->data[1] = 0;
	p_error_response->data[2] = i_id_accum;
	p_error_response->data[3] = 201;
	p_error_response->data[4] = 0;
	p_error_response->data[5] = 0;
	p_error_response->data[6] = 0;
	p_error_response->data[7] = 14;
	p_error_response->data[8] = 0;
	p_error_response->data[9] = p_error_response->packet_id;
	p_error_response->data[10] = p_error_response->type;
	p_error_response->data[11] = error_code;
	p_error_response->data[12] = 0;
	p_error_response->data[13] = 89;
	p_error_response->size = 14;

	i_id_accum++;
}

void v_HK_creator(struct _ethernet_payload* p_HK, INT8U i_channel) {

	INT8U chann_buff = i_channel;

	p_HK->data[0] = 2;
	p_HK->data[1] = 0;
	p_HK->data[2] = i_id_accum;
	p_HK->data[3] = 204;
	p_HK->data[4] = 0;
	p_HK->data[5] = 0;
	p_HK->data[6] = 0;
	p_HK->data[7] = 30;
	p_HK->data[8] = chann_buff;	//channel
	p_HK->data[9] = b_meb_status; //meb mode
	p_HK->data[10] = sub_config.linkstatus_running;	//Sub_config_enabled
	p_HK->data[11] = sub_config.link_config; //sub_config_linkstatus
	p_HK->data[12] = sub_config.linkspeed; //sub_config_linkspeed
	p_HK->data[13] = ul_SpaceWire_Interface_Link_Status_Read('A'); //sub_status_linkrunning
	p_HK->data[14] = 1; //link enabled
	p_HK->data[15] = sub_config.sub_status_sending;
	p_HK->data[16] = 0;	//link errors
	p_HK->data[17] = 0;
	p_HK->data[18] = 0;
	p_HK->data[19] = 0;
	p_HK->data[20] = 0; //sent packets byte 1
	p_HK->data[21] = i_total_imagette_counter; //sent packets byte 0
	p_HK->data[22] = 0; //Received packets 1
	p_HK->data[23] = 0; //Received packets 0
	p_HK->data[24] = 0; //current index
	p_HK->data[25] = i_imagette_counter; //current index
	p_HK->data[26] = 0; //packets to send
	p_HK->data[27] = p_img_control->nb_of_imagettes - i_imagette_counter; //packets to send
	p_HK->data[28] = 25;			//crc
	p_HK->data[29] = 86;			//crc
	p_HK->size = 30;

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

/**
 * @name v_parse_data
 * @brief Parses the payload to a struct useable to command
 * @ingroup UTIL
 *
 * This routine parses the payload to get the delay times and imagettes. It's used by the
 * command control and sub-units to prepare the SpW links. The imagette and delay sizes in
 * bytes can be changed accordingly in the header file.
 *
 * @param 	[in] 	*_ethernet_payload Payload Struct
 * 			[in]	*_imagette_control Control struct to receive the data
 *
 * @retval int	9 if error, 1 if no error
 **/
int v_parse_data(struct _ethernet_payload *p_payload,
		struct imagette_control *p_img_ctrl) {
	INT32U i = 0;
	INT32U p = 0;
	INT32U o = DATA_SHIFT;
	INT32U d = 0;
	INT16U nb_imagettes;
	INT32U error_verif = 0;

	printf(
			"[PARSER]testando valores do payload:\r\nsize: %i\r\ndata_payload: %i,%i,%i,%i,%i,%i\r\n",
			p_payload->size, (char) p_payload->data[8],
			(char) p_payload->data[9], (char) p_payload->data[10],
			(char) p_payload->data[11], (char) p_payload->data[12],
			(char) p_payload->data[13]);

	/*
	 * Do not use first 2 bytes
	 */

	nb_imagettes = p_payload->data[3] + 256 * p_payload->data[2];
	p_img_ctrl->nb_of_imagettes = nb_imagettes;

	printf("[PARSER] Number of imagettes: %i\r\n", nb_imagettes);

	p_img_ctrl->tag[7] = p_payload->data[4];
	p_img_ctrl->tag[6] = p_payload->data[5];
	p_img_ctrl->tag[5] = p_payload->data[6];
	p_img_ctrl->tag[4] = p_payload->data[7];
	p_img_ctrl->tag[3] = p_payload->data[8];
	p_img_ctrl->tag[2] = p_payload->data[9];
	p_img_ctrl->tag[1] = p_payload->data[10];
	p_img_ctrl->tag[0] = p_payload->data[11];

	printf("[PARSER]TAG: %i %i %i %i %i %i %i %i\r\n", p_img_ctrl->tag[7],
			p_img_ctrl->tag[6], p_img_ctrl->tag[5], p_img_ctrl->tag[4],
			p_img_ctrl->tag[3], p_img_ctrl->tag[2], p_img_ctrl->tag[1],
			p_img_ctrl->tag[0]);

	printf("[PARSER]Starting imagette addr %x\r\n", &(p_img_ctrl->imagette[0]));

	while (i < nb_imagettes) {

		printf("[PARSER] Imagette being parsed: %i to %x\r\n", (INT32U) i,
				(INT32U) &(p_img_ctrl->imagette[d]));

//		printf("[PARSER]Offset bytes: %i %i %i %i\r\n",p_payload->data[o],
//				p_payload->data[o + 1], p_payload->data[o + 2], 256 * p_payload->data[o + 2],
//					p_payload->data[o + 3]);

		p_img_ctrl->offset[i] = div(
				(p_payload->data[o + 3] + 256 * p_payload->data[o + 2]
						+ 65536 * p_payload->data[o + 1]
						+ 4294967296 * p_payload->data[o]), 10).quot;

		p_img_ctrl->imagette_length[i] = p_payload->data[o + 5]
				+ 256 * p_payload->data[o + 4];

		printf("[PARSER] offset: %i\r\n[PARSER] length: %i\r\n",
				p_img_ctrl->offset[i], p_img_ctrl->imagette_length[i]);

		for (p = 0; p < p_img_ctrl->imagette_length[i]; p++, d++) {
			p_img_ctrl->imagette[d] = p_payload->data[o + DELAY_SIZE + p];
//			printf(
//					"[PARSER]Teste de recepcao:imagette_nb %i, imagette_data %i\r\n",
//					(INT32U) i, (INT8U) p_img_ctrl->imagette[d]);
		}
		o += DELAY_SIZE + p_img_ctrl->imagette_length[i];
		i++;
	}

	p_img_ctrl->size = d;
	error_verif = o + DATA_SHIFT - 2;
	printf("[PARSER]error_verif %i\r\n", error_verif);
	if (p_payload->size == error_verif) {
		printf("[PARSER]OK...\r\n");
		return ACK_OK;
	} else
		return PARSER_ERROR;
}

/**
 * COMPLETAR
 * @name central_timer_callback_function
 * @brief Parses the payload to a struct useable to command
 * @ingroup UTIL
 *
 * This routine parses the payload to get the delay times and imagettes. It's used by the
 * command control and sub-units to prepare the SpW links. The imagette and delay sizes in
 * bytes can be changed accordingly in the header file.
 *
 * @param 	[in] 	*_ethernet_payload Payload Struct
 * 			[in]	*_imagette_control Control struct to receive the data
 *
 * @retval void
 **/
void central_timer_callback_function(void *p_arg) {

	INT8U error_code = 0;
	INT8U buffer_nb;

//	buffer_nb = i_imagette_number;

//	printf("[CALLBACK]Entered callback\r\n next offset %i, counter %i\r\n",
//			(INT32U) p_img_control->offset[i_imagette_counter],
//			(INT32U) i_central_timer_counter);

	if (p_img_control->offset[i_imagette_number] == i_central_timer_counter) {

		/*
		 * Enviar comando de envio para o sub-unit
		 */
		error_code = OSSemPost(sub_unit_command_semaphore);
		if (error_code == OS_ERR_NONE) {
			printf("[CALLBACK]Semaphore triggered\r\n");
//			i_imagette_counter++;
			i_total_imagette_counter++;
			printf("[CALLBACK]Entered function imagette count: %i\r\n",
					(INT32U) buffer_nb);
		}
	}

	i_central_timer_counter++;

	if (i_imagette_number == p_img_control->nb_of_imagettes) {

//		p_payload->type = 107;
//		error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
//		alt_SSSErrorHandler(error_code, 0);

		error_code = OSTmrStop(central_timer,
		OS_TMR_OPT_NONE, (void *) 0, &error_code);
		if (error_code == OS_ERR_NONE || error_code == OS_ERR_TMR_STOPPED) {
			i_central_timer_counter = 1;
//			i_imagette_number = 0;
//			i_imagette_counter = 0;
			printf("[CommandManagementTask]Timer stopped\r\n");
			printf("[CommandManagementTask]Timer restarted\r\n");
		}
	}
}

/*
 * Task used to parse and execute the commands received via ethernet. [yb]
 */

void CommandManagementTask() {

	INT8U error_code; /*uCOS error code*/
	int exec_error = 0; /*Internal error code for the command module*/

//	INT8U* cmd_pos;
//	INT8U cmd_char_buffer[SSS_TX_BUF_SIZE];
	//INT8U* cmd_char = cmd_char_buffer;

	struct _ethernet_payload payload;
	p_payload = &payload;

	/*
	 * Assigning imagette struct to RAM
	 */
	alt_u32 Ddr2Base;
	alt_u32 ByteLen;
	DDR2_SWITCH_MEMORY(DDR2_M1_ID);
	Ddr2Base = DDR2_EXTENDED_ADDRESS_WINDOWED_BASE;
	ByteLen = DDR2_M1_MEMORY_SIZE;
//	p_img_control = (struct imagette_control *) Ddr2Base;
	p_img_control = &img_struct;

	/*
	 * Declaring the sub-units initial status
	 */
	static struct sub_config *config_send;
	config_send = &config_send_A;

	/*
	 * Configuring done inside the sub-unit modules
	 */
//	config_send->mode = 0; //default starting mode is config
//	config_send->RMAP_handling = 0;
//	config_send->forward_data = 0;
//	config_send->link_config = 0;
//	config_send->sub_status_sending = 0;
//	config_send->linkstatus_running = 1;
//	config_send->linkspeed = 3;
//
//	/*
//	 * Forcing all sub-units to config mode
//	 * Repeat to all 8 sub-units will be implemented once
//	 * all subs will be functionnal
//	 */
//	error_code = (INT8U) OSQPost(p_sub_unit_config_queue, config_send);
//	alt_SSSErrorHandler(error_code, 0);

	while (1) {

		/*
		 * MEB in configuration mode.
		 * It's the default state
		 */
		while (b_meb_status == 0) {

			printf("[CommandManagementTask]MEB in config mode\n\r");
			/*
			 * Enter the receive command mode
			 */

			p_payload = OSQPend(p_simucam_command_q, 0, &error_code);
			alt_uCOSIIErrorHandler(error_code, 0);

			printf(
					"[CommandManagementTask]teste do payload: %c,%c,%c,%c,%c,%c\n\r",
					(INT8U) p_payload->type, (char) p_payload->data[0],
					(char) p_payload->data[1], (char) p_payload->data[2],
					(char) p_payload->data[3], (char) p_payload->data[4]);

			/*
			 * Switch case to select from different command options.[yb]
			 * Will be modified to suit IWF's needs
			 */
			switch (p_payload->type) { /*Selector for commands and actions*/

			/*Sub_unit test routine*/
			case '0':
				printf("[CommandManagementTask]Selected command: %c\n\r",
						(char) p_payload->type);

				//Change sub-unit to running mode
//				error_code = (INT8U) OSQPost(p_sub_unit_config_queue,
//						config_send);
//				alt_SSSErrorHandler(error_code, 0);
//
//				//Send a test byte through the cue
//				error_code = (INT8U) OSQPost(p_sub_unit_command_queue,
//						(INT8U) p_payload->sub_type);

				v_ack_creator(p_payload, ACK_OK);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);

				break;

				/*
				 * Sub-Unit configuration
				 */
			case '1':

				printf("[CommandManagementTask]Selected command: %c\n\r",
						(char) p_payload->type);

				config_send->mode = toInt(p_payload->data[0]);
				config_send->forward_data = toInt(p_payload->data[1]);
				config_send->RMAP_handling = toInt(p_payload->data[2]);

				error_code = (INT8U) OSQPost(p_sub_unit_config_queue,
						config_send);
				alt_SSSErrorHandler(error_code, 0);
				printf(
						"[CommandManagementTask]Configurations sent: %i, %i, %i\r\n",
						(INT8U) config_send->mode,
						(INT8U) config_send->forward_data,
						(INT8U) config_send->RMAP_handling);

				break;

				/*
				 * Preliminary data send
				 */
			case '2':
				printf("[CommandManagementTask]Selected command: %c\n\r",
						(char) p_payload->type);
				error_code = (INT8U) OSQPost(p_sub_unit_command_queue,
						p_payload);

				break;

				/*
				 * MEB to running mode
				 */
			case '3':
				printf("[CommandManagementTask]Selected command: %c\n\r",
						(char) p_payload->type);
				b_meb_status = 1;
				break;

				/*
				 * Parser and send test
				 */

			case '4':
				printf("[CommandManagementTask]Selected command: %c\n\r",
						(char) p_payload->type);

				v_parse_data(p_payload, p_img_control);
				printf(
						"[CommandManagementTask]Teste de parser byte: %i\n\r offset %i\r\nsize: %i\n\r",
						(INT8U) p_img_control->imagette[4],
						(INT32U) p_img_control->offset[0],
						(INT32U) p_img_control->size);

				printf("[CommandManagementTask]Data parsed correctly\r\n");

				config_send->mode = 1;
				config_send->forward_data = 0;
				config_send->RMAP_handling = 0;
				config_send->imagette = p_img_control;

				printf("[CommandManagementTask]Imagete 1 length: %i\r\n",
						config_send->imagette->imagette_length[0]);

				error_code = (INT8U) OSQPost(p_sub_unit_config_queue,
						config_send);
				alt_SSSErrorHandler(error_code, 0);
				printf("[CommandManagementTask]Sent config for test case\n\r");

				b_meb_status = 1;
				printf("[CommandManagementTask]MEB sent to running\n\r");

				break;

				/*
				 * Test case for the interrupts and imagette timers
				 */
			case '5':

				printf("teste de imagens\r\n");

				printf(
						"[CommandManagementTask]imagette 0 byte: %i @ %x\n\r offset %i \n\r",
						(INT8U) p_img_control->imagette[0],
						&p_img_control->imagette[0],
						(INT32U) p_img_control->offset[0]);
				printf(
						"[CommandManagementTask]imagette 1 byte: %i @ %x\n\r offset %i \n\r",
						(INT8U) p_img_control->imagette[1],
						&p_img_control->imagette[1],
						(INT32U) p_img_control->offset[1]);

				config_send->mode = 1;
				config_send->forward_data = 0;
				config_send->RMAP_handling = 0;
				config_send->imagette = p_img_control;

				error_code = (INT8U) OSQPost(p_sub_unit_config_queue,
						config_send);
				alt_SSSErrorHandler(error_code, 0);
				printf("[CommandManagementTask]Sent config for test case\n\r");

				b_meb_status = 1;
				printf("[CommandManagementTask]MEB sent to running\n\r");

				break;
			case '6':

				printf("[CommandManagementTask]IWF Coupling Test\r\n");

				p_img_control->imagette[0] = 0x28;
				p_img_control->imagette[1] = 0x2;
				p_img_control->imagette[2] = 0x0;
				p_img_control->imagette[3] = 0x0;
				p_img_control->imagette[4] = 1;
				p_img_control->imagette[5] = 2;
				p_img_control->imagette[6] = 3;
				p_img_control->imagette[7] = 5;
				p_img_control->imagette[8] = 8;
				p_img_control->imagette[9] = 13;
				p_img_control->imagette[10] = 21;
				p_img_control->imagette[11] = 224; //CRC
				p_img_control->imagette[12] = 250; //CRC

				p_img_control->offset[0] = 1;
				p_img_control->size = 13;
				p_img_control->imagette_length[0] = 13;
				p_img_control->nb_of_imagettes = 1;

				config_send->mode = 1;
				config_send->forward_data = 0;
				config_send->RMAP_handling = 0;
				config_send->imagette = p_img_control;

				error_code = (INT8U) OSQPost(p_sub_unit_config_queue,
						config_send);
				alt_SSSErrorHandler(error_code, 0);
				printf("[CommandManagementTask]Sent config for test case\n\r");

//				b_meb_status = 1;
//				printf("[CommandManagementTask]MEB sent to running\n\r");

				v_ack_creator(p_payload, ACK_OK);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);

				break;

			case '7':

				printf("[CommandManagementTask]IWF Coupling Test 5s\r\n");

				p_img_control->imagette[0] = 0x28;
				p_img_control->imagette[1] = 0x2;
				p_img_control->imagette[2] = 0x0;
				p_img_control->imagette[3] = 0x0;
				p_img_control->imagette[4] = 1;
				p_img_control->imagette[5] = 2;
				p_img_control->imagette[6] = 3;
				p_img_control->imagette[7] = 5;
				p_img_control->imagette[8] = 8;
				p_img_control->imagette[9] = 13;
				p_img_control->imagette[10] = 21;
				p_img_control->imagette[11] = 224; //CRC
				p_img_control->imagette[12] = 250; //CRC

				p_img_control->imagette[13] = 0x28;
				p_img_control->imagette[14] = 0x2;
				p_img_control->imagette[15] = 0x0;
				p_img_control->imagette[16] = 0x0;
				p_img_control->imagette[17] = 1;
				p_img_control->imagette[18] = 2;
				p_img_control->imagette[19] = 3;
				p_img_control->imagette[20] = 5;
				p_img_control->imagette[21] = 8;
				p_img_control->imagette[22] = 13;
				p_img_control->imagette[23] = 21;
				p_img_control->imagette[24] = 224; //CRC
				p_img_control->imagette[25] = 250; //CRC

				p_img_control->imagette[26] = 0x28;
				p_img_control->imagette[27] = 0x2;
				p_img_control->imagette[28] = 0x0;
				p_img_control->imagette[29] = 0x0;
				p_img_control->imagette[30] = 1;
				p_img_control->imagette[31] = 2;
				p_img_control->imagette[32] = 3;
				p_img_control->imagette[33] = 5;
				p_img_control->imagette[34] = 8;
				p_img_control->imagette[35] = 13;
				p_img_control->imagette[36] = 21;
				p_img_control->imagette[37] = 224; //CRC
				p_img_control->imagette[38] = 250; //CRC

				p_img_control->imagette[39] = 0x28;
				p_img_control->imagette[40] = 0x2;
				p_img_control->imagette[41] = 0x0;
				p_img_control->imagette[42] = 0x0;
				p_img_control->imagette[43] = 1;
				p_img_control->imagette[44] = 2;
				p_img_control->imagette[45] = 3;
				p_img_control->imagette[46] = 5;
				p_img_control->imagette[47] = 8;
				p_img_control->imagette[48] = 13;
				p_img_control->imagette[49] = 21;
				p_img_control->imagette[50] = 224; //CRC
				p_img_control->imagette[51] = 250; //CRC

				p_img_control->imagette[52] = 0x28;
				p_img_control->imagette[53] = 0x2;
				p_img_control->imagette[54] = 0x0;
				p_img_control->imagette[55] = 0x0;
				p_img_control->imagette[56] = 1;
				p_img_control->imagette[57] = 2;
				p_img_control->imagette[58] = 3;
				p_img_control->imagette[59] = 5;
				p_img_control->imagette[60] = 8;
				p_img_control->imagette[61] = 13;
				p_img_control->imagette[62] = 21;
				p_img_control->imagette[63] = 224; //CRC
				p_img_control->imagette[64] = 250; //CRC

				p_img_control->offset[0] = 1;
				p_img_control->offset[1] = 2;
				p_img_control->offset[2] = 3;
				p_img_control->offset[3] = 4;
				p_img_control->offset[4] = 5;

				p_img_control->imagette_length[0] = 13;
				p_img_control->imagette_length[1] = 13;
				p_img_control->imagette_length[2] = 13;
				p_img_control->imagette_length[3] = 13;
				p_img_control->imagette_length[4] = 13;

				p_img_control->size = 65;
				p_img_control->nb_of_imagettes = 5;

				config_send->mode = 1;
				config_send->forward_data = 0;
				config_send->RMAP_handling = 0;
				config_send->imagette = p_img_control;

//				error_code = (INT8U) OSQPost(p_sub_unit_config_queue,
//						config_send);
//				alt_SSSErrorHandler(error_code, 0);
//				printf("[CommandManagementTask]Sent config for test case\n\r");

				v_ack_creator(p_payload, ACK_OK);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);

//				b_meb_status = 1;
//				printf("[CommandManagementTask]MEB sent to running\n\r");

				break;

				/*
				 * Test cases for RAM
				 */
			case '8':
				printf("[CommandManagementTask] DDR2 Memory Test\r\n");

				break;

				/*
				 * Sub-Unit config command
				 * char: e
				 */
			case 101:
				printf("[CommandManagementTask]Configure Sub-Unit\r\n");

				/* Add a case for channel selection */

				config_send->link_config = p_payload->data[1];
				config_send->linkspeed = p_payload->data[2];
				config_send->linkstatus_running = p_payload->data[3];

				printf(
						"[CommandManagementTask]Configurations sent: %i, %i, %i\r\n",
						(INT8U) config_send->link_config,
						(INT8U) config_send->linkspeed,
						(INT8U) config_send->linkstatus_running);

				v_ack_creator(p_payload, ACK_OK);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);

				break;

				/*
				 * Receive and Parse data
				 * char: f
				 */
			case 102:
				printf("[CommandManagementTask]Parse data\n\r");

				exec_error = v_parse_data(p_payload, p_img_control);
				printf(
						"[CommandManagementTask]Teste de parser byte: %i\n\r offset %i\r\nsize: %i\n\r",
						(INT8U) p_img_control->imagette[0],
						(INT32U) p_img_control->offset[0],
						(INT32U) p_img_control->size);

				printf("[CommandManagementTask]Data parsed\r\n");

				config_send->imagette = p_img_control;

				v_ack_creator(p_payload, exec_error);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);

				break;

				/*
				 * Delete Data
				 * char: g
				 */
			case 103:

				v_ack_creator(p_payload, NOT_IMPLEMENTED);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);

				break;

				/*
				 * Select data to send
				 * char: h
				 */
			case 104:

				v_ack_creator(p_payload, NOT_IMPLEMENTED);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);

				break;

				/*
				 * Change Simucam Modes
				 * char: i
				 */
			case 105:
				printf("[CommandManagementTask]Change Mode\r\n");

				b_meb_status = p_payload->data[0];

				if (b_meb_status == 1) {
					config_send->mode = 1;

					error_code = (INT8U) OSQPost(p_sub_unit_config_queue,
							config_send);
					alt_SSSErrorHandler(error_code, 0);
				}

				printf("[CommandManagementTask]Config sent to sub\n\r");

				v_ack_creator(p_payload, ACK_OK);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);

				break;

				/*
				 * Clear RAM
				 */
			case 108:
				printf("[CommandManagementTask]Clear RAM\r\n");

				v_ack_creator(p_payload, NOT_IMPLEMENTED);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);

				break;

				/*
				 * Get HK
				 */
			case 110:
				printf("[CommandManagementTask]Get HK\r\n");

				v_HK_creator(p_payload, p_payload->data[0]);
				//v_ack_creator(p_payload, NOT_IMPLEMENTED);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);
				break;

				/*
				 * Config MEB
				 */
			case 111:
				printf("[CommandManagementTask]Clear RAM\r\n");

				i_forward_data = p_payload->data[0];
				i_echo_sent_data = p_payload->data[1];

				printf(
						"[CommandManagementTask]Meb configs: fwd: %i, echo: %i\r\n",
						(int) i_forward_data, (int) i_echo_sent_data);

				v_ack_creator(p_payload, ACK_OK);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);

				break;

				/*
				 * Set Recording
				 */
			case 112:
				printf("[CommandManagementTask]Selected command: %c\n\r",
						(int) p_payload->type);

				v_ack_creator(p_payload, NOT_IMPLEMENTED);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);

				break;

			default:
				printf(
						"[CommandManagementTask]Nenhum comando identificado\n\r");

				v_ack_creator(p_payload, COMMAND_NOT_FOUND);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);

				break;
			} //Switch fim

//				size = 1;
//				if (cmd_pos[1] >= 'A' && cmd_pos[1] <= 'H') {
//					data[0] = uc_SpaceWire_Interface_Get_TimeCode(cmd_pos[1]);
//
//					//Size is fixed at 1 in this application
//
//					error_code = OSQPost(SimucamDataQ, (void *) size);
//					alt_SSSErrorHandler(error_code, 0);
//
//					error_code = OSQPost(SimucamDataQ,(INT8U) data[0]);
//					alt_SSSErrorHandler(error_code, 0);
//
//					exec_error = Verif_Error(!error_code);
//
//				} else
//					printf("%c Nao e um canal valido do SpW\n\r",
//							(char) cmd_pos[1]);
//				break;
//
//				/*
//				 * send data
//				 */
//			case '4':
//				p = 4;
//				if (cmd_pos[1] >= 'A' && cmd_pos[1] <= 'H') {
//					for (i = 0; i < aatoh(&cmd_pos[2]); i++) {
//						data_pos[i] = aatoh(&cmd_pos[p]);
//						p += 2;
//					}
//				} else
//					printf("%c Nao e um canal valido do SpW\n\r",
//							(char) cmd_pos[1]);
//
//				error_code = b_SpaceWire_Interface_Send_SpaceWire_Data(
//						cmd_pos[1], data_pos, aatoh(&cmd_pos[2]));
//
//				exec_error = Verif_Error(error_code);
//				break;
//
//				/*
//				 * read data
//				 */
//			case '5':
//				if (cmd_pos[1] >= 'A' && cmd_pos[1] <= 'H') {
//
//					size = ui_SpaceWire_Interface_Get_SpaceWire_Data(cmd_pos[1],
//							data_pos, 512);
//
//					printf("size: %i\n", size);
//					exec_error = Verif_Error(size);
//					if (!exec_error)
//						break;
//					error_code = OSQPost(SimucamDataQ, (void *) size);
//					alt_SSSErrorHandler(error_code, 0);
//					for (i = 0; i < size; i++) {
//						error_code = OSQPost(SimucamDataQ,(INT8U) data_pos[i]);
//						alt_SSSErrorHandler(error_code, 0);
//					}
//				} else
//					printf("%c Nao e um canal valido do SpW\n\r",
//							(char) cmd_pos[1]);
//				break;
//
//				/*
//				 * spw autostart
//				 */
//			case '6':
//				if (cmd_pos[1] >= 'A' && cmd_pos[1] <= 'H') {
//					error_code = v_SpaceWire_Interface_Link_Control(
//							(char) cmd_pos[1], toInt(cmd_pos[2]),
//							SPWC_AUTOSTART_CONTROL_BIT_MASK);
//					exec_error = Verif_Error(error_code);
//				} else
//					printf("%c Nao e um canal valido do SpW\n\r",
//							(char) cmd_pos[1]);
//				break;
//
//				/*
//				 * spw link start
//				 */
//			case '7':
//				if (cmd_pos[1] >= 'A' && cmd_pos[1] <= 'H') {
//					error_code = v_SpaceWire_Interface_Link_Control(
//							(char) cmd_pos[1], toInt(cmd_pos[2]),
//							SPWC_LINK_START_CONTROL_BIT_MASK);
//					exec_error = Verif_Error(error_code);
//				} else
//					printf("%c Nao e um canal valido do SpW\n\r",
//							(char) cmd_pos[1]);
//				break;
//
//				/*
//				 * spw link disable
//				 */
//			case '8':
//				if (cmd_pos[1] >= 'A' && cmd_pos[1] <= 'H') {
//					error_code = v_SpaceWire_Interface_Link_Control(
//							(char) cmd_pos[1], toInt(cmd_pos[2]),
//							SPWC_LINK_DISCONNECT_CONTROL_BIT_MASK);
//					exec_error = Verif_Error(error_code);
//				} else
//					printf("%c Nao e um canal valido do SpW\n\r",
//							(char) cmd_pos[1]);
//				break;

			/*
			 * Create a error management task and queue
			 */

//			error_code = OSQPost(p_simucam_command_q, (void *) exec_error);
//			alt_SSSErrorHandler(error_code, 0);
			exec_error = 0; /*restart error value*/

		}

		/*
		 * MEB in running mode
		 */
		while (b_meb_status == 1) {
			INT8U i_internal_error;
			static INT8U b_timer_starter = 0;
			exec_error = 0;

			printf("MEB in running mode\n\r");

			if (b_timer_starter == 0) {

				/*
				 * Initializing central control timer
				 */
				central_timer = OSTmrCreate(0, CENTRAL_TIMER_RESOLUTION,
				OS_TMR_OPT_PERIODIC, central_timer_callback_function,
						(void *) 0, (INT8U*) "Central Timer",
						(INT8U*) &exec_error);

				if (exec_error == OS_ERR_NONE) {
					/* Timer was created but NOT started */
					printf(
							"[CommandManagementTask]SWTimer1 was created but NOT started \n");
				}
			}

			/*
			 * Test variables
			 */

//			if (y == 1) {
//				OSTmrStart((OS_TMR *) central_timer,
//						(INT8U *) &i_internal_error);
//				if (i_internal_error == OS_ERR_NONE) {
//					b_timer_starter = 1;
//					printf("[CommandManagementTask]timer started\r\n");
//					y = 0;
//
//				}
//			}
//				p_payload = OSQPend(p_simucam_command_q, 0, &i_internal_error);
//				alt_uCOSIIErrorHandler(i_internal_error, 0);
//
//				printf("[CommandManagementTask]Payload received %i\r\n",
//						(INT8U) p_payload->type);
//
//				if (p_payload->type == 'k') {
//					OSTmrStop(central_timer,
//					OS_TMR_OPT_NONE, (void *) 0, &i_internal_error);
//
//					if (i_internal_error == OS_ERR_NONE
//							|| i_internal_error == OS_ERR_TMR_STOPPED) {
//						printf("[CommandManagementTask]Timer stopped\r\n");
//						i_central_timer_counter = 1;
//						printf("[CommandManagementTask]Timer restarted\r\n");
//					}
//				}
//			} else {
			p_payload = OSQPend(p_simucam_command_q, 0, &i_internal_error);
			alt_uCOSIIErrorHandler(i_internal_error, 0);

			if (p_payload->type == 106) {

				printf("[CommandManagementTask]Starting timer\r\n");

				OSTmrStart((OS_TMR *) central_timer,
						(INT8U *) &i_internal_error);
				if (i_internal_error == OS_ERR_NONE) {
					b_timer_starter = 1;
					printf("[CommandManagementTask]timer started\r\n");

					v_ack_creator(p_payload, ACK_OK);

					error_code = (INT8U) OSQPost(p_simucam_command_q,
							p_payload);
					alt_SSSErrorHandler(error_code, 0);
				}
			} else {

				switch (p_payload->type) {

				/*
				 * Change Simucam Mode
				 */
				case 105:
					printf("[CommandManagementTask]MEB status: %i\r\n",
							(INT8U) p_payload->data[0]);

					b_meb_status = 0;	//change this

					if (b_meb_status == 0) {
						/*
						 * Send sub_units to config.
						 */
						config_send->mode = 0;
						error_code = (INT8U) OSQPost(p_sub_unit_config_queue,
								config_send);
						alt_SSSErrorHandler(error_code, 0);
					}

					v_ack_creator(p_payload, ACK_OK);

					error_code = (INT8U) OSQPost(p_simucam_command_q,
							p_payload);
					alt_SSSErrorHandler(error_code, 0);
					break;

					/*
					 * Abort Sending
					 *
					 * Implement a abort queue
					 *
					 */
				case 107:
					printf("[CommandManagementTask]Selected command: %i\n\r",
							(int) p_payload->type);

					OSTmrStop(central_timer,
					OS_TMR_OPT_NONE, (void *) 0, &i_internal_error);

					if (i_internal_error == OS_ERR_NONE
							|| i_internal_error == OS_ERR_TMR_STOPPED) {
						printf("[CommandManagementTask]Timer stopped\r\n");
						i_central_timer_counter = 1;
//						i_imagette_counter = 0;
//						i_imagette_number = 0;
						printf("[CommandManagementTask]Timer restarted\r\n");

						v_ack_creator(p_payload, ACK_OK);
						error_code = (INT8U) OSQPost(p_simucam_command_q,
								p_payload);
						alt_SSSErrorHandler(error_code, 0);
					} else {
						v_ack_creator(p_payload, TIMER_ERROR);
						error_code = (INT8U) OSQPost(p_simucam_command_q,
								p_payload);
						alt_SSSErrorHandler(error_code, 0);
					}
					break;

					/*
					 * Direct send
					 */
				case 109:

					printf("[CommandManagementTask]Direct Send to %c\n\r",
							(char) (p_payload->data[0] + ASCII_A));

					error_code = b_SpaceWire_Interface_Send_SpaceWire_Data(
							(char) p_payload->data[0] + ASCII_A,
							&(p_payload->data[1]), (p_payload->size) - 11);

					if (i_echo_sent_data == 1) {
						i_echo_dataset_direct_send(p_payload, p_tx_buffer);

						exec_error = send(conn.fd, p_tx_buffer,
								p_payload->size+4,
								0);
					}

					if(exec_error == -1){
						v_ack_creator(p_payload, ECHO_ERROR);
					}else{
						v_ack_creator(p_payload, ACK_OK);
					}


					error_code = (INT8U) OSQPost(p_simucam_command_q,
							p_payload);
					alt_SSSErrorHandler(error_code, 0);

					break;

					/*
					 * Get HK
					 */
				case 110:
					printf("[CommandManagementTask]Get HK\r\n");

					v_HK_creator(p_payload, p_payload->data[0]);

					error_code = (INT8U) OSQPost(p_simucam_command_q,
							p_payload);
					alt_SSSErrorHandler(error_code, 0);
					break;

				default:
					printf(
							"[CommandManagementTask]Nenhum comando aceito em modo running\n\r");

					v_ack_creator(p_payload, COMMAND_NOT_ACCEPTED);

					error_code = (INT8U) OSQPost(p_simucam_command_q,
							p_payload);
					alt_SSSErrorHandler(error_code, 0);

					break;

				}

			}
		}
	}
}
