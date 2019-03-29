typedef struct DschTimerConfig {
	bool bStartOnSync;
	uint32_t uliTimerDiv;
} TDschTimerConfig;

typedef struct DschTimerStatus {
	uint32_t uliTime;
	bool bStopped;
	bool bStarted;
	bool bRunning;
	bool bCleared;
} TDschTimerStatus;

typedef struct DschChannel {
	alt_u32 *puliDschChAddr;
	TDschTimerConfig xTimerConfig;
	TDschTimerStatus xTimerStatus;
} TDschChannel;

// Set functions -> set data from channel variable to hardware
// Get functions -> get data from hardware to channel variable

bool bDschSetTimerConfig(TDschChannel *pxDschCh);
bool bDschGetTimerConfig(TDschChannel *pxDschCh);

bool bDschGetTimerStatus(TDschChannel *pxDschCh);

uint32_t uliDschGetTime(TDschChannel *pxDschCh);

bool bDschStartTimer(TDschChannel *pxDschCh);
bool bDschRunTimer(TDschChannel *pxDschCh);
bool bDschStopTimer(TDschChannel *pxDschCh);
bool bDschClrTimer(TDschChannel *pxDschCh);

bool bDschInitCh(TDschChannel *pxDschCh, alt_u8 ucCommCh);
