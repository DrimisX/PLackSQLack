/* Created By Jasmyn Newton */

DECLARE
	
	-- CONSTANTS
	PLAYER_COUNT INT := 3;
	VERBOSE_MESSAGE BOOLEAN := true;
	P1_ACCOUNT_NAME := 'Ashika123';
	P2_ACCOUNT_NAME := 'Jasmyn234';
	P3_ACCOUNT_NAME := 'Dylan365';

BEGIN

	-- Create Game, Set Up Player Count and Whether or not Messaging is Verbose
	game_pkg.init_proc(PLAYER_COUNT, VERBOSE_MESSAGE);

	-- Add Players to Game
	game_pkg.add_players(P1_ACCOUNT_NAME, P2_ACCOUNT_NAME, P3_ACCOUNT_NAME)

	-- Create Shuffled Deck
	deck_pkg.shuffle_deck();

	-- Output Game Results
	DBMS_OUTPUT.PUT_LINE(deck_pkg.deal_game);

EXCEPTION
END;
