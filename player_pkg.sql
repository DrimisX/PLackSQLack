-- Package specifications

CREATE OR REPLACE PACKAGE player_package IS
  PROCEDURE create_player(
    p_account player.accountName%TYPE, p_password player.password%TYPE,
    p_fName player.firstName%TYPE, p_lName player.lastName%TYPE,
    p_email player.email%TYPE);
END player_package;

-- Package body
CREATE OR REPLACE PACKAGE BODY player_package IS
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
END player_package;
