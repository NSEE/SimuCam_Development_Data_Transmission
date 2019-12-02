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

void uart_receiver_task(void *task_data){
    bool bSuccess = FALSE;
    char cReceiveBuffer[UART_BUFFER_SIZE];
    char cReceive[UART_BUFFER_SIZE+64];
    tReaderStates eReaderRXMode;

    for(;;) {

        switch (eReaderRXMode){
            case sRConfiguring:
            	fprintf(fp, "[UART RCV] Uart receiver init\n");
                eReaderRXMode = sGetRxUart;
                break;
            case sGetRxUart:
            #if DEBUG_ON
                fprintf(fp, "[UART RCV] Waiting data\n");
            #endif
                memset(cReceiveBuffer, 0, UART_BUFFER_SIZE);
                scanf("%s", cReceive);
                memcpy(cReceiveBuffer, cReceive, (UART_BUFFER_SIZE -1) ); /* Make that there's a zero terminator */
                /* For testing only */
                printf("[UART RCV]Received data: %s\n", cReceiveBuffer);
                break;
        }

    }
}
