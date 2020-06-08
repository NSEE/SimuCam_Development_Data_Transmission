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
#if DEBUG_ON
    FILE* fp;
#endif

/* 
 *  Main task
 */
int main (int argc, char* argv[], char* envp[])
{
  INT8U error_code;

  vRstcReleaseSimucamReset(0);

  /* Debug device initialization - JTAG USB */
#if DEBUG_ON
    fp = fopen(JTAG_UART_0_NAME, "r+");
#endif

#if DEBUG_ON
    fprintf(fp, "Main entry point.\n");
#endif

    /* Clear the RTOS timer */
    OSTimeSet(0);

#if DEBUG_ON
    fprintf(fp, "\nSimucam Tasks initializing\n");
#endif
  /*
   * Simucam physical Inicialization
   */
    Init_Simucam_Config();
    Init_Simucam_Tasks();

     /* *
        * Create os data structures
        */
    SimucamCreateOSQ();
    DataCreateOSQ();

    /*create the sub-units data structures*/
    sub_unit_create_os_data_structs();

    /* create the Simucam tasks */
    SimucamCreateTasks();
    

  /*
   * Load ETH Configurations from SD Card
   */
  bInitializeSDCard();
  vLoadDefaultETHConf();
  /* 
   * Load debug configs 
   */
	// vLoadDebugConfs();
//  T_simucam.T_conf.usiDebugLevels = 2;
// 	T_simucam.T_conf.usiDebugLevels = xDefaults.usiDebugLevel;
// #if DEBUG_ON
// 		fprintf(fp, "[CommandManagementTask]Debug level: %i\r\n", T_simucam.T_conf.usiDebugLevels);
// #endif

  /*
   * Start the OS
   */
  OSStart();

  
  while(1); /* Correct Program Flow never gets here. */

  return -1;
}
