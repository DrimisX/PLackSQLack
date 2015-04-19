/* Created By Ashika Shallow */

-- Package Specification
CREATE OR REPLACE PACKAGE player_pkg IS

  -- Error codes and messages
  V_CODE_EXISTS NUMBER := -20001;
  V_MESSAGE_EXISTS VARCHAR(40) := 'That user already exists';
  V_CODE_NOT_EXISTS NUMBER := -20002;
  V_MESSAGE_NOT_EXISTS VARCHAR(40) := 'That user does not exists';
  
  -- A record to hold the player's first name, last name and email
  TYPE player_type IS RECORD(f_name players.first_name%TYPE, 
                             l_name players.last_name%TYPE,
                             pl_email players.email%TYPE); 
  -- Create player procedure
  PROCEDURE create_player(
    p_account players.account_name%TYPE, p_password players.password%TYPE,
    p_fname players.first_name%TYPE, p_lname players.last_name%TYPE,
    p_email players.email%TYPE);
	
  -- Get player information function
  FUNCTION get_player(p_account players.account_name%TYPE) RETURN player_type;
  
  -- Update player information procedure
  PROCEDURE update_player(p_account players.account_name%TYPE, p_player player_type);
    
  -- Change password procedure
  PROCEDURE change_password(p_account players.account_name%TYPE, p_password players.password%TYPE);
  
  -- Remove player information procedure
  PROCEDURE delete_player(p_account players.account_name%TYPE);
  
END player_pkg;


-- Package Body

CREATE OR REPLACE PACKAGE BODY player_pkg IS
  -- Create player procedure
  PROCEDURE create_player(
      p_account players.account_name%TYPE, p_password players.password%TYPE,
      p_fname players.first_name%TYPE, p_lname players.last_name%TYPE,
      p_email players.email%TYPE) IS    
  BEGIN   
    INSERT INTO players VALUES
      (p_account, p_password, p_fname, p_lname, p_email);
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(V_CODE_EXISTS, V_MESSAGE_EXISTS);
      game_pkg.log_error(V_CODE_EXISTS, V_MESSAGE_EXISTS);
  END create_player;
  
  -- Get player function
  FUNCTION get_player(p_account players.account_name%TYPE) 
    RETURN player_type IS
	player_rec player_type;
  BEGIN
    SELECT first_name, last_name, email INTO player_rec.f_name, player_rec.l_name,
	  player_rec.pl_email FROM players WHERE account_name = p_account;
	RETURN player_rec;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);
      game_pkg.log_error(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);    
  END get_player;
  
  -- update_player procedure
  PROCEDURE update_player(p_account players.account_name%TYPE, p_player player_type) 
  IS
    v_id players.account_name%TYPE;
  BEGIN
    -- Determine if player exists
    SELECT account_name INTO v_id FROM
      players WHERE account_name = p_account;
    -- If player exists
	UPDATE players SET first_name = p_players.f_name, last_name = p_players.l_name,
	  email = p_players.pl_email WHERE account_name = p_account;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);
      game_pkg.log_error(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);
  END update_player;
  
  -- Change password procedure
  PROCEDURE change_password(p_account players.account_name%TYPE, 
                            p_password players.password%TYPE) 
  IS
  p_first players.first_name%TYPE;
  BEGIN
    -- Determine if player exists
    SELECT first_name INTO p_first FROM
      players WHERE account_name = p_account;
    -- If player exists
    UPDATE players SET password = p_password
       WHERE account_name = p_account;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(V_CODE_NOT_EXISTS,V_MESSAGE_NOT_EXISTS );
      game_pkg.log_error(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);
  END change_password;
  
  -- Delete Player procedure
  PROCEDURE delete_player(p_account players.account_name%TYPE) IS
    p_first players.first_name%TYPE;
  BEGIN
    -- Determine if player exists
    SELECT first_name INTO p_first FROM
      players WHERE account_name = p_account;
    -- If player exists
    DELETE FROM players WHERE account_name = p_account;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);
      game_pkg.log_error(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);
  END delete_player;
  
END player_pkg;
