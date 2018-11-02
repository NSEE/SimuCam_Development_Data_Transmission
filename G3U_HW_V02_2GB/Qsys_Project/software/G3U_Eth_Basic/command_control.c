/*
 * command_control.c
 *
 *  Created on: Apr 26, 2018
 *      Author: yuribunduki
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "ucos_ii.h"
#include "os_cpu.h"
#include "simple_socket_server.h"
#include "alt_error_handler.h"
#include "utils/util.h"
#include "sub_unit_control.h"

/*
 * Include configurations for the communication modules [yb]
 */
#include "logic/comm/comm.h"

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
	static struct _ethernet_payload *p_payload;

	static INT8U data[SSS_TX_BUF_SIZE];
	INT8U* data_pos = data;

	static int size;

	int p;
	int i = 0;

	//INT32U cmd_addr = 0;
	//INT8U canal;

	/*
	 * Declaring the sub-units initial status
	 */
	static struct _sub_config *config_send;

	INT8U b_meb_status = 0; //default starting mode is config
	config_send->mode = 0; //default starting mode is config
	config_send->forward_data = 0;
	config_send->RMAP_handling = 0;

	while (1) {

		/*
		 * Forcing all sub-units to config mode
		 * Repeat to all 8 sub-units will be implemented once
		 * all subs will be functionnal
		 */
		error_code = (INT8U) OSQPost(p_sub_unit_config_queue, config_send);
		alt_SSSErrorHandler(error_code, 0);

		/*
		 * MEB in configuration mode.
		 * It's the default state
		 */
		while (b_meb_status == 0) {

			printf("MEB in config mode\n\r");
			/*
			 * Enter the receive command mode
			 */

			p_payload = (_ethernet_payload) OSQPend(p_simucam_command_q, 0, &error_code);
			alt_uCOSIIErrorHandler(error_code, 0);
			cmd_pos = data_addr;

			printf("teste do payload: %c,%c,%c,%c\n\r",
					(char) p_payload->command, (char) p_payload->data[0],
					(char) p_payload->data[1], (char) p_payload->data[2]);

			//printf("teste do novo cmd_char %c%c\n\r", (char) cmd_char[0], (char) cmd_char[1]);

			/*
			 * Switch case to select from different command options.[yb]
			 * Will be modified to suit IWF's needs
			 */
			switch (p_payload->command) { /*Selector for commands and actions*/

			/*Sub_unit test routine*/
			case '0':
				printf("Selected command: %c\n\r", (char) p_payload->command);

				//Change sub-unit to running mode
				error_code = (INT8U) OSQPost(p_sub_unit_config_queue,
						config_send);
				alt_SSSErrorHandler(error_code, 0);

				//Send a test byte through the cue
				error_code = (INT8U) OSQPost(p_sub_unit_command_queue,
						teste_byte);
				alt_SSSErrorHandler(error_code, 0);

				break;

				/*
				 * Sub-Unit configuration
				 */
			case '1':

				printf("Selected command: %c\n\r", (char) p_payload->command);

				config_send->mode = toInt(p_payload->data[0]);
				config_send->forward_data = toInt(p_payload->data[1]);
				config_send->RMAP_handling = toInt(p_payload->data[2]);

				error_code = (INT8U) OSQPost(p_sub_unit_config_queue,
						config_send);
				alt_SSSErrorHandler(error_code, 0);
				printf("Configurations sent: %i, %i, %i\r\n",
						(INT8U) config_send->mode,
						(INT8U) config_send->forward_data,
						(INT8U) config_send->RMAP_handling);

				break;

				/*
				 * MEB to running mode
				 */
			case '2':
				printf("Selected command: %c\n\r", (char) cmd_pos[0]);
				b_meb_status = 1;
				break;

			case '3':
				size = 1;
				if (cmd_pos[1] >= 'A' && cmd_pos[1] <= 'H') {
					data[0] = uc_SpaceWire_Interface_Get_TimeCode(cmd_pos[1]);

					//Size is fixed at 1 in this application

					error_code = OSQPost(SimucamDataQ, (void *) size);
					alt_SSSErrorHandler(error_code, 0);

					error_code = OSQPost(SimucamDataQ, data[0]);
					alt_SSSErrorHandler(error_code, 0);

					exec_error = Verif_Error(!error_code);

				} else
					printf("%c Nao e um canal valido do SpW\n\r",
							(char) cmd_pos[1]);
				break;

				/*
				 * send data
				 */
			case '4':
				p = 4;
				if (cmd_pos[1] >= 'A' && cmd_pos[1] <= 'H') {
					for (i = 0; i < aatoh(&cmd_pos[2]); i++) {
						data_pos[i] = aatoh(&cmd_pos[p]);
						p += 2;
					}
				} else
					printf("%c Nao e um canal valido do SpW\n\r",
							(char) cmd_pos[1]);

				error_code = b_SpaceWire_Interface_Send_SpaceWire_Data(
						cmd_pos[1], data_pos, aatoh(&cmd_pos[2]));

				exec_error = Verif_Error(error_code);
				break;

				/*
				 * read data
				 */
			case '5':
				if (cmd_pos[1] >= 'A' && cmd_pos[1] <= 'H') {

					size = ui_SpaceWire_Interface_Get_SpaceWire_Data(cmd_pos[1],
							data_pos, 512);

					printf("size: %i\n", size);
					exec_error = Verif_Error(size);
					if (!exec_error)
						break;
					error_code = OSQPost(SimucamDataQ, (void *) size);
					alt_SSSErrorHandler(error_code, 0);
					for (i = 0; i < size; i++) {
						error_code = OSQPost(SimucamDataQ, data_pos[i]);
						alt_SSSErrorHandler(error_code, 0);
					}
				} else
					printf("%c Nao e um canal valido do SpW\n\r",
							(char) cmd_pos[1]);
				break;

				/*
				 * spw autostart
				 */
			case '6':
				if (cmd_pos[1] >= 'A' && cmd_pos[1] <= 'H') {
					error_code = v_SpaceWire_Interface_Link_Control(
							(char) cmd_pos[1], toInt(cmd_pos[2]),
							SPWC_AUTOSTART_CONTROL_BIT_MASK);
					exec_error = Verif_Error(error_code);
				} else
					printf("%c Nao e um canal valido do SpW\n\r",
							(char) cmd_pos[1]);
				break;

				/*
				 * spw link start
				 */
			case '7':
				if (cmd_pos[1] >= 'A' && cmd_pos[1] <= 'H') {
					error_code = v_SpaceWire_Interface_Link_Control(
							(char) cmd_pos[1], toInt(cmd_pos[2]),
							SPWC_LINK_START_CONTROL_BIT_MASK);
					exec_error = Verif_Error(error_code);
				} else
					printf("%c Nao e um canal valido do SpW\n\r",
							(char) cmd_pos[1]);
				break;

				/*
				 * spw link disable
				 */
			case '8':
				if (cmd_pos[1] >= 'A' && cmd_pos[1] <= 'H') {
					error_code = v_SpaceWire_Interface_Link_Control(
							(char) cmd_pos[1], toInt(cmd_pos[2]),
							SPWC_LINK_DISCONNECT_CONTROL_BIT_MASK);
					exec_error = Verif_Error(error_code);
				} else
					printf("%c Nao e um canal valido do SpW\n\r",
							(char) cmd_pos[1]);
				break;

			default:
				printf("Nenhum comando identificado\n");
				break;
			}

			/*
			 * Create a error management task and queue
			 */

			//error_code = OSQPost(p_simucam_command_q, (void *) exec_error);
			//alt_SSSErrorHandler(error_code, 0);
			exec_error = 0; /*restart error value*/

		}

		/*
		 * MEB in running mode
		 */
		while (b_meb_status == 1) {

			//cmd_char = (_ethernet_payload) OSQAccept(p_simucam_command_q, &error_code);
			//alt_SSSErrorHandler(error_code, 0);
			printf("cmd_char dump %i\n\r", (INT8U) cmd_char);
		}

	}
}
