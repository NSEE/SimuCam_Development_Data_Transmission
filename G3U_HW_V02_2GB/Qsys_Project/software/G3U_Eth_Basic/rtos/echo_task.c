/*
 ************************************************************************************************
 *                                              NSEE
 *                                             Address
 *
 *                                       All Rights Reserved
 *
 *
 * Filename     : echo_task.c
 * Programmer(s): Yuri Bunduki
 * Created on: May 07, 2019
 * Description  : Source file for the echo function management task.
 ************************************************************************************************
 */
/*$PAGE*/

#include "echo_task.h"

/**
 * @name i_echo_dataset
 * @brief Echo SpW data to NUC
 *
 * @param 	[in] 	INT32U i_sim_time
 *          [in]    INT16U i_imagette_number
 *          [in]    INT8U i_channel
 * 
 * @retval void
 **/
void i_echo_dataset(INT32U i_sim_time, INT16U i_imagette_number, INT8U i_channel) {
	static INT8U tx_buffer[15];	//change to macro later

	INT32U i_mem_pointer_buffer;
	T_Imagette *p_imagette_buffer;
	INT8U *pDataPointer;

	INT8U i = 0;
	INT32U nb_size;
	INT32U nb_time = i_sim_time;
	INT16U nb_id = T_simucam.T_status.TM_id;
	INT16U usCRC = 0;
	INT16U i_length_buffer = 0;

#if DEBUG_ON
	if (T_simucam.T_conf.usiDebugLevels <= xMajor) {
		fprintf(fp, "[ECHO]Entered echo sender\r\n");
	}
#endif

	/*
	 * Select the apropriate RAM stick
	 */

	bDdr2SwitchMemory((unsigned char) i_channel / 4);

	/*
	 * go to the right addr
	 */
	p_imagette_buffer = (T_Imagette *) T_simucam.T_Sub[i_channel].T_data.addr_init;
#if DEBUG_ON
	if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
		fprintf(fp, "[ECHO] imagette nb %i\r\n", i_imagette_number);
	}
#endif
	for (i = 0; i < i_imagette_number; i++) {

		i_mem_pointer_buffer = (INT32U) p_imagette_buffer + p_imagette_buffer->imagette_length + DMA_OFFSET;

		if ((i_mem_pointer_buffer % 8)) {
			i_mem_pointer_buffer = ((((i_mem_pointer_buffer) >> 3) + 1) << 3);
		}
		p_imagette_buffer = (T_Imagette *) i_mem_pointer_buffer;
	}

#if DEBUG_ON
	if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
		fprintf(fp, "[ECHO]Imagette %i channel: %i lenght: %lu, first byte %i\r\n", i_imagette_number, i_channel, p_imagette_buffer->imagette_length,
				p_imagette_buffer->imagette_start);
	}
#endif

	i_length_buffer = p_imagette_buffer->imagette_length;
	nb_size = i_length_buffer + ECHO_CMD_OVERHEAD;

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

	/**
	 * Partial Calculating CRC
	 */
	usCRC = crc__CRC16CCITT(tx_buffer, 13);

	/*
	 * Send the compiled data
	 */

	for (INT8U t = 0; t < 13; t++) {
		// fprintf(fp, "%i", tx_buffer[t]);
		vUartWriteCharBlocking(tx_buffer[t]);
	}

	/**
	 * Assign the correct memory pointer to the 
	 * pointing buffer
	 */
	pDataPointer = &(p_imagette_buffer->imagette_start);

	/**
	 *  Calculating CRC
	 */

	usCRC = prev_crc__CRC16CCITT(pDataPointer, i_length_buffer, usCRC);

	/**
	 * Sending data
	 */
	for (size_t i = 0; i < i_length_buffer; i++) {
		/* Assure the right memory is in use */
		bDdr2SwitchMemory((unsigned char) i_channel / 4);
		/* Print imagette char */
		// fprintf(fp, "%i",(INT8U) *pDataPointer);
		vUartWriteCharBlocking(*pDataPointer);
		/* Advance the buffer pointer 1 byte */
		pDataPointer++;

#if DEBUG_ON
		if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
			fprintf(fp, "[ECHO]Bytes left to send: %i\r\n", i_length_buffer);
		}
#endif
	}

	/**
	 * Sending CRC
	 */
	tx_buffer[14] = div(usCRC, 256).rem;
	usCRC = div(usCRC, 256).quot;
	tx_buffer[13] = div(usCRC, 256).rem;
	// fprintf(fp, "%i%i", tx_buffer[13], tx_buffer[14]); //mock CRC
	vUartWriteCharBlocking(tx_buffer[13]);
	vUartWriteCharBlocking(tx_buffer[14]);

	T_simucam.T_status.TM_id++;
}

OS_EVENT *p_echo_queue;
void *p_echo_queue_tbl[ECHO_QUEUE_BUFFER]; /*Storage for sub_unit queue*/

void echo_task(void *task_data) {
	INT8U echo_error;
	x_echo *p_echo_rcvd;

#if DEBUG_ON
	if (T_simucam.T_conf.usiDebugLevels <= xMajor) {
		fprintf(fp, "[ECHO]Initialized Echo Task\r\n");
	}
#endif

	while (1) {

		p_echo_rcvd = (x_echo *) OSQPend(p_echo_queue, 0, &echo_error);
		if (echo_error == OS_ERR_NONE) {
			
#if DEBUG_ON
			// if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
				fprintf(fp, "[ECHO]Echo received on queue.\r\n");
			// }
#endif

			if (T_simucam.T_conf.echo_sent == 1) {
				i_echo_dataset(p_echo_rcvd->simucam_time, p_echo_rcvd->nb_imagette, p_echo_rcvd->channel);
#if DEBUG_ON
				if (T_simucam.T_conf.usiDebugLevels <= xVerbose) {
					fprintf(fp, "[ECHO]Echo Sent nb: %i CH: %i\r\n", p_echo_rcvd->nb_imagette, p_echo_rcvd->channel);
				}
#endif
			}
			// if (T_simucam.T_conf.echo_sent == 3) {
			// 	OSQFlush(p_echo_queue);
			// 	T_simucam.T_conf.echo_sent = 0;
			// }
		} else {
#if DEBUG_ON
			/* Create ack */
			if (T_simucam.T_conf.usiDebugLevels <= xCritical) {
				fprintf(fp, "[ECHO] Echo queue error.\r\n");
			}
#endif
		}

	}
}
