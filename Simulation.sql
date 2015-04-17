/* This file simulates a basic game of BlackJack with only two players (includes the dealer) */

/* shuffle_deck procedure */

CREATE OR REPLACE PROCEDURE shuffle_deck IS
BEGIN
  DELETE FROM ShuffledDeck;                     -- Clears the ShuffledDeck table
    INSERT INTO ShuffledDeck (cardFace, cardSuit) -- Inserts into ShuffledDecktable
      SELECT cardFace, cardSuit FROM Deck            -- All rows of both columns
      ORDER BY DBMS_RANDOM.VALUE;
END shuffle_deck;


/* get_card_value function returns the value of a card*/
CREATE OR REPLACE FUNCTION get_card_value (p_cface VARCHAR2, p_score INTEGER)
  RETURN INTEGER IS  
  card_value INTEGER := 0;
BEGIN
  IF p_cface = 'Jack' OR p_cface = 'Queen' OR p_cface = 'King'
    THEN card_value := 10;
  ELSIF p_cface = 'Ace' THEN
    IF p_score < 11 THEN card_value := 11;
	ELSE card_value := 1;
	END IF;
  ELSE card_value := TO_NUMBER(p_cface);
  END IF;
  
  RETURN card_value;
  
END get_card_value;

/* Anonymous block to simulate a game */
DECLARE

  -- Variables to hold the player's (and dealer's) scores
  v_player_score INTEGER := 0;
  v_dealer_score INTEGER := 0;
  
  -- Variables to hold each player's cards
  v_player_hand VARCHAR2(255);
  v_dealer_hand VARCHAR2(255);
  
  -- Variables which temporarily stores a card before adding it to the player's hand
  v_cardFace VARCHAR2(5);
  v_cardSuit VARCHAR2(10);
  v_cardPosition INTEGER;  -- Not needed but I didn't want to build a new ShuffledDeck table
  
  -- Cursor to hold a shuffled deck
  CURSOR deck_cur IS SELECT * FROM ShuffledDeck;
BEGIN
  DBMS_OUTPUT.PUT_LINE('WELCOME');
  DBMS_OUTPUT.PUT_LINE('');
  shuffle_deck;  -- shuffle the deck
  
  OPEN deck_cur;
  
  -- Loop to deal two cards to each player
  FOR i IN 1..2 LOOP
    FETCH deck_cur INTO v_cardPosition, v_cardFace, v_cardSuit;    -- Deal a card to the player
    v_player_hand := v_cardFace ||' of '|| v_cardSuit || ', '||v_player_hand; -- add the card to the player's hand
	v_player_score := v_player_score + get_card_value(v_cardFace, v_player_score);   -- add to the player's score
	FETCH deck_cur INTO v_cardPosition, v_cardFace, v_cardSuit;   -- Deal a card to the dealer
    v_dealer_hand := v_cardFace ||' of '|| v_cardSuit  || ', '||v_dealer_hand;  -- add the card to the dealer's hand
	v_dealer_score := v_dealer_score + get_card_value(v_cardFace, v_dealer_score);  -- add to the dealer's score
  END LOOP;
  
  -- Display the player's hand and score
  DBMS_OUTPUT.PUT_LINE('Ashika: '|| v_player_hand);
  DBMS_OUTPUT.PUT_LINE('Score: '|| v_player_score);
  
  DBMS_OUTPUT.PUT_LINE('');
   
  IF v_player_score = 21 THEN
    DBMS_OUTPUT.PUT_LINE('Player has BlackJack!');
  ELSE
    -- The player hits if his score is less than 17
    IF v_player_score < 17 THEN
      DBMS_OUTPUT.PUT_LINE('Player HITS');
	  
	  -- The player takes cards until his score is equal to or greater than 19
      WHILE v_player_score < 19 LOOP
        FETCH deck_cur INTO v_cardPosition, v_cardFace, v_cardSuit;
        v_player_hand := v_cardFace ||' of '|| v_cardSuit || ', '||v_player_hand;
        v_player_score := v_player_score + get_card_value(v_cardFace, v_player_score);
        DBMS_OUTPUT.PUT_LINE('Ashika: '|| v_player_hand);
        DBMS_OUTPUT.PUT_LINE('Score: '|| v_player_score);	  
      END LOOP;
	  
	  -- If the player's score becomes greater than 21, he busts and dealer automatically wins
	  IF v_player_score > 21 THEN
	    DBMS_OUTPUT.PUT_LINE('');
		DBMS_OUTPUT.PUT_LINE('Player Busts! House Wins');
	  END IF;
    ELSE
	  -- If the player's score is between 17 and 21, he rests
      DBMS_OUTPUT.PUT_LINE('Player rests.');
	END IF;
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('');
  
  -- Display the dealer's hand and score
  DBMS_OUTPUT.PUT_LINE('Dealer: '|| v_dealer_hand);
  DBMS_OUTPUT.PUT_LINE('Score: '|| v_dealer_score);
  
  -- HOUSE TURN
  IF v_dealer_score = 21 THEN
    DBMS_OUTPUT.PUT_LINE('House has BlackJack!');
  -- If the dealer's score is less than or equal to the player's score 
  -- AND the player's score is less than 21, House must take cards
  ELSIF v_dealer_score <= v_player_score AND v_player_score <= 21 THEN
    DBMS_OUTPUT.PUT_LINE('HOUSE HITS');
	WHILE v_dealer_score <= v_player_score LOOP
       FETCH deck_cur INTO v_cardPosition, v_cardFace, v_cardSuit; -- Deal a card to the dealer
       v_dealer_hand := v_cardFace ||' of '|| v_cardSuit  || ', '||v_dealer_hand;
       v_dealer_score := v_dealer_score + get_card_value(v_cardFace, v_dealer_score);
       DBMS_OUTPUT.PUT_LINE('Dealer: '|| v_dealer_hand);
       DBMS_OUTPUT.PUT_LINE('Score: '|| v_dealer_score);
    END LOOP;
  END IF;
  
  CLOSE deck_cur;
  
  DBMS_OUTPUT.PUT_LINE('');
  
  -- Determine the winner
  IF v_dealer_score > 21 THEN
    IF v_player_score > 21 THEN
	  DBMS_OUTPUT.PUT_LINE('No winners!');
	ELSE
      DBMS_OUTPUT.PUT_LINE('House Busts! Player wins!');
	END IF;
  ELSIF v_dealer_score > v_player_score AND v_dealer_score <= 21 THEN
    DBMS_OUTPUT.PUT_LINE('House Wins!');
  ELSIF v_player_score > v_dealer_score AND v_player_score <= 21 THEN
    DBMS_OUTPUT.PUT_LINE('Player Wins!');
  END IF;
END;

  


  
