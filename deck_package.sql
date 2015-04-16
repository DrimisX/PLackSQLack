CREATE OR REPLACE PACKAGE deck_pkg IS  
  
  -- CONSTANTS --
  
  -- VARIABLES --
  v_hands_to_deal;				-- Total number of players including deadler
  v_current_player INT;		-- Current player being dealt to
	v_next_player BOOLEAN;	-- Is there is another player this round

	v_dealer_hand VARCHAR2;	-- A string representing the dealer's cards
	v_dealer_hand_val INT;	-- Dealer's hand total value

	v_p1_account_name VARCHAR2;

	v_p1_hand VARCHAR2;
	v_p2_hand VARCHAR2;
	v_p3_hand VARCHAR2;
	v_p4_hand VARCHAR2;

	v_p1_hand_val INT;
	v_p2_hand_val INT;
	v_p3_hand_val INT;
	v_p4_hand_val INT;
	
	v_round_result VARCHAR2;
	
	-- PROCEDURES --
  PROCEDURE shuffle_deck;
  
  -- FUNCTIONS --
  FUNCTION get_card_value;
  
END deck_pkg;

-- DECK PACKAGE
CREATE OR REPLACE PACKAGE BODY deck_pkg IS

	-- ***CONSTANTS*** --
	
	-- ***VARIABLES*** --
	v_dealer_hand_val := 0;
	v_p1_hand_val := 0;
	v_p2_hand_val := 0;
	v_p3_hand_val := 0;
	v_p4_hand_val := 0;
	
	v_hands_to_deal := game_pkg.v_player_count + 1;
	
	
	-- ***PROCEDURES*** --
	
	-- ***FUNCTIONS*** --
  
  -- PROCEDURE shuffle_deck clears the existing ShuffledDeck table
  --  reads all rows from the Deck table (ordering by random), 
  --  and inserts them into the empty ShuffledDeck.
  PROCEDURE shuffle_deck IS   
  BEGIN
    DELETE FROM ShuffledDeck;                     -- Clears the ShuffledDeck table
    INSERT INTO ShuffledDeck (cardFace, cardSuit) -- Inserts into ShuffledDecktable
     SELECT cardFace, cardSuit FROM Deck            -- All rows of both columns
           ORDER BY dbms_random.value;              -- Randomizes order of SELECT rows
  END shuffle_deck;
  
  -- FUNCTION get_card_value returns the numerical value of a card,
  --	based on the face value of the card. 
  -- It will return 10 for J, Q, K, and either 1 or 11 for A, 
  --	depending on the total value of the hand it is being added to.
  -- It requires two arguments: 
  --	The first is a VARCHAR2 representing the face value
  --	The second is a NUMBER representing the existing hand value
  FUNCTION get_card_value
	  ( face_value IN VARCHAR2		-- The face value of the card
		  hand_value IN NUMBER )	-- The hand value before this card is added
	  RETURN number 			-- Return type
	  IS
	
  DECLARE
	  value NUMBER;				-- The numerical value to be returned
	  err_text VARCHAR2;
	
  BEGIN
	  -- Assign proper value based on face_value
	  value := 
	  CASE face_value		-- Face Values:
  		WHEN 'J' THEN 10	-- Jack
		  WHEN 'Q' THEN 10	-- Queen
	  	WHEN 'K' THEN 10	-- King
  		WHEN 'A' THEN 		-- Ace
		  	--	If the hand_value passed is less than 11,
	  		-- the Ace is worth 11, else, it is worth 1.
  			IF (hand_value < 11) THEN
			  	value := 11;
		  	ELSE	
	  			value := 1;
  			END IF;
		-- If face_value is not a letter, 
	  	-- convert from VARCHAR2 to NUMBER
  		ELSE
		  	TO_NUMBER(face_value)
	  END
	  RETURN value;
	
  EXCEPTION
	  -- Miscellaneous exception handler
	  WHEN OTHERS THEN
		  err_text = ": ERROR IN FUNCTION get_card_value - " || SQLERRM;
		  DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQLCODE)|| errText);
	  	log_error(SQLCODE, errText);
  END;
  
  -- PROCEDURE deal_cards deals out the starting hand values to each player.
  -- It deals one card to each player and the dealer, then a second card to each.
  -- The dealer's up card is recorded and shown to the players.
  PROCEDURE deal_cards IS
  v_deal_result VARCHAR2;
  v_play_result VARCHAR2;
  v_cur_player VARCHAR2;
  	BEGIN
  		FOR i IN 1..2
  		LOOP
  			FOR j IN 1..hands_to_deal
  			LOOP
  			
  			
  				IF j < hands_to_deal
  					v_cur_player = "Player " || j
  				ELSE
  					v_cur_player = "Dealer"
  				END IF;
  				v_deal_result = v_deal_result || v_cur_player || " receives a " ||  
  				
  	END
  -- FUNCTION deal_card deals out one card by reading from the ShuffledDeck table,
  -- and returns the card's face value.
  	-- CODE HERE
  	
  -- FUNCTION card_to_string takes a card (i.e. '2H'), and outputs
  -- a string for better output to the user (2 of Hearts).
  	-- CODE HERE
  
END deck_pkg;
