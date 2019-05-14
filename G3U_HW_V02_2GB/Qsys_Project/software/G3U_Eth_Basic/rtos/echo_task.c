/*
 * echo_task.c
 *
 *  Created on: 07/05/2019
 *      Author: root
 */
#include "echo_task.h"

/*
 * Echo data creation function
 */

void i_echo_dataset(INT32U i_sim_time, INT16U i_imagette_number,
		INT8U i_channel) {
	static INT8U tx_buffer[15];	//change to macro later

	INT32U i_mem_pointer_buffer;
	T_Imagette *p_imagette_buffer;

	INT8U i = 0;
	INT32U nb_size;
	INT32U nb_time = i_sim_time;
	INT16U nb_id = T_simucam.T_status.TM_id;
	INT16U crc = 0;


	/*
	 * Select the apropriate RAM stick
	 */

	bDdr2SwitchMemory((unsigned char) i_channel / 4);

	/*
	 * go to the right addr
	 */
	p_imagette_buffer =
			(T_Imagette *) T_simucam.T_Sub[i_channel].T_data.addr_init;
#if DEBUG_ON
	printf("[ECHO] imagette nb %i\r\n", i_imagette_number);
#endif
	for (i = 0; i < i_imagette_number; i++) {

		i_mem_pointer_buffer = (INT32U) p_imagette_buffer
				+ p_imagette_buffer->imagette_length + DMA_OFFSET;

		if ((i_mem_pointer_buffer % 8)) {
			i_mem_pointer_buffer = ((((i_mem_pointer_buffer) >> 3) + 1) << 3);
		}
		p_imagette_buffer = (T_Imagette *) i_mem_pointer_buffer;
	}

#if DEBUG_ON
	printf("[ECHO]Imagette %i channel: %i lenght: %lu, first byte %i\r\n",
			i_imagette_number, i_channel, p_imagette_buffer->imagette_length,
			p_imagette_buffer->imagette_start);
#endif

	nb_size = p_imagette_buffer->imagette_length + ECHO_CMD_OVERHEAD;

	tx_buffer[0] = 2;

	tx_buffer[2] = div(nb_id, 256).rem;
	nb_id = div(nb_id, 256).quot;
	tx_buffer[1] = div(nb_id, 256).rem;

	/* type */

	tx_buffer[3] = 203;

	/*Size to bytes*/

	tx_buffer[7] = div(nb_size, 256).rem;
	nb_size = div(nb_size, 256).quot;
	tx_buffer[6] = div(nb_size, 256).rem;
	nb_size = div(nb_size, 256).quot;
	tx_buffer[5] = div(nb_size, 256).rem;
	nb_size = div(nb_size, 256).quot;
	tx_buffer[4] = div(nb_size, 256).rem;

	/* Timer to bytes */
	tx_buffer[11] = div(nb_time, 256).rem;
	nb_time = div(nb_time, 256).quot;
	tx_buffer[10] = div(nb_time, 256).rem;
	nb_time = div(nb_time, 256).quot;
	tx_buffer[9] = div(nb_time, 256).rem;
	nb_time = div(nb_time, 256).quot;
	tx_buffer[8] = div(nb_time, 256).rem;

	tx_buffer[12] = i_channel;

//	while (i < p_imagette->imagette_length[i_imagette_number]) {
//		tx_buffer[i + (ECHO_CMD_OVERHEAD - 2)] =
//				p_imagette->imagette[i_imagette_counter_echo];
//		i++;
//		i_imagette_counter_echo++;
//	}

//crc = crc16(tx_buffer, (p_imagette->size - 11) + ECHO_CMD_OVERHEAD);
//crc is tx_buffer [13, 14]
	tx_buffer[14] = div(crc, 256).rem;
	crc = div(crc, 256).quot;
	tx_buffer[13] = div(crc, 256).rem;

	/*
	 * Send the compiled data
	 */

	send(conn.fd, &tx_buffer, 13, 0);
	bDdr2SwitchMemory((unsigned char) i_channel / 4); /* Assure the right memory */
	send(conn.fd, &(p_imagette_buffer->imagette_start),
			p_imagette_buffer->imagette_length, 0);
	send(conn.fd, &(tx_buffer[13]), 2, 0);
//send CRC

	T_simucam.T_status.TM_id++;
}

OS_EVENT *p_echo_queue;
void *p_echo_queue_tbl[ECHO_QUEUE_BUFFER]; /*Storage for sub_unit queue*/

void echo_task(void) {
	INT8U echo_error;
	x_echo *p_echo_rcvd;

	while (1) {

		p_echo_rcvd = (x_echo *) OSQPend(p_echo_queue, 0, &echo_error);
		if (echo_error == OS_ERR_NONE) {
			i_echo_dataset(p_echo_rcvd->simucam_time, p_echo_rcvd->nb_imagette,
					p_echo_rcvd->channel);
		} else {
#if DEBUG_ON
			printf("[ECHO] Echo queue error.\r\n");
#endif
		}

	}
}
