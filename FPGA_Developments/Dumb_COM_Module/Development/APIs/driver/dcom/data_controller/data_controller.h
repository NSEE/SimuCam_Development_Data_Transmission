const alt_u8 cucDctrIrqFlagsQtd;

enum DctrIrqFlags {
	eTxBeginFlag = 0,
	eTxEndFlag,
} EDctrIrqFlags;

typedef struct DctrIrqControl {
	bool bTxBeginEn;
	bool bTxEndEn;
} TDctrControl;

typedef struct DctrIrqFlag {
	bool bTxBeginFlag;
	bool bTxEndFlag
} TDctrIrqFlag;

typedef struct DctrControllerConfig {
	bool bSendEop;
	bool bSendEep;
} DctrControllerConfig;

typedef struct DctrChannel {
	alt_u32 *puliDctrChAddr;
	DctrIrqControl xIrqControl;
	DctrIrqFlag xIrqFlag;
	DctrControllerConfig xControllerConfig;
} TDctrChannel;

void vDctrCh1HandleIrq(void* pvContext);
void vDctrCh2HandleIrq(void* pvContext);
void vDctrCh3HandleIrq(void* pvContext);
void vDctrCh4HandleIrq(void* pvContext);
void vDctrCh5HandleIrq(void* pvContext);
void vDctrCh6HandleIrq(void* pvContext);
void vDctrCh7HandleIrq(void* pvContext);
void vDctrCh8HandleIrq(void* pvContext);

void vDctrCh1IrqFlagClr(alt_u8 ucIrqFlag);
void vDctrCh2IrqFlagClr(alt_u8 ucIrqFlag);
void vDctrCh3IrqFlagClr(alt_u8 ucIrqFlag);
void vDctrCh4IrqFlagClr(alt_u8 ucIrqFlag);
void vDctrCh5IrqFlagClr(alt_u8 ucIrqFlag);
void vDctrCh6IrqFlagClr(alt_u8 ucIrqFlag);
void vDctrCh7IrqFlagClr(alt_u8 ucIrqFlag);
void vDctrCh8IrqFlagClr(alt_u8 ucIrqFlag);

void vDctrCh1IrqFlag(bool *pbIrqFlags);
void vDctrCh2IrqFlag(bool *pbIrqFlags);
void vDctrCh3IrqFlag(bool *pbIrqFlags);
void vDctrCh4IrqFlag(bool *pbIrqFlags);
void vDctrCh5IrqFlag(bool *pbIrqFlags);
void vDctrCh6IrqFlag(bool *pbIrqFlags);
void vDctrCh7IrqFlag(bool *pbIrqFlags);
void vDctrCh8IrqFlag(bool *pbIrqFlags);

bool vDctrInitIrq(alt_u8 ucCommCh);

// Set functions -> set data from channel variable to hardware
// Get functions -> get data from hardware to channel variable

bool bDctrSetIrqControl(TDctrChannel *pxDctrCh);
bool bDctrGetIrqControl(TDctrChannel *pxDctrCh);
bool bDctrGetIrqFlags(TDctrChannel *pxDctrCh);

bool bDctrSetControllerConfig(TDctrChannel *pxDctrCh);
bool bDctrGetControllerConfig(TDctrChannel *pxDctrCh);

bool bDctrInitCh(TDctrChannel *pxDctrCh, alt_u8 ucCommCh);
