CREATE OR REPLACE PACKAGE BODY deck_pkg AS

  PROCEDURE shuffle_deck IS   
  BEGIN
    DBMS_OUT.PUT_LINE('Deck shuffled');
  END shuffle_deck;
  
  FUNCTION get_card_value ( p_face_value VARCHAR2, p_hand_value NUMBER )
    RETURN number 			  
    IS
    v_value NUMBER;	
  BEGIN
    v_value := 0;
    return v_value;
  END get_card_value;

  PROCEDURE deal_cards IS
  BEGIN
    DBMS_OUT.PUT_LINE('First 2 Cards dealt to each player');
  END deal_cards;
  		  	
  PROCEDURE deal_card( p_player_num NUMBER ) IS
     v_test_num NUMBER;
  BEGIN
     v_test_num:=p_player_num;
  END deal_card;
    
  FUNCTION deal_game( p_deck_pos NUMBER, p_num_players NUMBER )
  	RETURN VARCHAR2 IS
       v_return_var VARCHAR2(8);
  BEGIN
       v_return_var := '';
       return v_return_var;
  END deal_game;
  
  FUNCTION player_decision (p_player_num NUMBER )
  	RETURN boolean IS
  	v_return_bool boolean;
  BEGIN	
        v_return_bool := false;
        return v_return_bool;
  END player_decision;
  
  FUNCTION get_player_name ( p_player_pos NUMBER ) RETURN VARCHAR2 IS
  	v_return_name VARCHAR2(25);
  BEGIN
       v_return_name := '';
       return v_return_name;
  END get_player_name;

END deck_pkg;
