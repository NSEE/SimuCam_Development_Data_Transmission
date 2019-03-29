enum IdmaChBufferId {
	eIdmaCh1Buffer = 0,
	eIdmaCh2Buffer = 1,
	eIdmaCh3Buffer = 2,
	eIdmaCh4Buffer = 3,
	eIdmaCh5Buffer = 4,
	eIdmaCh6Buffer = 5,
	eIdmaCh7Buffer = 6,
	eIdmaCh8Buffer = 7
} EIdmaChBufferId;

bool bIdmaInitM1Dma(void);
bool bIdmaInitM2Dma(void);
bool bIdmaDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBlocks, alt_u8 ucChBufferId);
bool bIdmaDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBlocks, alt_u8 ucChBufferId);
