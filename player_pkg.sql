-- Package specifications

CREATE OR REPLACE PACKAGE player_package IS
  -- Create player procedure
  PROCEDURE create_player(
    p_account player.accountName%TYPE, p_password player.password%TYPE,
    p_fName player.firstName%TYPE, p_lName player.lastName%TYPE,
    p_email player.email%TYPE);
    
  -- Change password procedure
  PROCEDURE change_password(p_account player.accountName%TYPE, p_password player.password%TYPE);
END player_package;

-- Package body
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
        RAISE_APPLICATION_ERROR(-20001, 'That user already exists');
  END create_player;
  
  -- Change password procedure
  PROCEDURE change_password(p_account player.accountName%TYPE, 
                            p_password player.password%TYPE) 
  IS
  p_first player.accountName%TYPE;
  BEGIN
    SELECT firstName INTO p_first FROM
      Player WHERE accountName = p_account;
    UPDATE Player SET password = p_password
       WHERE accountName = p_account;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'That user does not exists');
  END change_password;
END player_package;
