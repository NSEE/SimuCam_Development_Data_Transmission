enum SdmaChBufferId {
	eSdmaCh1Buffer = 0,
	eSdmaCh2Buffer = 1,
	eSdmaCh3Buffer = 2,
	eSdmaCh4Buffer = 3,
	eSdmaCh5Buffer = 4,
	eSdmaCh6Buffer = 5,
	eSdmaCh7Buffer = 6,
	eSdmaCh8Buffer = 7
} ESdmaChBufferId;

bool bSdmaInitM1Dma(void);
bool bSdmaInitM2Dma(void);
bool bSdmaDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBlocks, alt_u8 ucChBufferId);
bool bSdmaDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBlocks, alt_u8 ucChBufferId);
