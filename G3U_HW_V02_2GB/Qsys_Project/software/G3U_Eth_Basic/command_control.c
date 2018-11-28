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

struct _imagette_control img_struct;

INT8U data[MAX_IMAGETTES];
INT8U *p_data_pos = &data[0];

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
 * @retval void
 **/
void v_parse_data(struct _ethernet_payload *p_payload,
		struct _imagette_control *p_img_ctrl) {
	INT32U i = 0;
	int p = 0;
	INT32U o = 0;
	INT32U d = 0;

	printf(
			"[PARSER]testando valores que chegaram\r\nsize: %i\r\ndata: %i,%i,%i,%i,%i,%i\r\n",
			p_payload->size, (char) p_payload->data[0],
			(char) p_payload->data[1], (char) p_payload->data[2],
			(char) p_payload->data[3], (char) p_payload->data[4],
			(char) p_payload->data[5]);

//	*p_img_ctrl->offset = toInt(p_payload->data[0]);
//	p_img_ctrl->imagette[0] = toInt(p_payload->data[1]);

	while (i < p_payload->size / (DELAY_SIZE + IMAGETTE_SIZE)) {
		p_img_ctrl->offset[i] = toInt(p_payload->data[o]);

		for (p = 0; p < IMAGETTE_SIZE; p++, d++) {
			p_img_ctrl->imagette[d] = toInt(p_payload->data[i + DELAY_SIZE + p]);
		}

		printf("[PARSER] offset %i: %i, data: %i\r\n", (int) o,
				(INT32U)p_img_ctrl->offset[0], (INT8U) p_img_ctrl->imagette[4]);
		o+=DELAY_SIZE + IMAGETTE_SIZE;
		i++;
		printf("[PARSER] offset counter %i\r\n", (int) o,
						(INT32U) i);
	}
	p_img_ctrl->size = d;
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
	static INT32U i_central_timer_counter = 1;
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
}

/*
 * Task used to parse and execute the commands received via ethernet. [yb]
 */

void CommandManagementTask() {

	INT8U error_code; /*uCOS error code*/
	INT8U exec_error; /*Internal error code for the command module*/

	INT8U* cmd_pos;
	INT8U cmd_char_buffer[SSS_TX_BUF_SIZE];
	//INT8U* cmd_char = cmd_char_buffer;

	static INT8U teste_byte = 1;
	struct _ethernet_payload payload;
	static struct _ethernet_payload *p_payload;
	p_payload = &payload;

//	struct _ethernet_payload test_payload;
//		static struct _ethernet_payload *p_test_payload;
//		p_payload  = &test_payload;

	struct _imagette_control *p_img_control;
	p_img_control = &img_struct;

	struct _sub_data sub_data;

	static struct _sub_data *p_sub_data;
	p_sub_data = &sub_data;

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
	static struct _sub_config *config_send;

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

	/*
	 * Test case for timers
	 */
	p_img_control->offset[0] = 2;
	p_img_control->offset[1] = 5;

	data[0] = 18;
	data[1] = 22;
	data[2] = 15;
	data[3] = 4;
	data[4] = 5;
	data[5] = 6;
	data[6] = 7;
	data[7] = 8;
	data[8] = 9;
	data[9] = 10;

	p_img_control->imagette[0] = data[0];
	p_img_control->imagette[1] = data[1];
	p_img_control->imagette[2] = data[2];
	p_img_control->imagette[3] = data[3];
	p_img_control->imagette[4] = data[4];
	p_img_control->imagette[5] = data[5];
	p_img_control->imagette[6] = data[6];
	p_img_control->imagette[7] = data[7];
	p_img_control->imagette[8] = data[8];
	p_img_control->imagette[9] = data[9];
	p_img_control->imagette[10] = data[10];

	printf("Imagette data 1: %i", (INT8U) p_img_control->imagette[0]);

//	printf("%x \n", &p_data_pos[0]);
//	printf("%x \n", &p_data_pos[1]);
//	printf("%x \n", &p_data_pos[2]);
//	printf("%x \n", &p_data_pos[3]);
//	printf("%x \n", &p_data_pos[4]);
//	printf("%x \n", &p_data_pos[5]);

	p_img_control->size = 2;

	//p_img_control->imagette_start[1] = &data_pos[5];

//	printf("%x \n", &img_struct.imagette_addr[0]);
//	printf("%x \n", &img_struct.imagette_addr[1]);
//	printf("%x \n", &img_struct.imagette_addr[2]);
//	printf("%x \n", &img_struct.imagette_addr[3]);
//
//	printf("SEPARADOR\n");
//
//	printf("%x \n", img_struct.imagette_addr[0]);
//	printf("%x \n", img_struct.imagette_addr[1]);
//	printf("%x \n", img_struct.imagette_addr[2]);
//	printf("%x \n", img_struct.imagette_addr[3]);

	while (1) {

		/*
		 * MEB in configuration mode.
		 * It's the default state
		 */
		while (b_meb_status == 0) {

			printf("MEB in config mode\n\r");
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
				error_code = (INT8U) OSQPost(p_sub_unit_config_queue,
						config_send);
				alt_SSSErrorHandler(error_code, 0);

				//Send a test byte through the cue
				error_code = (INT8U) OSQPost(p_sub_unit_command_queue,
						(INT8U) p_payload->sub_type);

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
//				p_sub_data->p_data_addr = &p_payload->data[0];
//				p_sub_data->i_data_size = p_payload->lenght[3]
//						+ 256 * p_payload->lenght[2]
//						+ 65536 * p_payload->lenght[1]
//						+ 4294967296 * p_payload->lenght[0]; /* Create function to calculate this */

//				printf("commd side data dump %c, %c, %c, %c\r\nSize: %i",
//						(char) p_sub_data->p_data_addr[0],
//						(char) p_sub_data->p_data_addr[1],
//						(char) p_sub_data->p_data_addr[2],
//						(char) p_sub_data->p_data_addr[3],
//						(int) p_sub_data->i_data_size);

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
				 * Parse data
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

			default:
				printf("Nenhum comando identificado\n\r");
				break;
			}

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
			//printf("MEB in running mode\n\r");

			printf("[CommandManagementTask]print offset: %i\r\n",
					(INT32U) p_img_control->offset[0]);

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
					printf("SWTimer1 was created but NOT started \n");
				}

				p_payload = OSQPend(p_simucam_command_q, 0, &i_internal_error);
				alt_uCOSIIErrorHandler(i_internal_error, 0);

				OSTmrStart((OS_TMR *) central_timer,
						(INT8U *) &i_internal_error);
				if (i_internal_error == OS_ERR_NONE) {
					b_timer_starter = 1;
					printf("[CommandManagementTask]timer started\r\n");
				}
			}
			//Encontrar um jeito melhor de manipular esse erro

			p_payload = OSQPend(p_simucam_command_q, 0, &i_internal_error);
			alt_uCOSIIErrorHandler(i_internal_error, 0);
			printf("[CommandManagementTask]Payload received %i\r\n",
					(INT8U) p_payload->type);

			//if (p_payload->type == 0) {
			OSTmrStop(central_timer,
			OS_TMR_OPT_NONE, (void *) 0, &i_internal_error);

			if (i_internal_error == OS_ERR_NONE
					|| i_internal_error == OS_ERR_TMR_STOPPED) {
				printf("[CommandManagementTask]Timer stopped\r\n");
			}

			/*
			 * Timer must be deleted for the values to be reseted
			 */
			OSTmrDel(central_timer, &i_internal_error);
			if (i_internal_error == OS_ERR_NONE
					|| i_internal_error == OS_ERR_TMR_STOPPED) {
				b_timer_starter = 0;
				printf("[CommandManagementTask]Timer deleted\r\n");
			}

			b_meb_status = 0;
			printf("[CommandManagementTask]Returning to MEB config\r\n");

			//}
			//osqaccept

			//printf("cmd_char dump %i\n\r", (INT8U) cmd_char);
		}

	}
}
