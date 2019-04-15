/*
 * simucam_model.h
 *
 *  Created on: 15/04/2019
 *      Author: root
 */

#ifndef SIMUCAM_MODEL_H_
#define SIMUCAM_MODEL_H_

typedef struct T_imagette{
	INT32U 	offset; 				/* In miliseconds*/
	INT16U	imagette_length; 		/* length of N imagette */
	INT8U	INT8U imagette_start; 	/*Pointer to de DDR2 address*/
}T_Imagette;

typedef struct T_dataset{
	INT32U		addr_init;
	INT16U 		nb_of_imagettes; 		/* Number of imagettes in dataset*/
	INT16U		i_imagette;				/* Imagette current number */
	T_imagette	*p_iterador;			/* Imagettes Iterator */
}T_dataset;

typedef struct T_SpW_conf{

}T_SpW_conf;

#endif /* SIMUCAM_MODEL_H_ */
