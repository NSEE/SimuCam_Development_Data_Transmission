/******************************************************************************
 * Copyright (c) 2006 Altera Corporation, San Jose, California, USA.           *
 * All rights reserved. All use of this software and documentation is          *
 * subject to the License Agreement located at the end of this file below.     *
 *******************************************************************************
 * Date - October 24, 2006                                                     *
 * Module - simple_socket_server.c                                             *
 *                                                                             *
 ******************************************************************************/

/******************************************************************************
 * Simple Socket Server (SSS) example. 
 * 
 * This example demonstrates the use of MicroC/OS-II running on NIOS II.       
 * In addition it is to serve as a good starting point for designs using       
 * MicroC/OS-II and Altera NicheStack TCP/IP Stack - NIOS II Edition.                                          
 *                                                                             
 * -Known Issues                                                             
 *     None.   
 *      
 * Please refer to the Altera NicheStack Tutorial documentation for details on this 
 * software example, as well as details on how to configure the NicheStack TCP/IP 
 * networking stack and MicroC/OS-II Real-Time Operating System.  
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h> 

/* MicroC/OS-II definitions */
#include "includes.h"

/* Simple Socket Server definitions */
#include "simple_socket_server.h"                                                                    
#include "alt_error_handler.h"

#include "driver/leds/leds.h"

/*sub-unit definitions*/
#include "sub_unit_control.h"

/* Command control definitions*/
#include "command_control.h"

/*
 * Global handles (pointers) to our MicroC/OS-II resources. All of resources 
 * beginning with "SSS" are declared and created in this file.
 */

static struct _ethernet_payload *p_payload;
SSSConn conn;

/*
 * Creation of the queue for receive/command communication [yb]
 */

OS_EVENT *p_simucam_command_q;
struct _ethernet_payload *p_simucam_command_q_table[3]; /*Storage for SimucamCommandQ */

/*
 * Configuration of the sub-unit management task
 */
#define SUB_UNIT_TASK_PRIORITY 7
OS_STK sub_unit_task_stack[TASK_STACKSIZE];

/*
 * Configuration of the simucam command management task[yb]
 */

#define COMMAND_MANAGEMENT_TASK_PRIORITY 6
OS_STK CommandManagementTaskStk[TASK_STACKSIZE];

/*
 * Configuration of the simucam data queue[yb]
 */

OS_EVENT *SimucamDataQ;
INT8U *SimucamDataQTbl[SSS_TX_BUF_SIZE]; /*Storage for SimucamCommandQ */

INT8U *data_addr;

/*
 * Create the Simucam command queue
 */

void SimucamCreateOSQ(void) {
	p_simucam_command_q = OSQCreate(&p_simucam_command_q_table[0],
	SSS_TX_BUF_SIZE);

	if (!p_simucam_command_q) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create Simucam Command Queue.\n");
	} else {
		printf("Simucam Command Queue created successfully.\r\n");
	}
}

/*
 * Create the Simucam data queue
 */
void DataCreateOSQ(void) {
	SimucamDataQ = OSQCreate(&SimucamDataQTbl[0], SSS_TX_BUF_SIZE);

	if (!SimucamDataQ) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create SimucamDataQ.\n");
	} else {
		printf("SimucamDataQ created successfully.\r\n");
	}
}

/* This function creates tasks used in this example which do not use sockets.
 * Tasks which use Interniche sockets must be created with TK_NEWTASK.
 */

void SSSCreateTasks(void) {
	INT8U error_code;

	/*
	 * Creating the command management task [yb]
	 */
	error_code = OSTaskCreateExt(CommandManagementTask,
	NULL, (void *) &CommandManagementTaskStk[TASK_STACKSIZE - 1],
	COMMAND_MANAGEMENT_TASK_PRIORITY,
	COMMAND_MANAGEMENT_TASK_PRIORITY, CommandManagementTaskStk,
	TASK_STACKSIZE,
	NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the sub_unit 1 management task [yb]
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task,
	NULL, (void *) &sub_unit_task_stack[TASK_STACKSIZE - 1],
	SUB_UNIT_TASK_PRIORITY,
	SUB_UNIT_TASK_PRIORITY, sub_unit_task_stack,
	TASK_STACKSIZE,
	NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	printf("Tasks created successfully\r\n");
}

/*
 * sss_reset_connection()
 * 
 * This routine will, when called, reset our SSSConn struct's members 
 * to a reliable initial state. Note that we set our socket (FD) number to
 * -1 to easily determine whether the connection is in a "reset, ready to go" 
 * state.
 */
void sss_reset_connection(SSSConn* conn) {
	memset(conn, 0, sizeof(SSSConn));

	conn->fd = -1;
	conn->state = READY;
	conn->rx_wr_pos = conn->rx_buffer;
	conn->rx_rd_pos = conn->rx_buffer;
	return;
}

/*
 * sss_send_menu()
 * 
 * This routine will transmit the commands menu out to the telnet client. [yb]
 */
void sss_send_menu(SSSConn* conn) {
	char tx_buf[SSS_TX_BUF_SIZE];
	char *tx_wr_pos = tx_buf;
//
//	tx_wr_pos += sprintf(tx_wr_pos, "=================================\n\r");
//	tx_wr_pos += sprintf(tx_wr_pos, "Simucam Ethernet Commands Menu\n\r");
//	tx_wr_pos += sprintf(tx_wr_pos, "=================================\n\r");
//	tx_wr_pos +=
//			sprintf(tx_wr_pos,
//					"Todos os numeros devem ser enviados em HEX, menos o numero do comando. "
//							"On/Off deve ser enviado como um 1 ou um 0 respectivamente \n\r");
//	tx_wr_pos += sprintf(tx_wr_pos, "=================================\n\r");
//	tx_wr_pos += sprintf(tx_wr_pos, "0: Teste da Sub-unidade\n\r");
//	tx_wr_pos += sprintf(tx_wr_pos,
//			"1: Sub-unit configuration(mode,forward data,handling)\n\r");
//	tx_wr_pos += sprintf(tx_wr_pos, "2: Write Timecodes(CH, N, TIMECODE)\n\r");
//	tx_wr_pos += sprintf(tx_wr_pos, "3: Read Timecode(CH)\n\r");
//	tx_wr_pos += sprintf(tx_wr_pos, "4: Write Data (CH, N, DATA)\n\r");
//	tx_wr_pos += sprintf(tx_wr_pos, "5: Read Data (CH)\n\r");
//	tx_wr_pos += sprintf(tx_wr_pos, "6: Set SpW Autostart (CH, On/Off)\n\r");
//	tx_wr_pos += sprintf(tx_wr_pos, "7: Set SpW Linkstart (CH, On/Off)\n\r");
//	tx_wr_pos += sprintf(tx_wr_pos, "8: Set SpW LinkDisable (CH, On/Off)\n\r");
//	tx_wr_pos += sprintf(tx_wr_pos, "Q: Sair\n\r");
//	tx_wr_pos += sprintf(tx_wr_pos, "=================================\n\r");
//	tx_wr_pos += sprintf(tx_wr_pos, "Enter your choice & press return:\n\r");
//
//	send(conn->fd, tx_buf, tx_wr_pos - tx_buf, 0);

	return;
}

/*
 * sss_handle_accept()
 * 
 * This routine is called when ever our listening socket has an incoming
 * connection request. Since this example has only data transfer socket, 
 * we just look at it to see whether its in use... if so, we accept the 
 * connection request and call the telent_send_menu() routine to transmit
 * instructions to the user. Otherwise, the connection is already in use; 
 * reject the incoming request by immediately closing the new socket.
 * 
 * We'll also print out the client's IP address.
 */
void sss_handle_accept(int listen_socket, SSSConn* conn) {
	int socket, len;
	struct sockaddr_in incoming_addr;

	len = sizeof(incoming_addr);

	if ((conn)->fd == -1) {
		if ((socket = accept(listen_socket, (struct sockaddr* )&incoming_addr,
				&len)) < 0) {
			alt_NetworkErrorHandler(EXPANDED_DIAGNOSIS_CODE,
					"[sss_handle_accept] accept failed");
		} else {
			(conn)->fd = socket;
			sss_send_menu(conn);
			printf("[sss_handle_accept] accepted connection request from %s\n",
					inet_ntoa(incoming_addr.sin_addr));
		}
	} else {
		printf("[sss_handle_accept] rejected connection request from %s\n",
				inet_ntoa(incoming_addr.sin_addr));
	}

	return;
}

/*
 * sss_exec_command()
 * 
 * This routine is called whenever we have new, valid receive data from our 
 * sss connection. It will parse through the data simply looking for valid
 * commands to the sss server.
 * 
 * Incoming commands to talk to the board LEDs are handled by sending the 
 * MicroC/OS-II SSSLedCommandQ a pointer to the value we received.
 * 
 * If the user wishes to quit, we set the "close" member of our SSSConn
 * struct, which will be looked at back in sss_handle_receive() when it 
 * comes time to see whether to close the connection or not.
 */
void sss_exec_command(SSSConn* conn) {

	INT8U error_code;

//	int bytes_to_process = conn->rx_wr_pos - conn->rx_rd_pos;

//	char tx_buf[SSS_TX_BUF_SIZE];
//	char* tx_wr_pos = tx_buf;

	/*
	 * Values passed in the queue must be static -> intCommand [yb]
	 */

//	INT8U q_error;
//
//	INT32U command;
//	static INT8U intCommand[SSS_TX_BUF_SIZE];
//	INT8U* cmd_pos = intCommand;
//	int i = 0;
//	static int puta = 0;
	/*
	 * Isolate the command from garbage. And terminate the process if need be.[yb]
	 //	 */
//	while (bytes_to_process--) {
//		command = *(conn->rx_rd_pos++);
//
//		if (command == CMD_QUIT) {
//			tx_wr_pos += sprintf(tx_wr_pos, "Terminating connection.\n\n\r");
//			conn->close = 1;
//			puta = 0;
//			return;
//		}
//
//		//Verify and ignore entries that aren't alphanumeric[yb]
////		if ( isdigit(command) || isalpha(command)) {
//		cmd_pos[i] = command;
//		printf("[SSS]Data in buffer: %i\r\n", (INT8U) cmd_pos[i]);
//		i++;
////		}
//
//	}
//	printf("[SSS]crc %i\r\n", (INT16U) crc16(cmd_pos[0], i + 1));
//	if (puta == 0) {
//
//		printf("[SSS]First run\r\n");
//
//		/*
//		 * Criar ponteiro ligado aos endere�os da RAM para poder manipular
//		 * os dados. Estocar tudo direto na RAM? Ou s� os dados das imagettes?
//		 */
//
//		/* Populating the payload struct */
//
//		p_payload->header = cmd_pos[0 + EMPIRICAL_BUFFER_MIN];
//		p_payload->packet_id = cmd_pos[1 + EMPIRICAL_BUFFER_MIN]
//				+ 256 * cmd_pos[2 + EMPIRICAL_BUFFER_MIN];
//		p_payload->type = cmd_pos[3 + EMPIRICAL_BUFFER_MIN];
//		p_payload->size = toInt(cmd_pos[7 + EMPIRICAL_BUFFER_MIN])
//				+ 256 * toInt(cmd_pos[6 + EMPIRICAL_BUFFER_MIN])
//				+ 65536 * toInt(cmd_pos[5 + EMPIRICAL_BUFFER_MIN])
//				+ 4294967296 * toInt(cmd_pos[4 + EMPIRICAL_BUFFER_MIN]);
//
//		printf("[SSS]Payload size: %i\r\n", (INT32U) p_payload->size);
//
//		if (p_payload->size > 10) {
//
//			for (i = 1; i <= p_payload->size - (PROTOCOL_OVERHEAD + 3); i++) {
//				p_payload->data[i - 1] = cmd_pos[i + PROTOCOL_OVERHEAD
//						+ EMPIRICAL_BUFFER_MIN];
//				printf("[SSS]data: %c\r\nPing %i\r\n",
//						(char) cmd_pos[i + PROTOCOL_OVERHEAD
//								+ EMPIRICAL_BUFFER_MIN], (INT8U) i);
//			}
//			p_payload->crc = toInt(
//					cmd_pos[p_payload->size + PROTOCOL_OVERHEAD + 1
//							+ EMPIRICAL_BUFFER_MIN])
//					+ 256
//							* toInt(
//									cmd_pos[p_payload->size + PROTOCOL_OVERHEAD
//											+ EMPIRICAL_BUFFER_MIN]);
//		}
//		puta++;
//	} else {
//	printf("[SSS]Second run\r\n");
//	/* Populating the payload struct */
//
//	p_payload->header = cmd_pos[0];
//	p_payload->packet_id = cmd_pos[1] + 256 * cmd_pos[2];
//	p_payload->type = cmd_pos[3];
//	p_payload->size = cmd_pos[7] + 256 * cmd_pos[6] + 65536 * cmd_pos[5]
//			+ 4294967296 * cmd_pos[4];
//
//	printf("[SSS]Payload size: %i\r\n", (INT32U) p_payload->size);
//
//	if (p_payload->size > 10) {
//
//		for (i = 1; i <= p_payload->size - (PROTOCOL_OVERHEAD + 3); i++) {
//			p_payload->data[i - 1] = cmd_pos[i + PROTOCOL_OVERHEAD];
//			printf("[SSS]data: %c\r\nPing %i\r\n",
//					(char) p_payload->data[i - 1], (INT8U) i);
//		}
//		p_payload->crc = cmd_pos[p_payload->size]
//				+ 256 * cmd_pos[p_payload->size - 1];
//	}
////	}
//	//data_addr = cmd_pos;
//
//	printf("[SSS]Socket side teste do payload:\r\nsize %i,%c,%c\r\n",
//			(INT32U) p_payload->size, (int) p_payload->type,
//			(int) p_payload->data[0]);
//
//	error_code = OSQPost(p_simucam_command_q, p_payload);
//	alt_SSSErrorHandler(error_code, 0);
//	error_code = OSQPost(p_simucam_command_q, p_payload);
//	alt_SSSErrorHandler(error_code, 0);
	/*
	 * Error code verification for the commands[yb]
	 */

//	p_payload = (INT8U) OSQPend(p_simucam_command_q, 0, &error_code);
//	alt_SSSErrorHandler(error_code, 0);
//
//	send(conn->fd, p_payload->data, p_payload->size, 0);
	return;
}

/*
 * sss_handle_receive()
 * 
 * This routine is called whenever there is a sss connection established and
 * the socket assocaited with that connection has incoming data. We will first
 * look for a newline "\n" character to see if the user has entered something 
 * and pressed 'return'. If there is no newline in the buffer, we'll attempt
 * to receive data from the listening socket until there is.
 * 
 * The connection will remain open until the user enters "Q\n" or "q\n", as
 * deterimined by repeatedly calling recv(), and once a newline is found, 
 * calling sss_exec_command(), which will determine whether the quit 
 * command was received.
 * 
 * Finally, each time we receive data we must manage our receive-side buffer.
 * New data is received from the sss socket onto the head of the buffer,
 * and popped off from the beginning of the buffer with the 
 * sss_exec_command() routine. Aside from these, we must move incoming
 * (un-processed) data to buffer start as appropriate and keep track of 
 * associated pointers.
 */
void sss_handle_receive(SSSConn* conn) {
	int data_used = 0, rx_code = 0;
	char *lf_addr;

	int i = 0;
	alt_u32 Ddr2Base_eth_buffer = SSSBUFFER_ADDR;
	INT8U error_code = 0;
	INT16U calculated_crc = 0;

//	struct ethernet_buffer buffer;
	struct ethernet_buffer *p_ethernet_buffer;
//	p_ethernet_buffer = &buffer;

	DDR2_SWITCH_MEMORY(DDR2_M1_ID);

	p_ethernet_buffer = (struct p_ethernet_buffer *) Ddr2Base_eth_buffer;

	p_ethernet_buffer->rx_rd_pos = p_ethernet_buffer->rx_buffer;
	p_ethernet_buffer->rx_wr_pos = p_ethernet_buffer->rx_buffer;

//	static struct _ethernet_payload *p_payload;

	conn->rx_rd_pos = conn->rx_buffer;
	conn->rx_wr_pos = conn->rx_buffer;

	printf("[sss_handle_receive] processing RX data\n");

	while (conn->state != CLOSE) {

//		printf(
//				"[sss_handle_receive DEBUG]Comeco::rx_rd_pos: %x \r\nrx_wr_pos: %x\r\n",
//				p_ethernet_buffer->rx_rd_pos, p_ethernet_buffer->rx_wr_pos);

		printf("[sss_handle_receive DEBUG]Waiting transmission...\n");

		rx_code = recv(conn->fd, (char* )p_ethernet_buffer->rx_rd_pos, 8, 0);

		if (rx_code > 0) {
			p_ethernet_buffer->rx_rd_pos += rx_code;

			/* Zero terminate so we can use string functions */
			*(p_ethernet_buffer->rx_wr_pos + 1) = 0;
		}

		printf("Printing all bytes: ");

		for (int j = 0; j < 8; j++) {
			printf("%i ", (int) p_ethernet_buffer->rx_buffer[j]);
		}

		printf("\n");

		if (p_ethernet_buffer->rx_buffer[0] == EXIT_CODE) {
			conn->close = 1;
		} else {

			printf("[sss_handle_receive DEBUG]Print size bytes: %i %i %i %i\n",
					(int) p_ethernet_buffer->rx_buffer[7],
					(int) p_ethernet_buffer->rx_buffer[6],
					(int) p_ethernet_buffer->rx_buffer[5],
					(int) p_ethernet_buffer->rx_buffer[4]);

			p_payload->header = p_ethernet_buffer->rx_buffer[0];
			p_payload->packet_id = p_ethernet_buffer->rx_buffer[2]
					+ 256 * p_ethernet_buffer->rx_buffer[1];
			p_payload->type = p_ethernet_buffer->rx_buffer[3];

			p_payload->size = p_ethernet_buffer->rx_buffer[7]
					+ 256 * p_ethernet_buffer->rx_buffer[6]
					+ 65536 * p_ethernet_buffer->rx_buffer[5]
					+ 4294967296 * p_ethernet_buffer->rx_buffer[4];

			printf("[sss_handle_receive DEBUG] calculating size = %i\n",
					(INT32U) p_payload->size);

			rx_code = recv(conn->fd, (char* )p_ethernet_buffer->rx_wr_pos,
					p_payload->size - 8, 0);
			if (rx_code > 0) {
				p_ethernet_buffer->rx_wr_pos += rx_code;

				/* Zero terminate so we can use string functions */
				*(p_ethernet_buffer->rx_wr_pos + 1) = 0;
			}

			/*
			 * Assign data in the payload struct to data in the buffer
			 * change to 0
			 */
			if (p_payload->size > 10) {
				for (i = 1; i <= p_payload->size - 10; i++) {
					p_payload->data[i - 1] =
							p_ethernet_buffer->rx_buffer[i - 1];
//					printf("[sss_handle_receive DEBUG]data: %i\r\nPing %i\r\n",
//							(INT8U) p_payload->data[i - 1], (INT8U) i);
				}
			}

			printf("[sss_handle_receive DEBUG]Printing buffer = ");
			for (int k = 0; k < p_payload->size - 8; k++) {
				printf("%i ", (INT8U) p_ethernet_buffer->rx_buffer[k]);
			}
			printf("\r\n");

			printf(
					"[sss_handle_receive DEBUG]Print data types:\r\nHeader: %i\r\nID %i\r\n"
							"Type: %i\r\n", (int) p_payload->header,
					(int) p_payload->packet_id, (int) p_payload->type);

			p_payload->crc = p_ethernet_buffer->rx_buffer[p_payload->size]
					+ 256 * p_ethernet_buffer->rx_buffer[p_payload->size - 1];

			printf("[sss_handle_receive DEBUG]Received CRC = %i\n",
					(INT16U) p_payload->crc);

			calculated_crc = crc16(p_ethernet_buffer->rx_buffer,
					p_payload->size);

			printf("[sss_handle_receive DEBUG]Calculated CRC = %i\n",
					(INT16U) calculated_crc);

//		printf("[sss_handle_receive DEBUG]Print received data bytes 0: %i\n",
//				(INT8U) p_payload->data[0]);

			printf("[sss_handle_receive DEBUG]finished receiving\n");

			error_code = OSQPost(p_simucam_command_q, p_payload);
			alt_SSSErrorHandler(error_code, 0);

			printf("[sss_handle_receive DEBUG]Waiting CC response...\n");

			p_payload = (INT8U) OSQPend(p_simucam_command_q, 0, &error_code);
			alt_SSSErrorHandler(error_code, 0);

			send(conn->fd, p_payload->data, p_payload->size, 0);

//			sss_exec_command(conn);

//			printf("[sss_handle_receive DEBUG]Returned from function\n");
		}

//		/* Find the Carriage return which marks the end of the header */
//		lf_addr = strchr((const char*) conn->rx_buffer, '\n');
//
//		if (lf_addr) {
//			/* go off and do whatever the user wanted us to do */
//			sss_exec_command(conn);
//		}
//		/* No newline received? Then ask the socket for data */
//		else {
//			rx_code = recv(conn->fd, (char* )conn->rx_wr_pos,
//					SSS_RX_BUF_SIZE - (conn->rx_wr_pos - conn->rx_buffer) -1,
//					0);
//
//			if (rx_code > 0) {
//				conn->rx_wr_pos += rx_code;
//
//				/* Zero terminate so we can use string functions */
//				*(conn->rx_wr_pos + 1) = 0;
//			}
//		}

		/*
		 * When the quit command is received, update our connection state so that
		 * we can exit the while() loop and close the connection
		 */
		conn->state = conn->close ? CLOSE : READY;

		printf("[sss_handle_receive DEBUG]connection state checked\n");

		/* Manage buffer */

//		printf(
//				"[sss_handle_receive DEBUG]Antes::rx_rd_pos: %x \r\nrx_wr_pos: %x\r\n",
//				p_ethernet_buffer->rx_rd_pos, p_ethernet_buffer->rx_wr_pos);
		data_used = conn->rx_rd_pos - conn->rx_buffer;
		p_ethernet_buffer->rx_rd_pos = p_ethernet_buffer->rx_buffer;
		p_ethernet_buffer->rx_wr_pos = p_ethernet_buffer->rx_buffer;
		memset(p_ethernet_buffer->rx_wr_pos, 0, p_payload->size);

//		printf(
//				"[sss_handle_receive DEBUG]Depois::rx_rd_pos: %x \r\nrx_wr_pos: %x\r\n",
//				p_ethernet_buffer->rx_rd_pos, p_ethernet_buffer->rx_wr_pos);
//
//		printf("[sss_handle_receive DEBUG]Printing buffer after memset = ");
//		for (int k = 0; k < p_payload->size - 8; k++) {
//			printf("%i ", (INT8U) p_ethernet_buffer->rx_buffer[k]);
//		}
//		printf("\r\n");

//
//		data_used = conn->rx_rd_pos - conn->rx_buffer;
//		memmove(conn->rx_buffer, conn->rx_rd_pos,
//				conn->rx_wr_pos - conn->rx_rd_pos);
//		conn->rx_rd_pos = conn->rx_buffer;
//		conn->rx_wr_pos -= data_used;
//		memset(conn->rx_wr_pos, 0, data_used);
	}

	printf("[sss_handle_receive] closing connection\n");
	close(conn->fd);
	sss_reset_connection(conn);

	return;
}

/*
 * SSSSimpleSocketServerTask()
 * 
 * This MicroC/OS-II thread spins forever after first establishing a listening
 * socket for our sss connection, binding it, and listening. Once setup,
 * it perpetually waits for incoming data to either the listening socket, or
 * (if a connection is active), the sss data socket. When data arrives, 
 * the approrpriate routine is called to either accept/reject a connection 
 * request, or process incoming data.
 */
void SSSSimpleSocketServerTask() {
	int fd_listen, max_socket;
	struct sockaddr_in addr;
	fd_set readfds;

	/*
	 * Sockets primer...
	 * The socket() call creates an endpoint for TCP of UDP communication. It
	 * returns a descriptor (similar to a file descriptor) that we call fd_listen,
	 * or, "the socket we're listening on for connection requests" in our sss
	 * server example.
	 *
	 * Traditionally, in the Sockets API, PF_INET and AF_INET is used for the
	 * protocol and address families respectively. However, there is usually only
	 * 1 address per protocol family. Thus PF_INET and AF_INET can be interchanged.
	 * In the case of NicheStack, only the use of AF_INET is supported.
	 * PF_INET is not supported in NicheStack.
	 */
	if ((fd_listen = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
		alt_NetworkErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"[sss_task] Socket creation failed");
	}

	/*
	 * Sockets primer, continued...
	 * Calling bind() associates a socket created with socket() to a particular IP
	 * port and incoming address. In this case we're binding to SSS_PORT and to
	 * INADDR_ANY address (allowing anyone to connect to us. Bind may fail for
	 * various reasons, but the most common is that some other socket is bound to
	 * the port we're requesting.
	 */
	addr.sin_family = AF_INET;
	addr.sin_port = htons(SSS_PORT);
	addr.sin_addr.s_addr = INADDR_ANY;

	if ((bind(fd_listen, (struct sockaddr * )&addr, sizeof(addr))) < 0) {
		alt_NetworkErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"[sss_task] Bind failed");
	}

	/*
	 * Sockets primer, continued...
	 * The listen socket is a socket which is waiting for incoming connections.
	 * This call to listen will block (i.e. not return) until someone tries to
	 * connect to this port.
	 */
	if ((listen(fd_listen, 1)) < 0) {
		alt_NetworkErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"[sss_task] Listen failed");
	}

	/* At this point we have successfully created a socket which is listening
	 * on SSS_PORT for connection requests from any remote address.
	 */
	sss_reset_connection(&conn);
	printf("[sss_task] Simple Socket Server listening on port %d\n",
	SSS_PORT);

	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_ST_1_MASK);

	while (1) {
		/*
		 * For those not familiar with sockets programming...
		 * The select() call below basically tells the TCPIP stack to return
		 * from this call when any of the events I have expressed an interest
		 * in happen (it blocks until our call to select() is satisfied).
		 *
		 * In the call below we're only interested in either someone trying to
		 * connect to us, or data being available to read on a socket, both of
		 * these are a read event as far as select is called.
		 *
		 * The sockets we're interested in are passed in in the readfds
		 * parameter, the format of the readfds is implementation dependant
		 * Hence there are standard MACROs for setting/reading the values:
		 *
		 *   FD_ZERO  - Zero's out the sockets we're interested in
		 *   FD_SET   - Adds a socket to those we're interested in
		 *   FD_ISSET - Tests whether the chosen socket is set
		 */
		FD_ZERO(&readfds);
		FD_SET(fd_listen, &readfds);
		max_socket = fd_listen + 1;

		if (conn.fd != -1) {
			FD_SET(conn.fd, &readfds);
			if (max_socket <= conn.fd) {
				max_socket = conn.fd + 1;
			}
		}

		select(max_socket, &readfds, NULL, NULL, NULL);

		/*
		 * If fd_listen (the listening socket we originally created in this thread
		 * is "set" in readfs, then we have an incoming connection request. We'll
		 * call a routine to explicitly accept or deny the incoming connection
		 * request (in this example, we accept a single connection and reject any
		 * others that come in while the connection is open).
		 */
		if (FD_ISSET(fd_listen, &readfds)) {
			sss_handle_accept(fd_listen, &conn);
		}
		/*
		 * If sss_handle_accept() accepts the connection, it creates *another*
		 * socket for sending/receiving data over sss. Note that this socket is
		 * independant of the listening socket we created above. This socket's
		 * descriptor is stored in conn.fd. If conn.fs is set in readfs... we have
		 * incoming data for our sss server, and we call our receiver routine
		 * to process it.
		 */
		else {
			if ((conn.fd != -1) && FD_ISSET(conn.fd, &readfds)) {
				sss_handle_receive(&conn);
			}
		}
	} /* while(1) */
}

/******************************************************************************
 *                                                                             *
 * License Agreement                                                           *
 *                                                                             *
 * Copyright (c) 2009 Altera Corporation, San Jose, California, USA.           *
 * All rights reserved.                                                        *
 *                                                                             *
 * Permission is hereby granted, free of charge, to any person obtaining a     *
 * copy of this software and associated documentation files (the "Software"),  *
 * to deal in the Software without restriction, including without limitation   *
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
 * and/or sell copies of the Software, and to permit persons to whom the       *
 * Software is furnished to do so, subject to the following conditions:        *
 *                                                                             *
 * The above copyright notice and this permission notice shall be included in  *
 * all copies or substantial portions of the Software.                         *
 *                                                                             *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
 * DEALINGS IN THE SOFTWARE.                                                   *
 *                                                                             *
 * This agreement shall be governed in all respects by the laws of the State   *
 * of California and by the laws of the United States of America.              *
 * Altera does not recommend, suggest or require that this reference design    *
 * file be used in conjunction or combination with any other product.          *
 ******************************************************************************/
