/* Created By Jasmyn Newton */

DECLARE
	
	-- CONSTANTS
	PLAYER_COUNT INT := 3;
	VERBOSE_MESSAGE BOOLEAN := true;
	P1_ACCOUNT_NAME := 'Ashika123';
	P2_ACCOUNT_NAME := 'Jasmyn234';
	P3_ACCOUNT_NAME := 'Dylan365';

	-- Global Variables
	gameID := '';

	v_player_count INT;
	v_verbose_messaging BOOLEAN;

	v_p1_account_name := '';
	v_p2_account_name := '';
	v_p3_account_name := '';
	v_p4_account_name := '';

	v_current_player INT;
	v_next_player BOOLEAN;

	v_dealer_hand VARCHAR := '';
	v_dealer_hand_val INT := 0;

	v_p1_account_name VARCHAR := '';

	v_p1_hand VARCHAR := '';
	v_p2_hand VARCHAR := '';
	v_p3_hand VARCHAR := '';
	v_p4_hand VARCHAR := '';

	v_p1_hand_val INT := 0;
	v_p2_hand_val INT := 0;
	v_p3_hand_val INT := 0;
	v_p4_hand_val INT := 0;



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
