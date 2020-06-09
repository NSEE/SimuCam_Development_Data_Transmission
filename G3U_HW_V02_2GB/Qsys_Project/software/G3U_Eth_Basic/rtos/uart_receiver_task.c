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
#include "../driver/uart/uart.h"
/**
 * @name luGetSerial
 * @brief Receives a fixed number of chars from serial
 * @ingroup rtos
 *
 * @param 	[in]	INT8U * Command structure
 * @param	[in]	INT32U  Number of chars
 *
 * @retval unsigned long        number of chars read
 **/
unsigned long luGetSerial(INT8U *pBuffer, INT32U luNbChars){
        INT32U luReturn = 0;

        if ( !iUartEmpty() ) {
                while(luNbChars != 0){
                        // fgets(pBuffer, 2, stdin);
                        //*pBuffer = getchar();
                        *pBuffer = cUartReadChar();
                        pBuffer++;
                        luReturn++;
                        luNbChars--;
                }
        } else {
                luReturn = 0;
        }
//#if DEBUG_ON
//        if (T_simucam.T_conf.usiDebugLevels <= xVerbose ){
//                fprintf(fp, "[GETSERIAL]Received Total: %lu\r\n", luReturn);
//        }
//#endif
        return luReturn;
}

/**
 * @name vHeaderParser
 * @brief Parses header from buffer
 * @ingroup rtos
 *
 * @param 	[in]	T_uart_payload * 	Command structure
 * @param	[in]	char * 	char buffer
 *
 * @retval void
 **/
void vHeaderParser(T_uart_payload *pPayload, char *cReceiveBuffer){

#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xVerbose ){
                fprintf(fp, "[UART HParser]Received Bytes: %u %u %u %u %u %u %u %u\n",
                cReceiveBuffer[0], cReceiveBuffer[1], cReceiveBuffer[2], cReceiveBuffer[3], cReceiveBuffer[4],
                cReceiveBuffer[5], cReceiveBuffer[6], cReceiveBuffer[7]);
        }
#endif

    pPayload->header = cReceiveBuffer[0];
    
    pPayload->packet_id = cReceiveBuffer[2]
            + 256 * cReceiveBuffer[1];

    pPayload->type = cReceiveBuffer[3];

    pPayload->size = cReceiveBuffer[7]
            + 256 * cReceiveBuffer[6]
            + 65536 * cReceiveBuffer[5]
            + 4294967296 * cReceiveBuffer[4];

    pPayload->luCRCPartial = crc__CRC16CCITT(cReceiveBuffer, HEADER_OVERHEAD);

#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xVerbose ){
        fprintf(fp, "[UART HParser]Parsed header %u, Parsed id: %u, parsed type %u, parsed size %lu\n", pPayload->header, pPayload->packet_id, pPayload->type, pPayload->size);
        fprintf(fp, "[UART HParser]Print partial crc %lu\n", pPayload->luCRCPartial);
        }
#endif
}

/**
 * @name vImagetteParser
 * @brief Parses imagette from serial
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
     INT8U iHeaderBuff[16];
     INT8U iOffsetLengthBuff[8];
     INT8U iCRCBuff[2];
     INT16U usLengthBuff = 0;

 #if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
                fprintf(fp, "[UART ImagetteParser DEBUG]Entered parser\r\n");
        }
 #endif
        memset(iHeaderBuff, 0, 16);
        /* Get payload data from RS232 */                
        luGetSerial((INT8U *)&iHeaderBuff, DATASET_HEADER);

#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xVerbose ){
                fprintf(fp, "[UART ImagetteParser DEBUG]iHeaderBuff Dump");
                for(int g=0; g<DATASET_HEADER; g++){
                fprintf(fp, " %i", iHeaderBuff[g]);
                }
                fprintf(fp, "\r\n");
        }
#endif

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

        /**
         * Add do partial CRC
         */
        pPayload->luCRCPartial = prev_crc__CRC16CCITT(iHeaderBuff, DATASET_HEADER, pPayload->luCRCPartial);

#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xVerbose ){
                fprintf(fp, "[UART ImagetteParser DEBUG]Received nb Imagettes %lu\r\n", pSimucam->T_Sub[i_channel_wr].T_data.nb_of_imagettes);
                fprintf(fp, "[UART ImagetteParser DEBUG]Received TAG %i %i %i %i\r\n",
                (INT8U) pSimucam->T_Sub[i_channel_wr].T_data.tag[0],
                (INT8U) pSimucam->T_Sub[i_channel_wr].T_data.tag[1],
                (INT8U) pSimucam->T_Sub[i_channel_wr].T_data.tag[2],
                (INT8U) pSimucam->T_Sub[i_channel_wr].T_data.tag[3]
                );
        }
#endif

         /*
        * Parse imagettes
        */
        while (i_nb_imag_ctrl
                < pSimucam->T_Sub[i_channel_wr].T_data.nb_of_imagettes) {

            p_imagette_buff = (T_Imagette *) p_imagette_byte;
            /*
             * Receive 6 bytes for offset and length
             */
            memset(iOffsetLengthBuff, 0, 8);           
            luGetSerial((INT8U *)&iOffsetLengthBuff, IMAGETTE_HEADER);

#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xVerbose ){
                fprintf(fp, "[UART ImagetteParser DEBUG]iOffsetLengthBuff Dump");
                for(int w=0; w<IMAGETTE_HEADER; w++){
                fprintf(fp, " %i", iOffsetLengthBuff[w]);
                }
                fprintf(fp, "\r\n");
        }
#endif

            /*
            * Switch to the right memory stick
            */
            if (((unsigned char) i_channel_wr / 4) == 0) {
                bDdr2SwitchMemory(DDR2_M1_ID);
            } else {
                bDdr2SwitchMemory(DDR2_M2_ID);
            }   

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



                        
            /**
             * Add do partial CRC
             */
            pPayload->luCRCPartial = prev_crc__CRC16CCITT(iOffsetLengthBuff, 
                            IMAGETTE_HEADER, pPayload->luCRCPartial);

#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xVerbose ){
            fprintf(fp, "[UART ImagetteParser DEBUG]Imagette %i length: %i\r\n", i_nb_imag_ctrl,
                    p_imagette_buff->imagette_length);
        }
#endif
            /* Advance byte addr to point to the start to imagette data */
            p_imagette_byte += IMAGETTE_HEADER;	//Length offset

            usLengthBuff = p_imagette_buff->imagette_length;

            /*
            * Switch to the right memory stick
            */
            if (((unsigned char) i_channel_wr / 4) == 0) {
                bDdr2SwitchMemory(DDR2_M1_ID);
            } else {
                bDdr2SwitchMemory(DDR2_M2_ID);
            }

            /* Get data bytes from RS232 */
            luGetSerial((INT8U *)p_imagette_byte, usLengthBuff);
            
            /**
             * Add do partial CRC
             */
            pPayload->luCRCPartial = prev_crc__CRC16CCITT((INT8U *)p_imagette_byte, 
                            usLengthBuff, pPayload->luCRCPartial);

            /* Sum memory positions */
            p_imagette_byte += usLengthBuff;

            /* Align memory */
            if (((INT32U) p_imagette_byte % 8)) {
                p_imagette_byte =
                        (INT8U *) (((((INT32U) p_imagette_byte) >> 3)
                                + 1) << 3);
            }

#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xVerbose ){
                INT8U *pxTestData =
                (INT8U *) pSimucam->T_Sub[i_channel_wr].T_data.addr_init+6;
                fprintf(fp, "[UART ImagetteParser DEBUG]First Bytes %i %i\r\n", pxTestData[0],
                pxTestData[1]);
        }
#endif
            
            i_nb_imag_ctrl++;
        }
        
        /* receive CRC */
        luGetSerial((INT8U *)&iCRCBuff, 2);
        
        pPayload->crc = iCRCBuff[1]
                + 256 * iCRCBuff[0];
        
#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xVerbose ){
                fprintf(fp, "[UART ImagetteParser DEBUG]CRC bytes %i %i\r\n", iCRCBuff[0],
                        iCRCBuff[1]);
        }
#endif

        /* Check CRC */
        if(pPayload->crc == pPayload->luCRCPartial){
#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
            fprintf(fp, "[vCmdParser DEBUG]CRC OK.\n");
        }
#endif
            v_ack_creator(pPayload, xAckOk);
        } else {

#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xCritical ){
            fprintf(fp, "[vCmdParser DEBUG]CRC ERROR.\n");
        }
#endif
            v_ack_creator(pPayload, xCRCError);
        }
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
INT8U vCmdParser(T_uart_payload *pUartPayload){
        INT8U cBuff[8];
        int i = 0;

        memset(pUartPayload->data, 0, PAYLOAD_DATA_SIZE);
        memset(cBuff, 0, 8);       
#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
        fprintf(fp, "[vCmdParser DEBUG]Command Parser Init\n");
        }
#endif

    /*
    * Assign data in the payload struct to data in the buffer
    * change to 0
    */
    if (pUartPayload->size > PAYLOAD_OVERHEAD && pUartPayload->size < PAYLOAD_DATA_SIZE ) {
        
        /* Get payload data from RS232 */                
        luGetSerial((INT8U *)&pUartPayload->data, pUartPayload->size - PAYLOAD_OVERHEAD);

#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xVerbose ){
                for (i = 1; i <= pUartPayload->size - PAYLOAD_OVERHEAD; i++) {
                fprintf(fp, 
                        "[vCmdParser DEBUG]data: %i\r\nPing %i\r\n",
                        (INT8U) pUartPayload->data[i - 1], (INT8U) i);
                }
        }
#endif
        pUartPayload->luCRCPartial = prev_crc__CRC16CCITT(pUartPayload->data, 
                    pUartPayload->size - PAYLOAD_OVERHEAD, 
                    pUartPayload->luCRCPartial);

#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xVerbose ){
                fprintf(fp, "[vCmdParser DEBUG]Calculated CRC = %lu\n",
                        (INT16U) pUartPayload->luCRCPartial);
        }
#endif

        /* Get CRC from RS232 */
        luGetSerial((INT8U *)&cBuff, 2);

        pUartPayload->crc = cBuff[1] + 256 * cBuff[0];

#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xVerbose ){
                fprintf(fp, "[vCmdParser DEBUG]Received CRC = %lu\n",
                        (INT16U) pUartPayload->crc);
        }
#endif

        /* Check CRC */
        if(pUartPayload->crc == pUartPayload->luCRCPartial){
#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
            fprintf(fp, "[vCmdParser DEBUG]CRC OK.\n");
        }
#endif
                return 0;
        } else {

#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xCritical ){
            fprintf(fp, "[vCmdParser DEBUG]CRC ERROR.\n");
        }
#endif
            v_ack_creator(pUartPayload, xCRCError);
            return 1;
        }

#if DEBUG_ON
        fprintf(fp, "[vCmdParser DEBUG]finished receiving.\n");
#endif

    } else if(pUartPayload->size == PAYLOAD_OVERHEAD){

        /* Get CRC from RS232 */
        luGetSerial((INT8U *)&cBuff, 2);

        pUartPayload->crc = cBuff[1] + 256 * cBuff[0];

#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xVerbose ){
                fprintf(fp, "[vCmdParser DEBUG]Received CRC = %lu\n",
                        (INT16U) pUartPayload->crc);
        }
#endif
        /* Check CRC */
        if(pUartPayload->crc == pUartPayload->luCRCPartial){
#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
            fprintf(fp, "[vCmdParser DEBUG]CRC OK.\n");
        }
#endif
        /* Ack is created further down the line */
        return 0;
        } else {

#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xCritical ){
            fprintf(fp, "[vCmdParser DEBUG]CRC ERROR, but that's ok.\n");
        }
#endif
        /* Temporary fix, TODO: Remove */
        //     v_ack_creator(pUartPayload, xCRCError);
        //     return 1;
                return 0;
        }

#if DEBUG_ON
        fprintf(fp, "[vCmdParser DEBUG]finished receiving.\n");
#endif
    } else{
#if DEBUG_ON
        if (T_simucam.T_conf.usiDebugLevels <= xCritical ){
            fprintf(fp, "[vCmdParser DEBUG]Invalid data size.\n");
        }
#endif
        v_ack_creator(pUartPayload, xParserError);
        return 1;
    }
}

void uart_receiver_task(void *task_data){
    bool bSuccess = FALSE;
    INT8U cReceiveBuffer[UART_BUFFER_SIZE];
    INT8U cReceive[UART_BUFFER_SIZE+64];
    INT8U error_code = 0;
    tReaderStates eReaderRXMode = sRConfiguring;
    static T_uart_payload payload;

    for(;;) {

        switch (eReaderRXMode){
            case sRConfiguring:
#if DEBUG_ON
                if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
                        fprintf(fp, "[UART RCV] Uart receiver init\n");
                }
#endif
                eReaderRXMode = sGetHeader;
                break;
                
            case sGetHeader:
//#if DEBUG_ON
//                if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
//                        fprintf(fp, "[UART RCV] Waiting data\n");
//                }
//#endif
                memset(cReceiveBuffer, 0, UART_BUFFER_SIZE);
                
                if( luGetSerial((char *) &cReceiveBuffer, 8) ){

                        vHeaderParser((T_uart_payload *) &payload, (char *) &cReceiveBuffer);
        #if DEBUG_ON
                        if (T_simucam.T_conf.usiDebugLevels <= xMajor ){
                                fprintf(fp, "[UART RCV]Parsed id: %i, parsed type %i, parsed size %lu\n", 
                                payload.packet_id, payload.type, payload.size);
                        }
        #endif
                        /* Send state to Imagette parser if type is correct */
                        if(payload.type == 102){
                        eReaderRXMode = sGetImagettes;
                        } else {
                        eReaderRXMode = sToGetCommand;
                        }
                } else {
                        eReaderRXMode = sGetHeader;
                }
                break;

                case sToGetImagettes:
                    eReaderRXMode = sGetImagettes;
                break;
                case sGetImagettes:
                    /* TODO Verify that the Simucam is in config mode */
                    if(T_simucam.T_status.simucam_mode == simModeConfig){
                        vImagetteParser((T_Simucam *) &T_simucam, (T_uart_payload *) &payload);
                        eReaderRXMode = sSendToCmdCtrl;
                    } else{
                        eReaderRXMode = sRConfiguring;
                        v_ack_creator(payload, xCommandNotAccepted);
                    }
                    
                break;

                case sToGetCommand:
                    eReaderRXMode = sGetCommand;
                break;

                case sGetCommand:
                	error_code = vCmdParser((T_uart_payload *) &payload);
                	if (error_code == 0){
                                eReaderRXMode = sSendToCmdCtrl;
                        } else {
                                eReaderRXMode = sRConfiguring;
                        }
                        
                break;

                case sSendToCmdCtrl:
                	error_code = OSQPost(p_simucam_command_q, &payload);
                					alt_SSSErrorHandler(error_code, 0);
                        // v_ack_creator(payload, xAckOk);
                	eReaderRXMode = sRConfiguring;
				break;
        }
    }
}
