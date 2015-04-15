-- Package specifications

CREATE OR REPLACE PACKAGE player_package IS
  TYPE player_type IS RECORD(f_name player.firstName%TYPE, 
                         l_name player.lastName%TYPE,
                         pl_email player.email%TYPE);
  -- Function does not return player password  
  FUNCTION get_player(p_account player.accountName%TYPE) RETURN player_type;
  PROCEDURE create_player(
    p_account player.accountName%TYPE, p_password player.password%TYPE,
    p_fName player.firstName%TYPE, p_lName player.lastName%TYPE,
    p_email player.email%TYPE);
  PROCEDURE update_player(p_account player.accountName%TYPE, p_fName player.firstName%TYPE,
                          p_lName player.lastName%TYPE, p_email player.email%TYPE);
  PROCEDURE remove_player(p_account player.accountName%TYPE);
  PROCEDURE change_password(p_account player.accountName%TYPE);
END player_package;

-- Package body
