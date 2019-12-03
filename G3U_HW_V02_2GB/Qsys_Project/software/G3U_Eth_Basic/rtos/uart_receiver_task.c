/*
 ************************************************************************************************
 *                                              NSEE
 *                                             Address
 *
 *                                       All Rights Reserved
 *
 *
 * Filename     : uart_receiver_task.c
 * Programmer(s): Yuri Bunduki
 * Created on: Nov 28, 2019
 * Description  : Source file for the uart communication receiver task.
 ************************************************************************************************
 */
/*$PAGE*/

#include "uart_receiver_task.h"



/**
 * @name vHeaderParser
 * @brief Parses header from buffer
 * @ingroup rtos
 *
 * @param 	[in]	_ethernet_payload * 	Command structure
 * @param	[in]	char * 	char buffer
 *
 * @retval void
 **/
void vHeaderParser(_ethernet_payload *pPayload, char *cReceiveBuffer){

#if DEBUG_ON
    printf("[UART HParser]Received Bytes: %u %u %u %u %u %u %u %u\n", 
        cReceiveBuffer[0], cReceiveBuffer[1], cReceiveBuffer[2], cReceiveBuffer[3], cReceiveBuffer[4],
        cReceiveBuffer[5], cReceiveBuffer[6], cReceiveBuffer[7]);
#endif

    pPayload->header = cReceiveBuffer[0];
    
    pPayload->packet_id = cReceiveBuffer[2]
            + 256 * cReceiveBuffer[1];

    pPayload->type = cReceiveBuffer[3];

    pPayload->size = cReceiveBuffer[7]
            + 256 * cReceiveBuffer[6]
            + 65536 * cReceiveBuffer[5]
            + 4294967296 * cReceiveBuffer[4];
#if DEBUG_ON
    printf("[UART HParser]Parsed header %u, Parsed id: %u, parsed type %u, parsed size %lu\n", pPayload->header, pPayload->packet_id, pPayload->type, pPayload->size);
#endif
}

/**
 * @name vCmdParser
 * @brief Parses command from serial
 * @ingroup rtos
 *
 * @param 	[in]	T_Simucam * 	    simucam model control structure
 * @param 	[in]	T_uart_payload * 	payload structure
 * 
 * @retval void
 **/
void vImagetteParser(T_Simucam *pSimucam, T_uart_payload *pPayload){

     INT8U *p_imagette_byte;
     INT16U i_nb_imag_ctrl = 0;
     INT8U i_channel_wr = 0;

 #if DEBUG_ON
     fprintf(fp, "[sss_handle_receive DEBUG]Entered parser\r\n");
 #endif

//     if (T_simucam.T_status.simucam_mode == simModeConfig) {
//         rx_code = recv(conn->fd,
//                 (char* )p_ethernet_buffer->rx_wr_pos, 12, 0);
//         if (rx_code > 0) {
//             p_ethernet_buffer->rx_rd_pos += rx_code;
//         }
//         i_channel_wr = p_ethernet_buffer->rx_buffer[1];
//
//         /*
//             * Switch to the right memory stick
//             */
//         if (((unsigned char) i_channel_wr / 4) == 0) {
//             bDdr2SwitchMemory(DDR2_M1_ID);
//         } else {
//             bDdr2SwitchMemory(DDR2_M2_ID);
//         }
//
//         T_Imagette *p_imagette_buff;
//
//         p_imagette_byte =
//                 (INT32U) T_simucam.T_Sub[i_channel_wr].T_data.addr_init;
//
//         /*
//             * Parse nb of imagettes
//             */
//         T_simucam.T_Sub[i_channel_wr].T_data.nb_of_imagettes =
//                 p_ethernet_buffer->rx_buffer[3]
//                         + 256 * p_ethernet_buffer->rx_buffer[2];
//
//         /*
//             * Parse TAG
//             */
//         T_simucam.T_Sub[i_channel_wr].T_data.tag[7] =
//                 p_ethernet_buffer->rx_buffer[4];
//         T_simucam.T_Sub[i_channel_wr].T_data.tag[6] =
//                 p_ethernet_buffer->rx_buffer[5];
//         T_simucam.T_Sub[i_channel_wr].T_data.tag[5] =
//                 p_ethernet_buffer->rx_buffer[6];
//         T_simucam.T_Sub[i_channel_wr].T_data.tag[4] =
//                 p_ethernet_buffer->rx_buffer[7];
//         T_simucam.T_Sub[i_channel_wr].T_data.tag[3] =
//                 p_ethernet_buffer->rx_buffer[8];
//         T_simucam.T_Sub[i_channel_wr].T_data.tag[2] =
//                 p_ethernet_buffer->rx_buffer[9];
//         T_simucam.T_Sub[i_channel_wr].T_data.tag[1] =
//                 p_ethernet_buffer->rx_buffer[10];
//         T_simucam.T_Sub[i_channel_wr].T_data.tag[0] =
//                 p_ethernet_buffer->rx_buffer[11];
//
//         /*
//             * Parse imagettes
//             */
//         while (i_nb_imag_ctrl
//                 < T_simucam.T_Sub[i_channel_wr].T_data.nb_of_imagettes) {
//
//             p_imagette_buff = (T_Imagette *) p_imagette_byte;
//             /*
//                 * Receive 6 bytes for offset and length
//                 */
//             rx_code = recv(conn->fd,
//                     (char* )p_ethernet_buffer->rx_wr_pos, 6, 0);
//             if (rx_code > 0) {
//                 p_ethernet_buffer->rx_rd_pos += rx_code;
//
//             }
//
//             p_imagette_buff->offset =
//                     p_ethernet_buffer->rx_buffer[3]
//                             + 256 * p_ethernet_buffer->rx_buffer[2]
//                             + 65536
//                                     * p_ethernet_buffer->rx_buffer[1]
//                             + 4294967296
//                                     * p_ethernet_buffer->rx_buffer[0];
//
//             p_imagette_buff->imagette_length =
//                     p_ethernet_buffer->rx_buffer[5]
//                             + 256 * p_ethernet_buffer->rx_buffer[4];
// #if DEBUG_ON
//             fprintf(fp, "[SSS]Imagette %i length: %i\r\n", i_nb_imag_ctrl,
//                     p_imagette_buff->imagette_length);
// #endif
//             p_imagette_byte += 6;
//             i_length_buff = p_imagette_buff->imagette_length;
//             while (i_length_buff > 0) {
//                 rx_code = recv(conn->fd, (void * )p_imagette_byte,
//                         i_length_buff, 0);
//                 if (rx_code > 0) {
//                     /*
//                         * TODO prepare for fragmented receive
//                         * if rx_code < data to receive, receive again
//                         */
// #if DEBUG_ON
//                     fprintf(fp,
//                             "[SSS] received bytes in imagette %i: %i\r\n",
//                             i_nb_imag_ctrl, rx_code);
// #endif
//                     p_imagette_byte += rx_code;
//                     i_length_buff -= rx_code;
//                 }
//             }
//             if (((INT32U) p_imagette_byte % 8)) {
//                 p_imagette_byte =
//                         (INT8U *) (((((INT32U) p_imagette_byte) >> 3)
//                                 + 1) << 3);
//             }
//
// #if DEBUG_ON
//             T_teste_data *pxTestData =
//             (T_teste_data *) T_simucam.T_Sub[i_channel_wr].T_data.addr_init;
// #endif
//             i_nb_imag_ctrl++;
//         }
//
//         rx_code = recv(conn->fd,
//                 (char* )p_ethernet_buffer->rx_wr_pos, 2, 0);
//         if (rx_code > 0) {
//             p_ethernet_buffer->rx_rd_pos += rx_code;
//
//             /* Zero terminate so we can use string functions */
//             *(p_ethernet_buffer->rx_wr_pos + 1) = 0;
//         }
//         /* Verificar se chegou tudo */
//
//         payload.crc = p_ethernet_buffer->rx_buffer[1]
//                 + 256 * p_ethernet_buffer->rx_buffer[0];
//         i_ack = ACK_OK;
//     } else {
//         /*
//             * Empty the ethernet stack to avoid garbage
//             */
//         if (payload.size < BUFFER_SIZE) {
//             rx_code = recv(conn->fd,
//                     (char* )p_ethernet_buffer->rx_wr_pos,
//                     payload.size, 0);
//             if (rx_code > 0) {
//                 p_ethernet_buffer->rx_rd_pos += rx_code;
//             }
//         } else {
//             while (payload.size > BUFFER_SIZE) {
//                 rx_code = recv(conn->fd,
//                         (char* )p_ethernet_buffer->rx_wr_pos,
//                         BUFFER_SIZE, 0);
//                 if (rx_code > 0) {
//                     p_ethernet_buffer->rx_rd_pos += rx_code;
//                     payload.size -= BUFFER_SIZE;
//                 }
//             }
//         }
//         i_ack = COMMAND_NOT_ACCEPTED;
//     }
}

/**
 * @name vCmdParser
 * @brief Parses command from serial
 * @ingroup rtos
 *
 * @param 	[in]	T_uart_payload * 	payload structure
 *
 * @retval void
 **/
void vCmdParser(T_uart_payload *pUartPayload){
    INT8U cBuff[UART_BUFFER_SIZE];
    int i = 0;

    memset(pUartPayload->data, 0, pUartPayload->size - PAYLOAD_OVERHEAD + 1);

    /*
    * Assign data in the payload struct to data in the buffer
    * change to 0
    */
    if (pUartPayload->size > PAYLOAD_OVERHEAD) {
        
        /* Get payload data from RS232 */                
        fgets(pUartPayload->data, pUartPayload->size - PAYLOAD_OVERHEAD, stdin);

#if DEBUG_ON
        for (i = 1; i <= pUartPayload->size - PAYLOAD_OVERHEAD; i++) {
            fprintf(fp, 
                    "[vCmdParser DEBUG]data: %i\r\nPing %i\r\n",
                    (INT8U) pUartPayload->data[i - 1], (INT8U) i);
        }
#endif
    }

    /* Get CRC from RS232 */
    fgets(pUartPayload->crc, 2, stdin);

#if DEBUG_ON
    fprintf(fp, "[vCmdParser DEBUG]Received CRC = %i\n",
            (INT16U) pUartPayload->crc);
#endif
    
    // calculated_crc = crc16(p_ethernet_buffer->rx_buffer,
    //         pUartPayload->size);

#if DEBUG_ON
    fprintf(fp, "[vCmdParser DEBUG]finished receiving\n");
#endif
}

void uart_receiver_task(void *task_data){
    bool bSuccess = FALSE;
    char cReceiveBuffer[UART_BUFFER_SIZE];
    char cReceive[UART_BUFFER_SIZE+64];
    tReaderStates eReaderRXMode = sRConfiguring;
    static _ethernet_payload payload;

    for(;;) {

        switch (eReaderRXMode){
            case sRConfiguring:
            	fprintf(fp, "[UART RCV] Uart receiver init\n");
                eReaderRXMode = sGetHeader;
                break;
            case sGetHeader:
            #if DEBUG_ON
                fprintf(fp, "[UART RCV] Waiting data\n");
            #endif
                memset(cReceiveBuffer, 0, UART_BUFFER_SIZE);
                memset(cReceive, 0, UART_BUFFER_SIZE);
                
                fgets(cReceive,9,stdin);
                //memcpy(cReceiveBuffer, cReceive, (UART_BUFFER_SIZE -1) ); /* Make that there's a zero terminator */
                
                /* For testing only */
                printf("[UART RCV]Received data: %s\n", cReceiveBuffer);

                vHeaderParser((_ethernet_payload *) &payload,(char *) &cReceiveBuffer);
                
                printf("[UART RCV]Parsed id: %i, parsed type %i, parsed size %lu\n", payload.packet_id, payload.type, payload.size);
                
                /* Send state to Imagette parser if type is correct */
                if(payload.type == 102){
                    eReaderRXMode = sGetImagettes;
                } else{
                    eReaderRXMode = sGetCommand;
                }
                break;
                case sGetImagettes:
                    vImagetteParser((T_Simucam *) &T_simucam);
                    eReaderRXMode = sSendToACKReceiver;
                break;
                case sGetCommand:
                	vCmdParser((T_uart_payload *) &payload);
                	eReaderRXMode = sSendToCmdCtrl;
                break;
                case sSendToCmdCtrl:

				break;
                case sSendToACKReceiver:

				break;
        }

    }
}
