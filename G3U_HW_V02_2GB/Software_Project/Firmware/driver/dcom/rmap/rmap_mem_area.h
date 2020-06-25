/*
 * rmap_mem_area.h
 *
 *  Created on: 12 de abr de 2020
 *      Author: rfranca
 */

#ifndef DRIVER_COMM_RMAP_RMAP_MEM_AREA_H_
#define DRIVER_COMM_RMAP_RMAP_MEM_AREA_H_

#include "../../../simucam_definitions.h"

//! [constants definition]
#define RMAP_MEMORY_AREA_LENGTH_BYTES   4096
//! [constants definition]

//! [public module structs definition]

/* RMAP Area Register Struct */
typedef struct RmapMemAreaReg {
	alt_u8 ucRmapMemByte[RMAP_MEMORY_AREA_LENGTH_BYTES];
} TRmapMemAreaReg;

/* RMAP Memory Area Register Struct */
typedef struct RmapMemArea {
	TRmapMemAreaReg xRmapMemAreaReg; /* RMAP Memory Area */
} TRmapMemArea;

//! [public module structs definition]

//! [public function prototypes]
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* DRIVER_COMM_RMAP_RMAP_MEM_AREA_H_ */
