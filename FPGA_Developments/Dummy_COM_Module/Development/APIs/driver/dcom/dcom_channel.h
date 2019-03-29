typedef struct DcomChannel {
	alt_u32 *puliCommChAddr;
	TDatbChannel xDataBuffer;
	TDschChannel xDataScheduler;
	TDctrChannel xDataController;
	TSpwcChannel xSpacewire;
} TDcomChannel;

bool bDcomSetGlobalIrqEn(bool bGlobalIrqEnable, alt_u8 ucDcomCh);

bool bDcomInitCh(TCommChannel *pxDcomCh, alt_u8 ucDcomCh);
