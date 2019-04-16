/*
 ************************************************************************************************
 *                                              NSEE
 *                                             Address
 *
 *                                       All Rights Reserved
 *
 *
 * Filename     : telemetry_manager_task.c
 * Programmer(s): Yuri Bunduki
 * Created on: Mar 28, 2019
 * Description  : Source file for the telemetry manager task.
 ************************************************************************************************
 */
/*$PAGE*/

/*
 ************************************************************************************************
 *                                        INCLUDE FILES
 ************************************************************************************************
 */

#include "telemetry_manager_task.h"

/*
 * Creation of the sub-unit communication queue [yb]
 */
//OS_EVENT *p_sub_unit_config_queue;
//struct sub_config *p_sub_unit_config_queue_tbl[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/
OS_EVENT *p_telemetry_queue;
struct x_telemetry *p_telemetry_queue_tbl[TELEMETRY_BUFFER_SIZE];

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
void v_ack_creator_telemetry(struct x_ethernet_payload* p_error_response,
		int error_code) {

	INT16U nb_id = i_id_accum;
	INT16U nb_id_pkt = p_error_response->packet_id;

	p_error_response->data[0] = 2;

	/*
	 * Id to bytes
	 */
	p_error_response->data[2] = div(nb_id, 256).rem;
	nb_id = div(nb_id, 256).quot;
	p_error_response->data[1] = div(nb_id, 256).rem;

//	p_error_response->data[1] = 0;
//	p_error_response->data[2] = i_id_accum;
	p_error_response->data[3] = 201;
	p_error_response->data[4] = 0;
	p_error_response->data[5] = 0;
	p_error_response->data[6] = 0;
	p_error_response->data[7] = 14;

	/*
	 * Packet id to bytes
	 */
	p_error_response->data[9] = div(nb_id_pkt, 256).rem;
	nb_id_pkt = div(nb_id_pkt, 256).quot;
	p_error_response->data[8] = div(nb_id_pkt, 256).rem;

//	p_error_response->data[8] = 0;
//	p_error_response->data[9] = p_error_response->packet_id;

	p_error_response->data[10] = p_error_response->type;
	p_error_response->data[11] = error_code;
	p_error_response->data[12] = 0;
	p_error_response->data[13] = 89;
	p_error_response->size = 14;

	i_id_accum++;
}

void i_echo_dataset_telemetry(struct Timagette_control* p_imagette,
		INT8U* tx_buffer) {
//	static INT8U tx_buffer[SSS_TX_BUF_SIZE];
	INT8U i = 0;
//	INT32U i_imagette_counter_echo = i_imagette_counter;
	INT32U i_imagette_counter_echo = 0;
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
	 * Substitute to real timer
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

	send(conn.fd, tx_buffer[0],
			p_imagette->imagette_length[i_imagette_number] + ECHO_CMD_OVERHEAD,
			0);

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
 * Create the telemetry manager defined data structures and queues
 */
void telemetry_manager_create_os_data_structs(void) {
	INT8U error_code;

	/*
	 * Create the sub-unit config queue [yb]
	 */
	p_telemetry_queue = OSQCreate(&p_telemetry_queue_tbl[0],
	TELEMETRY_BUFFER_SIZE);

	if (!p_telemetry_queue) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_sub_unit_queue.\n");
	}

}

void telemetry_manager_task() {
	struct x_telemetry *p_telemetry;
	INT8U error_code;
	INT8U i_tx_buffer[200];
	INT8U *p_tx_buffer = &i_tx_buffer[0];

	while (1) {
#if DEBUG_ON
		printf("[TELEMETRY] Telemetry manager waiting\r\n");
#endif

		p_telemetry = OSQPend(p_telemetry_queue, 0, &error_code);

		switch (p_telemetry->i_type) {

		case ACK_TYPE:
//			v_ack_creator_telemetry(p_telemetry->p_payload, p_telemetry->error_code);
//			send(conn.fd, p_telemetry->p_payload->data,
//					p_telemetry->p_payload->size, 0);
#if DEBUG_ON
			printf("[TMGEN]ACK_SENT\r\n");
#endif
			break;

		case ERROR_TYPE:

			break;

		case ECHO_TYPE:
			i_echo_dataset_telemetry(p_telemetry->p_imagette, p_tx_buffer);
			break;
		}
	}
}
