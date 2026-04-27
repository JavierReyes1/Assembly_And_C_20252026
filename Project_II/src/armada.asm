section .data
	CRLF:						db 0x0D, 0x0A, 0
	WELCOME_MSG:		db '************************************************************', 0x0D, 0x0A
									db '		SPAIN vs ENGLAND - NAVAL BATTLE 1588', 0x0D, 0x0A
									db '	The Spanish Armada faces the English Fleet', 0x0D, 0x0A
									db '************************************************************', 0x0D, 0x0A, 0

	SHIP1_ROW:			db 0
	SHIP1_COL:			db 0
	
	SHIP2_ROW:			db 2
	SHIP2_COL:			db 3
	
	SHIP3_ROW:			db 4
	SHIP3_COL:			db 1

	SHIPS_LEFT:			db 3
	SHOTS_LEFT:			db 10
	SHOT_VALID:			db 1
