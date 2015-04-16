-- Package Specification
CREATE OR REPLACE PACKAGE game_pkg AS

  v_game_id Game.gameID%TYPE;
  
  v_player_count INT;
  v_verbose_messaging BOOLEAN;
  
  v_p1_account_name Game.accountName%TYPE;
  v_p2_account_name Game.accountName%TYPE;
  v_p3_account_name Game.accountName%TYPE;
  v_p4_account_name Game.accountName%TYPE;

  -- PROCEDURES --
  PROCEDURE init_proc (p_player_count INT DEFAULT 1, p_verbose_messaging BOOLEAN DEFAULT false);
  PROCEDURE log_error (p_err_code GameErrorLog.errorCode%TYPE, p_err_msg GameErrorLog.errorMessage%TYPE);
  PROCEDURE add_players (
  	p_p1_account_name Game.accountName%TYPE,
  	p_p2_account_name Game.accountName%TYPE DEFAULT NULL,
  	p_p3_account_name Game.accountName%TYPE DEFAULT NULL,
  	p_p4_account_name Game.accountName%TYPE DEFAULT NULL
  	);

END game_pkg;

-- Package Body
CREATE OR REPLACE PACKAGE BODY game_pkg AS

  -- Create Game, Set v_player_count and v_verbose_messaging according to parameter
  PROCEDURE init_proc (p_player_count INT DEFAULT 1, p_verbose_messaging BOOLEAN DEFAULT false) IS
		
  v_game_date Game.gameDate%TYPE;

  BEGIN		
    -- Set v_game_date to Current Date/Time
	v_game_date := SYSDATE;

	-- Create new game in Game Table
	INSERT INTO Game(date) VALUES (v_game_date);
		
	-- Set Variables
	SELECT gameID INTO v_game_id FROM Game WHERE gameDate;
	v_player_count := p_player_count;

  EXCEPTION
	err_text := "ERROR IN PROCEDURE init_proc - " || SQLERRM;
	DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQLCODE)|| errText);
  	log_error(SQLCODE, errText);
	
  END init_proc;

  -- Procedure to Call when an Error Occurs
  -- Log Error in GameErrorLog Table
  PROCEDURE log_error (p_err_code GameErrorLog.errorCode%TYPE, p_err_msg GameErrorLog.errorMessage%TYPE) IS					
  BEGIN
	-- Insert information into GameErrorLog Table
	INSERT INTO GameErrorLog(errorCode, errorMessage, gameID)
	  VALUES (p_err_code, p_err_msg, v_game_id);

  EXCEPTION
	  -- Miscellaneous exception handler
	  WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR(-29999,'Error Logging Failed. Error not logged.');
  END log_error;

  -- Add Players to PlayerGame Table based on the Player Count
  PROCEDURE add_players (p_p1_account_name Game.accountName%TYPE, 
                       p_p2_account_name Game.accountName%TYPE DEFAULT NULL, 
					   p_p3_account_name Game.accountName%TYPE DEFAULT NULL, 
					   p_p4_account_name Game.accountName%TYPE DEFAULT NULL) IS
	
    v_current_insert VARCHAR2;
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
	  INSERT INTO PlayerGame (gameID, accountName, playerPos)
	    VALUES (v_game_id, v_current_insert, i)
	END LOOP;

  EXCEPTION
	-- Miscellaneous exception handler
	WHEN OTHERS THEN
	  err_text := "ERROR IN PROCEDURE add_players - " || SQLERRM;
	  DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQLCODE)|| errText);
  	  log_error(SQLCODE, errText);
  END add_players;
END game_pkg;
