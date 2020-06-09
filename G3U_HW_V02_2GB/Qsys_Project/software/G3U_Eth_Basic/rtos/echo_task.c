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
void i_echo_dataset(INT32U i_sim_time, INT16U i_imagette_number,
		INT8U i_channel) {
	static INT8U tx_buffer[15];	//change to macro later

	INT32U i_mem_pointer_buffer;
	T_Imagette *p_imagette_buffer;
    INT8U      *pDataPointer;

	INT8U i = 0;
	INT32U nb_size;
	INT32U nb_time = i_sim_time;
	INT16U nb_id = T_simucam.T_status.TM_id;
	INT16U usCRC = 0;
	INT16U i_length_buffer = 0;

#if DEBUG_ON
	if (T_simucam.T_conf.usiDebugLevels >= xMajor){
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
	p_imagette_buffer =
			(T_Imagette *) T_simucam.T_Sub[i_channel].T_data.addr_init;
#if DEBUG_ON
	if (T_simucam.T_conf.usiDebugLevels >= xVerbose){
        fprintf(fp, "[ECHO] imagette nb %i\r\n", i_imagette_number);
    }
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
	if(T_simucam.T_conf.usiDebugLevels >= xVerbose){
        fprintf(fp, "[ECHO]Imagette %i channel: %i lenght: %lu, first byte %i\r\n",
            i_imagette_number, i_channel, p_imagette_buffer->imagette_length,
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
     * TODO change to printf
	 */

    for (INT8U t = 0; t < 13; t++) {
        printf("%i", tx_buffer[t]);
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
    for (size_t i = 0; i < i_length_buffer; i++)
    {   
        /* Assure the right memory is in use */
        bDdr2SwitchMemory((unsigned char) i_channel / 4);
        /* Print imagette char */
        printf("%i",(INT8U) *pDataPointer);
        /* Advance the buffer pointer 1 byte */
        pDataPointer++;

#if DEBUG_ON
        if(T_simucam.T_conf.usiDebugLevels >= xVerbose) {
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
    printf("%i%i", tx_buffer[13], tx_buffer[14]); //mock CRC
     

	T_simucam.T_status.TM_id++;
}

/**
 * @name vLogSend
 * @brief Generates and sends log to NUC
 * @ingroup UTIL
 *
 * @param 	[in] 	INT32U i_sim_time
 *          [in]    INT16U i_imagette_number
 *          [in]    INT8U i_channel
 *          [in]    INT8U iTAG[]
 * 
 * @retval void
 **/
void vLogSend(INT32U i_sim_time, INT16U i_imagette_number,
		INT8U i_channel, INT8U iTAG[]){
    
    static INT8U tx_buffer[LOG_SIZE];
	INT32U nb_time = i_sim_time;
	INT16U nb_id = T_simucam.T_status.TM_id;
    INT16U iImagetteNbBuffer = i_imagette_number;
    INT16U usCRC;

	tx_buffer[0] = 4;

	tx_buffer[2] = div(nb_id, 256).rem;
	nb_id = div(nb_id, 256).quot;
	tx_buffer[1] = div(nb_id, 256).rem;

    tx_buffer[3] = typeSentLog;

    tx_buffer[4] = 0;
    tx_buffer[5] = 0;
    tx_buffer[6] = 0;
    tx_buffer[7] = LOG_SIZE;

    /* Timer to bytes */
	tx_buffer[11] = div(nb_time, 256).rem;
	nb_time = div(nb_time, 256).quot;
	tx_buffer[10] = div(nb_time, 256).rem;
	nb_time = div(nb_time, 256).quot;
	tx_buffer[9] = div(nb_time, 256).rem;
	nb_time = div(nb_time, 256).quot;
	tx_buffer[8] = div(nb_time, 256).rem;

    /* Channel */
	tx_buffer[12] = i_channel;

    for (INT8U y = 0; y < 8; y++)
    {
        tx_buffer[13 + y] = iTAG[y];
    }
    
    tx_buffer[22] = div(iImagetteNbBuffer, 256).rem;
	iImagetteNbBuffer = div(iImagetteNbBuffer, 256).quot;
	tx_buffer[21] = div(iImagetteNbBuffer, 256).rem;
    
    /**
	 * Calculating CRC
	 */
	usCRC = crc__CRC16CCITT(tx_buffer, LOG_SIZE - 2);

	tx_buffer[24] = div(usCRC, 256).rem;
	usCRC = div(usCRC, 256).quot;
	tx_buffer[23] = div(usCRC, 256).rem;

    /*
     * Send Log through serial
     */
    for (int f = 0; f < LOG_SIZE; f++){
		printf("%c", tx_buffer[f]);
	}

	T_simucam.T_status.TM_id++;
}

OS_EVENT *p_echo_queue;
void *p_echo_queue_tbl[ECHO_QUEUE_BUFFER]; /*Storage for sub_unit queue*/

void echo_task(void) {
	INT8U echo_error;
	x_echo *p_echo_rcvd;

#if DEBUG_ON
	if (T_simucam.T_conf.usiDebugLevels >= xMajor){
        fprintf(fp, "[ECHO]Initialized Echo Task\r\n");
    }
#endif

	while (1) {

		p_echo_rcvd = (x_echo *) OSQPend(p_echo_queue, 0, &echo_error);
		if (echo_error == OS_ERR_NONE) {
            if(T_simucam.T_conf.echo_sent == 1){
			i_echo_dataset(p_echo_rcvd->simucam_time, p_echo_rcvd->nb_imagette,
					p_echo_rcvd->channel);
                    }
            if(T_simucam.T_conf.iLog == 1){
                vLogSend(p_echo_rcvd->simucam_time, p_echo_rcvd->nb_imagette,
					p_echo_rcvd->channel, p_echo_rcvd->iTag);
            }
		} else {
#if DEBUG_ON
            /* Create ack */
			if (T_simucam.T_conf.usiDebugLevels >= xCritical){
                fprintf(fp, "[ECHO] Echo queue error.\r\n");
            }
#endif
		}

	}
}
