/*
 * sub_unit_control.c
 *
 *  Created on: Oct 22, 2018
 *      Author: Yuri Bunduki
 */

#include "sub_unit_control_task.h"

extern struct sub_config sub_config;
INT16U i_imagette_number;
INT16U i_imagette_counter;

/*
 * Creation of the sub-unit communication queue [yb]
 */
OS_EVENT *p_sub_unit_config_queue;
struct sub_config *p_sub_unit_config_queue_tbl[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/
//struct _sub_config

/*
 * Creation of the sub-unit command queue [yb]
 */
OS_EVENT *p_sub_unit_command_queue;
int *p_sub_unit_command_queue_tbl[2]; /*Storage for sub_unit queue*/

INT8U tx_buffer[SSS_TX_BUF_SIZE];
static INT8U *p_tx_buffer = &tx_buffer[0];

/*
 * Create the sub-unit defined data structures and queues
 */
void sub_unit_create_os_data_structs(void) {
	INT8U error_code;

	/*
	 * Create the sub-unit config queue [yb]
	 */
	p_sub_unit_config_queue = OSQCreate(&p_sub_unit_config_queue_tbl[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_sub_unit_queue.\n");
	}

	/*
	 * Create the sub-unit command queue [yb]
	 */
	p_sub_unit_command_queue = OSQCreate(&p_sub_unit_command_queue_tbl[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_command_queue) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_sub_unit_queue.\n");
	}

	/*
	 * Create Sub-Unit command semaphore, input set to 1 to create a binary semaphore
	 */
	sub_unit_command_semaphore = OSSemCreate(0);
}

/*
 * Echo data creation function
 */

void i_echo_dataset(struct imagette_control* p_imagette, INT8U* tx_buffer) {
//	static INT8U tx_buffer[SSS_TX_BUF_SIZE];
	INT8U i = 0;
	INT32U i_imagette_counter_echo = i_imagette_counter;
	INT32U k;
	INT32U nb_size = p_imagette->imagette_length[i_imagette_number]
			+ ECHO_CMD_OVERHEAD;
	INT32U nb_time = i_running_timer_counter;
	INT16U nb_id = i_id_accum;
	INT16U crc;

	tx_buffer[0] = 2;

	/*
	 * Id to bytes
	 */
	tx_buffer[2] = div(nb_id, 256).rem;
	nb_id = div(nb_id, 256).quot;
	tx_buffer[1] = div(nb_id, 256).rem;

	/*
	 * Type
	 */
	tx_buffer[3] = 203;

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

	tx_buffer[12] = 0;

	while (i < p_imagette->imagette_length[i_imagette_number]) {
		tx_buffer[i + (ECHO_CMD_OVERHEAD - 2)] =
				p_imagette->imagette[i_imagette_counter_echo];
		i++;
		i_imagette_counter_echo++;
	}

	crc = crc16(tx_buffer, (p_imagette->size - 11) + ECHO_CMD_OVERHEAD);

	tx_buffer[i + (ECHO_CMD_OVERHEAD - 1)] = div(crc, 256).rem;
	crc = div(crc, 256).quot;
	tx_buffer[i + (ECHO_CMD_OVERHEAD - 2)] = div(crc, 256).rem;

//	tx_buffer[i + (ECHO_CMD_OVERHEAD - 2)] = 0;	//crc
//	tx_buffer[i + (ECHO_CMD_OVERHEAD - 1)] = 7;	//crc

	i_id_accum++;

#if DEBUG_ON
	printf("[Echo DEBUG]Printing buffer = ");

	for (int k = 0;
			k
			< p_imagette->imagette_length[i_imagette_number]
			+ ECHO_CMD_OVERHEAD; k++) {
		printf("%i ", (INT8U) tx_buffer[k]);
	}

	printf("\r\n");
#endif

}

/*
 * Control task for sub-unit operation[yb]
 */
void sub_unit_control_task() {
	INT8U error_code; /*uCOS error code*/
	INT8U exec_error; /*Internal error code for the command module*/
	INT16U i_imagette_length = 0;

	struct sub_config *p_config;
	p_config = &sub_config;
	struct imagette_control *p_imagette_buffer;

	int i_command_control = 0;

	p_config->mode = 0;
	p_config->RMAP_handling = 0;
	p_config->forward_data = 0;
	p_config->link_config = 0;
	p_config->sub_status_sending = 0;
	p_config->linkstatus_running = 1;
	p_config->linkspeed = 3;

	int b_sub_status = 0;

	struct x_ethernet_payload *p_sub_data;

	while (b_sub_status == 0) {
#if DEBUG_ON
		printf("[SUBUNIT]Sub-unit in config mode\r\n");
#endif
		/*
		 * Disabling SpW channel
		 */
		v_SpaceWire_Interface_Link_Control((char) 'A', SPWC_REG_CLEAR,
		SPWC_AUTOSTART_CONTROL_BIT_MASK | SPWC_LINK_START_CONTROL_BIT_MASK);
		error_code = v_SpaceWire_Interface_Link_Control((char) 'A',
		SPWC_REG_SET,
		SPWC_LINK_DISCONNECT_CONTROL_BIT_MASK);

		exec_error = Verif_Error(error_code);
#if DEBUG_ON
		printf("[SUBUNIT]Sub-unit waiting config...\r\n");
#endif
		p_config = OSQPend(p_sub_unit_config_queue, 0, &error_code);
#if DEBUG_ON
		printf("[SUBUNIT]Sub-unit mode change to: %i\n\r",
				(INT8U) p_config->mode);
#endif
		b_sub_status = p_config->mode;

		p_imagette_buffer = p_config->imagette;
	}

	/*
	 * Sub-Unit in running mode
	 */
	while (b_sub_status == 1) {
		INT8U error_code; /*uCOS error code*/

		i_imagette_counter = 0;
		i_imagette_number = 0;
		i_command_control = 0;

		int p;
		INT16U nb_of_imagettes = p_imagette_buffer->nb_of_imagettes;
		p++;
#if DEBUG_ON
		printf("[SUBUNIT]Sub-unit in running mode\r\n");
#endif
		/*
		 * Set link interface status according to
		 * link_config
		 */
		if (p_config->linkstatus_running == 0) {
#if DEBUG_ON
			printf("[SUBUNIT]Channel disabled\r\n");
#endif
			//Testar ver se isso funciona
			v_SpaceWire_Interface_Link_Control((char) 'A', SPWC_REG_CLEAR,
			SPWC_AUTOSTART_CONTROL_BIT_MASK | SPWC_LINK_START_CONTROL_BIT_MASK);
			//fim teste
			error_code = v_SpaceWire_Interface_Link_Control((char) 'A',
			SPWC_REG_SET,
			SPWC_LINK_DISCONNECT_CONTROL_BIT_MASK);
			exec_error = Verif_Error(error_code);

		} else {

			switch (p_config->link_config) {

			/*
			 * Set link to autostart
			 */
			case 0:
#if DEBUG_ON
				printf("[SUBUNIT]Channel autostart\r\n");
#endif
				v_SpaceWire_Interface_Link_Control((char) 'A', SPWC_REG_CLEAR,
						SPWC_LINK_DISCONNECT_CONTROL_BIT_MASK
								| SPWC_LINK_START_CONTROL_BIT_MASK);

				error_code = v_SpaceWire_Interface_Link_Control((char) 'A',
				SPWC_REG_SET,
				SPWC_AUTOSTART_CONTROL_BIT_MASK);
				exec_error = Verif_Error(error_code);
#if DEBUG_ON
				printf("error_code: %i",exec_error);
#endif

				break;

				/*
				 * Set link to start
				 */
			case 1:
#if DEBUG_ON
				printf("[SUBUNIT]Channel start\r\n");
#endif
				//testar se isso funciona
				v_SpaceWire_Interface_Link_Control((char) 'A', SPWC_REG_CLEAR,
						SPWC_LINK_DISCONNECT_CONTROL_BIT_MASK
								| SPWC_AUTOSTART_CONTROL_BIT_MASK);
				//fim teste
				error_code = v_SpaceWire_Interface_Link_Control((char) 'A',
				SPWC_REG_SET,
				SPWC_LINK_START_CONTROL_BIT_MASK);
				exec_error = Verif_Error(error_code);
#if DEBUG_ON
				printf("error_code: %i",exec_error);
#endif
				break;
			}
		}

//		set_spw_linkspeed(0,p_config->linkspeed);
#if DEBUG_ON
printf("[SUBUNIT]imagette counter and nb start: %i %i\r\n",
				(int) i_imagette_counter, (int) i_imagette_number);
#endif

		while (i_imagette_number < nb_of_imagettes) {
#if DEBUG_ON
			printf("[SUBUNIT]Entered while\r\n");

			printf("[SUBUNIT]Received imagette %i start byte: %i @ %x\r\n",
					i_imagette_number,
					p_imagette_buffer->imagette[i_imagette_counter],
					&(p_imagette_buffer->imagette[i_imagette_counter]));
#endif
			i_imagette_length =
					p_imagette_buffer->imagette_length[i_imagette_number];
#if DEBUG_ON
			printf(
					"[SUBUNIT]imagette length var: %i, imagette length p_config %i\r\n",
					(INT16U) i_imagette_length,
					(INT16U) p_imagette_buffer->imagette_length[i_imagette_number]);

printf("[SUBUNIT]Waiting unblocked sub_unit_command_semaphore\r\n");
#endif
			p_config->sub_status_sending = 0;

			OSSemPend(sub_unit_command_semaphore, 0, &exec_error);
			i_command_control = (int) OSQAccept(p_sub_unit_command_queue,
					&error_code);

			//printf("[SUBUNIT]command_control: %i\r\n", (int) i_command_control);

			if (i_command_control != 0) {
#if DEBUG_ON
				printf("[SUBUNIT]Parsing command\r\n");
#endif
				switch (i_command_control) {
				case 1:
#if DEBUG_ON
					printf("[SUBUNIT]Abort Flag received\r\n");
#endif
					i_imagette_number = nb_of_imagettes;
					break;

				case 2:
#if DEBUG_ON
					printf("[SUBUNIT]Returning to config mode...\r\n");
#endif
					i_imagette_number = nb_of_imagettes;

					/*
					 * Disabling SpW channel
					 */
					v_SpaceWire_Interface_Link_Control((char) 'A',
					SPWC_REG_CLEAR,
							SPWC_AUTOSTART_CONTROL_BIT_MASK
									| SPWC_LINK_START_CONTROL_BIT_MASK);
					error_code = v_SpaceWire_Interface_Link_Control((char) 'A',
					SPWC_REG_SET,
					SPWC_LINK_DISCONNECT_CONTROL_BIT_MASK);
					exec_error = Verif_Error(error_code);
#if DEBUG_ON
					printf("[SUBUNIT]Sub-unit waiting config...\r\n");
#endif
					p_config = OSQPend(p_sub_unit_config_queue, 0, &error_code);
#if DEBUG_ON
					printf("[SUBUNIT]Sub-unit mode change to: %i\n\r",
							(INT8U) p_config->mode);
#endif
					b_sub_status = p_config->mode;
					p_imagette_buffer = p_config->imagette;
					break;
				default:
					break;
				}

			} else {

				/*
				 * Send data through SpW
				 */
#if !DMA_DEV
//				error_code = b_SpaceWire_Interface_Send_SpaceWire_Data('A',
//						&(p_imagette_buffer->imagette[i_imagette_counter]),
//						p_imagette_buffer->imagette_length[i_imagette_number]);
//				p_config->sub_status_sending = 0;
#endif

#if DMA_DEV
				error_code = b_SpaceWire_Interface_Send_SpaceWire_Data('A',
						&(p_imagette_buffer->dataset[i_imagette_number]->imagette_start),
						p_imagette_buffer->dataset[i_imagette_number]->imagette_length);
				p_config->sub_status_sending = 0;
#endif
				error_code =
						b_SpaceWire_Interface_Send_SpaceWire_Data('A',
								&(p_imagette_buffer->dataset[i_imagette_number]->imagette_start),
								p_imagette_buffer->dataset[i_imagette_number]->imagette_length);
				p_config->sub_status_sending = 0;
				/*
				 * Echo command statement
				 */
				if (i_echo_sent_data == 1) {

					i_echo_dataset(p_imagette_buffer, p_tx_buffer);
#if DEBUG_ON
					printf("[Echo in fct DEBUG]Printing buffer = ");
					for (int k = 0;
							k
							< p_imagette_buffer->imagette_length[i_imagette_number]
							+ ECHO_CMD_OVERHEAD; k++) {
						printf("%i ", (INT8U) tx_buffer[k]);
					}
					printf("\r\n");
#endif
					send(conn.fd, p_tx_buffer,
							p_imagette_buffer->imagette_length[i_imagette_number] + ECHO_CMD_OVERHEAD,
							0);
				}

				i_imagette_counter += i_imagette_length;
				i_imagette_number++;
#if DEBUG_ON
				printf("[SUBUNIT]imagette sent\r\n");
				printf("[SUBUNIT]imagette counter %i\r\n",
						(INT16U) i_imagette_counter);

				printf("[SUBUNIT]imagette nb %i\r\n",
						(INT16U) i_imagette_number);
#endif

				/*
				 * Restarting the timer when the transmission ends
				 */
				if (i_imagette_number == nb_of_imagettes) {

#if DEBUG_ON
					("[SUBUNIT]EOT timer restart\r\n");
#endif
					p_sub_data->type = 5;
					error_code = (INT8U) OSQPost(p_simucam_command_q,
							p_sub_data);
					alt_SSSErrorHandler(error_code, 0);
				}

			}
		}
#if DEBUG_ON
		//printf("[SUBUNIT]End of sending\r\n");
#endif
	}
}
