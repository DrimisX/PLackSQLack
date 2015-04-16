/* Created By Jasmyn Newton */

DECLARE
	
	-- CONSTANTS
	PLAYER_COUNT INT := 3;
	VERBOSE_MESSAGE BOOLEAN := true;
	P1_ACCOUNT_NAME := 'Ashika123';
	P2_ACCOUNT_NAME := 'Jasmyn234';
	P3_ACCOUNT_NAME := 'Dylan365';

BEGIN

	-- Pass v_player count to Init_Proc(), Update gameID, update v_verbose_messaging and v_player_count
	game_pkg.Init_Proc(PLAYER_COUNT, VERBOSE_MESSAGE);

	if resumegame = false-- Decide Players, Update v_player_count
		player_pkg.AddPlayers();
		deck_pkg.ShuffleDeck();
		deck_pkg.DealCards();

	-- Evaluates current turn, loops through players and dealer
	WHILE v_next_player
		LOOP
			deck_pkg.Turns();
		END LOOP

	-- Output Winner to screen with Stats
	output_pkg.OutputResults();

EXCEPTION
END;
