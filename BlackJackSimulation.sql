/* Created By Jasmyn Newton */

DECLARE
	err_text VARCHAR2(255);

	-- CONSTANTS
	PLAYER_COUNT INT := 3;
	VERBOSE_MESSAGE BOOLEAN := true;
	P1_ACCOUNT_NAME Player.accountName%TYPE := 'Ashika123';
	P2_ACCOUNT_NAME Player.accountName%TYPE := 'Jasmyn234';
	P3_ACCOUNT_NAME Player.accountName%TYPE := 'Dylan365';

BEGIN

	-- Create Game, Set Up Player Count and Whether or not Messaging is Verbose
	game_pkg.init_proc(PLAYER_COUNT, VERBOSE_MESSAGE);

	-- Add Players to Game
	game_pkg.add_players(P1_ACCOUNT_NAME, P2_ACCOUNT_NAME, P3_ACCOUNT_NAME);

	-- Create Shuffled Deck
	deck_pkg.shuffle_deck();

	-- Output Game Results
	DBMS_OUTPUT.PUT_LINE(deck_pkg.deal_game());

EXCEPTION

	-- Miscellaneous exception handler
	WHEN OTHERS THEN
		err_text := 'ERROR IN ANONYMOUS BLOCK - ' || SQLERRM;
		DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQLCODE)|| err_text);
		game_pkg.log_error(SQLCODE, err_text);

END;
