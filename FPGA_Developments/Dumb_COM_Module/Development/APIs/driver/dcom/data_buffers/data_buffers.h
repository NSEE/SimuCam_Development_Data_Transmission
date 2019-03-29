typedef struct DatbBufferStatus {
	bool bDataBufferFull;
	bool bDataBufferEmpty;
	uint16_t uiDataBufferUsed;
	uint16_t uiDataBufferFree;
} TDatbBufferStatus;

typedef struct DatbChannel {
	alt_u32 *puliDatbChAddr;
	TDatbBufferStatus xBufferStatus;
} TDatbChannel;

bool vDatbInitIrq(alt_u8 ucCommCh);

// Set functions -> set data from channel variable to hardware
// Get functions -> get data from hardware to channel variable

bool bDatbGetBuffersStatus(TDatbChannel *pxDatbCh);

bool bDatbInitCh(TDatbChannel *pxDatbCh, alt_u8 ucCommCh);
