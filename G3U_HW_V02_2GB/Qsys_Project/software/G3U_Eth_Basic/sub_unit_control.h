/*
 * sub_unit_control.h
 *
 *  Created on: Oct 22, 2018
 *      Author: Yuri Bunduki
 */

#ifndef SUB_UNIT_CONTROL_H_
#define SUB_UNIT_CONTROL_H_

#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "utils/util.h"
#include "alt_error_handler.h"
#include "includes.h"

#define SUBUNIT_BUFFER 10



void sub_unit_create_queue(void);
void sub_unit_control_task ();

#endif /* SUB_UNIT_CONTROL_H_ */