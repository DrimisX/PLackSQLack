/* DROP statements to guard against duplicate tables */

DROP TABLE PlayerGame;
DROP TABLE Game;
DROP TABLE Player;
DROP TABLE Deck;
DROP TABLE ShuffledDeck;
DROP TABLE GameErrorLog;
DROP TABLE ScoreTracker;

/* CREATE TABLE statements to create the tables necessary for the game */

/* Game table to hold information about games */
CREATE TABLE Game (
  gameID RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
  gameDate DATE DEFAULT SYSDATE
);

/* Player table that contains information about players */
CREATE TABLE Player (
  accountName VARCHAR2(25) NOT NULL PRIMARY KEY,
  password VARCHAR2(10) NOT NULL,
  firstName VARCHAR2(25) NOT NULL,
  lastName VARCHAR2(50) NOT NULL,
  email VARCHAR2(60) NOT NULL,
  CONSTRAINT uc_player UNIQUE (email)
);

/* PlayerGame table to hold statistics for a game */
CREATE TABLE PlayerGame (
  gameID RAW(16) NOT NULL,
  accountName VARCHAR2(25) NOT NULL,
  playerPos INT NOT NULL,
  winner VARCHAR2(2) DEFAULT 'N' NOT NULL,
  CONSTRAINT pk_playerGame PRIMARY KEY (gameID, accountName),
  CONSTRAINT fk_gameID FOREIGN KEY (gameID)
    REFERENCES Game(gameID) ON DELETE CASCADE,
  CONSTRAINT fk_accountName FOREIGN KEY (accountName)
	REFERENCES Player(accountName) ON DELETE CASCADE
);

/* Deck table to hold all the cards in a deck */
CREATE TABLE Deck (
  cardFace VARCHAR2(10) NOT NULL,
  cardSuit VARCHAR2(10) NOT NULL,
  CONSTRAINT deck_pk PRIMARY KEY (cardFace, cardSuit),
  CONSTRAINT chk_suit CHECK (cardSuit IN ('Hearts', 'Diamonds', 'Spades', 'Clubs'))
);

/* ShuffledDeck object to hold the cards in a shuffled deck */
CREATE TABLE ShuffledDeck (
  position INT NOT NULL PRIMARY KEY,
  cardFace VARCHAR2(10) NOT NULL,
  cardSuit VARCHAR2(10) NOT NULL
);

/* A table to log errors occured during a simulation */
CREATE TABLE GameErrorLog (
  errorDateTime DATE DEFAULT SYSDATE PRIMARY KEY,
  errorCode NUMBER NOT NULL,
  errorMessage VARCHAR2(250) NOT NULL,
  relatedFunctionality VARCHAR2(250) NOT NULL,
  gameID RAW(16) NOT NULL,
  CONSTRAINT fk_gameID2 FOREIGN KEY (gameID)
	REFERENCES Game(gameID) ON DELETE CASCADE
);

/* A table to store the current score of a player */
CREATE TABLE ScoreTracker (
  playerNum NUMBER NOT NULL PRIMARY KEY,
  playerScore NUMBER
);

/* A sequence to automatically increment a card's position in a shuffled deck */
CREATE SEQUENCE seq_id START WITH 1 INCREMENT BY 1 MAXVALUE 52 CYCLE;

/* A trigger to call the seq_id sequence when inserting into the ShuffledDeck table*/
CREATE OR REPLACE TRIGGER insert_cards
BEFORE INSERT ON ShuffledDeck
FOR EACH ROW
BEGIN
  SELECT seq_id.NEXTVAL
  INTO   :new.position
  FROM   dual;
END;


/* INSERT statements to populate the Deck table */
INSERT ALL
INTO Deck (cardFace, cardSuit) VALUES('2', 'Hearts')
INTO Deck (cardFace, cardSuit) VALUES('3', 'Hearts')
INTO Deck (cardFace, cardSuit) VALUES('4', 'Hearts')
INTO Deck (cardFace, cardSuit) VALUES('5', 'Hearts')
INTO Deck (cardFace, cardSuit) VALUES('6', 'Hearts')
INTO Deck (cardFace, cardSuit) VALUES('7', 'Hearts')
INTO Deck (cardFace, cardSuit) VALUES('8', 'Hearts')
INTO Deck (cardFace, cardSuit) VALUES('9', 'Hearts')
INTO Deck (cardFace, cardSuit) VALUES('10', 'Hearts')
INTO Deck (cardFace, cardSuit) VALUES('Jack', 'Hearts')
INTO Deck (cardFace, cardSuit) VALUES('Queen', 'Hearts')
INTO Deck (cardFace, cardSuit) VALUES('King', 'Hearts')
INTO Deck (cardFace, cardSuit) VALUES('Ace', 'Hearts')
INTO Deck (cardFace, cardSuit) VALUES('2', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('3', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('4', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('5', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('6', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('7', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('8', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('9', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('10', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('Jack', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('Queen', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('King', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('Ace', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('2', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('3', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('4', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('5', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('6', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('7', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('8', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('9', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('10', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('Jack', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('Queen', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('King', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('Ace', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('2', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('3', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('4', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('5', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('6', 'Clubs')
INTO Deck (cardFace, cardSuit)VALUES('7', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('8', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('9', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('10', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('Jack', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('Queen', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('King', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('Ace', 'Clubs')
SELECT * FROM dual;

/* OBJECT PACKAGES */

/* PLAYER PACKAGE */

-- Package Specification
CREATE OR REPLACE PACKAGE player_pkg IS

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
  
END player_pkg;

-- Package Body

CREATE OR REPLACE PACKAGE BODY player_pkg IS
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
  
END player_pkg;

/* GAME PACKAGE WHICH CONTAINS VARIABLES AND METHODS TO SIMULATE A GAME */

-- Package Specification
CREATE OR REPLACE PACKAGE game_pkg AS

  v_game_id Game.gameID%TYPE;
  
  v_player_count INT;
  v_verbose_messaging BOOLEAN;

  v_p2_account_name PlayerGame.accountName%TYPE;
  v_p3_account_name PlayerGame.accountName%TYPE;
  v_p4_account_name PlayerGame.accountName%TYPE;
  
  v_code NUMBER;
  v_errm VARCHAR2(255);
  v_err_text VARCHAR2(255);

  -- PROCEDURES --
  PROCEDURE init_proc (p_player_count INT DEFAULT 1, p_verbose_messaging BOOLEAN DEFAULT false);
  PROCEDURE log_error (p_err_code GameErrorLog.errorCode%TYPE, p_err_msg GameErrorLog.errorMessage%TYPE);
  PROCEDURE add_players (
  	p_p1_account_name PlayerGame.accountName%TYPE,
  	p_p2_account_name PlayerGame.accountName%TYPE DEFAULT NULL,
  	p_p3_account_name PlayerGame.accountName%TYPE DEFAULT NULL,
  	p_p4_account_name PlayerGame.accountName%TYPE DEFAULT NULL
);

END game_pkg;

-- Package Body
CREATE OR REPLACE PACKAGE BODY game_pkg AS

  -- Create Game, Set v_player_count and v_verbose_messaging according to parameter
  PROCEDURE init_proc (p_player_count INT DEFAULT 1, p_verbose_messaging BOOLEAN DEFAULT false) IS
		
    v_game_date Game.gameDate%TYPE;

  BEGIN		
    -- Set v_game_date to Current Date/Time
	v_game_date := SYSDATE;

	-- Create new game in Game Table
	INSERT INTO Game(gameDate) VALUES (v_game_date);
		
	-- Set Variables
	SELECT gameID INTO v_game_id FROM Game WHERE gameDate = v_game_date;
	v_player_count := p_player_count;
	
	EXCEPTION
	 WHEN OTHERS THEN
	v_code := SQLCODE;
	v_errm := SQLERRM;
	v_err_text := 'ERROR IN PROCEDURE init_proc - ' || v_errm;
	RAISE_APPLICATION_ERROR(v_code, v_err_text);
  	log_error(v_code, v_err_text);
  END init_proc;

  -- Procedure to Call when an Error Occurs
  -- Log Error in GameErrorLog Table
  PROCEDURE log_error (p_err_code GameErrorLog.errorCode%TYPE, p_err_msg GameErrorLog.errorMessage%TYPE) IS					
  BEGIN
	-- Insert information into GameErrorLog Table
	INSERT INTO GameErrorLog(errorCode, errorMessage, gameID) VALUES (p_err_code, p_err_msg, v_game_id);
	  
	EXCEPTION
	  -- Miscellaneous exception handler
	  WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR(-29999,'Error Logging Failed. Error not logged.');
  END log_error;

  -- Add Players to PlayerGame Table based on the Player Count
  PROCEDURE add_players (p_p1_account_name PlayerGame.accountName%TYPE, 
                       p_p2_account_name PlayerGame.accountName%TYPE DEFAULT NULL, 
					   p_p3_account_name PlayerGame.accountName%TYPE DEFAULT NULL, 
					   p_p4_account_name PlayerGame.accountName%TYPE DEFAULT NULL) IS
	
	v_current_user VARCHAR2(255);
	
  BEGIN
	-- Iterate through parameters according to # Players
	FOR i IN 1..v_player_count LOOP
	  CASE i
	    WHEN 1 THEN v_current_user := p_p1_account_name;
	    WHEN 2 THEN v_current_user := p_p2_account_name;
	    WHEN 3 THEN v_current_user := p_p3_account_name;
	    WHEN 4 THEN v_current_user := p_p4_account_name;
	  END CASE;
	  -- Insert Player into PlayerGamer
	  INSERT INTO PlayerGame (gameID, accountName, playerPos)
	    VALUES (v_game_id, v_current_user, i);
	END LOOP;
	
	EXCEPTION
	-- Miscellaneous exception handler
	WHEN OTHERS THEN
	  v_code := SQLCODE;
	  v_errm := SQLERRM;
	  v_err_text := 'ERROR IN PROCEDURE add_players - ' || v_errm;
	  RAISE_APPLICATION_ERROR(v_code, v_err_text);
  	  log_error(v_code, v_err_text);

  END add_players;
END game_pkg;


/* DECK PACKAGE contains procedures to shuffle a deck and deal a card */

-- DECK_PKG Specification
CREATE OR REPLACE PACKAGE deck_pkg IS  

  -- VARIABLES --
  v_hands_to_deal NUMBER;				-- Total number of players including dealer
  v_current_player NUMBER;		-- Current player being dealt to
  v_next_player BOOLEAN;	-- Is there is another player this round

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
	
  v_deck_pos NUMBER;		-- Current top card of the shuffled deck
  v_card_face VARCHAR2(4);	-- Holds a card's face value
  v_card_suit VARCHAR2(8);	-- Holds a card's suit
	
  v_deal_result VARCHAR2(255);		-- Holds a string output of a card dealt
  v_round_result VARCHAR2(255);	-- Holds a string output of the game's entirety
	
  v_winning_score NUMBER;		-- Holds the high score for the round
  v_winning_player NUMBER;	-- Holds the winning player position
  v_winning_name VARCHAR2(30);	-- Holds the winning player's name
	
  v_err_text VARCHAR2(255);				-- Text for error log output
  v_err_code NUMBER;					-- Number for error log output
	
	-- PROCEDURES --
  PROCEDURE shuffle_deck;
  
  PROCEDURE deal_cards;
  
  PROCEDURE deal_card;
  
  -- FUNCTIONS --
  FUNCTION get_card_value
	  ( p_face_value IN VARCHAR2, p_hand_value IN NUMBER ) RETURN NUMBER;
		  
  FUNCTION get_player_name(p_player_pos NUMBER) RETURN VARCHAR2;
		    
  FUNCTION deal_game( p_deck_pos IN	NUMBER, p_num_players IN NUMBER ) RETURN VARCHAR2;
  		
  FUNCTION player_decision( p_player_num IN	NUMBER ) RETURN BOOLEAN;
  
END deck_pkg;

-- DECK_PKG Body
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
	  ( face_value IN VARCHAR2,		-- The face value of the card
		  hand_value IN NUMBER )	-- The hand value before this card is added
	  RETURN number 			-- Return type
	  IS

	  value NUMBER;				-- The numerical value to be returned
	  hand_under_11 boolean;		-- Is the hand under 11
	
  BEGIN
  	  IF hand_value < 11 THEN
  	  	hand_under_11 := true;
  	  ELSE
  	  	hand_under_11 := false;
  	  END IF;
	  -- Assign proper value based on face_value
	  value := 
	    CASE face_value		-- Face Values:
  		  WHEN 'J' THEN 10	-- Jack
		  WHEN 'Q' THEN 10	-- Queen
	  	  WHEN 'K' THEN 10	-- King
  		  WHEN 'A' THEN 11		-- Ace

		-- If face_value is not a letter, 
	  	-- convert from VARCHAR2 to NUMBER
  		  ELSE
		  	TO_NUMBER(face_value)
	    END;
	  IF hand_under_11 = false AND value = 11 THEN
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
	  FOR j IN 1..hands_to_deal LOOP 			
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
  	
  	CASE p_player_num
  		WHEN 1 THEN 
		  v_loop_value := v_p1_hand_value
 		WHEN 2 AND p_player_num < hands_to_deal THEN 
 		  v_loop_value := v_p2_hand_value
  		WHEN 3 AND p_player_num < hands_to_deal THEN 
  		  v_loop_value := v_p3_hand_value
  		WHEN 4 AND p_player_num < hands_to_deal THEN 
  		  v_loop_value := v_p4_hand_value
  		ELSE 
  		  v_loop_value := v_dealer_hand_value
  	END;
  		
  	SELECT cardFace, cardSuit 
  	  INTO v_card_face, v_card_suit
  	  FROM ShufffledDeck
      WHERE position = p_deck_pos;
  	v_card_val := get_card_value(v_card_face, v_loop_value);
  	
  	-- Updates player's hand string and values --
  	CASE p_loop_i
  		WHEN 1 THEN 
		  v_p1_hand := v_p1_hand || v_card_face || ' of ' || v_card_suit || ',';
		  v_p1_hand_value := v_p1_hand_value + v_card_val;
 		WHEN 2 THEN 
 		  v_p2_hand := v_p1_hand || v_card_face || ' of ' || v_card_suit || ',';
		  v_p2_hand_value := v_p2_hand_value + v_card_val;
  		WHEN 3 THEN 
 		  v_p3_hand := v_p1_hand || v_card_face || ' of ' || v_card_suit || ',';
		  v_p3_hand_value := v_p3_hand_value + v_card_val;
  		WHEN 4 THEN 
  		  v_p4_hand := v_p1_hand || v_card_face || ' of ' || v_card_suit || ',';
		  v_p4_hand_value := v_p4_hand_value + v_card_val;
  		ELSE 
  		  v_dealer_hand := v_dealer_hand || v_card_face || ' of ' || v_card_suit || ',';
		  v_dealer_hand_value := v_dealer_hand_value + v_card_val;
  	END;
  		
  	-- Updates game result string with the card dealt --			
  	IF p_loop_i < hands_to_deal THEN
  	  v_cur_player := 'Player ' || p_loop_i;
  	ELSE
 	   v_cur_player := 'Dealer';
  	END IF;
  END deal_card;
    
  -- FUNCTION deal_game deals out the whole round
  FUNCTION deal_game( p_deck_pos IN	NUMBER, p_num_players IN NUMBER )
  	RETURNS VARCHAR2 IS
  	
  	  v_dealer_hand_val NUMBER:= 0;
	  v_p1_hand_val NUMBER:= 0;
	  v_p2_hand_val NUMBER:= 0;
	  v_p3_hand_val NUMBER:= 0;
	  v_p4_hand_val NUMBER:= 0;
	
	  v_p1_hand := '';
	  v_p2_hand := '';
	  v_p3_hand := '';
	  v_p4_hand := '';
	
	  v_round_result := '';
	
	  v_hands_to_deal := game_pkg.v_player_count + 1;
  	
  	  v_loop_value
  	BEGIN
  	
  	deal_cards();
  	
  	FOR i IN 1..v_hands_to_deal LOOP
  	  WHILE player_decision(i) LOOP	
  	    IF i < hands_to_deal THEN
  		  v_cur_player := 'Player ' || i;
  		ELSE
 	 	  v_cur_player := 'Dealer'
  		END IF;
  		v_round_result := v_round_result || v_cur_player || ' hits.' || chr(10);
  		deal_card(i);
  	  END LOOP;
  	  v_round_result := v_round_result || V_cur_player || ' stands.' || chr(10);
  	END LOOP;
  	
  	FOR i IN 1..v_hands_to_deal LOOP		
  	  IF i < hands_to_deal THEN
	    v_cur_player := 'Player ' || i;
  	  ELSE
 	 	v_cur_player := 'Dealer';
  	  END IF;
  		
  	  CASE i
  		WHEN 1 THEN 
		  v_loop_value := v_p1_hand_value;
		  UPDATE ScoreTracker
		    SET playerScore = v_loop_value
			WHERE playerNum = i;
 		WHEN 2 AND p_player_num < hands_to_deal THEN 
 		  v_loop_value := v_p2_hand_value;
 		  UPDATE ScoreTracker
		    SET playerScore = v_loop_value
			WHERE playerNum = i;
  		WHEN 3 AND p_player_num < hands_to_deal THEN 
  			v_loop_value := v_p3_hand_value;
  			UPDATE ScoreTracker
			  SET playerScore = v_loop_value
			  WHERE playerNum = i;
  		WHEN 4 AND p_player_num < hands_to_deal THEN 
  			v_loop_value := v_p4_hand_value;
  			UPDATE ScoreTracker
			  SET playerScore = v_loop_value
			  WHERE playerNum = i;
  		ELSE 
  			v_loop_value := v_dealer_hand_value;
  			UPDATE ScoreTracker
			  SET playerScore = v_loop_value
			  WHERE playerNum = 5;
  	  END CASE;
  		
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
		  v_loop_value := v_p1_hand_value;
 		WHEN 2 AND p_player_num < hands_to_deal THEN 
 		  v_loop_value := v_p2_hand_value;
  		WHEN 3 AND p_player_num < hands_to_deal THEN 
  			v_loop_value := v_p3_hand_value;
  		WHEN 4 AND p_player_num < hands_to_deal THEN 
  			v_loop_value := v_p4_hand_value;
  		ELSE 
  			v_loop_value := v_dealer_hand_value;
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
  	  v_return_name = 'Dealer';
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
  	
