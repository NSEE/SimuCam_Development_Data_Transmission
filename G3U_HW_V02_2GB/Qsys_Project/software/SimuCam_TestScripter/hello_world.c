/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>

#include "simucam_definitions.h"
#include "utils/initialization_simucam.h"
#include "utils/test_module_simucam.h"

#include "utils/sdcard_file_manager.h"
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <sys/alt_stdio.h>

/* Declaring file for JTAG debug */
#if DEBUG_ON
FILE* fp;
#endif

#define NUMBER_OF_DCOM_CHANNELS 4
alt_u8 ucDcomCh = 0;
TDcomChannel *vpxDcomCh[NUMBER_OF_DCOM_CHANNELS] = {
		(TDcomChannel *) (DCOM_CH_1_BASE_ADDR),
		(TDcomChannel *) (DCOM_CH_2_BASE_ADDR),
		(TDcomChannel *) (DCOM_CH_3_BASE_ADDR),
		(TDcomChannel *) (DCOM_CH_4_BASE_ADDR)
};

#define DATA_CONTROLLER_DATA_CONTROL_SIZE 2
#define DATA_CONTROLLER_DATA_TIME_SIZE    4
#define DATA_CONTROLLER_DATA_LENGTH_SIZE  2

typedef struct DataControllerFormat {
	alt_u8 ucDataControl[DATA_CONTROLLER_DATA_CONTROL_SIZE];
	alt_u8 ucDataTime[DATA_CONTROLLER_DATA_TIME_SIZE];
	alt_u8 ucDataLenght[DATA_CONTROLLER_DATA_LENGTH_SIZE];
	alt_u8 ucDataFirstByte;
} TDataControllerFormat;

typedef struct TestDataControl {
	alt_u32 uliDdrBaseAddr;
	alt_u32 uliDataLengthBytes;
	alt_u32 uliNumberOfPackets;
	alt_u32 uliTransmittedPackets;
	bool bFinishedTransmission;
} TTestDataControl;

bool bLoadTestData(char *strFileName, TTestDataControl xTestDataControl[NUMBER_OF_DCOM_CHANNELS]);
alt_u8 ucConvertHex8ToDec(char cHex[2]);
bool bConvertUint32ToBytes(alt_u32 uliValue, alt_u8 *pucBytes, alt_u8 ucLenghtInBytes);

int main()
{

	/* Debug device initialization - JTAG USB */
#if DEBUG_ON
	fp = fopen(JTAG_UART_0_NAME, "r+");
#endif

#if DEBUG_ON
	fprintf(fp, "Main entry point.\n");
#endif

	/* Initialization of core HW */
	if (bInitSimucamCoreHW()) {
#if DEBUG_ON
		fprintf(fp, "\n");
		fprintf(fp, "SimuCam Release: %s\n", SIMUCAM_RELEASE);
		fprintf(fp, "SimuCam HW Version: %s.%s\n", SIMUCAM_RELEASE, SIMUCAM_HW_VERSION);
		fprintf(fp, "SimuCam FW Version: %s.%s.%s\n", SIMUCAM_RELEASE, SIMUCAM_HW_VERSION, SIMUCAM_FW_VERSION);
		fprintf(fp, "\n");
#endif
	} else {
#if DEBUG_ON
		fprintf(fp, "\n");
		fprintf(fp, "CRITICAL HW FAILURE: Hardware TimeStamp or System ID does not match the expected! SimuCam will be halted.\n");
		fprintf(fp, "CRITICAL HW FAILURE: Expected HW release: %s.%s\n", SIMUCAM_RELEASE, SIMUCAM_HW_VERSION);
		fprintf(fp, "CRITICAL HW FAILURE: SimuCam will be halted.\n");
		fprintf(fp, "\n");
#endif
		while (1) {
		}
	}

	/* Test of some critical IPCores HW interfaces in the Simucam */
	if (!bTestSimucamCriticalHW()) {
#if DEBUG_ON
		fprintf(fp, "\n");
		fprintf(fp, "Failure to initialize SimuCam Critical HW!\n");
		fprintf(fp, "Initialization attempt %lu, ", uliRstcGetResetCounter());
#endif
		/* Need to reset 2 times (3 tries) before halting the SimuCam */
		if (3 > uliRstcGetResetCounter()) {
			/* There are more initialization tries to make */
#if DEBUG_ON
			fprintf(fp, "SimuCam will be reseted now!\n");
#endif
			vRstcHoldSimucamReset(0);
		} else {
			/* No more tries, lock the SimuCam */
#if DEBUG_ON

			fprintf(fp, "SimuCam will be halted now!\n");
#endif
			while(1) {};
		}
		return (-1);
	}

	/* Initialization and Test of basic HW */
	vInitSimucamBasicHW();
	bTestSimucamBasicHW();

	/* Initialize SD Card */
	bInitializeSDCard();

	/* Enable Spw Channels */
	bEnableIsoDrivers();
	bEnableLvdsBoard();

	/* Set Channels Configuration */
	for (ucDcomCh = 0; NUMBER_OF_DCOM_CHANNELS > ucDcomCh; ucDcomCh++) {

//		bDcomInitCh(&(xDcomCh[ucDcomCh]), ucDcomCh);

		vpxDcomCh[ucDcomCh]->xRmap.xRmapCodecConfig.bEnable          = FALSE;
		vpxDcomCh[ucDcomCh]->xRmap.xRmapCodecConfig.ucLogicalAddress = 0x00;
		vpxDcomCh[ucDcomCh]->xRmap.xRmapCodecConfig.ucKey            = 0x00;

		vpxDcomCh[ucDcomCh]->xSpacewire.xSpwcLinkConfig.bEnable     = TRUE;
		vpxDcomCh[ucDcomCh]->xSpacewire.xSpwcLinkConfig.bDisconnect = FALSE;
		vpxDcomCh[ucDcomCh]->xSpacewire.xSpwcLinkConfig.bLinkStart  = TRUE;
		vpxDcomCh[ucDcomCh]->xSpacewire.xSpwcLinkConfig.bAutostart  = TRUE;
		vpxDcomCh[ucDcomCh]->xSpacewire.xSpwcLinkConfig.ucTxDivCnt  = 1;

		/* SpW A [0] and SpW B [1] --> Spw G [6] */
		/* SpW C [2] and SpW D [3] --> Spw H [7] */
		vpxDcomCh[ucDcomCh]->xRmap.xRmapEchoingModeConfig.bRmapEchoingModeEn = TRUE;
		vpxDcomCh[ucDcomCh]->xRmap.xRmapEchoingModeConfig.bRmapEchoingIdEn   = TRUE;

		vpxDcomCh[ucDcomCh]->xDataScheduler.xDschTimerControl.bStop  = TRUE;
		vpxDcomCh[ucDcomCh]->xDataScheduler.xDschTimerControl.bClear = TRUE;

		vpxDcomCh[ucDcomCh]->xDataScheduler.xDschTimerConfig.bRunOnSync   = FALSE;
		vpxDcomCh[ucDcomCh]->xDataScheduler.xDschTimerConfig.uliClockDiv  = TIMER_CLOCK_DIV_1MS;
		vpxDcomCh[ucDcomCh]->xDataScheduler.xDschTimerConfig.uliStartTime = 0;

		vpxDcomCh[ucDcomCh]->xDataScheduler.xDschTimerControl.bStart = TRUE;

		vpxDcomCh[ucDcomCh]->xDataScheduler.xDschPacketConfig.bSendEop = TRUE;
		vpxDcomCh[ucDcomCh]->xDataScheduler.xDschPacketConfig.bSendEep = FALSE;

		bIdmaResetChDma(ucDcomCh, TRUE);

	}

	/* Write Data to memory */
	bDdr2SwitchMemory(eDdr2Memory1);

	char strFolderName[50];
	char strFileName[50];
	TTestDataControl xTestDataControl[NUMBER_OF_DCOM_CHANNELS];
	alt_u8 ucDcomLink = 0;

	while (1) {

		sprintf(strFolderName, "TEST/");
		sprintf(strFileName, " ");
		printf("\nSelect a Test File: ");
		scanf("%s", strFileName);
		printf("\n");

		xTestDataControl[0].uliDdrBaseAddr = (alt_u32)DDR2_BASE_ADDR_DATASET_1;
		xTestDataControl[0].uliDataLengthBytes = 0;
		xTestDataControl[0].uliNumberOfPackets = 0;
		xTestDataControl[0].uliTransmittedPackets = 0;
		xTestDataControl[0].bFinishedTransmission = FALSE;
		xTestDataControl[1].uliDdrBaseAddr = (alt_u32)DDR2_BASE_ADDR_DATASET_2;
		xTestDataControl[1].uliDataLengthBytes = 0;
		xTestDataControl[1].uliNumberOfPackets = 0;
		xTestDataControl[1].uliTransmittedPackets = 0;
		xTestDataControl[1].bFinishedTransmission = FALSE;
		xTestDataControl[2].uliDdrBaseAddr = (alt_u32)DDR2_BASE_ADDR_DATASET_3;
		xTestDataControl[2].uliDataLengthBytes = 0;
		xTestDataControl[2].uliNumberOfPackets = 0;
		xTestDataControl[2].uliTransmittedPackets = 0;
		xTestDataControl[2].bFinishedTransmission = FALSE;
		xTestDataControl[3].uliDdrBaseAddr = (alt_u32)DDR2_BASE_ADDR_DATASET_4;
		xTestDataControl[3].uliDataLengthBytes = 0;
		xTestDataControl[3].uliNumberOfPackets = 0;
		xTestDataControl[3].uliTransmittedPackets = 0;
		xTestDataControl[3].bFinishedTransmission = FALSE;

		printf("Starting test...\n");
		usleep(1000000);

		strcat(strFolderName, strFileName);
		if (bLoadTestData(strFolderName, xTestDataControl)) {

			for (ucDcomLink = 0; ucDcomLink < NUMBER_OF_DCOM_CHANNELS; ucDcomLink++) {
				if (xTestDataControl[ucDcomLink].uliNumberOfPackets > 0) {

					printf("Test have %lu packets for channel %u\n", xTestDataControl[ucDcomLink].uliNumberOfPackets, ucDcomLink);
					usleep(1000000);

					uliIdmaChDmaTransfer(eDdr2Memory1, (alt_u32 *)xTestDataControl[ucDcomLink].uliDdrBaseAddr, xTestDataControl[ucDcomLink].uliDataLengthBytes, ucDcomLink);

				}
			}

			for (ucDcomLink = 0; ucDcomLink < NUMBER_OF_DCOM_CHANNELS; ucDcomLink++) {
				if (xTestDataControl[ucDcomLink].uliNumberOfPackets > 0) {

					/* Run Channel */
					vpxDcomCh[ucDcomLink]->xDataScheduler.xDschTimerControl.bRun   = TRUE;

				}
			}

			while (
					(FALSE == xTestDataControl[0].bFinishedTransmission) ||
					(FALSE == xTestDataControl[1].bFinishedTransmission) ||
					(FALSE == xTestDataControl[2].bFinishedTransmission) ||
					(FALSE == xTestDataControl[3].bFinishedTransmission)
					) {

				for (ucDcomLink = 0; ucDcomLink < NUMBER_OF_DCOM_CHANNELS; ucDcomLink++) {
					if (vpxDcomCh[ucDcomLink]->xDataScheduler.xDschTimerStatus.uliCurrentTime >= xTestDataControl[ucDcomLink].uliNumberOfPackets) {
						/* All packages transmitted */
						xTestDataControl[ucDcomLink].bFinishedTransmission = TRUE;
					} else {
						/* Not all packages transmitted */
						if (vpxDcomCh[ucDcomLink]->xDataScheduler.xDschTimerStatus.uliCurrentTime > xTestDataControl[ucDcomLink].uliTransmittedPackets) {
							xTestDataControl[ucDcomLink].uliTransmittedPackets = vpxDcomCh[ucDcomLink]->xDataScheduler.xDschTimerStatus.uliCurrentTime;
							printf("Transmitted %lu / %lu packets for channel %u\n", xTestDataControl[ucDcomLink].uliTransmittedPackets, xTestDataControl[ucDcomLink].uliNumberOfPackets, ucDcomLink);
						}
					}
				}
				usleep(500000);
			}

			for (ucDcomLink = 0; ucDcomLink < NUMBER_OF_DCOM_CHANNELS; ucDcomLink++) {
				if (xTestDataControl[ucDcomLink].uliNumberOfPackets > 0) {

					/* All transmitted, end of operation */
					vpxDcomCh[ucDcomLink]->xDataScheduler.xDschTimerControl.bStop  = TRUE;
					vpxDcomCh[ucDcomLink]->xDataScheduler.xDschTimerControl.bClear = TRUE;
					vpxDcomCh[ucDcomLink]->xDataScheduler.xDschTimerControl.bStart = TRUE;

				}
			}

			printf("Finished test!!\n");
			usleep(1000000);

			bDdr2SingleMemoryZeroFill(eDdr2Memory1);

		} else {
			printf("Test file %s not found!\n", strcat("TEST/", strFileName));
		}

		printf("\n\n");

	}

  return 0;
}

bool bLoadTestData(char *strFileName, TTestDataControl xTestDataControl[NUMBER_OF_DCOM_CHANNELS]) {
	bool bStatus = FALSE;

	short int siFile;
	bool bEOF = FALSE;
	bool close = FALSE;
	char c, *p_inteiroll;
	char inteiroll[24];

	alt_u8 ucDcomChannelLink = 0;

	alt_u8 ucByteDigitCnt = 1;
	char cHexDigits[2];

	alt_u32 uliDdrDataControllerAddr[NUMBER_OF_DCOM_CHANNELS] = {0, 0, 0, 0};
	alt_u8 *pucDdrDataControllerAddrPrt[NUMBER_OF_DCOM_CHANNELS] = {NULL, NULL, NULL, NULL};
	volatile TDataControllerFormat *vpxDataControllerFormat[NUMBER_OF_DCOM_CHANNELS];

	uliDdrDataControllerAddr[0] = xTestDataControl[0].uliDdrBaseAddr;
	uliDdrDataControllerAddr[1] = xTestDataControl[1].uliDdrBaseAddr;
	uliDdrDataControllerAddr[2] = xTestDataControl[2].uliDdrBaseAddr;
	uliDdrDataControllerAddr[3] = xTestDataControl[3].uliDdrBaseAddr;
	vpxDataControllerFormat[0] = (TDataControllerFormat *)(xTestDataControl[0].uliDdrBaseAddr);
	vpxDataControllerFormat[1] = (TDataControllerFormat *)(xTestDataControl[1].uliDdrBaseAddr);
	vpxDataControllerFormat[2] = (TDataControllerFormat *)(xTestDataControl[2].uliDdrBaseAddr);
	vpxDataControllerFormat[3] = (TDataControllerFormat *)(xTestDataControl[3].uliDdrBaseAddr);

	if ((xSdHandle.connected == TRUE) && (bSDcardIsPresent()) && (bSDcardFAT16Check())) {

		siFile = siOpenFile(strFileName);

		if (siFile >= 0) {

			memset(&(inteiroll), 10, sizeof(inteiroll));
			p_inteiroll = inteiroll;

			do {
				c = cGetNextChar(siFile);
				switch (c) {

					case 39: // single quote '
						c = cGetNextChar(siFile);
						while (c != 39) {
							c = cGetNextChar(siFile);
						}
						break;

					case -1: 	//EOF
						bEOF = TRUE;
						break;

					case -2: 	//EOF
						debug(fp, "SDCard: Problem with SDCard");
						bEOF = TRUE;
						break;

					case 0x20: 	//ASCII: 0x20 = space
					case 10: 	//ASCII: 10 = LN
					case 13: 	//ASCII: 13 = CR
						break;

					case 'S':

						do {
							c = cGetNextChar(siFile);
							if (isdigit(c)) {
								(*p_inteiroll) = c;
								p_inteiroll++;
							}
						} while (c != 59); //ASCII: 59 = ';'
						(*p_inteiroll) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						ucDcomChannelLink = (alt_u8)(atoll(inteiroll));
						p_inteiroll = inteiroll;

						break;


					case 'C':

						do {
							c = cGetNextChar(siFile);
							if (isdigit(c)) {
								(*p_inteiroll) = c;
								p_inteiroll++;
							}
						} while (c != 59); //ASCII: 59 = ';'
						(*p_inteiroll) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						bConvertUint32ToBytes(atoll(inteiroll), (alt_u8 *)(&(vpxDataControllerFormat[ucDcomChannelLink]->ucDataControl[0])), DATA_CONTROLLER_DATA_CONTROL_SIZE);
						if (atoll(inteiroll) <= 1) {
							xTestDataControl[ucDcomChannelLink].uliNumberOfPackets++;
						}
						p_inteiroll = inteiroll;

						break;

					case 'T':

						do {
							c = cGetNextChar(siFile);
							if (isdigit(c)) {
								(*p_inteiroll) = c;
								p_inteiroll++;
							}
						} while (c != 59); //ASCII: 59 = ';'
						(*p_inteiroll) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						bConvertUint32ToBytes(atoll(inteiroll), (alt_u8 *)(&(vpxDataControllerFormat[ucDcomChannelLink]->ucDataTime[0])), DATA_CONTROLLER_DATA_TIME_SIZE);
						p_inteiroll = inteiroll;

						break;

					case 'L':

						do {
							c = cGetNextChar(siFile);
							if (isdigit(c)) {
								(*p_inteiroll) = c;
								p_inteiroll++;
							}
						} while (c != 59); //ASCII: 59 = ';'
						(*p_inteiroll) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						bConvertUint32ToBytes(atoll(inteiroll), (alt_u8 *)(&(vpxDataControllerFormat[ucDcomChannelLink]->ucDataLenght[0])), DATA_CONTROLLER_DATA_LENGTH_SIZE);
						p_inteiroll = inteiroll;

						break;

					case 'D':

						ucByteDigitCnt = 1;

						uliDdrDataControllerAddr[ucDcomChannelLink] = (alt_u32)(&(vpxDataControllerFormat[ucDcomChannelLink]->ucDataFirstByte));
						pucDdrDataControllerAddrPrt[ucDcomChannelLink] = (alt_u8 *)uliDdrDataControllerAddr[ucDcomChannelLink];
						do {
							c = cGetNextChar(siFile);
							if (isxdigit(c)) {
								cHexDigits[ucByteDigitCnt] = c;
								ucByteDigitCnt = (ucByteDigitCnt - 1) & 0x01;
								if (1 == ucByteDigitCnt) {
									*(pucDdrDataControllerAddrPrt[ucDcomChannelLink]) = ucConvertHex8ToDec(cHexDigits);
									uliDdrDataControllerAddr[ucDcomChannelLink]++;
									pucDdrDataControllerAddrPrt[ucDcomChannelLink]++;
								}
							}
						} while (c != 59); //ASCII: 59 = ';'
						(*p_inteiroll) = 10; // Adding LN -> ASCII: 10 = LINE FEED
						p_inteiroll = inteiroll;

						/* Rounding up the address to the nearest multiple of DSCH_DATA_ACCESS_WIDTH_BYTES (DSCH_DATA_ACCESS_WIDTH_BYTES = 8 bytes = 64b = size of memory access) */
						if (uliDdrDataControllerAddr[ucDcomChannelLink] % DSCH_DATA_ACCESS_WIDTH_BYTES) {
							/* Transfer size is not a multiple of DSCH_DATA_ACCESS_WIDTH_BYTES */
							uliDdrDataControllerAddr[ucDcomChannelLink] = (alt_u32) ((uliDdrDataControllerAddr[ucDcomChannelLink] & DSCH_DATA_TRANSFER_SIZE_MASK ) + DSCH_DATA_ACCESS_WIDTH_BYTES );
						}
						vpxDataControllerFormat[ucDcomChannelLink] = (TDataControllerFormat *)(uliDdrDataControllerAddr[ucDcomChannelLink]);

						xTestDataControl[ucDcomChannelLink].uliDataLengthBytes = uliDdrDataControllerAddr[ucDcomChannelLink] - xTestDataControl[ucDcomChannelLink].uliDdrBaseAddr;

						break;

					case 0x3C: //"<"
						close = siCloseFile(siFile);
						if (close == FALSE) {
							debug(fp, "SDCard: Can't close the file.\n");
						}
						/* End of Parser File */
						bEOF = TRUE;
						bStatus = TRUE; //todo: pensar melhor
						break;

					default:
						fprintf(fp, "SDCard: Problem with the parser. (%c)\n", c);
						break;
				}

			} while (bEOF == FALSE);

		} else {
			fprintf(fp, "SDCard: File not found.\n");
		}
	} else {
		fprintf(fp, "SDCard: No SDCard.\n");
	}

	return (bStatus);
}

alt_u8 ucConvertHex8ToDec(char cHex[2]) {
	alt_u8 ucDec = 0;

	switch (cHex[0]) {
		case '0': ucDec = 0; break;
		case '1': ucDec = 1; break;
		case '2': ucDec = 2; break;
		case '3': ucDec = 3; break;
		case '4': ucDec = 4; break;
		case '5': ucDec = 5; break;
		case '6': ucDec = 6; break;
		case '7': ucDec = 7; break;
		case '8': ucDec = 8; break;
		case '9': ucDec = 9; break;
		case 'A':
		case 'a': ucDec = 10; break;
		case 'B':
		case 'b': ucDec = 11; break;
		case 'C':
		case 'c': ucDec = 12; break;
		case 'D':
		case 'd': ucDec = 13; break;
		case 'E':
		case 'e': ucDec = 14; break;
		case 'F':
		case 'f': ucDec = 15; break;
		default: ucDec = 0xFF; break;
	}

	switch (cHex[1]) {
		case '0': ucDec += (0 << 4); break;
		case '1': ucDec += (1 << 4); break;
		case '2': ucDec += (2 << 4); break;
		case '3': ucDec += (3 << 4); break;
		case '4': ucDec += (4 << 4); break;
		case '5': ucDec += (5 << 4); break;
		case '6': ucDec += (6 << 4); break;
		case '7': ucDec += (7 << 4); break;
		case '8': ucDec += (8 << 4); break;
		case '9': ucDec += (9 << 4); break;
		case 'A':
		case 'a': ucDec += (10 << 4); break;
		case 'B':
		case 'b': ucDec += (11 << 4); break;
		case 'C':
		case 'c': ucDec += (12 << 4); break;
		case 'D':
		case 'd': ucDec += (13 << 4); break;
		case 'E':
		case 'e': ucDec += (14 << 4); break;
		case 'F':
		case 'f': ucDec += (15 << 4); break;
		default: ucDec = 0xFF; break;
	}

	return (ucDec);
}

bool bConvertUint32ToBytes(alt_u32 uliValue, alt_u8 *pucBytes, alt_u8 ucLenghtInBytes) {
	bool bStatus = FALSE;

	switch (ucLenghtInBytes) {
		case 1:
			pucBytes[0] = (alt_u8)( uliValue       & 0x000000FF);
			break;
		case 2:
			pucBytes[0] = (alt_u8)((uliValue >> 8) & 0x000000FF);
			pucBytes[1] = (alt_u8)( uliValue       & 0x000000FF);
			break;
		case 3:
			pucBytes[0] = (alt_u8)((uliValue >> 16) & 0x000000FF);
			pucBytes[1] = (alt_u8)((uliValue >> 8)  & 0x000000FF);
			pucBytes[2] = (alt_u8)( uliValue        & 0x000000FF);
			break;
		case 4:
			pucBytes[0] = (alt_u8)((uliValue >> 24) & 0x000000FF);
			pucBytes[1] = (alt_u8)((uliValue >> 16) & 0x000000FF);
			pucBytes[2] = (alt_u8)((uliValue >> 8)  & 0x000000FF);
			pucBytes[3] = (alt_u8)( uliValue        & 0x000000FF);
			break;
		default:
			bStatus = FALSE;
			break;
	}

	return (bStatus);
}
