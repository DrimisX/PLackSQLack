/* Created By Dylan Huculak */

CREATE OR REPLACE PACKAGE deck_package IS  
  -- PROCEDURES
  PROCEDURE shuffle_deck;
  
  -- FUNCTIONS
  FUNCTION get_card_value;
  -- Include other functions/procedures --
END deck_of_cards;

-- DECK PACKAGE
CREATE OR REPLACE PACKAGE BODY deck_package IS
  
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
  --	The first is a VARCHAR representing the face value
  --	The second is a NUMBER representing the existing hand value
  FUNCTION get_card_value
	  ( face_value IN VARCHAR		-- The face value of the card
		  hand_value IN NUMBER )	-- The hand value before this card is added
	  RETURN number 			-- Return type
	  IS
	
  DECLARE
	  value NUMBER;				-- The numerical value to be returned
	
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
	  	-- convert from VARCHAR to NUMBER
  		ELSE
		  	TO_NUMBER(face_value)
	  END
	  RETURN value;
	
  EXCEPTION
	  -- Miscellaneous exception handler
	  WHEN OTHERS THEN
		  DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQLCODE)||
	  		": ERROR IN FUNCTION get_card_value - " || SQLERRM);
END;
  
END deck_package;
