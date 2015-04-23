DROP TABLE player_games;
DROP TABLE score_trackers;
DROP TABLE players;
DROP TABLE decks;
DROP TABLE shuffled_decks;
DROP TABLE error_logs;
DROP TABLE games;
DROP SEQUENCE seq_id;

CREATE TABLE games (
	game_id RAW(16) DEFAULT SYS_GUID(),
	game_date DATE DEFAULT SYSDATE,
	CONSTRAINT pk_games PRIMARY KEY (game_id)
	);

CREATE TABLE players (
	account_name VARCHAR2(25) NOT NULL,
	password VARCHAR2(10) NOT NULL,
	first_name VARCHAR2(25) NOT NULL,
	last_name VARCHAR2(50) NOT NULL,
	email VARCHAR2(60) NOT NULL,
	CONSTRAINT pk_players PRIMARY KEY (account_name),
	CONSTRAINT uc_players_email UNIQUE (email)
	);

CREATE TABLE player_games (
	game_id RAW(16) NOT NULL,
	account_name VARCHAR2(25) NOT NULL,
	player_pos INT NOT NULL,
	winner VARCHAR2(2) DEFAULT 'N' NOT NULL,
	CONSTRAINT pk_player_games PRIMARY KEY (game_id, account_name),
	CONSTRAINT fk_player_games_game_id FOREIGN KEY (game_id)
		REFERENCES games(game_id) ON DELETE CASCADE,
	CONSTRAINT fk_player_games_account_name FOREIGN KEY (account_name)
		REFERENCES players(account_name) ON DELETE CASCADE
	);

CREATE TABLE decks (
	card_face VARCHAR2(8) NOT NULL,
	card_suit VARCHAR2(8) NOT NULL,
	CONSTRAINT pk_decks PRIMARY KEY (card_face, card_suit),
	CONSTRAINT chk_decks_suit CHECK (card_suit IN ('Hearts', 'Diamonds', 'Spades', 'Clubs'))
	);

CREATE TABLE shuffled_decks (
	position INT NOT NULL,
	card_face VARCHAR2(8) NOT NULL,
	card_suit VARCHAR2(8) NOT NULL,
	CONSTRAINT pk_shuffled_decks PRIMARY KEY (position)
	);

CREATE TABLE error_logs (
	err_date_time DATE DEFAULT SYSDATE,
	err_code NUMBER NOT NULL,
	err_msg VARCHAR2(1024) NOT NULL,
	related_func VARCHAR2(256),
	game_id RAW(16) NOT NULL,
	CONSTRAINT pk_error_logs PRIMARY KEY (err_date_time),
	CONSTRAINT fk_error_logs_game_id FOREIGN KEY (game_id)
		REFERENCES games(game_id) ON DELETE CASCADE
	);
	
CREATE TABLE score_trackers (
	player_num NUMBER NOT NULL,
	player_score NUMBER,
	CONSTRAINT pk_score_trackers PRIMARY KEY (player_num)
	);

CREATE SEQUENCE seq_id START WITH 1 INCREMENT BY 1 MAXVALUE 52 CYCLE;

CREATE OR REPLACE TRIGGER tr_insert_cards
BEFORE INSERT ON shuffled_decks
FOR EACH ROW
BEGIN
  SELECT seq_id.NEXTVAL
  INTO   :new.position
  FROM   dual;
END;

INSERT ALL
INTO decks (card_face, card_suit) VALUES('2', 'Hearts')
INTO decks (card_face, card_suit) VALUES('3', 'Hearts')
INTO decks (card_face, card_suit) VALUES('4', 'Hearts')
INTO decks (card_face, card_suit) VALUES('5', 'Hearts')
INTO decks (card_face, card_suit) VALUES('6', 'Hearts')
INTO decks (card_face, card_suit) VALUES('7', 'Hearts')
INTO decks (card_face, card_suit) VALUES('8', 'Hearts')
INTO decks (card_face, card_suit) VALUES('9', 'Hearts')
INTO decks (card_face, card_suit) VALUES('10', 'Hearts')
INTO decks (card_face, card_suit) VALUES('Jack', 'Hearts')
INTO decks (card_face, card_suit) VALUES('Queen', 'Hearts')
INTO decks (card_face, card_suit) VALUES('King', 'Hearts')
INTO decks (card_face, card_suit) VALUES('Ace', 'Hearts')
INTO decks (card_face, card_suit) VALUES('2', 'Diamonds')
INTO decks (card_face, card_suit) VALUES('3', 'Diamonds')
INTO decks (card_face, card_suit) VALUES('4', 'Diamonds')
INTO decks (card_face, card_suit) VALUES('5', 'Diamonds')
INTO decks (card_face, card_suit) VALUES('6', 'Diamonds')
INTO decks (card_face, card_suit) VALUES('7', 'Diamonds')
INTO decks (card_face, card_suit) VALUES('8', 'Diamonds')
INTO decks (card_face, card_suit) VALUES('9', 'Diamonds')
INTO decks (card_face, card_suit) VALUES('10', 'Diamonds')
INTO decks (card_face, card_suit) VALUES('Jack', 'Diamonds')
INTO decks (card_face, card_suit) VALUES('Queen', 'Diamonds')
INTO decks (card_face, card_suit) VALUES('King', 'Diamonds')
INTO decks (card_face, card_suit) VALUES('Ace', 'Diamonds')
INTO decks (card_face, card_suit) VALUES('2', 'Spades')
INTO decks (card_face, card_suit) VALUES('3', 'Spades')
INTO decks (card_face, card_suit) VALUES('4', 'Spades')
INTO decks (card_face, card_suit) VALUES('5', 'Spades')
INTO decks (card_face, card_suit) VALUES('6', 'Spades')
INTO decks (card_face, card_suit) VALUES('7', 'Spades')
INTO decks (card_face, card_suit) VALUES('8', 'Spades')
INTO decks (card_face, card_suit) VALUES('9', 'Spades')
INTO decks (card_face, card_suit) VALUES('10', 'Spades')
INTO decks (card_face, card_suit) VALUES('Jack', 'Spades')
INTO decks (card_face, card_suit) VALUES('Queen', 'Spades')
INTO decks (card_face, card_suit) VALUES('King', 'Spades')
INTO decks (card_face, card_suit) VALUES('Ace', 'Spades')
INTO decks (card_face, card_suit) VALUES('2', 'Clubs')
INTO decks (card_face, card_suit) VALUES('3', 'Clubs')
INTO decks (card_face, card_suit) VALUES('4', 'Clubs')
INTO decks (card_face, card_suit) VALUES('5', 'Clubs')
INTO decks (card_face, card_suit) VALUES('6', 'Clubs')
INTO decks (card_face, card_suit) VALUES('7', 'Clubs')
INTO decks (card_face, card_suit) VALUES('8', 'Clubs')
INTO decks (card_face, card_suit) VALUES('9', 'Clubs')
INTO decks (card_face, card_suit) VALUES('10', 'Clubs')
INTO decks (card_face, card_suit) VALUES('Jack', 'Clubs')
INTO decks (card_face, card_suit) VALUES('Queen', 'Clubs')
INTO decks (card_face, card_suit) VALUES('King', 'Clubs')
INTO decks (card_face, card_suit) VALUES('Ace', 'Clubs')
SELECT * FROM dual;

INSERT ALL
INTO score_trackers (player_num) VALUES(1)
INTO score_trackers (player_num) VALUES(2)
INTO score_trackers (player_num) VALUES(3)
INTO score_trackers (player_num) VALUES(4)
INTO score_trackers (player_num) VALUES(5)
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
  TYPE player_type IS RECORD(f_name players.first_name%TYPE, 
                             l_name players.last_name%TYPE,
                             pl_email players.email%TYPE); 
  -- Create player procedure
  PROCEDURE create_player(
    p_account players.account_name%TYPE, p_password players.password%TYPE,
    p_fname players.first_name%TYPE, p_lname players.last_name%TYPE,
    p_email players.email%TYPE);
	
  -- Get player information function
  FUNCTION get_player(p_account players.account_name%TYPE) RETURN player_type;
  
  -- Update player information procedure
  PROCEDURE update_player(p_account players.account_name%TYPE, p_player player_type);
    
  -- Change password procedure
  PROCEDURE change_password(p_account players.account_name%TYPE, p_password players.password%TYPE);
  
  -- Remove player information procedure
  PROCEDURE delete_player(p_account players.account_name%TYPE);
  
END player_pkg;


-- Package Body
CREATE OR REPLACE PACKAGE BODY player_pkg IS
  -- Create player procedure
  PROCEDURE create_player(
      p_account players.account_name%TYPE, p_password players.password%TYPE,
      p_fname players.first_name%TYPE, p_lname players.last_name%TYPE,
      p_email players.email%TYPE) IS    
  BEGIN   
    INSERT INTO players VALUES
      (p_account, p_password, p_fname, p_lname, p_email);
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(V_CODE_EXISTS, V_MESSAGE_EXISTS);
      game_pkg.log_error(V_CODE_EXISTS, V_MESSAGE_EXISTS);
  END create_player;
  
  -- Get player function
  FUNCTION get_player(p_account players.account_name%TYPE) 
    RETURN player_type IS
	player_rec player_type;
  BEGIN
    SELECT first_name, last_name, email INTO player_rec.f_name, player_rec.l_name,
	  player_rec.pl_email FROM players WHERE account_name = p_account;
	RETURN player_rec;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);
      game_pkg.log_error(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);    
  END get_player;
  
  -- update_player procedure
  PROCEDURE update_player(p_account players.account_name%TYPE, p_player player_type) 
  IS
    v_id players.account_name%TYPE;
  BEGIN
    -- Determine if player exists
    SELECT account_name INTO v_id FROM
      players WHERE account_name = p_account;
    -- If player exists
	UPDATE players SET first_name = p_player.f_name, last_name = p_player.l_name,
	  email = p_player.pl_email WHERE account_name = p_account;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);
      game_pkg.log_error(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);
  END update_player;
  
  -- Change password procedure
  PROCEDURE change_password(p_account players.account_name%TYPE, 
                            p_password players.password%TYPE) 
  IS
  p_first players.first_name%TYPE;
  BEGIN
    -- Determine if player exists
    SELECT first_name INTO p_first FROM
      players WHERE account_name = p_account;
    -- If player exists
    UPDATE players SET password = p_password
       WHERE account_name = p_account;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(V_CODE_NOT_EXISTS,V_MESSAGE_NOT_EXISTS );
      game_pkg.log_error(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);
  END change_password;
  
  -- Delete Player procedure
  PROCEDURE delete_player(p_account players.account_name%TYPE) IS
    p_first players.first_name%TYPE;
  BEGIN
    -- Determine if player exists
    SELECT first_name INTO p_first FROM
      players WHERE account_name = p_account;
    -- If player exists
    DELETE FROM players WHERE account_name = p_account;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);
      game_pkg.log_error(V_CODE_NOT_EXISTS, V_MESSAGE_NOT_EXISTS);
  END delete_player;
  
END player_pkg;

/* GAME PACKAGE WHICH CONTAINS VARIABLES AND METHODS TO SIMULATE A GAME */

-- Package Specification
CREATE OR REPLACE PACKAGE game_pkg AS

  v_game_id games.game_id%TYPE;
  v_err_text error_logs.err_msg%TYPE;
  
  v_player_count INT;
  v_verbose_messaging BOOLEAN;
  
  v_p1_account_name player_games.account_name%TYPE;
  v_p2_account_name player_games.account_name%TYPE;
  v_p3_account_name player_games.account_name%TYPE;
  v_p4_account_name player_games.account_name%TYPE;

  -- PROCEDURES --
  PROCEDURE init_proc (p_player_count INT DEFAULT 1, p_verbose_messaging BOOLEAN DEFAULT false);
  PROCEDURE log_error (p_err_code error_logs.err_code%TYPE, p_err_msg error_logs.err_msg%TYPE);
  PROCEDURE add_players (
    p_p1_account_name player_games.account_name%TYPE,
    p_p2_account_name player_games.account_name%TYPE DEFAULT NULL,
    p_p3_account_name player_games.account_name%TYPE DEFAULT NULL,
    p_p4_account_name player_games.account_name%TYPE DEFAULT NULL
    );

  -- FUNCTIONS --
  FUNCTION get_game_id RETURN games.game_id%TYPE;

END game_pkg;

-- Package Body
CREATE OR REPLACE PACKAGE BODY game_pkg AS

  -- Create Game, Set v_player_count and v_verbose_messaging according to parameter
  PROCEDURE init_proc (p_player_count INT DEFAULT 1, p_verbose_messaging BOOLEAN DEFAULT false) IS
    
  v_game_date games.game_date%TYPE;

  BEGIN   
    -- Set v_game_date to Current Date/Time
  v_game_date := SYSDATE;

  -- Create new game in Game Table
  INSERT INTO games(game_date) VALUES (v_game_date);
  
  -- Set Variables
  SELECT game_id INTO v_game_id FROM games WHERE game_date = v_game_date;
  v_player_count := p_player_count;

  EXCEPTION
  WHEN OTHERS THEN
  v_err_text := 'ERROR IN PROCEDURE init_proc - ' || SQLERRM;
  DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQLCODE)|| v_err_text);
    log_error(SQLCODE, v_err_text);
  
  END init_proc;

  -- Procedure to Call when an Error Occurs
  -- Log Error in GameErrorLog Table
  PROCEDURE log_error (p_err_code error_logs.err_code%TYPE, p_err_msg error_logs.err_msg%TYPE) IS
        
  BEGIN

  -- Insert information into GameErrorLog Table
  INSERT INTO error_logs (err_code, err_msg, game_id)
    VALUES (p_err_code, p_err_msg, v_game_id);

  EXCEPTION
    -- Miscellaneous exception handler
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20990,'Error Logging Failed. Error not logged.');
  END log_error;

  -- Add Players to PlayerGame Table based on the Player Count
  PROCEDURE add_players (p_p1_account_name player_games.account_name%TYPE, 
                       p_p2_account_name player_games.account_name%TYPE DEFAULT NULL, 
             p_p3_account_name player_games.account_name%TYPE DEFAULT NULL, 
             p_p4_account_name player_games.account_name%TYPE DEFAULT NULL) IS
  
    v_current_user player_games.account_name%TYPE;
  BEGIN
  -- Iterate through parameters according to # Players
  FOR i IN 1 .. v_player_count LOOP
    CASE i
      WHEN 1 THEN v_current_user := p_p1_account_name;
      WHEN 2 THEN v_current_user := p_p2_account_name;
      WHEN 3 THEN v_current_user := p_p3_account_name;
      WHEN 4 THEN v_current_user := p_p4_account_name;
    END CASE;
    -- Insert Player into PlayerGame
    INSERT INTO player_games (game_id, account_name, player_pos)
      VALUES (v_game_id, v_current_user, i);
  END LOOP;

  EXCEPTION
  -- Miscellaneous exception handler
  WHEN OTHERS THEN
    v_err_text := 'ERROR IN PROCEDURE add_players - ' || SQLERRM;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQLCODE)|| v_err_text);
      log_error(SQLCODE, v_err_text);
  END add_players;

  -- FUNCTION get_game_id returns the current game_id
  FUNCTION get_game_id
    RETURN games.game_id%TYPE
    IS

    v_current_game_id games.game_id%TYPE;

    BEGIN

    RETURN v_current_game_id;

    EXCEPTION
      -- Miscellaneous exception handler
      WHEN OTHERS THEN
        v_err_text := 'ERROR IN FUNCTION get_game_id - ' || SQLERRM;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQLCODE)|| v_err_text);
        log_error(SQLCODE, v_err_text);
  END get_game_id;

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
