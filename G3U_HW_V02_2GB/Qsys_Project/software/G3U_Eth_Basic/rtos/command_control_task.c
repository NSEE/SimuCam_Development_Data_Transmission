/*
 ************************************************************************************************
 *                                              NSEE
 *                                             Address
 *
 *                                       All Rights Reserved
 *
 *
 * Filename     : command_control_task.c
 * Programmer(s): Yuri Bunduki
 * Created on: Apr 26, 2018
 * Description  : Source file for the command control management task.
 ************************************************************************************************
 */
/*$PAGE*/

#include "command_control_task.h"

struct sub_config config_send_A;
struct sub_config config_send_B;

Timagette_control img_struct;
Timagette_control *p_img_control;

struct x_ethernet_payload *p_payload;

INT8U b_meb_status = 0; //default starting mode is config
INT8U i_forward_data = 0;
INT8U i_echo_sent_data = 0;

//INT32U i_imagette_counter_CC = 0;
volatile INT32U i_total_imagette_counter = 0;

INT8U data[MAX_IMAGETTES];
INT8U *p_data_pos = &data[0];

volatile INT32U i_running_timer_counter = 1;

volatile INT32U i_central_timer_counter = 1;
INT8U exec_error;

INT16U i_id_accum = 1;

INT8U tx_buffer_CC[SSS_TX_BUF_SIZE];
INT8U *p_tx_buffer = &tx_buffer_CC[0];

int abort_flag = 1;
int i_return_config_flag = 2;

/**
 * @name long_to_int
 * @brief transforms an int to a byte array
 * @ingroup UTIL
 *
 * @param 	[in]	int 	number
 * @param	[in]	int 	number of bytes
 * @param	[in]	INT8U	*destination array
 *
 * @retval INT16U crc
 **/

//void long_to_int(int nb, int nb_bytes, INT8U* p_destination) {
////	def long_to_bytes(nb,n_bytes):
////	    p=0
////	    size = []
////	    while p < n_bytes:
////	        buff = nb//256
////	        size.append(nb%256)
////	        nb = buff
////	        p+=1
////	    return size[::-1]
//
//	int p = 0;
//	int k = 0;
//	INT8U byte_buffer[nb_bytes];
//	INT32U i_buffer;
//
//	while (p < nb_bytes) {
//		i_buffer = div(nb, 256).quot;
//		byte_buffer[p] = div(nb, 256).rem;
//		nb = i_buffer;
//		p++;
//	}
//#if DEBUG_ON
//	printf("[LongToInt]Final Bytes ");
//#endif
//	while (p != 0) {
//		p_destination[p] = byte_buffer[k];
//#if DEBUG_ON
//		printf("%i ", p_destination[p]);
//#endif
//		p--;
//		k++;
//	}
//#if DEBUG_ON
//	printf("\r\n");
//#endif
//
//#if DEBUG_ON
//	printf("[LongToInt]Byte buffer ");
//	for (p = 0; p < nb_bytes; p++) {
//		printf("%i ", byte_buffer[p]);
//	}
//	printf("\r\n");
//#endif
//}
/**
 * @name i_echo_dataset_direct_send
 * @brief Send direct-send echo
 * @ingroup UTIL
 *
 *
 * @param 	[in] 	x_ethernet_payload 	*Imagette
 * @param	[in]	INT8U				*tx_buffer
 * @retval void
 **/
void i_echo_dataset_direct_send(struct x_ethernet_payload* p_imagette,
		INT8U* tx_buffer) {
//	static INT8U tx_buffer[SSS_TX_BUF_SIZE];
	INT8U i = 0;
//	INT32U i_imagette_counter_echo = i_imagette_counter;
//	INT32U k;
	INT32U nb_size = (p_imagette->size - 11) + ECHO_CMD_OVERHEAD;
	INT32U nb_time = i_running_timer_counter;
	INT16U crc;

//	INT8U buffer_size[4];
//	INT8U *p_buffer_size;
//	p_buffer_size = &buffer_size[0];

	tx_buffer[0] = 2;
	tx_buffer[1] = 0;
	tx_buffer[2] = i_id_accum;
	tx_buffer[3] = 203;

//	long_to_int((p_imagette->size - 11) + ECHO_CMD_OVERHEAD, 4, p_buffer_size);
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

//	tx_buffer[8] = 0;
//	tx_buffer[9] = 0;
//	tx_buffer[10] = 0;
//	tx_buffer[11] = i_running_timer_counter;

	tx_buffer[12] = 0;			//channel info

	while (i < p_imagette->size - 11) {
		tx_buffer[i + (ECHO_CMD_OVERHEAD - 2)] = p_imagette->data[i + 1];
		i++;
	}

	crc = crc16(tx_buffer, (p_imagette->size - 11) + ECHO_CMD_OVERHEAD);

	tx_buffer[i + (ECHO_CMD_OVERHEAD - 1)] = div(crc, 256).rem;
	crc = div(crc, 256).quot;
	tx_buffer[i + (ECHO_CMD_OVERHEAD - 2)] = div(crc, 256).rem;

	i_id_accum++;

#if DEBUG_ON
	printf("[Echo DEBUG]Printing buffer = ");
	for (int k = 0; k < (p_imagette->size - 11) + ECHO_CMD_OVERHEAD; k++) {
		printf("%i ", (INT8U) tx_buffer[k]);
	}
	printf("\r\n");
#endif
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
void v_ack_creator(struct x_ethernet_payload* p_error_response, int error_code) {

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

void v_HK_creator(struct x_ethernet_payload* p_HK, INT8U i_channel) {

	INT8U chann_buff = i_channel;
	INT16U crc;
	INT16U nb_id = i_id_accum;
	INT16U nb_counter_total = i_total_imagette_counter;
	INT16U nb_counter_current = i_imagette_counter;
	INT16U nb_counter_left = p_img_control->nb_of_imagettes
			- i_imagette_counter;

	p_HK->data[0] = 2;

	/*
	 * Id to bytes
	 */
	p_HK->data[2] = div(nb_id, 256).rem;
	nb_id = div(nb_id, 256).quot;
	p_HK->data[1] = div(nb_id, 256).rem;

	p_HK->data[3] = 204;
	p_HK->data[4] = 0;
	p_HK->data[5] = 0;
	p_HK->data[6] = 0;
	p_HK->data[7] = 30;
	p_HK->data[8] = chann_buff; /**channel*/
	p_HK->data[9] = b_meb_status; /**meb mode*/
	p_HK->data[10] = sub_config.linkstatus_running; /**Sub_config_enabled*/
	p_HK->data[11] = sub_config.link_config; /**sub_config_linkstatus*/
	p_HK->data[12] = sub_config.linkspeed; /**sub_config_linkspeed*/
//	p_HK->data[13] = ul_SpaceWire_Interface_Link_Status_Read('A'); /**sub_status_linkrunning*/ // TODO
	p_HK->data[14] = 1; /**link enabled*/
	p_HK->data[15] = sub_config.sub_status_sending;
	p_HK->data[16] = 0; /**link errors*/
	p_HK->data[17] = 0;
	p_HK->data[18] = 0;
	p_HK->data[19] = 0;

	/*
	 * Sent Packets
	 */
	p_HK->data[21] = div(nb_counter_total, 256).rem;
	nb_counter_total = div(nb_counter_total, 256).quot;
	p_HK->data[20] = div(nb_counter_total, 256).rem;

	p_HK->data[22] = 0; /**Received packets 1*/
	p_HK->data[23] = 0; /**Received packets 0*/

	/**
	 * Current packet nb
	 */
	p_HK->data[25] = div(nb_counter_current, 256).rem;
	nb_counter_current = div(nb_counter_current, 256).quot;
	p_HK->data[24] = div(nb_counter_current, 256).rem;

	/**
	 * Packets to send
	 */
	p_HK->data[26] = div(nb_counter_left, 256).rem;
	nb_counter_left = div(nb_counter_left, 256).quot;
	p_HK->data[27] = div(nb_counter_left, 256).rem;
	p_HK->size = 30;

	/**
	 * Calculating CRC
	 */
	crc = crc16(p_HK->data, p_HK->size - 2);

	p_HK->data[29] = div(crc, 256).rem;
	crc = div(crc, 256).quot;
	p_HK->data[28] = div(crc, 256).rem;

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
 * @param	[in]	*_imagette_control Control struct to receive the data
 *
 * @retval int	9 if error, 1 if no error
 **/
int v_parse_data(struct x_ethernet_payload *p_payload,
		struct Timagette_control *p_img_ctrl) { //, struct x_imagette *dataset

	INT32U i = 0;
	INT32U o = DATA_SHIFT;
	INT32U d = 0;
	INT16U nb_imagettes;
	INT32U error_verif = 0;
	INT8U imagette_byte;

#if DEBUG_ON
	printf(
			"[PARSER]testando valores do payload:\r\nsize: %i\r\ndata_payload: %i,%i,%i,%i,%i,%i\r\n",
			p_payload->size, (char) p_payload->data[8],
			(char) p_payload->data[9], (char) p_payload->data[10],
			(char) p_payload->data[11], (char) p_payload->data[12],
			(char) p_payload->data[13]);
#endif

	/*
	 * Do not use first 2 bytes
	 */

	nb_imagettes = p_payload->data[3] + 256 * p_payload->data[2];
	p_img_ctrl->nb_of_imagettes = nb_imagettes;
#if DEBUG_ON
	printf("[PARSER] Number of imagettes: %i\r\n", nb_imagettes);
#endif

	p_img_ctrl->tag[7] = p_payload->data[4];
	p_img_ctrl->tag[6] = p_payload->data[5];
	p_img_ctrl->tag[5] = p_payload->data[6];
	p_img_ctrl->tag[4] = p_payload->data[7];
	p_img_ctrl->tag[3] = p_payload->data[8];
	p_img_ctrl->tag[2] = p_payload->data[9];
	p_img_ctrl->tag[1] = p_payload->data[10];
	p_img_ctrl->tag[0] = p_payload->data[11];
#if DEBUG_ON
	printf("[PARSER]TAG: %i %i %i %i %i %i %i %i\r\n", p_img_ctrl->tag[7],
			p_img_ctrl->tag[6], p_img_ctrl->tag[5], p_img_ctrl->tag[4],
			p_img_ctrl->tag[3], p_img_ctrl->tag[2], p_img_ctrl->tag[1],
			p_img_ctrl->tag[0]);

	printf("[PARSER]Starting imagette addr %x\r\n",
			&(p_img_ctrl->dataset[0]->imagette_start));
#endif

#if DMA_DEV
	while (i < nb_imagettes) {
		INT32U p = 0;
#if DEBUG_ON
		printf("[PARSER] Imagette being parsed: %i to %x\r\n", (INT32U) i,
				(INT32U) &(p_img_ctrl->dataset[i]));

		printf("[PARSER]Offset bytes: %i %i %i %i\r\n", p_payload->data[o],
				p_payload->data[o + 1], p_payload->data[o + 2],
				256 * p_payload->data[o + 2], p_payload->data[o + 3]);

#endif

		dataset[i].offset = div(
				(p_payload->data[o + 3] + 256 * p_payload->data[o + 2]
						+ 65536 * p_payload->data[o + 1]
						+ 4294967296 * p_payload->data[o]), 10).quot;

		dataset[i].imagette_length = p_payload->data[o + 5]
		+ 256 * p_payload->data[o + 4];

#if DEBUG_ON
		printf("[PARSER] offset: %i\r\n[PARSER] length: %i\r\n",
				dataset[i].offset, dataset[i].imagette_length);
#endif

		dataset[i].imagette_start = p_payload->data[o + DELAY_SIZE];
		p_imagette_byte = &(dataset[i].imagette_start);

#if DEBUG_ON
		printf("[PARSER] first byte addr %x = %x p_byte\r\n",
				&(dataset[i].imagette_start), p_imagette_byte);
#endif

		for (p = 1; p < dataset[i].imagette_length; p++, d++) {
			p_imagette_byte++;
			*(p_imagette_byte) = p_payload->data[o + DELAY_SIZE + p];
#if DEBUG_ON
			printf("[PARSER] byte %i %i\r\n", p , *(p_imagette_byte));
#endif
		}

#if DEBUG_ON
		printf("[PARSER] first byte %i\r\n", (INT8U) dataset[0].imagette_start);
		printf("[PARSER] last byte addr %x\r\n[PARSER] last byte %i\r\n",
				p_imagette_byte, *(p_imagette_byte));
#endif

		p_imagette_byte++;
		o += DELAY_SIZE + dataset[i].imagette_length;
		p_img_ctrl->dataset[i] = &(dataset[i]);
		i++;
	}

	p_img_ctrl->size = d;
	error_verif = o + DATA_SHIFT - 2;
#if DEBUG_ON
	printf("[PARSER]error_verif %i\r\n", error_verif);
#endif
	if (p_payload->size == error_verif) {
#if DEBUG_ON
		printf("[PARSER]OK...\r\n");
#endif
		return ACK_OK;
	} else
	return PARSER_ERROR;
}

#endif

	/*
	 * Old ways, funny ways
	 */
#if !DMA_DEV
	while (i < nb_imagettes) {
		INT32U p = 0;
#if DEBUG_ON
		printf("[PARSER] Imagette being parsed: %i to %x\r\n", (INT32U) i,
				(INT32U) &(p_img_ctrl->imagette[d]));

		printf("[PARSER]Offset bytes: %i %i %i %i\r\n", p_payload->data[o],
				p_payload->data[o + 1], p_payload->data[o + 2],
				256 * p_payload->data[o + 2], p_payload->data[o + 3]);
#endif

		p_img_ctrl->offset[i] = div(
				(p_payload->data[o + 3] + 256 * p_payload->data[o + 2]
						+ 65536 * p_payload->data[o + 1]
						+ 4294967296 * p_payload->data[o]), 10).quot;

		p_img_ctrl->imagette_length[i] = p_payload->data[o + 5]
				+ 256 * p_payload->data[o + 4];
#if DEBUG_ON
		printf("[PARSER] offset: %i\r\n[PARSER] length: %i\r\n",
				p_img_ctrl->offset[i], p_img_ctrl->imagette_length[i]);
#endif

		for (p = 0; p < p_img_ctrl->imagette_length[i]; p++, d++) {
			p_img_ctrl->imagette[d] = p_payload->data[o + DELAY_SIZE + p];
#if DEBUG_ON
			printf(
					"[PARSER]Teste de recepcao:imagette_nb %i, imagette_data %i\r\n",
					(INT32U) i, (INT8U) p_img_ctrl->imagette[d]);
#endif
		}

		o += DELAY_SIZE + p_img_ctrl->imagette_length[i];
		i++;
	}

	p_img_ctrl->size = d;
	error_verif = o + DATA_SHIFT - 2;
#if DEBUG_ON
	printf("[PARSER]error_verif %i\r\n", error_verif);
#endif
	if (p_payload->size == error_verif) {
#if DEBUG_ON
		printf("[PARSER]OK...\r\n");
#endif
		return ACK_OK;
	} else
		return PARSER_ERROR;

#endif
}

int v_parse_data_teste(struct x_ethernet_payload *p_payload,
		Timagette_control *p_img_ctrl, x_imagette *dataset[MAX_IMAGETTES]) { //, struct x_imagette *dataset

	INT32U i = 0;
	INT32U o = DATA_SHIFT;
	INT32U d = 0;
	INT16U nb_imagettes;
	INT32U error_verif = 0;

	INT8U *p_imagette_byte;

#if DEBUG_ON
	printf(
			"[PARSER]testando valores do payload:\r\nsize: %i\r\ndata_payload: %i,%i,%i,%i,%i,%i\r\n",
			p_payload->size, (char) p_payload->data[8],
			(char) p_payload->data[9], (char) p_payload->data[10],
			(char) p_payload->data[11], (char) p_payload->data[12],
			(char) p_payload->data[13]);
#endif

	/*
	 * Do not use first 2 bytes
	 */

	nb_imagettes = p_payload->data[3] + 256 * p_payload->data[2];
	p_img_ctrl->nb_of_imagettes = nb_imagettes;
#if DEBUG_ON
	printf("[PARSER] Number of imagettes: %i\r\n", nb_imagettes);
#endif

	p_img_ctrl->tag[7] = p_payload->data[4];
	p_img_ctrl->tag[6] = p_payload->data[5];
	p_img_ctrl->tag[5] = p_payload->data[6];
	p_img_ctrl->tag[4] = p_payload->data[7];
	p_img_ctrl->tag[3] = p_payload->data[8];
	p_img_ctrl->tag[2] = p_payload->data[9];
	p_img_ctrl->tag[1] = p_payload->data[10];
	p_img_ctrl->tag[0] = p_payload->data[11];
#if DEBUG_ON
	printf("[PARSER]TAG: %i %i %i %i %i %i %i %i\r\n", p_img_ctrl->tag[7],
			p_img_ctrl->tag[6], p_img_ctrl->tag[5], p_img_ctrl->tag[4],
			p_img_ctrl->tag[3], p_img_ctrl->tag[2], p_img_ctrl->tag[1],
			p_img_ctrl->tag[0]);

	printf("[PARSER]Starting imagette addr %x\r\n", &(p_img_ctrl->dataset[0]));
#endif

	while (i < nb_imagettes) {
		INT32U p = 0;
#if DEBUG_ON
		printf("[PARSER] Imagette being parsed: %i to %x\r\n", (INT32U) i,
				(INT32U) &(p_img_ctrl->dataset[i]));

		printf("[PARSER]Offset bytes: %i %i %i %i\r\n", p_payload->data[o],
				p_payload->data[o + 1], p_payload->data[o + 2],
				256 * p_payload->data[o + 2], p_payload->data[o + 3]);

#endif

		dataset[i]->offset = (p_payload->data[o + 3]
				+ 256 * p_payload->data[o + 2] + 65536 * p_payload->data[o + 1]
				+ 4294967296 * p_payload->data[o]);

		dataset[i]->imagette_length = p_payload->data[o + 5]
				+ 256 * p_payload->data[o + 4];

#if DEBUG_ON
		printf("[PARSER] offset: %i\r\n[PARSER] length: %i\r\n",
				dataset[i]->offset, dataset[i]->imagette_length);
#endif

		dataset[i]->imagette_start = p_payload->data[o + DELAY_SIZE];
//		p_imagette_byte = (INT8U *)dataset[i];
		p_imagette_byte = (INT8U *) (dataset[i]) + DMA_OFFSET;
//		p_imagette_byte = &((*dataset)[i].imagette_start);

#if DEBUG_ON
		printf("[PARSER] first byte addr %x = %x p_byte\r\n",
				&(dataset[i]->imagette_start), p_imagette_byte);
#endif

		for (p = 1; p < dataset[i]->imagette_length; p++, d++) {
			p_imagette_byte++;
			*(p_imagette_byte) = p_payload->data[o + DELAY_SIZE + p];
#if DEBUG_ON
			printf("[PARSER] byte %i %i\r\n", p, *(p_imagette_byte));
#endif
		}
#if DEBUG_ON
		printf("[PARSER] first byte %i\r\n",
				(INT8U) dataset[0]->imagette_start);
		printf("[PARSER] last byte addr %x\r\n[PARSER] last byte %i\r\n",
				p_imagette_byte, *(p_imagette_byte));
#endif

		/*
		 * Align last imagette byte with
		 * an 8 byte memory
		 */
		while ((INT32U) (p_imagette_byte) % 8) {
			p_imagette_byte++;
		}

		o += DELAY_SIZE + dataset[i]->imagette_length;
		p_img_ctrl->dataset[i] = dataset[i];
		i++;
		dataset[i] = (x_imagette *) (p_imagette_byte);
	}

	p_img_ctrl->size = d;
	error_verif = o + DATA_SHIFT - 2;
#if DEBUG_ON
	printf("[PARSER]error_verif %i\r\n", error_verif);
#endif
	if (p_payload->size == error_verif) {
#if DEBUG_ON
		printf("[PARSER]OK...\r\n");
#endif
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
 * @param	[in]	*_imagette_control Control struct to receive the data
 *
 * @retval void
 **/
void central_timer_callback_function(void *p_arg) {

	INT8U error_code = 0;
	INT8U buffer_nb;
	int i_internal_error_timer;

#if DEBUG_ON
	printf("[CALLBACK]Entered callback\r\n next offset %i, counter %i\r\n",
			(INT32U) p_img_control->dataset[i_imagette_number]->offset,
			(INT32U) i_central_timer_counter);
#endif

	if (p_img_control->dataset[i_imagette_number]->offset
			== i_central_timer_counter) {

		/*
		 * Enviar comando de envio para o sub-unit
		 */
		error_code = OSSemPost(sub_unit_command_semaphore);
		if (error_code == OS_ERR_NONE) {
#if DEBUG_ON
			printf("[CALLBACK]Semaphore triggered\r\n");
#endif
			i_total_imagette_counter++;
#if DEBUG_ON
			printf("[CALLBACK]Entered function imagette count: %i\r\n",
					(INT32U) i_imagette_number);
#endif
		}
	}

	i_central_timer_counter++;
}

/**
 * COMPLETAR
 * @name central_timer_callback_function
 * @brief Simucam central timer callback function
 * @ingroup UTIL
 *
 * This is the Simucam central timer callback function,
 * it's used to accumulate the total running time of the
 * Simucam (in running mode).
 *
 * @param 	[in] 	*p_arg NOT USED
 * @retval void
 **/
void simucam_running_timer_callback_function(void *p_arg) {

	i_running_timer_counter++;

}

/*
 * Task used to parse and execute the commands received via ethernet. [yb]
 */

void CommandManagementTask() {

	INT8U error_code; /*uCOS error code*/
	int exec_error = 0; /*Internal error code for the command module*/

//	INT8U* cmd_pos;
//	INT8U cmd_char_buffer[SSS_TX_BUF_SIZE];
//	INT8U* cmd_char = cmd_char_buffer;

	struct x_ethernet_payload payload;

	x_imagette *p_imagette_A[MAX_IMAGETTES];

	x_imagette *p_imagette_B[MAX_IMAGETTES];

	/*
	 * Assigning imagette struct to RAM
	 */
	alt_u32 Ddr2Base;
	alt_u32 ByteLen;
	bDdr2SwitchMemory(DDR2_M1_ID);
	Ddr2Base = DDR2_BASE_ADDR_DATASET_1;


	/*
	 * Initialize DMA
	 */
	bIdmaInitM1Dma();
	bIdmaInitM2Dma();

//	ByteLen = DDR2_M1_MEMORY_SIZE;
//	p_img_control = (struct imagette_control *) Ddr2Base;

	/*
	 * Img control is now addressed in the primary memory, since the
	 * dataset will be assigned in vector mode.
	 */
	p_img_control = &img_struct;
	p_payload = &payload;
	p_imagette_A[0] = (struct x_imagette *) Ddr2Base;

	struct x_telemetry x_telemetry_buffer;
	struct x_telemetry *p_telemetry_buffer = &x_telemetry_buffer;

#if DEBUG_ON
	printf("[CommandManagementTask]p_imagette_A[0] addr %x\n\r",
			p_imagette_A[0]);
#endif

	/*
	 * Declaring the sub-units initial status
	 */
	static struct sub_config *config_send;
	config_send = &config_send_A;

	/*
	 * Configuring done inside the sub-unit modules
	 */
	config_send->mode = 0; //default starting mode is config
	config_send->RMAP_handling = 0;
	config_send->forward_data = 0;
	config_send->link_config = 0;
	config_send->sub_status_sending = 0;
	config_send->linkstatus_running = 1;
	config_send->linkspeed = 3;

	/*
	 * Creating running timer
	 * Will be substituted by HW timer
	 */
	simucam_running_timer = OSTmrCreate(0, CENTRAL_TIMER_RESOLUTION,
	OS_TMR_OPT_PERIODIC, simucam_running_timer_callback_function, (void *) 0,
			(INT8U*) "Running Timer", (INT8U*) &exec_error);

	bSyncSetOst(25e6);
	bSyncSetPolarity(FALSE);
	bSyncCtrExtnIrq(TRUE);
	bSyncCtrReset();
	bSyncCtrCh1OutEnable(TRUE);

	/*
	 * Stop timer for ChA
	 * NOT STARTING THE TIMER
	 */
	bDschStopTimer(&(xChA.xDataScheduler));
	bDschClrTimer(&(xChA.xDataScheduler));

	/*
	 * Initializing the timer
	 * for channel A
	 */
	bDschGetTimerConfig(&(xChA.xDataScheduler));
	xChA.xDataScheduler.xTimerConfig.bStartOnSync = TRUE;
	xChA.xDataScheduler.xTimerConfig.uliTimerDiv = TIMER_CLOCK_DIV_1MS;
	bDschSetTimerConfig(&(xChA.xDataScheduler));

	bDcomSetGlobalIrqEn(TRUE, eDcomSpwCh1);
	bDctrGetIrqControl(&(xChA.xDataController));
	xChA.xDataController.xIrqControl.bTxBeginEn = FALSE;
	xChA.xDataController.xIrqControl.bTxEndEn = TRUE;
	bDctrSetIrqControl(&(xChA.xDataController));

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

#if DEBUG_ON
			printf("[CommandManagementTask]MEB in config mode\n\r");
#endif
			/*
			 * Enter the receive command mode
			 */

			p_payload = OSQPend(p_simucam_command_q, 0, &error_code);
			alt_uCOSIIErrorHandler(error_code, 0);
#if DEBUG_ON
			//printf(
//					"[CommandManagementTask]teste do payload: %c,%c,%c,%c,%c,%c\n\r",
//					(INT8U) p_payload->type, (char) p_payload->data[0],
//					(char) p_payload->data[1], (char) p_payload->data[2],
//					(char) p_payload->data[3], (char) p_payload->data[4]);
#endif
			/*
			 * Switch case to select from different command options.[yb]
			 * Will be modified to suit IWF's needs
			 */
			int i_channel_buffer;

			switch (p_payload->type) { /*Selector for commands and actions*/

			/*
			 * Sub-Unit config command
			 * char: e
			 */
			case 101:
#if DEBUG_ON
				printf("[CommandManagementTask]Configure Sub-Unit\r\n");
#endif

				/* Add a case for channel selection */

				config_send->link_config = p_payload->data[1];
				config_send->linkspeed = p_payload->data[2];
				config_send->linkstatus_running = p_payload->data[3];
#if DEBUG_ON
				printf(
						"[CommandManagementTask]Configurations sent: %i, %i, %i\r\n",
						(INT8U) config_send->link_config,
						(INT8U) config_send->linkspeed,
						(INT8U) config_send->linkstatus_running);
#endif

				v_ack_creator(p_payload, ACK_OK);
				p_telemetry_buffer->i_type = ACK_TYPE;
				p_telemetry_buffer->error_code = ACK_OK;
				p_telemetry_buffer->p_payload = p_payload;

				error_code = (INT8U) OSQPost(p_telemetry_queue,
						p_telemetry_buffer);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);

				break;

				/*
				 * Receive and Parse data
				 * char: f
				 */
			case 102:
#if DEBUG_ON
				printf("[CommandManagementTask]Parse data\n\r");
				printf("[CommandManagementTask]p_imagette_A addr %x\n\r",
						p_imagette_A[0]);
#endif

				switch (p_payload->data[1]) {

				case 0:
					exec_error = v_parse_data_teste(p_payload, p_img_control,
							p_imagette_A);
					//exec_error = v_parse_data(p_payload, p_img_control);
#if DEBUG_ON
					printf(
							"[CommandManagementTask]Teste de parser byte: %i\n\r offset %i\r\nsize: %i\n\r",
							(INT8U) p_img_control->dataset[0]->imagette_start,
							(INT32U) p_img_control->dataset[0]->offset,
							(INT32U) p_img_control->size);
#endif

#if DEBUG_ON
					printf("[CommandManagementTask]Data parsed\r\n");
#endif

					/*
					 * DMA test 1
					 */
					INT16U i_dma_counter = 0;
					while (i_dma_counter < p_img_control->nb_of_imagettes) {

						bIdmaDmaM1Transfer(
								(INT32U*) (p_img_control->dataset[i_dma_counter]),
								p_img_control->dataset[i_dma_counter]->imagette_length
										+ DMA_OFFSET, 0);
						i_dma_counter++;
					}

					config_send->imagette = p_img_control;

					v_ack_creator(p_payload, exec_error);

					error_code = (INT8U) OSQPost(p_simucam_command_q,
							p_payload);
					alt_SSSErrorHandler(error_code, 0);
					break;
				}
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
#if DEBUG_ON
				printf("[CommandManagementTask]Change Mode\r\n");
#endif

				b_meb_status = p_payload->data[0];

				if (b_meb_status == 1) {
					config_send->mode = 1;

					error_code = (INT8U) OSQPost(p_sub_unit_config_queue,
							config_send);
					alt_SSSErrorHandler(error_code, 0);
				}

#if DEBUG_ON
				printf("[CommandManagementTask]Config sent to sub\n\r");
#endif

				v_ack_creator(p_payload, ACK_OK);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);

				break;

				/*
				 * Clear RAM
				 */
			case 108:
#if DEBUG_ON
				printf("[CommandManagementTask]Clear RAM\r\n");
#endif

				v_ack_creator(p_payload, NOT_IMPLEMENTED);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);

				break;

				/*
				 * Get HK
				 */
			case 110:
#if DEBUG_ON
				printf("[CommandManagementTask]Get HK\r\n");
#endif
				i_channel_buffer = p_payload->data[0];

				v_HK_creator(p_payload, i_channel_buffer);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);
				break;

				/*
				 * Config MEB
				 */
			case 111:
#if DEBUG_ON
				printf("[CommandManagementTask]Clear RAM\r\n");
#endif
				i_forward_data = p_payload->data[0];
				i_echo_sent_data = p_payload->data[1];
#if DEBUG_ON
				printf(
						"[CommandManagementTask]Meb configs: fwd: %i, echo: %i\r\n",
						(int) i_forward_data, (int) i_echo_sent_data);
#endif
				v_ack_creator(p_payload, ACK_OK);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);

				break;

				/*
				 * Set Recording
				 */
			case 112:
#if DEBUG_ON
				printf("[CommandManagementTask]Selected command: %c\n\r",
						(int) p_payload->type);
#endif
				v_ack_creator(p_payload, NOT_IMPLEMENTED);

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);

				break;

			default:
#if DEBUG_ON
				printf(
						"[CommandManagementTask]Nenhum comando identificado\n\r");
#endif

				if (p_payload->type == 106 || p_payload->type == 106
						|| p_payload->type == 107 || p_payload->type == 109) {
					v_ack_creator(p_payload, COMMAND_NOT_ACCEPTED);
				} else {
					v_ack_creator(p_payload, COMMAND_NOT_FOUND);
				}

				error_code = (INT8U) OSQPost(p_simucam_command_q, p_payload);
				alt_SSSErrorHandler(error_code, 0);

				break;
			} //Switch fim

			/*
			 * Create a error management task and queue
			 */

			exec_error = 0; /*restart error value*/

		}

		/*
		 * MEB in running mode
		 */
		while (b_meb_status == 1) {
			INT8U i_internal_error;
			static INT8U b_timer_starter = 0;
			exec_error = 0;

			OSTmrStart((OS_TMR *) simucam_running_timer,
					(INT8U *) &i_internal_error);

			/*
			 * Start timer for ChA
			 * NOT STARTING THE TIMER
			 */
			bDschStartTimer(&(xChA.xDataScheduler));

#if DEBUG_ON
			printf("MEB in running mode\n\r");
#endif
			if (b_timer_starter == 0) {

				/*
				 * Initializing central control timer
				 */
				central_timer = OSTmrCreate(0, CENTRAL_TIMER_RESOLUTION,
				OS_TMR_OPT_PERIODIC, central_timer_callback_function,
						(void *) 0, (INT8U*) "Central Timer",
						(INT8U*) &exec_error);

				if (exec_error == OS_ERR_NONE) {
					b_timer_starter = 1;

					/* Timer was created but NOT started */
#if DEBUG_ON
					printf(
							"[CommandManagementTask]SWTimer1 was created but NOT started \n");
#endif
				}

			}
#if DEBUG_ON
			printf("[CommandManagementTask RUNNING]Waiting command...\r\n");
#endif
			p_payload = OSQPend(p_simucam_command_q, 0, &i_internal_error);
			alt_uCOSIIErrorHandler(i_internal_error, 0);

			/*
			 * SYNC cmd
			 */
			if (p_payload->type == 106) {

				bSyncCtrOneShot();

#if DEBUG_ON
				printf("[CommandManagementTask]Starting timer\r\n");
#endif
				OSTmrStart((OS_TMR *) central_timer,
						(INT8U *) &i_internal_error);
				if (i_internal_error == OS_ERR_NONE) {
					b_timer_starter = 1;

#if DEBUG_ON
					printf("[CommandManagementTask]timer started\r\n");
#endif

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

#if DEBUG_ON
					printf("[CommandManagementTask]MEB status to: %i\r\n",
							(INT8U) p_payload->data[0]);
#endif

					b_meb_status = p_payload->data[0];

					if (b_meb_status == 0) {
						i_central_timer_counter = 1;

						/*
						 * Send sub_units to config.
						 */
#if DEBUG_ON
						printf(
								"[CommandManagementTask]Sending change mode command...\r\n");
#endif

						/*
						 * Stop and restart running timer
						 */

						/*
						 * Stop and clear ChA timer
						 */
						bDschStopTimer(&(xChA.xDataScheduler));
						bDschClrTimer(&(xChA.xDataScheduler));

						OSTmrStop(simucam_running_timer,
						OS_TMR_OPT_NONE, (void *) 0, &i_internal_error);
						if (i_internal_error == OS_ERR_NONE
								|| i_internal_error == OS_ERR_TMR_STOPPED) {
#if DEBUG_ON
							printf(
									"[CommandManagementTask Restart]Running Timer stopped\r\n");
#endif

							i_running_timer_counter = 1;

#if DEBUG_ON
							printf(
									"[CommandManagementTask Restart]Running Timer restarted\r\n");
#endif
						}

						error_code = OSQPost(p_sub_unit_command_queue,
								i_return_config_flag);
						OSSemPost(sub_unit_command_semaphore);
						alt_SSSErrorHandler(error_code, 0);
					}

					v_ack_creator(p_payload, ACK_OK);

					error_code = (INT8U) OSQPost(p_simucam_command_q,
							p_payload);
					alt_SSSErrorHandler(error_code, 0);

					break;

					/*
					 * End of dataset internal command
					 */
				case 5:
#if DEBUG_ON
					printf(
							"[CommandManagementTask]End of dataset, restarting\r\n");
#endif
					printf(
							"[CommandManagementTask]End of dataset, restarting\r\n");
					/*
					 * Stop and clear ChA timer
					 */
					bDschStopTimer(&(xChA.xDataScheduler));
					bDschClrTimer(&(xChA.xDataScheduler));

					INT16U i_dma_counter = 0;
					while (i_dma_counter < p_img_control->nb_of_imagettes) {

						bIdmaDmaM1Transfer(
								(INT32U*) (p_img_control->dataset[i_dma_counter]),
								p_img_control->dataset[i_dma_counter]->imagette_length
										+ DMA_OFFSET, 0);
						i_dma_counter++;
					}

//					/*
//					 * Start timer for ChA
//					 * NOT STARTING THE TIMER
//					 */
//					bDschStartTimer(&(xChA.xDataScheduler));

					OSTmrStop(central_timer,
					OS_TMR_OPT_NONE, (void *) 0, &i_internal_error);

					if (i_internal_error == OS_ERR_NONE
							|| i_internal_error == OS_ERR_TMR_STOPPED) {
#if DEBUG_ON
						printf(
								"[CommandManagementTask Restart]Timer stopped\r\n");
#endif
						i_central_timer_counter = 1;
//						OSQPost(p_sub_unit_command_queue, abort_flag);
//						OSSemPost(sub_unit_command_semaphore);
#if DEBUG_ON
						printf(
								"[CommandManagementTask Restart]Timer restarted\r\n");
#endif
					}

					break;
					/*
					 * Abort Sending
					 *
					 * Implement a abort queue
					 *
					 */
				case 107:
#if DEBUG_ON
					printf("[CommandManagementTask]Selected command: %i\n\r",
							(int) p_payload->type);
#endif

					bDschStopTimer(&(xChA.xDataScheduler));
					bDschClrTimer(&(xChA.xDataScheduler));

					OSTmrStop(central_timer,
					OS_TMR_OPT_NONE, (void *) 0, &i_internal_error);

					if (i_internal_error == OS_ERR_NONE
							|| i_internal_error == OS_ERR_TMR_STOPPED) {
#if DEBUG_ON
						printf(
								"[CommandManagementTask Abort]Timer stopped\r\n");
#endif
						i_central_timer_counter = 1;
						OSQPost(p_sub_unit_command_queue, abort_flag);
						OSSemPost(sub_unit_command_semaphore);
#if DEBUG_ON
						printf(
								"[CommandManagementTask Abort]Timer restarted\r\n");
#endif
						v_ack_creator(p_payload, ACK_OK);
					} else {
						v_ack_creator(p_payload, TIMER_ERROR);
					}

					error_code = (INT8U) OSQPost(p_simucam_command_q,
							p_payload);
					alt_SSSErrorHandler(error_code, 0);
					break;

					/*
					 * Direct send
					 */
				case 109:
#if DEBUG_ON
					printf("[CommandManagementTask]Direct Send to %c\n\r",
							(char) (p_payload->data[0] + ASCII_A));
#endif
//					error_code = b_SpaceWire_Interface_Send_SpaceWire_Data(
//							(char) p_payload->data[0] + ASCII_A,
//							&(p_payload->data[1]), (p_payload->size) - 11);
//
//					if (i_echo_sent_data == 1) {
//						i_echo_dataset_direct_send(p_payload, p_tx_buffer);
//
//						exec_error = send(conn.fd, p_tx_buffer,
//								p_payload->size + 4, 0);
//					}
//
//					if (exec_error == -1) {
//						v_ack_creator(p_payload, ECHO_ERROR);
//					} else {
//						v_ack_creator(p_payload, ACK_OK);
//					}
//
//					error_code = (INT8U) OSQPost(p_simucam_command_q,
//							p_payload);
//					alt_SSSErrorHandler(error_code, 0);

					break;

					/*
					 * Get HK
					 */
				case 110:
#if DEBUG_ON
					printf("[CommandManagementTask]Get HK\r\n");
#endif
					v_HK_creator(p_payload, p_payload->data[0]);

					error_code = (INT8U) OSQPost(p_simucam_command_q,
							p_payload);
					alt_SSSErrorHandler(error_code, 0);
					break;

				default:
#if DEBUG_ON
					printf(
							"[CommandManagementTask]Nenhum comando aceito em modo running\n\r");
#endif
					if (p_payload->type == 101 || p_payload->type == 102
							|| p_payload->type == 103 || p_payload->type == 104
							|| p_payload->type == 108
							|| p_payload->type == 111) {
						v_ack_creator(p_payload, COMMAND_NOT_ACCEPTED);
					} else {
						v_ack_creator(p_payload, COMMAND_NOT_FOUND);
					}

					error_code = (INT8U) OSQPost(p_simucam_command_q,
							p_payload);
					alt_SSSErrorHandler(error_code, 0);

					break;

				}

			}
		}
	}
}
