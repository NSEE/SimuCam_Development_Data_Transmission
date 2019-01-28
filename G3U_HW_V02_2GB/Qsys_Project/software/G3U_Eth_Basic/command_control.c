/*
 * command_control.c
 *
 *  Created on: Apr 26, 2018
 *      Author: yuribunduki
 */

#include "command_control.h"

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

struct imagette_control img_struct;

INT8U data[MAX_IMAGETTES];
INT8U *p_data_pos = &data[0];

INT32U i_central_timer_counter = 1;
INT8U exec_error;

INT16U i_id_accum = 0;

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
 * @retval int	0 if error, 1 if no error
 **/
int v_parse_data(struct _ethernet_payload *p_payload,
		struct imagette_control *p_img_ctrl) {
	INT32U i = 0;
	int p = 0;
	INT32U o = DATA_SHIFT;
	INT32U d = 0;
	INT32U error_verif = 0;

	printf(
			"[PARSER]testando valores do payload:\r\nsize: %i\r\ndata_payload: %i,%i,%i,%i,%i,%i\r\n",
			p_payload->size, (char) p_payload->data[8],
			(char) p_payload->data[9], (char) p_payload->data[10],
			(char) p_payload->data[11], (char) p_payload->data[12],
			(char) p_payload->data[13]);

//	*p_img_ctrl->offset = toInt(p_payload->data[0]);
//	p_img_ctrl->imagette[0] = toInt(p_payload->data[1]);

	p_img_ctrl->nb_of_imagettes = toInt(p_payload->data[3])
			+ 256 * toInt(p_payload->data[2]);

	printf("[PARSER] Number of imagettes: %i\r\n", p_img_ctrl->nb_of_imagettes);

	while (i < p_img_ctrl->nb_of_imagettes) {

		p_img_ctrl->offset[i] = toInt(p_payload->data[o + 3])
				+ 256 * toInt(p_payload->data[o + 2])
				+ 65536 * toInt(p_payload->data[o + 1])
				+ 4294967296 * toInt(p_payload->data[o]);

		p_img_ctrl->imagette_length[i] = toInt(
				p_payload->data[o + 5] + 256 * toInt(p_payload->data[o + 4]));

		error_verif += p_img_ctrl->imagette_length[i];

		printf("[PARSER] offset: %i\r\n[PARSER] length: %i\r\n",
				p_img_ctrl->offset[i], p_img_ctrl->imagette_length[i]);

		for (p = 0; p < p_img_ctrl->imagette_length[i]; p++, d++) {
			p_img_ctrl->imagette[d] = toInt(
					p_payload->data[o + DELAY_SIZE + p]);
			printf("[PARSER]Teste de recepcao: %i,%i\r\n", (INT32U) i,
					(INT8U) p_img_ctrl->imagette[d]);
		}

		printf("[PARSER] offset %i: %i, data: %i\r\n", (int) o,
				(INT32U) p_img_ctrl->offset[i],
				(INT8U) p_img_ctrl->imagette[i + p + DELAY_SIZE]);
		o += DELAY_SIZE + p_img_ctrl->imagette_length[i];
		i++;
		printf("[PARSER] offset counter: %i\r\n", (INT32U) i);
		printf("[PARSER] error verif: %i\r\n", (INT32U) error_verif);
	}
	p_img_ctrl->size = d;
	if (p_img_ctrl->size == error_verif) {
		return 1;
	} else
		return 0;
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
	static INT32U i_imagette_counter = 0;
	INT8U error_code = 0;

	printf("[CALLBACK]Entered callback\r\n next offset %i, counter %i\r\n",
			(INT32U) img_struct.offset[i_imagette_counter],
			(INT32U) i_central_timer_counter);

	if (img_struct.offset[i_imagette_counter] == i_central_timer_counter) {

		/*
		 * Enviar comando de envio para o sub-unit
		 */
		error_code = OSSemPost(sub_unit_command_semaphore);
		if (error_code == OS_ERR_NONE) {
			printf("[CALLBACK]Semaphore triggered\r\n");
			i_imagette_counter++;
		}
		printf("[CALLBACK]Entered function imagette count: %i\r\n",
				(INT32U) i_imagette_counter);
	}

	i_central_timer_counter++;

	if (i_imagette_counter == 5) {
		printf("[CALLBACK]Timer stopped\r\n");
		printf("[CALLBACK]Timer restarted\r\n");
		i_central_timer_counter = 1;
		i_imagette_counter = 0;
		error_code = OSTmrStop(central_timer,
		OS_TMR_OPT_NONE, (void *) 0, &error_code);

		if (error_code == OS_ERR_NONE || error_code == OS_ERR_TMR_STOPPED) {
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
	INT8U exec_error; /*Internal error code for the command module*/

	INT8U i_forward_data = 0;
	INT8U i_echo_sent_data = 0;

	INT8U* cmd_pos;
	INT8U cmd_char_buffer[SSS_TX_BUF_SIZE];
	//INT8U* cmd_char = cmd_char_buffer;

	struct _ethernet_payload payload;
	static struct _ethernet_payload *p_payload;
	p_payload = &payload;

	struct imagette_control *pRAMData;
	alt_u32 Ddr2Base;
	alt_u32 ByteLen;

	DDR2_SWITCH_MEMORY(DDR2_M1_ID);
	Ddr2Base = DDR2_EXTENDED_ADDRESS_WINDOWED_BASE;
	ByteLen = DDR2_M1_MEMORY_SIZE;
	pRAMData = (struct imagette_control *) Ddr2Base;

//	struct _ethernet_payload test_payload;
//		static struct _ethernet_payload *p_test_payload;
//		p_payload  = &test_payload;

	struct imagette_control *p_img_control;
	p_img_control = &img_struct;

//	struct _sub_data sub_data;
//
//	static struct _sub_data *p_sub_data;
//	p_sub_data = &sub_data;

//INT8U data[SSS_TX_BUF_SIZE];

	static int size;

	int p;
	int i = 0;

//	printf("%x \n", &img_struct.imagette_addr[0]);
//	printf("%x \n", &img_struct.imagette_addr[1]);
//	printf("%x \n", &img_struct.imagette_addr[2]);
//	printf("%x \n", &img_struct.imagette_addr[3]);
//
//	printf("SEPARADOR");
//
//	printf("%x \n", img_struct.imagette_addr[0]);
//	printf("%x \n", img_struct.imagette_addr[1]);
//	printf("%x \n", img_struct.imagette_addr[2]);
//	printf("%x \n", img_struct.imagette_addr[3]);
	/*
	 * Declaring the sub-units initial status
	 */
	static struct sub_config *config_send;

	INT8U b_meb_status = 0; //default starting mode is config
	config_send->mode = 0; //default starting mode is config
	config_send->forward_data = 0;
	config_send->RMAP_handling = 0;

	/*
	 * Forcing all sub-units to config mode
	 * Repeat to all 8 sub-units will be implemented once
	 * all subs will be functionnal
	 */
	error_code = (INT8U) OSQPost(p_sub_unit_config_queue, config_send);
	alt_SSSErrorHandler(error_code, 0);

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
			cmd_pos = data_addr;
			printf(
					"[CommandManagementTask]teste do payload: %c,%c,%c,%c,%c,%c\n\r",
					(char) p_payload->type, (char) p_payload->data[0],
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

				/*
				 * Ack packet model
				 */
				p_payload->data[0] = 2;
				p_payload->data[1] = i_id_accum;
				p_payload->data[2] = 201;
				p_payload->data[3] = 0;
				p_payload->data[4] = 0;
				p_payload->data[5] = 0;
				p_payload->data[6] = 10;
				p_payload->data[7] = p_payload->packet_id;
				p_payload->data[8] = p_payload->type;
				p_payload->data[9] = ACK_OK;
				p_payload->size = 10;

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);
				i_id_accum++;

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

				b_meb_status = 1;
				printf("[CommandManagementTask]MEB sent to running\n\r");

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
				printf("[CommandManagementTask]Sent config for test case\n\r");

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
				printf("[CommandManagementTask]Selected command: %c\n\r",
						(char) p_payload->type);

				/* Add a case for channel selection */

				config_send->mode = toInt(p_payload->data[0]);
				config_send->forward_data = toInt(p_payload->data[1]);
				config_send->RMAP_handling = toInt(p_payload->data[2]);

//				error_code = (INT8U) OSQPost(p_sub_unit_config_queue,
//						config_send);
//				alt_SSSErrorHandler(error_code, 0);
				printf(
						"[CommandManagementTask]Configurations sent: %i, %i, %i\r\n",
						(INT8U) config_send->mode,
						(INT8U) config_send->forward_data,
						(INT8U) config_send->RMAP_handling);

				break;

				/*
				 * Receive and Parse data
				 * char: f
				 */
			case 102:
				printf("[CommandManagementTask]Selected command: %c\n\r",
						(char) p_payload->type);

				v_parse_data(p_payload, p_img_control);
				printf(
						"[CommandManagementTask]Teste de parser byte: %i\n\r offset %i\r\nsize: %i\n\r",
						(INT8U) p_img_control->imagette[4],
						(INT32U) p_img_control->offset[0],
						(INT32U) p_img_control->size);

				printf("[CommandManagementTask]Data parsed correctly\r\n");

				break;

				/*
				 * Delete Data
				 * char: g
				 */
			case 103:

				break;

				/*
				 * Select data to send
				 * char: h
				 */
			case 104:

				break;

				/*
				 * Change Simucam Modes
				 * char: i
				 */
			case 105:
				printf("[CommandManagementTask]Selected command: %c\n\r",
						(char) p_payload->type);

				b_meb_status = toInt(p_payload->data[0]);
				//b_meb_status = toInt(p_payload->data[0]);
				printf("[CommandManagementTask]MEB sent to running\n\r");

				break;

				/*
				 * Clear RAM
				 */
			case 108:
				printf("[CommandManagementTask]Selected command: %c\n\r",
						(int) p_payload->type);

				break;

				/*
				 * Direct send
				 */

			case 109:
				/*
				 * Verificar se realmente funciona,
				 * mas não tem porque não funcionar...
				 */
				error_code = b_SpaceWire_Interface_Send_SpaceWire_Data((char)toupper(p_payload->data[0]),
						&(p_payload->data[1]),
						(p_payload->size)-11);

				break;

				/*
				 * Get HK
				 */
			case 110:

				/*
				 * Next version
				 */

				break;

				/*
				 * Config MEB
				 */
			case 111:
				printf("[CommandManagementTask]Selected command: %c\n\r",
						(int) p_payload->type);
				i_forward_data = p_payload->data[0];
				i_echo_sent_data = p_payload->data[1];

				break;

			default:
				printf(
						"[CommandManagementTask]Nenhum comando identificado\n\r");
				INT8U i_type_buffer = p_payload->type;
				INT16U i_id_buffer = p_payload->packet_id;

				p_payload->header = 2;
//			p_payload->data[0] = i_id_buffer; //converter em 2 bytes
				p_payload->data[1] = i_type_buffer;
				p_payload->data[2] = COMMAND_NOT_FOUND;	//insert error for no command found

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

			printf("MEB in running mode\n\r");

			error_code = (INT8U) OSQPost(p_sub_unit_config_queue, config_send);
			alt_SSSErrorHandler(error_code, 0);

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

			p_payload = OSQPend(p_simucam_command_q, 0, &i_internal_error);
			alt_uCOSIIErrorHandler(i_internal_error, 0);

			if (p_payload->type == 106) {
				OSTmrStart((OS_TMR *) central_timer,
						(INT8U *) &i_internal_error);
				if (i_internal_error == OS_ERR_NONE) {
					b_timer_starter = 1;
					printf("[CommandManagementTask]timer started\r\n");
				}

				p_payload = OSQPend(p_simucam_command_q, 0, &i_internal_error);
				alt_uCOSIIErrorHandler(i_internal_error, 0);

				printf("[CommandManagementTask]Payload received %i\r\n",
						(INT8U) p_payload->type);

				if (p_payload->type == 'k') {
					OSTmrStop(central_timer,
					OS_TMR_OPT_NONE, (void *) 0, &i_internal_error);

					if (i_internal_error == OS_ERR_NONE
							|| i_internal_error == OS_ERR_TMR_STOPPED) {
						printf("[CommandManagementTask]Timer stopped\r\n");
						i_central_timer_counter = 1;
						printf("[CommandManagementTask]Timer restarted\r\n");
					}
				}
			}

			switch (p_payload->type) {
			case 105:
				printf("[CommandManagementTask]Return to config\r\n");
				b_meb_status = 0;
				break;

			case 107:
				OSTmrStop(central_timer,
				OS_TMR_OPT_NONE, (void *) 0, &i_internal_error);

				if (i_internal_error == OS_ERR_NONE
						|| i_internal_error == OS_ERR_TMR_STOPPED) {
					printf("[CommandManagementTask]Timer stopped\r\n");
					i_central_timer_counter = 1;
					printf("[CommandManagementTask]Timer restarted\r\n");
				}
				break;
			}

		}
	}
}
