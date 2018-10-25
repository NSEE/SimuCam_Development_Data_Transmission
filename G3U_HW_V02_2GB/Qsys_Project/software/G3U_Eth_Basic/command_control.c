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
 * External OSQueues must be declared
 */
extern OS_EVENT *SimucamCommandQ;
extern OS_EVENT *SimucamDataQ;
extern OS_EVENT *p_sub_unit_command_queue;

/*
 * Task used to parse and execute the commands received via ethernet. [yb]
 */

void CommandManagementTask() {

	INT8U error_code;		/*uCOS error code*/
	INT8U exec_error;	/*Internal error code for the command module*/

	INT8U* cmd_pos;
	INT8U cmd_char;

	static INT8U data[SSS_TX_BUF_SIZE];
	INT8U* data_pos = data;

	static int size;

	int p;
	//teste
	int t;

	//INT32U cmd_addr = 0;
	//INT8U canal;

	while (1) {
		cmd_char = (INT8U) OSQPend(SimucamCommandQ, 0, &error_code);
		alt_uCOSIIErrorHandler(error_code, 0);
		cmd_pos = data_addr;
		static INT8U teste_byte = 1;
		int i = 0;

		/*
		 * Switch case to select from different command options.[yb]
		 * Will be modified to suit IWF's needs
		 */
		switch (cmd_pos[0]) {  /*Selector for commands and actions*/

		/*Loopback SpW config*/
		case '0':
			printf("Comando selecionado: %c\n\r", (char) cmd_pos[0]);
			error_code = OSQPost(p_sub_unit_command_queue, teste_byte);
				alt_SSSErrorHandler(error_code, 0);
//			if (cmd_pos[1] >= 'A' && cmd_pos[1] <= 'H') { /*Verify if the channel is valid*/
//				printf("Acessando canal %c do SpW\n\r", (char) cmd_pos[1]);
//				error_code = b_SpaceWire_Interface_Mode_Control(
//						(char) cmd_pos[1], toInt(cmd_pos[2]));
//				exec_error = Verif_Error(error_code);
//			} else
//				printf("%c Nao e um canal valido do SpW\n\r",
//						(char) cmd_pos[1]);

			break;

			/*
			 * Force specific transmission rate
			 */
		case '1':
			printf("Comando selecionado: %c\n\r", (char) cmd_pos[0]);

			if (cmd_pos[1] >= 'A' && cmd_pos[1] <= 'H') { /*Verify if the channel is valid*/

				printf("Acessando canal %c do SpW\n\r", (char) cmd_pos[1]);
				INT8U div;

				div = aatoh(&cmd_pos[2]);
				printf("Divider conversion: %u\n\r", div);
				error_code = b_SpaceWire_Interface_Set_TX_Div(
						(char) cmd_pos[1], aatoh(&cmd_pos[2]));
				exec_error = Verif_Error(error_code);

			} else {
				printf("%c Nao e um canal valido do SpW\n\r",
						(char) cmd_pos[1]);
			}

			break;

			/*
			 * send timecode via specific SpW link
			 */
		case '2':
			t =  aatoh(&cmd_pos[2]);
			p = 4;
			if (cmd_pos[1] >= 'A' && cmd_pos[1] <= 'H') {
				printf("n timecode: %i\n", t);
				for (i = 0; i < t; i++) {
					data[0] = aatoh(&cmd_pos[p]);
					printf("timecode[%i]: %u\n\r", i, data[0]);
					v_SpaceWire_Interface_Send_TimeCode(cmd_pos[1], data[0]);
					exec_error = Verif_Error(1);
					p += 2;
				}
			} else
				printf("%c Nao e um canal valido do SpW\n\r",
						(char) cmd_pos[1]);
			break;

			/*
			 * read timecode
			 */
		case '3':
			size = 1;
			if (cmd_pos[1] >= 'A' && cmd_pos[1] <= 'H') {
				data[0] = uc_SpaceWire_Interface_Get_TimeCode(cmd_pos[1]);

				//Size is fixed at 1 in this application

				error_code = OSQPost(SimucamDataQ, (void *)size);
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
					p+=2;
				}
			} else
				printf("%c Nao e um canal valido do SpW\n\r",
						(char) cmd_pos[1]);

			error_code = b_SpaceWire_Interface_Send_SpaceWire_Data(cmd_pos[1],
					data_pos, aatoh(&cmd_pos[2]));

			exec_error = Verif_Error(error_code);
			break;

			/*
			 * read data
			 */
		case '5':
			if (cmd_pos[1] >= 'A' && cmd_pos[1] <= 'H') {

				size = ui_SpaceWire_Interface_Get_SpaceWire_Data(
						cmd_pos[1], data_pos, 512);

				printf("size: %i\n", size);
				exec_error = Verif_Error(size);
				if (!exec_error)
					break;
				error_code = OSQPost(SimucamDataQ, (void *)size);
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
		error_code = OSQPost(SimucamCommandQ, (void *) exec_error);
		alt_SSSErrorHandler(error_code, 0);
		exec_error = 0;		/*restart error value*/
	}
}
