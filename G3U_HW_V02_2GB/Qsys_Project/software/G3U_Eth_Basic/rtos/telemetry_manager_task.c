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
void v_ack_creator_1(struct x_ethernet_payload* p_error_response,
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

	while (1) {

		p_telemetry = OSQPend(p_telemetry_queue, 0, &error_code);

		switch (p_telemetry->i_type) {

		case ACK_TYPE:
			v_ack_creator_1(p_telemetry->p_payload, p_telemetry->error_code);
			send(conn.fd, p_telemetry->p_payload->data,
					p_telemetry->p_payload->size, 0);
			break;

		case ERROR_TYPE:

			break;
		}
	}
}
