/* Created By Ashika Shallow */

-- PACKAGE SPECIFICATION

CREATE OR REPLACE PACKAGE player_package IS

  -- Error codes and messages
  V_CODE_EXISTS NUMBER := -20001;
  V_MESSAGE_EXISTS VARCHAR(40) := 'That user already exists';
  V_CODE_NOT_EXISTS NUMBER := -20002;
  V_MESSAGE_NOT_EXISTS VARCHAR(40) := 'That user does not exists';
  
  -- A record to hold the player's first name, last name and email
  TYPE player_type IS RECORD(f_name player.firstName%TYPE, 
                             l_name player.lastName%TYPE,
                             pl_email player.email%TYPE); 
  -- Create player procedure
  PROCEDURE create_player(
    p_account player.accountName%TYPE, p_password player.password%TYPE,
    p_fName player.firstName%TYPE, p_lName player.lastName%TYPE,
    p_email player.email%TYPE);
	
  -- Get player information function
  FUNCTION get_player(p_account player.accountName%TYPE) RETURN player_type;
  
  -- Update player information procedure
  PROCEDURE update_player(p_account player.accountName%TYPE, p_player player_type);
    
  -- Change password procedure
  PROCEDURE change_password(p_account player.accountName%TYPE, p_password player.password%TYPE);
  
  -- Remove player information procedure
  PROCEDURE delete_player(p_account player.accountName%TYPE);
  
END player_package;


-- PACKAGE BODY

CREATE OR REPLACE PACKAGE BODY player_package IS
  -- Create player procedure
  PROCEDURE create_player(
      p_account player.accountName%TYPE, p_password player.password%TYPE,
      p_fName player.firstName%TYPE, p_lName player.lastName%TYPE,
      p_email player.email%TYPE) IS    
  BEGIN   
    INSERT INTO Player VALUES
      (p_account, p_password, p_fName, p_lName, p_email);
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(V_CODE_EXISTS, V_MESSAGE_EXISTS);
      game_pkg.log_error(V_CODE_EXISTS, V_MESSAGE_EXISTS);
  END create_player;
  
  -- Get player function
  FUNCTION get_player(p_account player.accountName%TYPE) 
    RETURN player_type IS
	player_rec player_type;
  BEGIN
    SELECT firstName, lastName, email INTO player_rec.f_name, player_rec.l_name,
	  player_rec.pl_email FROM Player WHERE accountName = p_account;
	RETURN player_rec;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);
      game_pkg.log_error(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);    
  END get_player;
  
  -- update_player procedure
  PROCEDURE update_player(p_account player.accountName%TYPE, p_player player_type) 
  IS
    v_id player.accountName%TYPE;
  BEGIN
    -- Determine if player exists
    SELECT accountName INTO v_id FROM
      Player WHERE accountName = p_account;
    -- If player exists
	UPDATE Player SET firstName = p_player.f_name, lastName = p_player.l_name,
	  email = p_player.pl_email WHERE accountName = p_account;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);
      game_pkg.log_error(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);
  END update_player;
  
  -- Change password procedure
  PROCEDURE change_password(p_account player.accountName%TYPE, 
                            p_password player.password%TYPE) 
  IS
  p_first player.firstName%TYPE;
  BEGIN
    -- Determine if player exists
    SELECT firstName INTO p_first FROM
      Player WHERE accountName = p_account;
    -- If player exists
    UPDATE Player SET password = p_password
       WHERE accountName = p_account;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(V_CODE_NOT_EXISTS,V_MESSAGE_NOT_EXISTS );
      game_pkg.log_error(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);
  END change_password;
  
  -- Delete Player procedure
  PROCEDURE delete_player(p_account player.accountName%TYPE) IS
    p_first player.firstName%TYPE;
  BEGIN
    -- Determine if player exists
    SELECT firstName INTO p_first FROM
      Player WHERE accountName = p_account;
    -- If player exists
    DELETE FROM Player WHERE accountName = p_account;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);
      game_pkg.log_error(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);
  END delete_player;
  
END player_package;
