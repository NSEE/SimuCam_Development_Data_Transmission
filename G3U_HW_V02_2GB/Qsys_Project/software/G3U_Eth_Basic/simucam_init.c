/*
 ************************************************************************************************
 *                                              NSEE
 *                                             Address
 *
 *                                       All Rights Reserved
 *
 * TODO header format
 * Filename     : simucam_init.c
 * Programmer(s): Yuri Bunduki
 * Created on: May 27, 2019
 * Description  : Header file for the Simucam initialization task.
 ************************************************************************************************
 */
/*$PAGE*/
  
#include "rtos/simucam_init_task.h"

/* Declaring file for JTAG debug */
//#if DEBUG_ON
    FILE* fp;
//#endif

/*     *     *     *     *     New tasks implementation     *     *     */



/* Definition of task stack for the initial task which will initialize the NicheStack
 * TCP/IP Stack and then initialize the rest of the Simple Socket Server example tasks. 
 */
OS_STK    SimucamInitialTaskStk[TASK_STACKSIZE];

/* Declarations for creating a task with TK_NEWTASK.  
 * All tasks which use NicheStack (those that use sockets) must be created this way.
 * TK_OBJECT macro creates the static task object used by NicheStack during operation.
 * TK_ENTRY macro corresponds to the entry point, or defined function name, of the task.
 * inet_taskinfo is the structure used by TK_NEWTASK to create the task.
 */
//TK_OBJECT(to_uart_receiver_task);
//TK_ENTRY(uart_receiver_task);
//
//struct inet_taskinfo uart_receiver_task = {
//      &to_uart_receiver_task,
//      "simucam task",
//      uart_receiver_task,
//      4,
//      APP_STACK_SIZE,
//};

void SimucamInitialTask(){
    INT8U error_code;

    /* Application Specific Task Launching Code Block Begin */
#if DEBUG_ON
    fprintf(fp, "\nSimucam Tasks initializing\n");
#endif

    /* Create the main simple socket server task. */
//    TK_NEWTASK(&uart_receiver_task);

     /* *
        * Create os data structures
        */
    SimucamCreateOSQ();
    DataCreateOSQ();

    /*create the sub-units data structures*/
    sub_unit_create_os_data_structs();

    /* create the Simucam tasks */
    SimucamCreateTasks();

}


/* Main creates a single task, SSSInitialTask, and starts task scheduler.
 */


int main (int argc, char* argv[], char* envp[])
{

  INT8U error_code;


  /* Debug device initialization - JTAG USB */
	// #if DEBUG_ON
  		fp = fopen(JTAG_UART_0_NAME, "r+");
  // #endif

  	// #if DEBUG_ON
  		fprintf(fp, "Main entry point.\n");
  	// #endif

  /* Clear the RTOS timer */
  OSTimeSet(0);

  /*
   * Simucam Inicialization
   */
    Init_Simucam_Config();
    Init_Simucam_Tasks();
    
  /*
   * Load ETH Configurations from SD Card
   */
  bInitializeSDCard();
  vLoadDefaultETHConf();

  /* 
   * Create initial Simucam Task
   */  
 error_code = OSTaskCreateExt(SimucamInitialTask,
                            NULL,
                            (void *)&SimucamInitialTaskStk[TASK_STACKSIZE],
                            SIMUCAM_INITIAL_TASK_PRIORITY,
                            SIMUCAM_INITIAL_TASK_PRIORITY,
                            SimucamInitialTaskStk,
                            TASK_STACKSIZE,
                            NULL,
                            0);
 alt_uCOSIIErrorHandler(error_code, 0);

  /*
   * As with all MicroC/OS-II designs, once the initial thread(s) and 
   * associated RTOS resources are declared, we start the RTOS. That's it!
   */
  OSStart();

  
  while(1); /* Correct Program Flow never gets here. */

  return -1;
}
