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

#include "../simucam_definitions.h"

/* Simple Socket Server definitions */
#include "simple_socket_server.h"                                                                    
#include "../alt_error_handler.h"

#include "../driver/leds/leds.h"
#include "../api_drivers/ddr2/ddr2.h"

#include "tasks_init.h"

/* Include to get the ETH Configs from the SimuCam */
#include "../utils/configs_simucam.h"

/*
 * Global handles (pointers) to our MicroC/OS-II resources. All of resources 
 * beginning with "SSS" are declared and created in this file.
 */

#if DEBUG_ON
typedef struct teste_data {
	INT8U data[500];
}T_teste_data;
#endif
SSSConn conn;

/*
 * Creation of the queue for receive/command communication [yb]
 */

OS_EVENT *p_simucam_command_q;
struct x_ethernet_payload *p_simucam_command_q_table[16]; /*Storage for SimucamCommandQ */

/*
 * Configuration of the sub-unit management task
 */
OS_STK sub_unit_task_stack[TASK_STACKSIZE];
OS_STK sub_unit_task_stack_1[TASK_STACKSIZE];
OS_STK sub_unit_task_stack_2[TASK_STACKSIZE];
OS_STK sub_unit_task_stack_3[TASK_STACKSIZE];
OS_STK sub_unit_task_stack_4[TASK_STACKSIZE];
OS_STK sub_unit_task_stack_5[TASK_STACKSIZE];
OS_STK sub_unit_task_stack_6[TASK_STACKSIZE];
OS_STK sub_unit_task_stack_7[TASK_STACKSIZE];

/*
 * Configuration of the simucam command management task[yb]
 */
OS_STK CommandManagementTaskStk[TASK_STACKSIZE];

/*
 * Configuration of the simucam command management task[yb]
 */
OS_STK telemetry_manager_task_stack[TASK_STACKSIZE];

OS_STK dma1_scheduler_task_stack_0[TASK_STACKSIZE];
OS_STK dma1_scheduler_task_stack_1[TASK_STACKSIZE];

/*
 * Configuration of the simucam data queue[yb]
 */

OS_EVENT *SimucamDataQ;
INT8U *SimucamDataQTbl[SSS_TX_BUF_SIZE]; /*Storage for SimucamCommandQ */

INT8U *data_addr;

/*
 * DMA mutex
 */
OS_EVENT *xMutexDMA[2];

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
#if DEBUG_ON
		printf("Simucam Command Queue created successfully.\r\n");
#endif
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
#if DEBUG_ON
		printf("SimucamDataQ created successfully.\r\n");
#endif
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
	 * Creating the sub_unit 0 management task [yb]
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task, (void *) 0,
			(void *) &sub_unit_task_stack[TASK_STACKSIZE - 1],
			SUB_UNIT_TASK_PRIORITY,
			SUB_UNIT_TASK_PRIORITY, sub_unit_task_stack,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	OSTimeDlyHMSM(0, 0, 1, 0);

	/*
	 * Creating the sub_unit 1 management task [yb]
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_1, (void *) 1,
			(void *) &sub_unit_task_stack_1[TASK_STACKSIZE - 1],
			SUB_UNIT_TASK_PRIORITY + 1,
			SUB_UNIT_TASK_PRIORITY + 1, sub_unit_task_stack_1,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the sub_unit 2 management task [yb]
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_2, (void *) 2,
			(void *) &sub_unit_task_stack_2[TASK_STACKSIZE - 1],
			SUB_UNIT_TASK_PRIORITY + 2,
			SUB_UNIT_TASK_PRIORITY + 2, sub_unit_task_stack_2,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the sub_unit 3 management task [yb]
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_3, (void *) 3,
			(void *) &sub_unit_task_stack_3[TASK_STACKSIZE - 1],
			SUB_UNIT_TASK_PRIORITY + 3,
			SUB_UNIT_TASK_PRIORITY + 3, sub_unit_task_stack_3,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the sub_unit 4 management task [yb]
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_4, (void *) 4,
			(void *) &sub_unit_task_stack_4[TASK_STACKSIZE - 1],
			SUB_UNIT_TASK_PRIORITY + 4,
			SUB_UNIT_TASK_PRIORITY + 4, sub_unit_task_stack_4,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);
	/*
	 * Creating the sub_unit 5 management task [yb]
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_5, (void *) 5,
			(void *) &sub_unit_task_stack_5[TASK_STACKSIZE - 1],
			SUB_UNIT_TASK_PRIORITY + 5,
			SUB_UNIT_TASK_PRIORITY + 5, sub_unit_task_stack_5,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the sub_unit 6 management task [yb]
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_6, (void *) 6,
			(void *) &sub_unit_task_stack_6[TASK_STACKSIZE - 1],
			SUB_UNIT_TASK_PRIORITY + 6,
			SUB_UNIT_TASK_PRIORITY + 6, sub_unit_task_stack_6,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the sub_unit 7 management task [yb]
	 */
	error_code = OSTaskCreateExt(sub_unit_control_task_7, (void *) 7,
			(void *) &sub_unit_task_stack_7[TASK_STACKSIZE - 1],
			SUB_UNIT_TASK_PRIORITY + 7,
			SUB_UNIT_TASK_PRIORITY + 7, sub_unit_task_stack_7,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);
	/*
	 * Creating the telemtry management task [yb]
	 */
	error_code = OSTaskCreateExt(telemetry_manager_task,
	NULL, (void *) &telemetry_manager_task_stack[TASK_STACKSIZE - 1],
	TELEMETRY_TASK_PRIORITY,
	TELEMETRY_TASK_PRIORITY, telemetry_manager_task_stack,
	TASK_STACKSIZE,
	NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the DMA controller task [yb]
	 */
	error_code = OSTaskCreateExt(dma1_scheduler_task, (void *) 0,
			(void *) &dma1_scheduler_task_stack_0[TASK_STACKSIZE - 1],
			DMA_SCHEDULER_TASK_PRIORITY,
			DMA_SCHEDULER_TASK_PRIORITY, dma1_scheduler_task_stack_0,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	/*
	 * Creating the DMA2 controller task [yb]
	 */
	error_code = OSTaskCreateExt(dma2_scheduler_task, (void *) 1,
			(void *) &dma1_scheduler_task_stack_1[TASK_STACKSIZE - 1],
			DMA_SCHEDULER_TASK_PRIORITY + 1,
			DMA_SCHEDULER_TASK_PRIORITY + 1, dma1_scheduler_task_stack_1,
			TASK_STACKSIZE,
			NULL, 0);

	alt_uCOSIIErrorHandler(error_code, 0);

	xMutexDMA[0] = OSMutexCreate(PCP_MUTEX_DMA_QUEUE, &error_code);
	if (error_code != OS_ERR_NONE) {
#if DEBUG_ON
		printf("Error creating mutex\r\n");
#endif
	}
	xMutexDMA[1] = OSMutexCreate(PCP_MUTEX_DMA_QUEUE + 1, &error_code);
	if (error_code != OS_ERR_NONE) {
#if DEBUG_ON
		printf("Error creating mutex\r\n");
#endif
	}

#if DEBUG_ON
	printf("Tasks created successfully\r\n");
#endif
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
#if DEBUG_ON
			printf("[sss_handle_accept] accepted connection request from %s\n",
					inet_ntoa(incoming_addr.sin_addr));
#endif
		}
	} else {
#if DEBUG_ON
		printf("[sss_handle_accept] rejected connection request from %s\n",
				inet_ntoa(incoming_addr.sin_addr));
#endif
	}

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
	int rx_code = 0;

	int i = 0;
	INT8U error_code = 0;
	INT16U calculated_crc = 0;
	INT32U i_received_bytes = 0;
	INT32U i_length_buff = 0;
	INT8U i_ack;

	struct ethernet_buffer buffer;
	struct ethernet_buffer *p_ethernet_buffer;
	p_ethernet_buffer = &buffer;

	static _ethernet_payload payload;
	INT8U i_channel_wr = 0;

	p_ethernet_buffer->rx_rd_pos = p_ethernet_buffer->rx_buffer;
	p_ethernet_buffer->rx_wr_pos = p_ethernet_buffer->rx_buffer;

	conn->rx_rd_pos = conn->rx_buffer;
	conn->rx_wr_pos = conn->rx_buffer;

#if DEBUG_ON
	printf("[sss_handle_receive] processing RX data\n");
#endif

	while (conn->state != CLOSE) {

#if DEBUG_ON
		printf("[sss_handle_receive DEBUG]Waiting transmission...\n");
#endif

		rx_code = recv(conn->fd, (char* )p_ethernet_buffer->rx_rd_pos, 8, 0);

		if (rx_code > 0) {
			p_ethernet_buffer->rx_rd_pos += rx_code;

			/* Zero terminate so we can use string functions */
			*(p_ethernet_buffer->rx_wr_pos + 1) = 0;
		}

#if DEBUG_ON
		printf("Printing all bytes: ");
#endif

		for (int j = 0; j < 8; j++) {
#if DEBUG_ON
			printf("%i ", (int) p_ethernet_buffer->rx_buffer[j]);
#endif
		}

#if DEBUG_ON
		printf("\n");
#endif

		if (p_ethernet_buffer->rx_buffer[0] == EXIT_CODE) {
			conn->close = 1;
		} else {

#if DEBUG_ON
			printf("[sss_handle_receive DEBUG]Print size bytes: %i %i %i %i\n",
					(int) p_ethernet_buffer->rx_buffer[7],
					(int) p_ethernet_buffer->rx_buffer[6],
					(int) p_ethernet_buffer->rx_buffer[5],
					(int) p_ethernet_buffer->rx_buffer[4]);
#endif

			payload.header = p_ethernet_buffer->rx_buffer[0];
			payload.packet_id = p_ethernet_buffer->rx_buffer[2]
					+ 256 * p_ethernet_buffer->rx_buffer[1];
			payload.type = p_ethernet_buffer->rx_buffer[3];

			payload.size = p_ethernet_buffer->rx_buffer[7]
					+ 256 * p_ethernet_buffer->rx_buffer[6]
					+ 65536 * p_ethernet_buffer->rx_buffer[5]
					+ 4294967296 * p_ethernet_buffer->rx_buffer[4];

#if DEBUG_ON
			printf("[sss_handle_receive DEBUG] calculating size = %i\n",
					(INT32U) payload.size);
#endif

			/*
			 * Case for receiving data
			 * TODO Prepare a truncated receive mode
			 */

			if (payload.type == 102) {
#if DEBUG_ON
				printf("[sss_handle_receive DEBUG]Entered parser\r\n");
#endif
				INT8U *p_imagette_byte;
				INT16U i_nb_imag_ctrl = 0;

				if (T_simucam.T_status.simucam_mode == simModeConfig) {
					rx_code = recv(conn->fd,
							(char* )p_ethernet_buffer->rx_wr_pos, 12, 0);
					if (rx_code > 0) {
						p_ethernet_buffer->rx_rd_pos += rx_code;
					}
					i_channel_wr = p_ethernet_buffer->rx_buffer[1];

					/*
					 * Switch to the right memory stick
					 */
					if (((unsigned char) i_channel_wr / 4) == 0) {
						bDdr2SwitchMemory(DDR2_M1_ID);
					} else {
						bDdr2SwitchMemory(DDR2_M2_ID);
					}

					T_Imagette *p_imagette_buff;

					p_imagette_byte =
							(INT32U) T_simucam.T_Sub[i_channel_wr].T_data.addr_init;

					/*
					 * Parse nb of imagettes
					 */
					T_simucam.T_Sub[i_channel_wr].T_data.nb_of_imagettes =
							p_ethernet_buffer->rx_buffer[3]
									+ 256 * p_ethernet_buffer->rx_buffer[2];

					/*
					 * Parse TAG
					 */
					T_simucam.T_Sub[i_channel_wr].T_data.tag[7] =
							p_ethernet_buffer->rx_buffer[4];
					T_simucam.T_Sub[i_channel_wr].T_data.tag[6] =
							p_ethernet_buffer->rx_buffer[5];
					T_simucam.T_Sub[i_channel_wr].T_data.tag[5] =
							p_ethernet_buffer->rx_buffer[6];
					T_simucam.T_Sub[i_channel_wr].T_data.tag[4] =
							p_ethernet_buffer->rx_buffer[7];
					T_simucam.T_Sub[i_channel_wr].T_data.tag[3] =
							p_ethernet_buffer->rx_buffer[8];
					T_simucam.T_Sub[i_channel_wr].T_data.tag[2] =
							p_ethernet_buffer->rx_buffer[9];
					T_simucam.T_Sub[i_channel_wr].T_data.tag[1] =
							p_ethernet_buffer->rx_buffer[10];
					T_simucam.T_Sub[i_channel_wr].T_data.tag[0] =
							p_ethernet_buffer->rx_buffer[11];

					/*
					 * Parse imagettes
					 */
					while (i_nb_imag_ctrl
							< T_simucam.T_Sub[i_channel_wr].T_data.nb_of_imagettes) {

						p_imagette_buff = (T_Imagette *) p_imagette_byte;
						/*
						 * Receive 6 bytes for offset and length
						 */
						rx_code = recv(conn->fd,
								(char* )p_ethernet_buffer->rx_wr_pos, 6, 0);
						if (rx_code > 0) {
							p_ethernet_buffer->rx_rd_pos += rx_code;

						}

						p_imagette_buff->offset =
								p_ethernet_buffer->rx_buffer[3]
										+ 256 * p_ethernet_buffer->rx_buffer[2]
										+ 65536
												* p_ethernet_buffer->rx_buffer[1]
										+ 4294967296
												* p_ethernet_buffer->rx_buffer[0];

						p_imagette_buff->imagette_length =
								p_ethernet_buffer->rx_buffer[5]
										+ 256 * p_ethernet_buffer->rx_buffer[4];
#if DEBUG_ON
						printf("[SSS]Imagette %i length: %i\r\n", i_nb_imag_ctrl,
								p_imagette_buff->imagette_length);
#endif
						p_imagette_byte += 6;
						i_length_buff = p_imagette_buff->imagette_length;
						while (i_length_buff > 0) {
							rx_code = recv(conn->fd, (void * )p_imagette_byte,
									i_length_buff, 0);
							if (rx_code > 0) {
								/*
								 * TODO prepare for fragmented receive
								 * if rx_code < data to receive, receive again
								 */
#if DEBUG_ON
								printf(
										"[SSS] received bytes in imagette %i: %i\r\n",
										i_nb_imag_ctrl, rx_code);
#endif
								p_imagette_byte += rx_code;
								i_length_buff -= rx_code;
								if (((INT32U) p_imagette_byte % 8)) {
									p_imagette_byte =
											(INT8U *) (((((INT32U) p_imagette_byte)
													>> 3) + 1) << 3);
								}
							}
						}

#if DEBUG_ON
						T_teste_data *pxTestData =
						(T_teste_data *) T_simucam.T_Sub[i_channel_wr].T_data.addr_init;
#endif
						i_nb_imag_ctrl++;
					}

					rx_code = recv(conn->fd,
							(char* )p_ethernet_buffer->rx_wr_pos, 2, 0);
					if (rx_code > 0) {
						p_ethernet_buffer->rx_rd_pos += rx_code;

						/* Zero terminate so we can use string functions */
						*(p_ethernet_buffer->rx_wr_pos + 1) = 0;
					}
					/* Verificar se chegou tudo */

					payload.crc = p_ethernet_buffer->rx_buffer[1]
							+ 256 * p_ethernet_buffer->rx_buffer[0];
					i_ack = ACK_OK;
				} else {
					/*
					 * Empty the ethernet stack to avoid garbage
					 */
					if (payload.size < BUFFER_SIZE) {
						rx_code = recv(conn->fd,
								(char* )p_ethernet_buffer->rx_wr_pos,
								payload.size, 0);
						if (rx_code > 0) {
							p_ethernet_buffer->rx_rd_pos += rx_code;
						}
					} else {
						while (payload.size > BUFFER_SIZE) {
							rx_code = recv(conn->fd,
									(char* )p_ethernet_buffer->rx_wr_pos,
									BUFFER_SIZE, 0);
							if (rx_code > 0) {
								p_ethernet_buffer->rx_rd_pos += rx_code;
								payload.size -= BUFFER_SIZE;
							}
						}
					}
					i_ack = COMMAND_NOT_ACCEPTED;
				}
				/*
				 * Prepare ACK statement
				 * TODO use ack function
				 */

				INT8U ack[14];
				INT8U nb_id = i_id_accum;
				INT8U nb_id_pkt = payload.packet_id;

				ack[0] = 2;
				ack[2] = div(nb_id, 256).rem;
				nb_id = div(nb_id, 256).quot;
				ack[1] = div(nb_id, 256).rem;
				ack[3] = 201;
				ack[4] = 0;
				ack[5] = 0;
				ack[6] = 0;
				ack[7] = 14;
				ack[9] = div(nb_id_pkt, 256).rem;
				nb_id_pkt = div(nb_id_pkt, 256).quot;
				ack[8] = div(nb_id_pkt, 256).rem;
				ack[10] = payload.type;
				ack[11] = i_ack;
				ack[12] = 0;
				ack[13] = 89;

				send(conn->fd, ack, 14, 0); /* TODO parser ack*/

#if DEBUG_ON
				printf("[sss_handle_receive DEBUG]Exit parser\r\n");
#endif
			} else {
				rx_code = recv(conn->fd, (char* )p_ethernet_buffer->rx_wr_pos,
						payload.size - 8, 0);

				if (rx_code > 0) {
					p_ethernet_buffer->rx_wr_pos += rx_code;

					/* Zero terminate so we can use string functions */
					*(p_ethernet_buffer->rx_wr_pos + 1) = 0;
				}

				/*
				 * Assign data in the payload struct to data in the buffer
				 * change to 0
				 */
				if (payload.size > 10) {
					for (i = 1; i <= payload.size - 10; i++) {
						payload.data[i - 1] =
								p_ethernet_buffer->rx_buffer[i - 1];
#if DEBUG_ON
						printf(
								"[sss_handle_receive DEBUG]data: %i\r\nPing %i\r\n",
								(INT8U) payload.data[i - 1], (INT8U) i);
#endif

					}
				}

#if DEBUG_ON
				printf("[sss_handle_receive DEBUG]Payload %lu",
						(INT32U) payload.size);
				printf("[sss_handle_receive DEBUG]Printing buffer = ");
#endif
				for (int k = 0; k < payload.size - 8; k++) {
#if DEBUG_ON
					printf("%i ", (INT8U) p_ethernet_buffer->rx_buffer[k]);
#endif
				}
#if DEBUG_ON
				printf("\r\n");
				printf(
						"[sss_handle_receive DEBUG]Print data types:\r\nHeader: %i\r\nID %i\r\n"
						"Type: %i\r\n", (int) payload.header,
						(int) payload.packet_id, (int) payload.type);

#endif

				payload.crc = p_ethernet_buffer->rx_buffer[payload.size]
						+ 256 * p_ethernet_buffer->rx_buffer[payload.size - 1];

#if DEBUG_ON
				printf("[sss_handle_receive DEBUG]Received CRC = %i\n",
						(INT16U) payload.crc);
#endif

				calculated_crc = crc16(p_ethernet_buffer->rx_buffer,
						payload.size);

#if DEBUG_ON
				printf("[sss_handle_receive DEBUG]Calculated CRC = %i\n",
						(INT16U) calculated_crc);

				printf("[sss_handle_receive DEBUG]finished receiving\n");
#endif

				error_code = OSQPost(p_simucam_command_q, &payload);
				alt_SSSErrorHandler(error_code, 0);
#if DEBUG_ON
				printf("[sss_handle_receive DEBUG]Waiting CC response...\n");
#endif
			}
		}

		/*
		 * When the quit command is received, update our connection state so that
		 * we can exit the while() loop and close the connection
		 */
		conn->state = conn->close ? CLOSE : READY;

#if DEBUG_ON
		printf("[sss_handle_receive DEBUG]connection state checked\n");
#endif

		/* Manage buffer */

		p_ethernet_buffer->rx_rd_pos = &p_ethernet_buffer->rx_buffer[0];
		p_ethernet_buffer->rx_wr_pos = &p_ethernet_buffer->rx_buffer[0];
		memset(p_ethernet_buffer->rx_wr_pos, 0, BUFFER_SIZE);

	}

#if DEBUG_ON
	printf("[sss_handle_receive] closing connection\n");
#endif
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
	addr.sin_port = htons(xConfEth.siPort);
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
#if DEBUG_ON
	printf("[sss_task] Simple Socket Server listening on port %d\n",
			xConfEth.siPort);
#endif

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
