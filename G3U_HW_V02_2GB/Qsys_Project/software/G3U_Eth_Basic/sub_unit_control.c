/*
 * sub_unit_control.c
 *
 *  Created on: Oct 22, 2018
 *      Author: Yuri Bunduki
 */

#include "sub_unit_control.h"

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
	 * Create Sub-Unit command semaphore, input set to 1 to create a binary semaphore
	 */
	sub_unit_command_semaphore = OSSemCreate(0);
}

/*
 * Control task for sub-unit operation[yb]
 */
void sub_unit_control_task() {
	INT8U error_code; /*uCOS error code*/
	int j = 0;

	struct _sub_config sub_config;
	struct _sub_config *p_config;
	p_config = &sub_config;

	p_config->mode = 0;
	p_config->RMAP_handling = 0;
	p_config->forward_data = 0;

	struct _ethernet_payload *p_sub_data;

	while (p_config->mode == 0) {

		printf("[SUBUNIT]Sub-unit in config mode\r\n");
		p_config = OSQPend(p_sub_unit_config_queue, 0, &error_code);
		printf("[SUBUNIT]Sub-unit mode change to: %i\n\r",
				(INT8U) p_config->mode);
	}

	while (p_config->mode == 1) {
		INT8U error_code; /*uCOS error code*/
		INT8U exec_error; /*Internal error code for the command module*/
		INT16U i_imagette_counter = 0;
		//INT32U size = 0;
		int p;
		INT16U imagette_number = 0;
		INT16U nb_of_imagettes = p_config->imagette->nb_of_imagettes;
		p++;

		int teste = p_config->imagette;

		/*Start SpW link*/
//		error_code = v_SpaceWire_Interface_Link_Control((char) 'A',
//		SPWC_REG_SET,
//		SPWC_AUTOSTART_CONTROL_BIT_MASK);
//		exec_error = Verif_Error(error_code);
		INT8U buffer_burro[MAX_IMAGETTES * IMAGETTE_SIZE];
		INT16U buffer_length[MAX_IMAGETTES];

		printf("[SUBUNIT]Sub-unit in running mode\r\n");

//		for (p = 0; p < p_config->imagette->imagette_length; p++) {
//			buffer_burro[p] = p_config->imagette->imagette[p];
//			printf("[SUBUNIT]Buffer burro %i: %i @ %x\r\n", (int) p,
//					(INT8U) buffer_burro[p], &buffer_burro[p]);
//		}

		for (p = 0; p < p_config->imagette->nb_of_imagettes; p++) {
			buffer_length[p] = p_config->imagette->imagette_length[p];
			printf("[SUBUNIT]Buffer length %i: %i @ %x\r\n", (int) p,
					(INT16U) buffer_burro[p], &buffer_burro[p]);
		}

//p_sub_data = OSQPend(p_sub_unit_command_queue, 0, &error_code);

		while (imagette_number < nb_of_imagettes) {

			printf("[SUBUNIT]Entered while\r\n");

			printf("[SUBUNIT]imagette counter antes %i\r\n",
					(int) i_imagette_counter);

			for (p = 0; p < buffer_length[imagette_number]; p++) {
				buffer_burro[p + i_imagette_counter] =
						p_config->imagette->imagette[p + i_imagette_counter];
				printf("[SUBUNIT]Buffer burro %i: %i @ %x\r\n", (int) p,
						(INT8U) buffer_burro[p + i_imagette_counter],
						&buffer_burro[p + i_imagette_counter]);
			}

//			printf("[SUBUNIT]Received imagette %i start byte: %i @ %x\r\n",
//					i_imagette_counter,
//					p_config->imagette->imagette[i_imagette_counter],
//					&p_config->imagette->imagette[i_imagette_counter]);

			printf("[SUBUNIT]imagette length: %i\r\n",
					(INT16U) buffer_length[imagette_number]);

			printf("[SUBUNIT]Waiting unblocked sub_unit_command_semaphore\r\n");

			OSSemPend(sub_unit_command_semaphore, 0, &exec_error);

			/*
			 * Verificar como passar esse end
			 *
			 * Quando RAM implementada, em teoria, poderia passar somente o end
			 * do primeiro byte da info + o tamanho, diminuir os buffers
			 */
			error_code = b_SpaceWire_Interface_Send_SpaceWire_Data('A',
					&buffer_burro[0],
					//p_config->imagette->imagette[i_imagette_counter],
					buffer_length[imagette_number]);

			printf("[SUBUNIT]imagette sent\r\n");

			i_imagette_counter += buffer_length[imagette_number];

			imagette_number++;

			printf("[SUBUNIT]imagette counter %i\r\n",
					(INT16U) i_imagette_counter);

			printf("[SUBUNIT]imagette nb %i\r\n", (INT16U) imagette_number);

		}
		printf("[SUBUNIT]Waiting config instructions\r\n");
		p_config = OSQPend(p_sub_unit_config_queue, 0, &error_code);
		printf("[SUBUNIT]Configuration instructions received\r\n");

		/* Modificar para assegurar um funcionamento como desejado */
	}
}

