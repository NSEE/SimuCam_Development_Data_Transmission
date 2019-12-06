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
void vHeaderParser(T_uart_payload *pPayload, char *cReceiveBuffer){

#if DEBUG_ON
	fprintf(fp, "[UART HParser]Received Bytes: %u %u %u %u %u %u %u %u\n",
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
    fprintf(fp, "[UART HParser]Parsed header %u, Parsed id: %u, parsed type %u, parsed size %lu\n", pPayload->header, pPayload->packet_id, pPayload->type, pPayload->size);
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
     INT8U iHeaderBuff[IMAGETTE_HEADER];
     INT8U iOffsetLengthBuff[6];
     INT8U iCRCBuff[2];
     INT16U usLengthBuff = 0;

 #if DEBUG_ON
     fprintf(fp, "[sss_handle_receive DEBUG]Entered parser\r\n");
 #endif

        /* Get payload data from RS232 */                
        fgets(iHeaderBuff, IMAGETTE_HEADER, stdin);


        i_channel_wr = iHeaderBuff[1];

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
                (INT32U) pSimucam->T_Sub[i_channel_wr].T_data.addr_init;

        /*
        * Parse nb of imagettes
        */
        pSimucam->T_Sub[i_channel_wr].T_data.nb_of_imagettes =
                iHeaderBuff[3]
                        + 256 * iHeaderBuff[2];

        /*
        * Parse TAG
        */
        pSimucam->T_Sub[i_channel_wr].T_data.tag[7] =
                iHeaderBuff[4];
        pSimucam->T_Sub[i_channel_wr].T_data.tag[6] =
                iHeaderBuff[5];
        pSimucam->T_Sub[i_channel_wr].T_data.tag[5] =
                iHeaderBuff[6];
        pSimucam->T_Sub[i_channel_wr].T_data.tag[4] =
                iHeaderBuff[7];
        pSimucam->T_Sub[i_channel_wr].T_data.tag[3] =
                iHeaderBuff[8];
        pSimucam->T_Sub[i_channel_wr].T_data.tag[2] =
                iHeaderBuff[9];
        pSimucam->T_Sub[i_channel_wr].T_data.tag[1] =
                iHeaderBuff[10];
        pSimucam->T_Sub[i_channel_wr].T_data.tag[0] =
                iHeaderBuff[11];

        /*
        * Parse imagettes
        */
        while (i_nb_imag_ctrl
                < pSimucam->T_Sub[i_channel_wr].T_data.nb_of_imagettes) {

            p_imagette_buff = (T_Imagette *) p_imagette_byte;
            /*
            * Receive 6 bytes for offset and length
            */           
            fgets(iOffsetLengthBuff, 6, stdin);

            p_imagette_buff->offset =
                    iOffsetLengthBuff[3]
                            + 256 * iOffsetLengthBuff[2]
                            + 65536
                                    * iOffsetLengthBuff[1]
                            + 4294967296
                                    * iOffsetLengthBuff[0];

            p_imagette_buff->imagette_length =
                    iOffsetLengthBuff[5]
                            + 256 * iOffsetLengthBuff[4];
#if DEBUG_ON
            fprintf(fp, "[SSS]Imagette %i length: %i\r\n", i_nb_imag_ctrl,
                    p_imagette_buff->imagette_length);
#endif
            /* Advance byte addr */
            p_imagette_byte += 6;

            usLengthBuff = p_imagette_buff->imagette_length;
            
//             while (usLengthBuff > 0) {
//                 rx_code = recv(conn->fd, (void * )p_imagette_byte,
//                         usLengthBuff, 0);
//                 if (rx_code > 0) {

// #if DEBUG_ON
//                     fprintf(fp,
//                             "[SSS] received bytes in imagette %i: %i\r\n",
//                             i_nb_imag_ctrl, rx_code);
// #endif
//                     p_imagette_byte += rx_code;
//                     usLengthBuff -= rx_code;
//                 }
//             }

            /* Get data bytes from RS232 */
            //TODO Verif if correct
            fgets(*p_imagette_byte, usLengthBuff, stdin);

            /* Sum memory positions */
            p_imagette_byte += usLengthBuff;

            /* Align memory */
            if (((INT32U) p_imagette_byte % 8)) {
                p_imagette_byte =
                        (INT8U *) (((((INT32U) p_imagette_byte) >> 3)
                                + 1) << 3);
            }

#if DEBUG_ON
            // T_teste_data *pxTestData =
            // (T_teste_data *) pSimucam->T_Sub[i_channel_wr].T_data.addr_init;
#endif
            i_nb_imag_ctrl++;
        }
        
        /* receive CRC */
        fgets(iCRCBuff, 2, stdin);

        /* Verificar se chegou tudo */
        /* Mock CRC */
        pPayload->crc = iCRCBuff[1]
                + 256 * iCRCBuff[0];
        /* TODO Verif CRC */
//        i_ack = ACK_OK;435
    
    //ACK for not config condition
    // } else {
    //     /*
    //         * Empty the ethernet stack to avoid garbage
    //         */
    //     if (payload.size < BUFFER_SIZE) {
    //         rx_code = recv(conn->fd,
    //                 (char* )p_ethernet_buffer->rx_wr_pos,
    //                 payload.size, 0);
    //         if (rx_code > 0) {
    //             p_ethernet_buffer->rx_rd_pos += rx_code;
    //         }
    //     } else {
    //         while (payload.size > BUFFER_SIZE) {
    //             rx_code = recv(conn->fd,
    //                     (char* )p_ethernet_buffer->rx_wr_pos,
    //                     BUFFER_SIZE, 0);
    //             if (rx_code > 0) {
    //                 p_ethernet_buffer->rx_rd_pos += rx_code;
    //                 payload.size -= BUFFER_SIZE;
    //             }
    //         }
    //     }
    //     i_ack = COMMAND_NOT_ACCEPTED;
    // }
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

    memset(pUartPayload->data, 0, PAYLOAD_DATA_SIZE);
        memset(cBuff, 0, UART_BUFFER_SIZE);       
#if DEBUG_ON
    fprintf(fp, "[vCmdParser DEBUG]Command Parser Init\n");
#endif

    /*
    * Assign data in the payload struct to data in the buffer
    * change to 0
    */
    if (pUartPayload->size > PAYLOAD_OVERHEAD && pUartPayload->size < PAYLOAD_DATA_SIZE ) {
        
        /* Get payload data from RS232 */                
        fgets(pUartPayload->data, pUartPayload->size - PAYLOAD_OVERHEAD + 1, stdin);

#if DEBUG_ON
        for (i = 1; i <= pUartPayload->size - PAYLOAD_OVERHEAD; i++) {
            fprintf(fp, 
                    "[vCmdParser DEBUG]data: %i\r\nPing %i\r\n",
                    (INT8U) pUartPayload->data[i - 1], (INT8U) i);
        }
#endif
        /* Get CRC from RS232 */
        fgets(cBuff, 2 + 1, stdin);

#if DEBUG_ON
        fprintf(fp, "[vCmdParser DEBUG]Received CRC = %i %i\n",
                (INT8U) cBuff[0],(INT8U) cBuff[1]);
#endif
        /* TODO ACK statement */
        /* TODO Calculate CRC */

#if DEBUG_ON
        fprintf(fp, "[vCmdParser DEBUG]finished receiving\n");
#endif
    } else{
        /* TODO Error reporting + NACK */
#if DEBUG_ON
        fprintf(fp, "[vCmdParser DEBUG]Invalid Data Size\n");
#endif
    }


}

void uart_receiver_task(void *task_data){
    bool bSuccess = FALSE;
    INT8U cReceiveBuffer[UART_BUFFER_SIZE];
    INT8U cReceive[UART_BUFFER_SIZE+64];
    tReaderStates eReaderRXMode = sRConfiguring;
    static T_uart_payload payload;

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
//                memset(cReceive, 0, UART_BUFFER_SIZE);
                
                fgets(cReceiveBuffer,8 + 1,stdin);
//                memcpy(cReceiveBuffer, cReceive, (UART_BUFFER_SIZE -1) ); /* Make that there's a zero terminator */
                
                /* For testing only */
                fprintf(fp, "[UART RCV]Received data: %s\n", cReceiveBuffer);

                vHeaderParser((T_uart_payload *) &payload, (char *) &cReceiveBuffer);
                
                fprintf(fp, "[UART RCV]Parsed id: %i, parsed type %i, parsed size %lu\n", payload.packet_id, payload.type, payload.size);

                /* Send state to Imagette parser if type is correct */
                if(payload.type == 102){
                    eReaderRXMode = sGetImagettes;
                } else{
                   eReaderRXMode = sToGetCommand;
                }
                break;
                case sToGetImagettes:
                    eReaderRXMode = sGetImagettes;
                break;
                case sGetImagettes:
                    /* TODO Verify that the Simucam is in config mode */
                    vImagetteParser((T_Simucam *) &T_simucam, (T_uart_payload *) &payload);
                    eReaderRXMode = sSendToACKReceiver;
                break;
                case sToGetCommand:
                    eReaderRXMode = sGetCommand;
                break;
                case sGetCommand:
                	vCmdParser((T_uart_payload *) &payload);
                	eReaderRXMode = sSendToCmdCtrl;
                break;
                case sSendToCmdCtrl:
                	eReaderRXMode = sSendToACKReceiver;
				break;
                case sSendToACKReceiver:
                	eReaderRXMode = sGetHeader;
				break;
        }

    }
}
