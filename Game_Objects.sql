/* DROP statements to guard against duplicate tables */

DROP TABLE Game;
DROP TABLE Player;
DROP TABLE PlayerGame;
DROP TABLE Deck;
DROP TABLE ShuffledDeck;
DROP TABLE GameErrorLog;

/* CREATE TABLE methods to create the tables necessary for the game */

/* Game table to hold information about games */
CREATE TABLE Game (
  gameID RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
  gameDate DATE DEFAULT SYSDATE
);

/* Player table that contains information about players */
CREATE TABLE Player (
  accountName VARCHAR22(25) NOT NULL PRIMARY KEY,
  password VARCHAR2(10) NOT NULL,
  firstName VARCHAR2(25) NOT NULL,
  lastName VARCHAR2(50) NOT NULL,
  email VARCHAR2(60) NOT NULL,
  CONSTRAINT uc_player UNIQUE (email)
);

/* PlayerGame table to hold statistics for a game */
CREATE TABLE PlayerGame (
  gameID RAW(16) NOT NULL,
  accountName VARCHAR22(25) NOT NULL,
  playerPos INT NOT NULL,
  winner VARCHAR22(2) DEFAULT 'N' NOT NULL,
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
