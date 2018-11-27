/*
 * sub_unit_control.c
 *
 *  Created on: Oct 22, 2018
 *      Author: Yuri Bunduki
 */

#include "sub_unit_control.h"

/*
 * Structure to identify the Sub-Unit configuration parameters
 * mode: 0-> config, 1-> running
 * [receive_data: 0->ethernet, 1->SSD] Not needed anymore
 * RMAP_handling: 0->none, 1->echoing, 2->logging
 * forward_data to ethernet link
 */

/*
 * Creation of the sub-unit communication queue [yb]
 */
OS_EVENT *p_sub_unit_config_queue;
struct _sub_config *p_sub_unit_config_queue_tbl[SUBUNIT_BUFFER]; /*Storage for sub_unit queue*/
//struct _sub_config

/*
 * Creation of the sub-unit command queue [yb]
 */
OS_EVENT *p_sub_unit_command_queue;
struct _ethernet_payload *p_sub_unit_command_queue_tbl[2]; /*Storage for sub_unit queue*/

/*
 * Create the sub-unit defined data structures and queues
 */
void sub_unit_create_os_data_structs(void) {
	INT8U error_code;

	/*
	 * Create the sub-unit config queue [yb]
	 */
	p_sub_unit_config_queue = OSQCreate(&p_sub_unit_config_queue_tbl[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_config_queue) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_sub_unit_queue.\n");
	}

	/*
	 * Create the sub-unit command queue [yb]
	 */
	p_sub_unit_command_queue = OSQCreate(&p_sub_unit_command_queue_tbl[0],
	SUBUNIT_BUFFER);

	if (!p_sub_unit_command_queue) {
		alt_uCOSIIErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"Failed to create p_sub_unit_queue.\n");
	}

	/*
	 * Create Sub-Unit command semaphore
	 */
	sub_unit_command_semaphore = OSSemCreate(1);
}

/*
 * Control task for sub-unit operation[yb]
 */
void sub_unit_control_task() {
	INT8U error_code; /*uCOS error code*/

	struct _sub_config *p_config;
	p_config->mode = 0;
	p_config->RMAP_handling = 0;
	p_config->forward_data = 0;

	struct _ethernet_payload *p_sub_data;

	while (p_config->mode == 0) {

		p_config = OSQPend(p_sub_unit_config_queue, 0, &error_code);
		printf("[SUBUNIT]Sub-unit mode change to: %i\n\r", (INT8U) p_config->mode);

	}

	while (p_config->mode == 1) {
		INT8U cmd = 0;
		INT8U error_code; /*uCOS error code*/
		INT8U exec_error; /*Internal error code for the command module*/
		static INT8U i_imagette_counter = 0;
		//INT32U size = 0;

		/*Start SpW link*/
		error_code = v_SpaceWire_Interface_Link_Control((char) 'A',
		SPWC_REG_SET,
		SPWC_LINK_START_CONTROL_BIT_MASK);
		exec_error = Verif_Error(error_code);

		//p_sub_data = OSQPend(p_sub_unit_command_queue, 0, &error_code);

		printf("[SUBUNIT]data verif: item 1: %i\r\n",
				(INT8U)p_config->imagette->imagette_start[i_imagette_counter]);

		OSSemPend(&sub_unit_command_semaphore, 0, &exec_error);
		printf("[SUBUNIT]entered semaphore\r\n");
//		printf(
//				"data received via subcommandQ %c,%c,%c,%c\r\nCalculated size: %i",
//				(char) p_sub_data->data[0],
//				(char) p_sub_data->data[1],
//				(char) p_sub_data->data[2],
//				(char) p_sub_data->data[3],
//				(int) p_sub_data->size);

		error_code = b_SpaceWire_Interface_Send_SpaceWire_Data('A',
				p_config->imagette->imagette_start[i_imagette_counter],
				IMAGETTE_SIZE);

		printf("[SUBUNIT]imagette sent\r\n");

		i_imagette_counter++;
		/*Load data array from memory*/

		//cmd = (INT8U) OSQPend(p_sub_unit_command_queue, 0, &error_code);
		//printf("Recebido da queue: %i\n\r", (INT8U) cmd);
		/*
		 * advance imagette position to next frame
		 * if last change mode
		 */

		p_config = OSQAccept(p_sub_unit_config_queue, &error_code);
		alt_SSSErrorHandler(error_code, 0);
	}
}

