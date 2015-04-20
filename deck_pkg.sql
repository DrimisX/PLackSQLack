
CREATE OR REPLACE PACKAGE deck_pkg AS  

  -- CONSTANTS --
  ERR_CODE_SHUFFLE NUMBER := -20300;
  ERR_MSG_SHUFFLE VARCHAR(250) := 'Error in PROCEDURE shuffle_deck';

  -- VARIABLES --
  v_hands_to_deal NUMBER;       -- Total number of players including dealer
  v_current_player NUMBER;    -- Current player being dealt to
  v_next_player BOOLEAN;  -- Is there is another player this round

  -- Strings representing each player's cards --
  v_p1_hand VARCHAR2(256);
  v_p2_hand VARCHAR2(256);
  v_p3_hand VARCHAR2(256);
  v_p4_hand VARCHAR2(256);
  v_dealer_hand VARCHAR2(256);

  -- Numbers representing each player's hand values --
  v_p1_hand_val NUMBER;
  v_p2_hand_val NUMBER;
  v_p3_hand_val NUMBER;
  v_p4_hand_val NUMBER;
  v_dealer_hand_val NUMBER;
  
  v_deck_pos NUMBER;            -- Current top card of the shuffled deck
  v_card_face VARCHAR2(4);      -- Holds a card's face value
  v_card_suit VARCHAR2(8);      -- Holds a card's suit
  
  v_deal_result VARCHAR2(256);  -- Holds a string output of a card dealt
  v_round_result VARCHAR2(16384); -- Holds a string output of the game's entirety
  
  v_winning_score NUMBER;       -- Holds the high score for the round
  v_winning_player NUMBER;      -- Holds the winning player position
  v_winning_name VARCHAR2(30);  -- Holds the winning player's name
  
  v_err_text error_logs.err_msg%TYPE;     -- Text for error log output
  v_err_code NUMBER;            -- Number for error log output

 -- PROCEDURES --
  PROCEDURE shuffle_deck;
  
  PROCEDURE deal_cards;
  
  PROCEDURE deal_card ( p_player_num NUMBER );
  
  -- FUNCTIONS --
  FUNCTION get_card_value ( p_face_value VARCHAR2, p_hand_value NUMBER ) 
  RETURN NUMBER;
      
  FUNCTION get_player_name(p_player_pos NUMBER) 
  RETURN VARCHAR2;
        
  FUNCTION deal_game 
  RETURN VARCHAR2;
      
  FUNCTION player_decision ( p_player_num NUMBER ) 
  RETURN BOOLEAN;

END deck_pkg;


CREATE OR REPLACE PACKAGE BODY deck_pkg AS

  -- PROCEDURE shuffle_deck clears the existing shuffled_decks table
  --  reads all rows from the Deck table (ordering by random), 
  --  and inserts them into the empty shuffled_decks.
  PROCEDURE shuffle_deck IS

  BEGIN
    DELETE FROM shuffled_decks;                       -- Clears the shuffled_decks table
    INSERT INTO shuffled_decks (card_face, card_suit) -- Inserts into shuffled_deckstable
      SELECT card_face, card_suit FROM decks          -- All rows of both columns
      ORDER BY dbms_random.value;                     -- Randomizes order of SELECT rows
    v_deck_pos := 1;                                  -- Sets top card of deck as next
  EXCEPTION
    -- Miscellaneous exception handler
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(ERR_CODE_SHUFFLE,ERR_MSG_SHUFFLE);
      game_pkg.log_error(ERR_CODE_SHUFFLE, ERR_MSG_SHUFFLE);

  END shuffle_deck;



  -- FUNCTION player_decision accepts a player number, and makes a decision
  -- whether to hit or stand, based on the score of that player
  FUNCTION player_decision 
    (p_player_num NUMBER )
    RETURN boolean 
    IS
    
    v_loop_value NUMBER;

  BEGIN 
    CASE
      WHEN p_player_num=1 THEN 
      v_loop_value := v_p1_hand_val;
    WHEN p_player_num=2 AND p_player_num < v_hands_to_deal THEN 
      v_loop_value := v_p2_hand_val;
      WHEN p_player_num=3 AND p_player_num < v_hands_to_deal THEN 
        v_loop_value := v_p3_hand_val;
      WHEN p_player_num=4 AND p_player_num < v_hands_to_deal THEN 
        v_loop_value := v_p4_hand_val;
      ELSE 
        v_loop_value := v_dealer_hand_val;
    END CASE;
    
    RETURN v_loop_value < 17;
    
  EXCEPTION
  -- Miscellaneous exception handler
    WHEN OTHERS THEN
    v_err_code := SQLCODE;
    v_err_text := ': ERROR IN FUNCTION player_decision - ' || SQLERRM;
    RAISE_APPLICATION_ERROR(v_err_code, v_err_text);
    game_pkg.log_error(v_err_code, v_err_text);
      
  END player_decision;



  -- FUNCTION get_player_name accepts a player position, and returns
  -- the players account name
  FUNCTION get_player_name ( p_player_pos NUMBER )
    RETURN VARCHAR2 IS
    
    v_return_name VARCHAR2(25);
    current_game games.game_id%TYPE;
  BEGIN
    current_game := game_pkg.get_game_id;
    IF p_player_pos = 5 THEN
      v_return_name := 'Dealer';
    ELSE
      SELECT account_name INTO v_return_name
      FROM player_games
      WHERE game_id = current_game
        AND player_pos = p_player_pos;
    END IF;
    
    RETURN v_return_name;
  EXCEPTION
    -- Miscellaneous exception handler
    WHEN OTHERS THEN
      v_err_code := SQLCODE;
    v_err_text := ': ERROR IN FUNCTION get_player_name - ' || SQLERRM;
      RAISE_APPLICATION_ERROR(v_err_code, v_err_text);
      game_pkg.log_error(v_err_code, v_err_text);
  END get_player_name;



  -- FUNCTION get_card_value returns the numerical value of a card,
  --  based on the face value of the card. 
  -- It will return 10 for J, Q, K, and either 1 or 11 for A, 
  --  depending on the total value of the hand it is being added to.
  -- It requires two arguments: 
  --  The first is a VARCHAR2 representing the face value
  --  The second is a NUMBER representing the existing hand value
  FUNCTION get_card_value
    ( p_face_value VARCHAR2,    -- The face value of the card
      p_hand_value NUMBER ) -- The hand value before this card is added
    RETURN number       -- Return type
    IS

    v_value NUMBER;       -- The numerical value to be returned
    v_hand_under_11 boolean;    -- Is the hand under 11
  
  BEGIN
      IF p_hand_value < 11 THEN
        v_hand_under_11 := true;
      ELSE
        v_hand_under_11 := false;
      END IF;
    -- Assign proper value based on face_value
    v_value := 
      CASE p_face_value   -- Face Values:
        WHEN 'J' THEN 10  -- Jack
      WHEN 'Q' THEN 10  -- Queen
        WHEN 'K' THEN 10  -- King
        WHEN 'A' THEN 11  -- Ace
    -- If face_value is not a letter, 
      -- convert from VARCHAR2 to NUMBER
        ELSE
        TO_NUMBER(p_face_value)
      END;
    IF v_hand_under_11 = false AND v_value = 11 THEN
      v_value := 1;
    END IF;
    RETURN v_value;
  
  EXCEPTION
    -- Miscellaneous exception handler
    WHEN OTHERS THEN
      v_err_code := SQLCODE;
      v_err_text := 'ERROR IN FUNCTION get_card_value - ' || SQLERRM;
      RAISE_APPLICATION_ERROR(v_err_code, v_err_text);
      game_pkg.log_error(v_err_code, v_err_text);

  END get_card_value;



  -- PROCEDURE deal_card deals out one card by reading from the shuffled_decks table,
  -- then updates the player's hand, the player's hand value, and the game's output.
  PROCEDURE deal_card
    ( p_player_num NUMBER ) 
    IS
  
    v_loop_value NUMBER;
    v_card_face VARCHAR2(4);
  v_card_suit VARCHAR2(8);
  v_card_val NUMBER;
  BEGIN
    
    CASE
      WHEN p_player_num=1 THEN 
      v_loop_value := v_p1_hand_val;
    WHEN p_player_num=2 AND p_player_num < v_hands_to_deal THEN 
      v_loop_value := v_p2_hand_val;
      WHEN p_player_num=3 AND p_player_num < v_hands_to_deal THEN 
        v_loop_value := v_p3_hand_val;
      WHEN p_player_num=4 AND p_player_num < v_hands_to_deal THEN 
        v_loop_value := v_p4_hand_val;
      ELSE 
        v_loop_value := v_dealer_hand_val;
    END CASE;
      
    SELECT card_face, card_suit 
      INTO v_card_face, v_card_suit
      FROM shuffled_decks
      WHERE position = v_deck_pos;
    v_card_val := get_card_value(v_card_face, v_loop_value);
    
    -- Updates player's hand string and values --
    CASE
      WHEN p_player_num=1 THEN 
      v_p1_hand := v_p1_hand || v_card_face || ' of ' || v_card_suit || ',';
      v_p1_hand_val := v_p1_hand_val + v_card_val;
    WHEN p_player_num=2 THEN 
      v_p2_hand := v_p1_hand || v_card_face || ' of ' || v_card_suit || ',';
      v_p2_hand_val := v_p2_hand_val + v_card_val;
      WHEN p_player_num=3 THEN 
      v_p3_hand := v_p1_hand || v_card_face || ' of ' || v_card_suit || ',';
      v_p3_hand_val := v_p3_hand_val + v_card_val;
      WHEN p_player_num=4 THEN 
        v_p4_hand := v_p1_hand || v_card_face || ' of ' || v_card_suit || ',';
      v_p4_hand_val := v_p4_hand_val + v_card_val;
      ELSE 
        v_dealer_hand := v_dealer_hand || v_card_face || ' of ' || v_card_suit || ',';
      v_dealer_hand_val := v_dealer_hand_val + v_card_val;
    END CASE;
      
    -- Updates game result string with the card dealt --      
    IF p_player_num < v_hands_to_deal THEN
      v_current_player := 'Player ' || p_player_num;
    ELSE
      v_current_player := 'Dealer';
    END IF;

    EXCEPTION
      -- Miscellaneous exception handler
      WHEN OTHERS THEN
        v_err_code := SQLCODE;
        v_err_text := 'ERROR IN FUNCTION deal_card - ' || SQLERRM;
        RAISE_APPLICATION_ERROR(v_err_code, v_err_text);
        game_pkg.log_error(v_err_code, v_err_text);

  END deal_card;



  -- PROCEDURE deal_cards deals out the starting hand values to each player.
  -- It deals one card to each player and the dealer, then a second card to each.
  -- The dealer's up card is recorded and shown to the players.
  PROCEDURE deal_cards IS
    
  BEGIN
      
    v_deal_result := '';
    v_round_result := '';
    FOR i IN 1..2 LOOP
    FOR j IN 1..v_hands_to_deal LOOP      
        deal_card(j);
      v_round_result := v_round_result || v_deal_result;
      END LOOP; 
  END LOOP; 
  EXCEPTION
    -- Miscellaneous exception handler
    WHEN OTHERS THEN
      v_err_code := SQLCODE;
      v_err_text := ': ERROR IN PROCEDURE deal_cards - ' || SQLERRM;
      RAISE_APPLICATION_ERROR(v_err_code, v_err_text);
      game_pkg.log_error(v_err_code, v_err_text);
  END deal_cards;



  -- FUNCTION deal_game deals out the whole round
  -- and returns a string explaining the results.
  FUNCTION deal_game
    RETURN VARCHAR2
    IS

    v_loop_value NUMBER;
    
    BEGIN
    
    v_dealer_hand_val := 0;
    v_p1_hand_val := 0;
    v_p2_hand_val := 0;
    v_p3_hand_val := 0;
    v_p4_hand_val := 0;
  
    v_p1_hand := '';
    v_p2_hand := '';
    v_p3_hand := '';
    v_p4_hand := '';
  
    v_round_result := '';
  
    v_hands_to_deal := game_pkg.v_player_count + 1;
  
    deal_cards();
    
    FOR i IN 1..v_hands_to_deal 
    LOOP
      
      WHILE player_decision(i) 
      LOOP  
        IF i < v_hands_to_deal THEN
          v_current_player := 'Player ' || i;
        ELSE
          v_current_player := 'Dealer';
        END IF;
        v_round_result := v_round_result || v_current_player || ' hits.' || chr(10);
        deal_card(i);
      END LOOP;
      
      v_round_result := v_round_result || v_current_player || ' stands.' || chr(10);
    END LOOP;
    
    FOR i IN 1..v_hands_to_deal 
    LOOP
     
      IF i=1 THEN 
        v_loop_value := v_p1_hand_val;
        UPDATE score_trackers
          SET player_score = v_loop_value
          WHERE player_num = 1;
      ELSIF i=2 AND i < v_hands_to_deal THEN 
        v_loop_value := v_p2_hand_val;
        UPDATE score_trackers
          SET player_score = v_loop_value
          WHERE player_num = 2;
      ELSIF i=3 AND i < v_hands_to_deal THEN 
        v_loop_value := v_p3_hand_val;
        UPDATE score_trackers
          SET player_score = v_loop_value
          WHERE player_num = 3;
      ELSIF i=4 AND i < v_hands_to_deal THEN 
        v_loop_value := v_p4_hand_val;
        UPDATE score_trackers
          SET player_score = v_loop_value
          WHERE player_num = 4;
      ELSE 
        v_loop_value := v_dealer_hand_val;
        UPDATE score_trackers
          SET player_score = v_loop_value
          WHERE player_num = 5;
      END IF;

      IF i < v_hands_to_deal THEN
        v_current_player := 'Player ' || i;
      ELSE
        v_current_player := 'Dealer';
      END IF;
      
      v_round_result := v_round_result || v_current_player || 
        ' has ' || TO_CHAR(v_loop_value) || '.' || chr(10);
      
    END LOOP;
    
    SELECT MAX(player_score)
      INTO v_winning_score
      FROM score_trackers;
    
    SELECT player_num
      INTO v_winning_player
      FROM score_trackers
      WHERE player_score = v_winning_score;
        
    v_round_result := v_round_result || get_player_name(v_winning_player) ||
      ' wins, with ' || v_winning_score || '!';
    
    RETURN v_round_result;
    
    EXCEPTION
    -- Miscellaneous exception handler
    WHEN OTHERS THEN
      v_err_code := SQLCODE;
      v_err_text := ': ERROR IN FUNCTION deal_game - ' || SQLERRM;
      RAISE_APPLICATION_ERROR(v_err_code, v_err_text);
      --game_pkg.log_error(v_err_code, v_err_text);
    
  END deal_game;

END deck_pkg;
