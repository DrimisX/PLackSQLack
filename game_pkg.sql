/* Created By Jasmyn Newton */

	CREATE OR REPLACE PACKAGE game_pkg AS
	    v_game_date := Game.gameDate%TYPE;
	    [constant_declaration ...]
	    [exception_declaration ...] 
	    [cursor_specification ...]
		
		PROCEDURE init_proc (p_player_count INT DEFAULT 1, p_verbose_messaging BOOLEAN DEFAULT false) IS
				variable declarations;
				constant declarations;					
			BEGIN
				v_game_date = SYSDATE
				INSERT INTO Game(date) VALUES (, );


			EXCEPTION
				WHEN ...
			END

		-- Procedure to Call when an Error Occurs
		-- Logs Error in GameErrorLog Table
		PROCEDURE log_error (p_err_code GameErrorLog.errorCode%TYPE, p_err_msg GameErrorLog.errorMessage%TYPE) IS
				variable declarations;
				constant declarations;					
			BEGIN
				INSERT INTO GameErrorLog(errorCode, errorMessage, gameID) VALUES (p_err_code, p_err_msg, v_gameID);

			EXCEPTION
				WHEN ...
		END
	END game_pkg;
