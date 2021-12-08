/*
 * configs_simucam.c
 *
 *  Created on: 26/11/2018
 *      Author: Tiago-Low
 */

#include "configs_simucam.h"

TConfEth xConfEth;
TConfRmap xConfRmap;
TConfDebug xConfDebug;

/* Load ETH configuration values from SD Card */
bool bLoadDefaultEthConf(void) {
	short int siFile, sidhcpTemp;
	bool bSuccess = FALSE;
	bool bEOF = FALSE;
	bool close = FALSE;
	unsigned char ucParser;
	char c, *p_inteiro;
	char inteiro[8];

	if ((xSdHandle.connected == TRUE) && (bSDcardIsPresent()) && (bSDcardFAT16Check())) {

		siFile = siOpenFile( ETH_FILE_NAME);

		if (siFile >= 0) {

			memset(&(inteiro), 10, sizeof(inteiro));
			p_inteiro = inteiro;

			do {
				c = cGetNextChar(siFile);
				//fprintf(fp, "%c \n", c);
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
#if DEBUG_ON
					if (xConfDebug.usiDebugLevel <= xCritical) {
						debug(fp, "SDCard: Problem with SDCard");
					}
#endif
					bEOF = TRUE;
					break;
				case 0x20: 	//ASCII: 0x20 = space
				case 10: 	//ASCII: 10 = LN
				case 13: 	//ASCII: 13 = CR
					break;
				case 'M':

					ucParser = 0;
					do {
						do {
							c = cGetNextChar(siFile);
							if (isdigit(c)) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ((c != 58) && (c != 59)); //ASCII: 58 = ':' 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xConfEth.ucMAC[min_sim(ucParser, 5)] = (unsigned char) atoi(inteiro);
						p_inteiro = inteiro;
						ucParser++;
					} while ((c != 59));

					break;
				case 'I':

					ucParser = 0;
					do {
						do {
							c = cGetNextChar(siFile);
							if (isdigit(c)) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ((c != 46) && (c != 59)); //ASCII: 46 = '.' 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xConfEth.ucIP[min_sim(ucParser, 3)] = (unsigned char) atoi(inteiro);
						p_inteiro = inteiro;
						ucParser++;
					} while ((c != 59));

					break;
				case 'G':

					ucParser = 0;
					do {
						do {
							c = cGetNextChar(siFile);
							if (isdigit(c)) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ((c != 46) && (c != 59)); //ASCII: 46 = '.' 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xConfEth.ucGTW[min_sim(ucParser, 3)] = (unsigned char) atoi(inteiro);
						p_inteiro = inteiro;
						ucParser++;
					} while ((c != 59));

					break;
				case 'S':

					ucParser = 0;
					do {
						do {
							c = cGetNextChar(siFile);
							if (isdigit(c)) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ((c != 46) && (c != 59)); //ASCII: 46 = '.' 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xConfEth.ucSubNet[min_sim(ucParser, 3)] = (unsigned char) atoi(inteiro);
						p_inteiro = inteiro;
						ucParser++;
					} while ((c != 59));

					break;
				case 'D':

					ucParser = 0;
					do {
						do {
							c = cGetNextChar(siFile);
							if (isdigit(c)) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ((c != 46) && (c != 59)); //ASCII: 46 = '.' 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xConfEth.ucDNS[min_sim(ucParser, 3)] = (unsigned char) atoi(inteiro);
						p_inteiro = inteiro;
						ucParser++;
					} while ((c != 59));

					break;
				case 'P':
					ucParser = 0;
					do {
						c = cGetNextChar(siFile);
						if (isdigit(c)) {
							(*p_inteiro) = c;
							p_inteiro++;
						}
					} while (c != 59); //ASCII: 59 = ';'
					(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

					xConfEth.siPort = (unsigned short int) atoi(inteiro);
					p_inteiro = inteiro;

					break;
				case 'H':

					do {
						c = cGetNextChar(siFile);
						if (isdigit(c)) {
							(*p_inteiro) = c;
							p_inteiro++;
						}
					} while (c != 59); //ASCII: 59 = ';'
					(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

					sidhcpTemp = atoi(inteiro);
					if (sidhcpTemp == 1)
						xConfEth.bDHCP = TRUE;
					else
						xConfEth.bDHCP = FALSE;

					p_inteiro = inteiro;

					break;
				case 0x3C: //"<"
					close = siCloseFile(siFile);
					if (close == FALSE) {
#if DEBUG_ON
						if (xConfDebug.usiDebugLevel <= xCritical) {
							debug(fp, "SDCard: Can't close the file.\n");
						}
#endif
					}
					/* End of Parser File */
					bEOF = TRUE;
					bSuccess = TRUE; //todo: pensar melhor
					break;
				default:
#if DEBUG_ON
					if (xConfDebug.usiDebugLevel <= xCritical) {
						fprintf(fp, "SDCard: Problem with the parser. (%c)\n", c);
					}
#endif
					break;
				}
			} while (bEOF == FALSE);
		} else {
#if DEBUG_ON
			if (xConfDebug.usiDebugLevel <= xCritical) {
				fprintf(fp, "SDCard: File not found.\n");
			}
#endif
		}
	} else {
#if DEBUG_ON
		if (xConfDebug.usiDebugLevel <= xCritical) {
			fprintf(fp, "SDCard: No SDCard.\n");
		}
#endif
	}
	/* Load the default configuration if not successful in read the SDCard */
	if (bSuccess == FALSE) {

		/*ucMAC[0]:ucMAC[1]:ucMAC[2]:ucMAC[3]:ucMAC[4]:ucMAC[5]
		 *54:10:EC:60:42:79*/
		xConfEth.ucMAC[0] = 0x54;
		xConfEth.ucMAC[1] = 0x10;
		xConfEth.ucMAC[2] = 0xEC;
		xConfEth.ucMAC[3] = 0x60;
		xConfEth.ucMAC[4] = 0x42;
		xConfEth.ucMAC[5] = 0x79;

		/*ucIP[0].ucIP[1].ucIP[2].ucIP[3]
		 *10.9.11.216*/
		xConfEth.ucIP[0] = 10;
		xConfEth.ucIP[1] = 9;
		xConfEth.ucIP[2] = 11;
		xConfEth.ucIP[3] = 216;

		/*ucGTW[0].ucGTW[1].ucGTW[2].ucGTW[3]
		 *10.9.11.1*/
		xConfEth.ucGTW[0] = 10;
		xConfEth.ucGTW[1] = 9;
		xConfEth.ucGTW[2] = 11;
		xConfEth.ucGTW[3] = 1;

		/*ucSubNet[0].ucSubNet[1].ucSubNet[2].ucSubNet[3]
		 *255.255.255.0*/
		xConfEth.ucSubNet[0] = 255;
		xConfEth.ucSubNet[1] = 255;
		xConfEth.ucSubNet[2] = 255;
		xConfEth.ucSubNet[3] = 0;

		/*ucDNS[0].ucDNS[1].ucDNS[2].ucDNS[3]
		 *8.8.8.8*/
		xConfEth.ucDNS[0] = 8;
		xConfEth.ucDNS[1] = 8;
		xConfEth.ucDNS[2] = 8;
		xConfEth.ucDNS[3] = 8;

		xConfEth.siPort = 17000; /* PORT CHANGED */

		xConfEth.bDHCP = FALSE;
	}

	return bSuccess;
}

/* Load RMAP configuration values from SD Card */
bool bLoadDefaultRmapConf(void) {
	short int siFile;
	bool bSuccess = FALSE;
	bool bEOF = FALSE;
	bool close = FALSE;
	unsigned char ucParser;
	char c, *p_inteiro, *p_inteiroll;
	char inteiro[8];
	char inteiroll[24];
	alt_u8 ucSubunitId = 0;

	if ((xSdHandle.connected == TRUE) && (bSDcardIsPresent()) && (bSDcardFAT16Check())) {

		siFile = siOpenFile( RMAP_FILE_NAME);

		if (siFile >= 0) {

			memset(&(inteiro), 10, sizeof(inteiro));
			memset(&(inteiroll), 10, sizeof(inteiroll));
			p_inteiro = inteiro;
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
#if DEBUG_ON
					if (xConfDebug.usiDebugLevel <= xCritical) {
						debug(fp, "SDCard: Problem with SDCard");
					}
#endif
					bEOF = TRUE;
					break;
				case 0x20: 	//ASCII: 0x20 = space
				case 10: 	//ASCII: 10 = LN
				case 13: 	//ASCII: 13 = CR
					break;
				case 'L': /* RMAP Logical Address */
					c = cGetNextChar(siFile);
					if (('1' <= c) && ('8' >= c)) {
						ucSubunitId = (alt_u8)(c - 48 - 1);
					} else {
						ucSubunitId = 0;
					}
					ucParser = 0;
					do {
						do {
							c = cGetNextChar(siFile);
							if (isdigit(c)) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ((c != 46) && (c != 59)); //ASCII: 46 = '.' 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xConfRmap.ucLogicalAddr[ucSubunitId] = (alt_u8) atoi(inteiro);
						p_inteiro = inteiro;
						ucParser++;
					} while ((c != 59));

					break;
				case 'K': /* RMAP Key */
					c = cGetNextChar(siFile);
					if (('1' <= c) && ('8' >= c)) {
						ucSubunitId = (alt_u8)(c - 48 - 1);
					} else {
						ucSubunitId = 0;
					}
					ucParser = 0;
					do {
						do {
							c = cGetNextChar(siFile);
							if (isdigit(c)) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ((c != 46) && (c != 59)); //ASCII: 46 = '.' 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xConfRmap.ucKey[ucSubunitId] = (alt_u8) atoi(inteiro);
						p_inteiro = inteiro;
						ucParser++;
					} while ((c != 59));

					break;
				case 'A': /* RMAP Address Offset */
					c = cGetNextChar(siFile);
					if (('1' <= c) && ('8' >= c)) {
						ucSubunitId = (alt_u8)(c - 48 - 1);
					} else {
						ucSubunitId = 0;
					}
					do {
						c = cGetNextChar(siFile);
						if (isdigit(c)) {
							(*p_inteiroll) = c;
							p_inteiroll++;
						}
					} while (c != 59); //ASCII: 59 = ';'
					(*p_inteiroll) = 10; // Adding LN -> ASCII: 10 = LINE FEED

					xConfRmap.uliAddrOffset[ucSubunitId] = (alt_u32) atoll(inteiroll);
					p_inteiroll = inteiroll;

					break;
				case 'U': /* RMAP Unaligned Memory access Enable */
					c = cGetNextChar(siFile);
					if (('1' <= c) && ('8' >= c)) {
						ucSubunitId = (alt_u8)(c - 48 - 1);
					} else {
						ucSubunitId = 0;
					}
					ucParser = 0;
					do {
						do {
							c = cGetNextChar(siFile);
							if (isdigit(c)) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ((c != 46) && (c != 59)); //ASCII: 46 = '.' 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xConfRmap.bUnaligmentEn[ucSubunitId] = (((bool)atoi(inteiro)) ? TRUE : FALSE);
						p_inteiro = inteiro;
						ucParser++;
					} while ((c != 59));

					break;
				case 'W': /* RMAP Word Width in bits */
					c = cGetNextChar(siFile);
					if (('1' <= c) && ('8' >= c)) {
						ucSubunitId = (alt_u8)(c - 48 - 1);
					} else {
						ucSubunitId = 0;
					}
					ucParser = 0;
					do {
						do {
							c = cGetNextChar(siFile);
							if (isdigit(c)) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ((c != 46) && (c != 59)); //ASCII: 46 = '.' 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xConfRmap.ucWordWidth[ucSubunitId] = (alt_u8) atoi(inteiro);
						p_inteiro = inteiro;
						ucParser++;
					} while ((c != 59));

					break;
				case 0x3C: //"<"
					close = siCloseFile(siFile);
					if (close == FALSE) {
#if DEBUG_ON
						if (xConfDebug.usiDebugLevel <= xCritical) {
							debug(fp, "SDCard: Can't close the file.\n");
						}
#endif
					}
					/* End of Parser File */
					bEOF = TRUE;
					bSuccess = TRUE; //tod: pensar melhor
					break;
				default:
#if DEBUG_ON
					if (xConfDebug.usiDebugLevel <= xCritical) {
						fprintf(fp, "SDCard: Problem with the parser. (%c)\n", c);
					}
#endif
					break;
				}
			} while (bEOF == FALSE);
		} else {
#if DEBUG_ON
			if (xConfDebug.usiDebugLevel <= xCritical) {
				fprintf(fp, "SDCard: File not found.\n");
			}
#endif
		}
	} else {
#if DEBUG_ON
		if (xConfDebug.usiDebugLevel <= xCritical) {
			fprintf(fp, "SDCard: No SDCard.\n");
		}
#endif
	}
	/* Load the default configuration if not successful in read the SDCard */
	if (bSuccess == FALSE) {

		xConfRmap.ucLogicalAddr[0] = 0x00;
		xConfRmap.ucLogicalAddr[1] = 0x00;
		xConfRmap.ucLogicalAddr[2] = 0x00;
		xConfRmap.ucLogicalAddr[3] = 0x00;
		xConfRmap.ucLogicalAddr[4] = 0x00;
		xConfRmap.ucLogicalAddr[5] = 0x00;
		xConfRmap.ucLogicalAddr[6] = 0x00;
		xConfRmap.ucLogicalAddr[7] = 0x00;

		xConfRmap.ucKey[0] = 0x00;
		xConfRmap.ucKey[1] = 0x00;
		xConfRmap.ucKey[2] = 0x00;
		xConfRmap.ucKey[3] = 0x00;
		xConfRmap.ucKey[4] = 0x00;
		xConfRmap.ucKey[5] = 0x00;
		xConfRmap.ucKey[6] = 0x00;
		xConfRmap.ucKey[7] = 0x00;

		xConfRmap.uliAddrOffset[0] = 0xA0000000;
		xConfRmap.uliAddrOffset[1] = 0xA0001000;
		xConfRmap.uliAddrOffset[2] = 0xA0002000;
		xConfRmap.uliAddrOffset[3] = 0xA0003000;
		xConfRmap.uliAddrOffset[4] = 0xA0004000;
		xConfRmap.uliAddrOffset[5] = 0xA0005000;
		xConfRmap.uliAddrOffset[6] = 0xA0006000;
		xConfRmap.uliAddrOffset[7] = 0xA0007000;

		xConfRmap.bUnaligmentEn[0] = FALSE;
		xConfRmap.bUnaligmentEn[1] = FALSE;
		xConfRmap.bUnaligmentEn[2] = FALSE;
		xConfRmap.bUnaligmentEn[3] = FALSE;
		xConfRmap.bUnaligmentEn[4] = FALSE;
		xConfRmap.bUnaligmentEn[5] = FALSE;
		xConfRmap.bUnaligmentEn[6] = FALSE;
		xConfRmap.bUnaligmentEn[7] = FALSE;

		xConfRmap.ucWordWidth[0] = 2;
		xConfRmap.ucWordWidth[1] = 2;
		xConfRmap.ucWordWidth[2] = 2;
		xConfRmap.ucWordWidth[3] = 2;
		xConfRmap.ucWordWidth[4] = 2;
		xConfRmap.ucWordWidth[5] = 2;
		xConfRmap.ucWordWidth[6] = 2;
		xConfRmap.ucWordWidth[7] = 2;

	}

	return bSuccess;
}

/* Load debug values from SD Card, only used during the development */
bool bLoadDefaultDebugConf(void) {
	short int siFile;
	bool bSuccess = FALSE;
	bool bEOF = FALSE;
	bool close = FALSE;
	unsigned char ucParser;
	char c, *p_inteiro;
	char inteiro[8];

	if ((xSdHandle.connected == TRUE) && (bSDcardIsPresent()) && (bSDcardFAT16Check())) {

		siFile = siOpenFile( DEBUG_FILE_NAME);

		if (siFile >= 0) {

			memset(&(inteiro), 10, sizeof(inteiro));
			p_inteiro = inteiro;

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
#if DEBUG_ON
					debug(fp, "SDCard: Problem with SDCard")
					;
#endif
					bEOF = TRUE;
					break;
				case 0x20: 	//ASCII: 0x20 = space
				case 10: 	//ASCII: 10 = LN
				case 13: 	//ASCII: 13 = CR
					break;
				case 'T':
					ucParser = 0;
					do {
						do {
							c = cGetNextChar(siFile);
							if (isdigit(c)) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ((c != 46) && (c != 59)); //ASCII: 46 = '.' 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						switch ((unsigned short int) atoi(inteiro)) {
						case 0:
							xConfDebug.bSendEEP = FALSE;
							xConfDebug.bSendEOP = FALSE;
							break;
						case 1:
							xConfDebug.bSendEEP = TRUE;
							xConfDebug.bSendEOP = FALSE;
							break;
						case 2:
						default:
							xConfDebug.bSendEEP = FALSE;
							xConfDebug.bSendEOP = TRUE;
							break;
						}

						p_inteiro = inteiro;
						ucParser++;
					} while ((c != 59));

					break;
				case 'D':
					ucParser = 0;
					do {
						do {
							c = cGetNextChar(siFile);
							if (isdigit(c)) {
								(*p_inteiro) = c;
								p_inteiro++;
							}
						} while ((c != 46) && (c != 59)); //ASCII: 46 = '.' 59 = ';'
						(*p_inteiro) = 10; // Adding LN -> ASCII: 10 = LINE FEED

						xConfDebug.usiDebugLevel = (unsigned short int) atoi(inteiro);
						p_inteiro = inteiro;
						ucParser++;
					} while ((c != 59));

					break;
				case 0x3C: //"<"
					close = siCloseFile(siFile);
					if (close == FALSE) {
#if DEBUG_ON
						debug(fp, "SDCard: Can't close the file.\n");
#endif
					}
					/* End of Parser File */
					bEOF = TRUE;
					bSuccess = TRUE; //tod: pensar melhor
					break;
				default:
#if DEBUG_ON
					fprintf(fp, "SDCard: Problem with the parser. (%c)\n", c);
#endif
					break;
				}
			} while (bEOF == FALSE);
		} else {
#if DEBUG_ON
			fprintf(fp, "SDCard: File not found.\n");
#endif
		}
	} else {
#if DEBUG_ON
		fprintf(fp, "SDCard: No SDCard.\n");
#endif
	}
	/* Load the default configuration if not successful in read the SDCard */
	if (bSuccess == FALSE) {

		xConfDebug.bSendEEP = FALSE;
		xConfDebug.bSendEOP = TRUE;

		xConfDebug.usiDebugLevel = xMajor;

	}

	return bSuccess;
}

#if DEBUG_ON
void vShowEthConfig(void) {

	fprintf(fp, "Ethernet loaded configurations:\n");

	fprintf(fp, "  MAC: %02X:%02X:%02X:%02X:%02X:%02X \n", xConfEth.ucMAC[0], xConfEth.ucMAC[1], xConfEth.ucMAC[2], xConfEth.ucMAC[3], xConfEth.ucMAC[4], xConfEth.ucMAC[5]);

	fprintf(fp, "  IP: %i.%i.%i.%i \n", xConfEth.ucIP[0], xConfEth.ucIP[1], xConfEth.ucIP[2], xConfEth.ucIP[3]);

	fprintf(fp, "  GTW: %i.%i.%i.%i \n", xConfEth.ucGTW[0], xConfEth.ucGTW[1], xConfEth.ucGTW[2], xConfEth.ucGTW[3]);

	fprintf(fp, "  Sub: %i.%i.%i.%i \n", xConfEth.ucSubNet[0], xConfEth.ucSubNet[1], xConfEth.ucSubNet[2], xConfEth.ucSubNet[3]);

	fprintf(fp, "  DNS: %i.%i.%i.%i \n", xConfEth.ucDNS[0], xConfEth.ucDNS[1], xConfEth.ucDNS[2], xConfEth.ucDNS[3]);

	fprintf(fp, "  Server Port: %i\n", xConfEth.siPort);

	fprintf(fp, "  Use DHCP: %i\n", xConfEth.bDHCP);

	fprintf(fp, "\n");

}

void vShowRmapConfig(void) {
	alt_u8 ucSubunitId = 0;

	fprintf(fp, "RMAP loaded configurations:\n");

	for (ucSubunitId = 0; ucSubunitId < 8; ucSubunitId++) {
		fprintf(fp, "  Subunit %u: Logical Address = 0x%02X, Key = 0x%02X, Address Offset = 0x%08lX, Unaligment Enable = %u, Word Size [Bytes] = %u \n",
				(ucSubunitId + 1), xConfRmap.ucLogicalAddr[ucSubunitId], xConfRmap.ucKey[ucSubunitId], xConfRmap.uliAddrOffset[ucSubunitId], xConfRmap.bUnaligmentEn[ucSubunitId], (1 << xConfRmap.ucWordWidth[ucSubunitId]));
	}

	fprintf(fp, "\n");

}

void vShowDebugConfig(void) {

	fprintf(fp, "Debug loaded configurations:\n");

	fprintf(fp, "  Send EEP with data packet: %d \n", xConfDebug.bSendEEP);

	fprintf(fp, "  Send EOP with data packet: %d \n", xConfDebug.bSendEOP);

	fprintf(fp, "  Messages debug level: %d \n", xConfDebug.usiDebugLevel);

	fprintf(fp, "\n");

}
#endif
