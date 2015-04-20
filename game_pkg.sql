/* Created By Jasmyn Newton */

-- Package Body
CREATE OR REPLACE PACKAGE BODY game_pkg AS

  -- Create Game, Set v_player_count and v_verbose_messaging according to parameter
  PROCEDURE init_proc (p_player_count INT DEFAULT 1, p_verbose_messaging BOOLEAN DEFAULT false) IS
		
  v_game_date games.game_date%TYPE;

  BEGIN		
    -- Set v_game_date to Current Date/Time
	v_game_date := SYSDATE;

	-- Create new game in Game Table
	INSERT INTO games (game_date) VALUES (v_game_date);
		
	-- Set Variables
	SELECT game_id INTO v_game_id FROM games WHERE game_date = v_game_date;
	v_player_count := p_player_count;

  EXCEPTION
	v_err_text := "ERROR IN PROCEDURE init_proc - " || SQLERRM;
	DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQLCODE)|| v_err_text);
  	log_error(SQLCODE, v_err_text);
	
  END init_proc;

  -- Procedure to Call when an Error Occurs
  -- Log Error in GameErrorLog Table
  PROCEDURE log_error (p_err_code error_logs.err_code%TYPE, p_err_msg error_logs.err_msg%TYPE) IS
  v_err_game games.game_id%TYPE;				
  BEGIN
  IF v_game_id IS NOT NULL THEN
    v_err_game := v_game_id;
  ELSE
    v_err_game := 0;
  END IF;
	-- Insert information into GameErrorLog Table
	INSERT INTO error_logs (err_code, error_msg, game_id)
	  VALUES (p_err_code, p_err_msg, v_err_game);

  EXCEPTION
	  -- Miscellaneous exception handler
	  WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR(-29999,'Error Logging Failed. Error not logged.');
  END log_error;

  -- Add Players to PlayerGame Table based on the Player Count
  PROCEDURE add_players (p_p1_account_name games.account_name%TYPE, 
                       p_p2_account_name games.account_name%TYPE DEFAULT NULL, 
					   p_p3_account_name games.account_name%TYPE DEFAULT NULL, 
					   p_p4_account_name games.account_name%TYPE DEFAULT NULL) IS
	
    v_current_user VARCHAR2;
  BEGIN
	-- Iterate through parameters according to # Players
	FOR i .. v_player_count LOOP
	  CASE i
	    WHEN 1 THEN v_current_user := p_p1_account_name
	    WHEN 2 THEN v_current_user := p_p2_account_name
	    WHEN 3 THEN v_current_user := p_p3_account_name
	    WHEN 4 THEN v_current_user := p_p4_account_name
	  END CASE;
	  -- Insert Player into PlayerGame
	  INSERT INTO player_games (game_id, account_name, player_pos)
	    VALUES (v_game_id, v_current_user, i)
	END LOOP;

  EXCEPTION
	-- Miscellaneous exception handler
	WHEN OTHERS THEN
	  v_err_text := "ERROR IN PROCEDURE add_players - " || SQLERRM;
	  DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQLCODE)|| v_err_text);
  	  log_error(SQLCODE, v_err_text);
  END add_players;

  -- FUNCTION get_game_id returns the current game_id
  FUNCTION get_game_id
    RETURNS games.game_id%TYPE
    IS

    v_current_game_id games.game_id%TYPE;

    BEGIN

    IF v_game_id IS NOT NULL THEN
      v_current_game_id := v_game_id;
    ELSE
      v_current_game_id := 0;
    END IF;

    RETURN v_current_game_id;

    EXCEPTION
      -- Miscellaneous exception handler
      WHEN OTHERS THEN
        v_err_text := "ERROR IN FUNCTION get_game_id - " || SQLERRM;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQLCODE)|| v_err_text);
        log_error(SQLCODE, v_err_text);
  END get_game_id;

END game_pkg;
