/**
 *  @file   util.h
 * @Author Rafael Corsi (corsiferrao@gmail.com)
 * @date   Mar??o, 2015
 * @brief  Utilidades
 *
 */

#ifndef __UTIL_H__
#define __UTIL_H__

#include <io.h>         /* Leiutura e escrita no Avalon */
#include "system.h"
#include <stdio.h>
#include <ctype.h>
#include "../simucam_definitions.h"

#define DEBUG_HIGH
#define DEBUG_MID

/* Defines */
#define CPU_FREQ_MH 50000000
#define POLY 0x8408

/* TRUE/FALSE */

/* share memory */
alt_u32 pnt_memory;

/* prototype */
alt_32 _reg_write(int BASE_ADD, alt_32 REG_ADD, alt_32 REG_Dado);
alt_32 _reg_read(int BASE_ADD, alt_32 REG_ADD, alt_32* REG_Dado);
void _split_codec_status(int codec_status, int *started, int *connecting, int *running);
void _print_codec_status(int codec_status);
//void _print_link_config(LinkConfig *link);

alt_u8 aatoh(alt_u8 *buffer);
alt_u8 toInt(alt_u8 ascii);
alt_u8 toChar(alt_u8 i_int);
alt_u8 Verif_Error(alt_u8 error_code);
alt_u16 crc16(alt_u8 *p_data, alt_u32 i_length);

/**
 * @brief Set the High level log file
 */

/**git pul
 * @brief Set the Mid level log file
 */

/**
 * @brief Set the low level log file
 */

#endif /*UTIL */

