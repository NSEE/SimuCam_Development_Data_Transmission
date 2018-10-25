/*
 * spwc_registers.h
 *
 *  Created on: 06/10/2017
 *      Author: rfranca
 */

#ifndef SPWC_REGISTERS_H_
#define SPWC_REGISTERS_H_

	#define SPWC_SPACEWIRE_INTERFACE_REGISTERS_ADDRESS_OFFSET   0x00

	#define SPWC_INTERFACE_CONTROL_STATUS_REGISTER_ADDRESS      (0x00 + SPWC_SPACEWIRE_INTERFACE_REGISTERS_ADDRESS_OFFSET)
	#define SPWC_BACKDOOR_MODE_CONTROL_BIT_MASK                 (1 << 12)
	#define SPWC_EXTERNAL_LOOPBACK_MODE_CONTROL_BIT_MASK        (1 << 11)
	#define SPWC_CODEC_ENABLE_CONTROL_BIT_MASK                  (1 << 10)
	#define SPWC_CODEC_RX_ENABLE_CONTROL_BIT_MASK               (1 << 9)
	#define SPWC_CODEC_TX_ENABLE_CONTROL_BIT_MASK               (1 << 8)
	#define SPWC_LOOPBACK_MODE_CONTROL_BIT_MASK                 (1 << 7)
	#define SPWC_CODEC_FORCE_RESET_CONTROL_BIT_MASK             (1 << 6)
	#define SPWC_LINK_ERROR_INTERRUPT_ENABLE_BIT_MASK           (1 << 5)
	#define SPWC_TIMECODE_RECEIVED_INTERRUPT_ENABLE_BIT_MASK    (1 << 4)
	#define SPWC_LINK_RUNNING_INTERRUPT_ENABLE_BIT_MASK         (1 << 3)
	#define SPWC_LINK_ERROR_INTERRUPT_FLAG_MASK                 (1 << 2)
	#define SPWC_TIMECODE_RECEIVED_INTERRUPT_FLAG_MASK          (1 << 1)
	#define SPWC_LINK_RUNNING_INTERRUPT_FLAG_MASK               (1 << 0)

	#define SPWC_SPACEWIRE_LINK_CONTROL_STATUS_REGISTER_ADDRESS (0x01 + SPWC_SPACEWIRE_INTERFACE_REGISTERS_ADDRESS_OFFSET)
	#define SPWC_TX_CLOCK_DIVISOR_VALUE_MASK                    (0b11111111 << 10)
	#define SPWC_AUTOSTART_CONTROL_BIT_MASK                     (1 << 9)
	#define SPWC_LINK_START_CONTROL_BIT_MASK                    (1 << 8)
	#define SPWC_LINK_DISCONNECT_CONTROL_BIT_MASK               (1 << 7)
	#define SPWC_LINK_DISCONNECT_ERROR_BIT_MASK                 (1 << 6)
	#define SPWC_LINK_PARITY_ERROR_BIT_MASK                     (1 << 5)
	#define SPWC_LINK_ESCAPE_ERROR_BIT_MASK                     (1 << 4)
	#define SPWC_LINK_CREDIT_ERROR_BIT_MASK                     (1 << 3)
	#define SPWC_LINK_STARTED_STATUS_BIT_MASK                   (1 << 2)
	#define SPWC_LINK_CONNECTING_STATUS_BIT_MASK                (1 << 1)
	#define SPWC_LINK_RUNNING_STATUS_BIT_MASK                   (1 << 0)

	#define SPWC_TIMECODE_CONTROL_REGISTER_ADDRESS              (0x02 + SPWC_SPACEWIRE_INTERFACE_REGISTERS_ADDRESS_OFFSET)
	#define SPWC_RX_TIMECODE_CONTROL_BITS_MASK                  (0b11 << 23)
	#define SPWC_RX_TIMECODE_COUNTER_VALUE_MASK                 (0b111111 << 17)
	#define SPWC_RX_TIMECODE_STATUS_BIT_MASK                    (1 << 16)
	#define SPWC_TX_TIMECODE_CONTROL_BITS_MASK                  (0b11 << 7)
	#define SPWC_TX_TIMECODE_COUNTER_VALUE_MASK                 (0b111111 << 1)
	#define SPWC_TX_TIMECODE_CONTROL_BIT_MASK                   (1 << 0)

	#define SPWC_BACKDOOR_CONTROL_REGISTER_ADDRESS              (0x03 + SPWC_SPACEWIRE_INTERFACE_REGISTERS_ADDRESS_OFFSET)
	#define SPWC_RX_CODEC_RX_DATAVALID_STATUS_BIT_MASK          (1 << 26)
	#define SPWC_RX_CODEC_RX_READ_CONTROL_BIT_MASK              (1 << 25)
	#define SPWC_RX_CODEC_SPACEWIRE_FLAG_VALUE_MASK             (1 << 24)
	#define SPWC_RX_CODEC_SPACEWIRE_DATA_VALUE_MASK             (0b11111111 << 16)
	#define SPWC_TX_CODEC_TX_READY_STATUS_BIT_MASK              (1 << 10)
	#define SPWC_TX_CODEC_TX_WRITE_CONTROL_BIT_MASK             (1 << 9)
	#define SPWC_TX_CODEC_SPACEWIRE_FLAG_VALUE_MASK             (1 << 8)
	#define SPWC_TX_CODEC_SPACEWIRE_DATA_VALUE_MASK             (0b11111111 << 0)


#endif /* SPWC_REGISTERS_H_ */
