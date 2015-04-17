CREATE OR REPLACE PACKAGE BODY deck_pkg IS
  
  -- PROCEDURE shuffle_deck clears the existing ShuffledDeck table
  --  reads all rows from the Deck table (ordering by random), 
  --  and inserts them NUMBERo the empty ShuffledDeck.
  PROCEDURE shuffle_deck IS   
  BEGIN
    DELETE FROM ShuffledDeck;                     -- Clears the ShuffledDeck table
    INSERT INTO ShuffledDeck (cardFace, cardSuit) -- Inserts NUMBERo ShuffledDecktable
      SELECT cardFace, cardSuit FROM Deck            -- All rows of both columns
      ORDER BY dbms_random.value;              -- Randomizes order of SELECT rows
    v_deck_pos := 1;								-- Sets top card of deck as next
  EXCEPTION
	  -- Miscellaneous exception handler
	  WHEN OTHERS THEN
	  	v_err_code := SQLCODE;
		v_err_text := ': ERROR IN FUNCTION shuffle_deck - ' || SQLERRM;
		DBMS_OUTPUT.PUT_LINE(v_err_code||' '||v_err_text);
	  	game_pkg.log_error(v_err_code, v_err_text);
  END shuffle_deck;
  
  -- FUNCTION get_card_value returns the numerical value of a card,
  --	based on the face value of the card. 
  -- It will return 10 for J, Q, K, and either 1 or 11 for A, 
  --	depending on the total value of the hand it is being added to.
  -- It requires two arguments: 
  --	The first is a VARCHAR2 representing the face value
  --	The second is a NUMBER representing the existing hand value
  FUNCTION get_card_value
	  ( p_face_value IN VARCHAR2,		-- The face value of the card
		  p_hand_value IN NUMBER )	-- The hand value before this card is added
	  RETURN number 			-- Return type
	  IS

	  value NUMBER;				-- The numerical value to be returned
	  v_hand_under_11 boolean;		-- Is the hand under 11
	
  BEGIN
  	  IF p_hand_value < 11 THEN
  	  	v_hand_under_11 := true;
  	  ELSE
  	  	v_hand_under_11 := false;
  	  END IF;
	  -- Assign proper value based on face_value
	  value := 
	    CASE p_face_value		-- Face Values:
  		  WHEN 'J' THEN 10	-- Jack
		  WHEN 'Q' THEN 10	-- Queen
	  	  WHEN 'K' THEN 10	-- King
  		  WHEN 'A' THEN 11	-- Ace
		-- If face_value is not a letter, 
	  	-- convert from VARCHAR2 to NUMBER
  		  ELSE
		  	TO_NUMBER(p_face_value)
	    END;
	  IF v_hand_under_11 = false AND value = 11 THEN
	  	value := 1;
	  END IF;
	  RETURN value;
	
  EXCEPTION
	  -- Miscellaneous exception handler
	  WHEN OTHERS THEN
	    v_err_code := SQLCODE;
		v_err_text := ': ERROR IN FUNCTION get_card_value - ' || SQLERRM;
		DBMS_OUTPUT.PUT_LINE(v_err_code||' '|| v_err_text);
	  	game_pkg.log_error(v_err_code, v_err_text);
  END get_card_value;

  	
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
		v_err_text := ': ERROR IN FUNCTION deal_cards - ' || SQLERRM;
		DBMS_OUTPUT.PUT_LINE(v_err_code||' '|| v_err_text);
	  	game_pkg.log_error(v_err_code, v_err_text);
  END deal_cards;
  	
  	  	
  -- PROCEDURE deal_card deals out one card by reading from the ShuffledDeck table,
  -- then updates the player's hand, the player's hand value, and the game's output.
  PROCEDURE deal_card( p_player_num NUMBER ) IS
  
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
  		
  	SELECT cardFace, cardSuit 
  	  INTO v_card_face, v_card_suit
  	  FROM ShuffledDeck
      WHERE position = v_deck_pos;
  	v_card_val := get_card_value(v_card_face, v_loop_value);
  	
  	-- Updates player's hand string and values --
  	CASE p_player_num
  		WHEN 1 THEN 
		  v_p1_hand := v_p1_hand || v_card_face || ' of ' || v_card_suit || ',';
		  v_p1_hand_val := v_p1_hand_val + v_card_val;
 		WHEN 2 THEN 
 		  v_p2_hand := v_p1_hand || v_card_face || ' of ' || v_card_suit || ',';
		  v_p2_hand_val := v_p2_hand_val + v_card_val;
  		WHEN 3 THEN 
 		  v_p3_hand := v_p1_hand || v_card_face || ' of ' || v_card_suit || ',';
		  v_p3_hand_val := v_p3_hand_val + v_card_val;
  		WHEN 4 THEN 
  		  v_p4_hand := v_p1_hand || v_card_face || ' of ' || v_card_suit || ',';
		  v_p4_hand_val := v_p4_hand_val + v_card_val;
  		ELSE 
  		  v_dealer_hand := v_dealer_hand || v_card_face || ' of ' || v_card_suit || ',';
		  v_dealer_hand_val := v_dealer_hand_val + v_card_val;
  	END CASE;
  		
  	-- Updates game result string with the card dealt --			
  	IF p_player_num < v_hands_to_deal THEN
  	  v_cur_player := 'Player ' || p_player_num;
  	ELSE
 	   v_cur_player := 'Dealer';
  	END IF;
  END deal_card;
    
  -- FUNCTION deal_game deals out the whole round
  FUNCTION deal_game( p_deck_pos IN	NUMBER, p_num_players IN NUMBER )
  	RETURN VARCHAR2 IS

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
  		  v_cur_player := 'Player ' || i;
  		ELSE
 	 	  v_cur_player := 'Dealer';
  		END IF;
  		v_round_result := v_round_result || v_cur_player || ' hits.' || chr(10);
  		deal_card(i);
  	  END LOOP;
  	  v_round_result := v_round_result || V_cur_player || ' stands.' || chr(10);
  	END LOOP;
  	
  	FOR i IN 1..v_hands_to_deal 
	
	LOOP		
  	  IF i < v_hands_to_deal THEN
	    v_cur_player := 'Player ' || i;
  	  ELSE
 	 	v_cur_player := 'Dealer';
  	  END IF;
  	 
		IF i=1 THEN 
		  v_loop_value := v_p1_hand_val;
		  UPDATE ScoreTracker
		    SET playerScore = v_loop_value
			WHERE playerNum = i;
 		ELSE IF i=2 AND p_player_num < v_hands_to_deal THEN 
 		  v_loop_value := v_p2_hand_val;
 		  UPDATE ScoreTracker
		    SET playerScore = v_loop_value
			WHERE playerNum = i;
  		ELSE IF i=3 AND p_player_num < v_hands_to_deal THEN 
  			v_loop_value := v_p3_hand_val;
  			UPDATE ScoreTracker
			  SET playerScore = v_loop_value
			  WHERE playerNum = i;
  		ELSE IF i=4 AND p_player_num < v_hands_to_deal THEN 
  			v_loop_value := v_p4_hand_val;
  			UPDATE ScoreTracker
			  SET playerScore = v_loop_value
			  WHERE playerNum = i;
  		ELSE 
  			v_loop_value := v_dealer_hand_val;
  			UPDATE ScoreTracker
			  SET playerScore = v_loop_value
			  WHERE playerNum = 5;
		END IF;
  		
  	  v_round_result := v_round_result || v_cur_player || 
  			' has ' || v_loop_value || '.' || chr(10);
  		
  	END LOOP;
  	
  	SELECT MAX(playerScore)
  		INTO v_winning_score
  		FROM ScoreTracker;
  	
  	SELECT playerNum
  		INTO v_winning_player
  		FROM ScoreTracker
  		WHERE playerScore = v_winning_score;
  			
  	v_round_result := v_round_result || get_player_name(v_winning_player) ||
  		' wins, with ' || v_winning_score || '!';
  	
  	RETURN v_round_result;
  	
  	EXCEPTION
	  -- Miscellaneous exception handler
	  WHEN OTHERS THEN
	  	v_err_code := SQLCODE;
		  v_err_text := ': ERROR IN FUNCTION deal_game - ' || SQLERRM;
		  DBMS_OUTPUT.PUT_LINE(v_err_code||' '|| v_err_text);
	  	game_pkg.log_error(v_err_code, v_err_text);
  	
  END deal_game;
  
  -- FUNCTION player_decision accepts a player number, and makes a decision
  -- whether to hit or stand, based on the score of that player
  FUNCTION player_decision (p_player_num IN	NUMBER )
  	RETURN boolean IS
  	
  BEGIN	
  	CASE p_player_num
  		WHEN 1 THEN 
		  v_loop_value := v_p1_hand_val;
 		WHEN 2 AND p_player_num < v_hands_to_deal THEN 
 		  v_loop_value := v_p2_hand_val;
  		WHEN 3 AND p_player_num < v_hands_to_deal THEN 
  			v_loop_value := v_p3_hand_val;
  		WHEN 4 AND p_player_num < v_hands_to_deal THEN 
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
	  DBMS_OUTPUT.PUT_LINE(v_err_code||' '|| v_err_text);
	  game_pkg.log_error(v_err_code, v_err_text);
	  	
  END player_decision;
  
  -- FUNCTION get_player_name accepts a player position, and returns
  -- the players account name
  FUNCTION get_player_name ( p_player_pos IN NUMBER )
  	RETURN VARCHAR2 IS
  	
  	v_return_name VARCHAR2(25);
  BEGIN
  	IF p_player_pos = 5 THEN
  	  v_return_name := 'Dealer';
  	ELSE
  	  SELECT accountName INTO v_return_name
  		FROM PlayerGame
  		WHERE gameID = game_pkg.v_game_id
  		  AND playerPos = p_player_pos;
  	END IF;
  	
  	RETURN v_return_name;
  EXCEPTION
	  -- Miscellaneous exception handler
	  WHEN OTHERS THEN
	    v_err_code := SQLCODE;
		v_err_text := ': ERROR IN FUNCTION get_player_name - ' || SQLERRM;
	    DBMS_OUTPUT.PUT_LINE(v_err_code||' '|| v_err_text);
	  	game_pkg.log_error(v_err_code, v_err_text);
  END get_player_name;
  	
END deck_pkg;
