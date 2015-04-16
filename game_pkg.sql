CREATE OR REPLACE PACKAGE game_pkg AS

	v_game_id Game.gameID%TYPE;

	v_player_count INT;
	v_verbose_messaging BOOLEAN;

	v_p1_account_name Game.accountName%TYPE;
	v_p2_account_name Game.accountName%TYPE;
	v_p3_account_name Game.accountName%TYPE;
	v_p4_account_name Game.accountName%TYPE;

END game_pkg;

CREATE OR REPLACE PACKAGE BODY game_pkg AS
	
	-- 
	PROCEDURE init_proc (p_player_count INT DEFAULT 1, p_verbose_messaging BOOLEAN DEFAULT false) IS
			v_game_date Game.gameDate%TYPE;

		BEGIN
			v_game_date := SYSDATE;
			INSERT INTO Game(date) VALUES (v_game_date);
			
			SELECT gameID INTO v_game_id FROM Game WHERE gameDate = v_game_date;

			v_player_count := p_player_count;

		EXCEPTION
			WHEN ...
	END;

	-- Procedure to Call when an Error Occurs
	-- Logs Error in GameErrorLog Table
	PROCEDURE log_error (p_err_code GameErrorLog.errorCode%TYPE, p_err_msg GameErrorLog.errorMessage%TYPE) IS					
		BEGIN
			INSERT INTO GameErrorLog(errorCode, errorMessage, gameID)
				VALUES (p_err_code, p_err_msg, v_game_id);

		EXCEPTION
			WHEN ...
	END;


	-- Adds Players to PlayerGame Table based on the Player Count
	PROCEDURE add_players (p_p1_account_name Game.accountName%TYPE, p_p2_account_name Game.accountName%TYPE DEFAULT NULL, p_p3_account_name Game.accountName%TYPE DEFAULT NULL, p_p4_account_name Game.accountName%TYPE DEFAULT NULL) IS
		
		v_current_insert VARCHAR2;

		BEGIN

		    FOR i .. v_player_count
		    LOOP
		        CASE i
		            WHEN 1 THEN v_current_user := p_p1_account_name
		            WHEN 2 THEN v_current_user := p_p2_account_name
		            WHEN 3 THEN v_current_user := p_p3_account_name
		            WHEN 4 THEN v_current_user := p_p4_account_name
		        END
		        INSERT INTO PlayerGame (gameID, accountName, playerPos)
		            VALUES (v_game_id, v_current_insert, i)
		    END LOOP;

		EXCEPTION
			WHEN ...
		END;
END game_pkg;

