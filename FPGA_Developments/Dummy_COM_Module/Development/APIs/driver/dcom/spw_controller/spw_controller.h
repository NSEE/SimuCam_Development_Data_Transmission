typedef struct SpwcLinkConfig {
	bool bAutostart;
	bool bLinkStart;
	bool bDisconnect;
	alt_u8 ucTxDivCnt;
} TSpwcLinkConfig;

typedef struct SpwcLinkError {
	bool bDisconnect;
	bool bParity;
	bool bEscape;
	bool bCredit;
} TSpwcLinkError;

typedef struct SpwcLinkStatus {
	bool bStarted;
	bool bConnecting;
	bool bRunning;
} TSpwcLinkStatus;

typedef struct SpwcRxTimecode {
	alt_u8 ucControl;
	alt_u8 ucCounter;
	bool bTransmit;
} TSpwcRxTimecode;

typedef struct SpwcTxTimecode {
	alt_u8 ucControl;
	alt_u8 ucCounter;
	bool bReceived;
} TSpwcTxTimecode;

typedef struct SpwcChannel {
	alt_u32 *puliSpwcChAddr;
	TSpwcLinkConfig xLinkConfig;
	TSpwcLinkError xLinkError;
	TSpwcLinkStatus xLinkStatus;
	TSpwcRxTimecode xRxTimecode;
	TSpwcTxTimecode xTxTimecode;
} TSpwcChannel;

// Set functions -> set data from channel variable to hardware
// Get functions -> get data from hardware to channel variable

bool bSpwcSetLink(TSpwcChannel *pxSpwcCh);
bool bSpwcGetLink(TSpwcChannel *pxSpwcCh);

bool bSpwcGetLinkError(TSpwcChannel *pxSpwcCh);

bool bSpwcGetLinkStatus(TSpwcChannel *pxSpwcCh);

bool bSpwcSetTxTimecode(TSpwcChannel *pxSpwcCh);
bool bSpwcGetTxTimecode(TSpwcChannel *pxSpwcCh);

bool bSpwcGetRxTimecode(TSpwcChannel *pxSpwcCh);

bool bSpwcInitCh(TSpwcChannel *pxSpwcCh, alt_u8 ucCommCh);
