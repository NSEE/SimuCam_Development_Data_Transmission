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

typedef struct SpwcTimecode {
	alt_u8 ucControl;
	alt_u8 ucCounter;
} TSpwcTimecode;

typedef struct SpwcChannel {
	alt_u32 *puliSpwcChAddr;
	TSpwcLinkConfig xLinkConfig;
	TSpwcLinkError xLinkError;
	TSpwcLinkStatus xLinkStatus;
	TSpwcTimecode xRxTimecode;
	TSpwcTimecode xTxTimecode;
} TSpwcChannel;

// Set functions -> set data from channel variable to hardware
// Get functions -> get data from hardware to channel variable

bool bSpwcSetLink(TSpwcChannel *pxSpwcCh);
bool bSpwcGetLink(TSpwcChannel *pxSpwcCh);

bool bSpwcGetLinkError(TSpwcChannel *pxSpwcCh);

bool bSpwcGetLinkStatus(TSpwcChannel *pxSpwcCh);

bool bSpwcSetTimecode(TSpwcChannel *pxSpwcCh);
bool bSpwcGetTimecode(TSpwcChannel *pxSpwcCh);

bool bSpwcInitCh(TSpwcChannel *pxSpwcCh, alt_u8 ucCommCh);
