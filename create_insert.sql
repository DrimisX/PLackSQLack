CREATE TABLE Game (
	gameID RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
	gameDate DATE DEFAULT SYSDATE,
	player1ID VARCHAR(10) NOT NULL,
	player2ID VARCHAR(10),
	player3ID VARCHAR(10),
	player4ID VARCHAR(10)
	);

CREATE TABLE PlayerGame (
	gameID RAW(16) NOT NULL,
	accountName VARCHAR(25) NOT NULL,
	winner VARCHAR(2) DEFAULT 'N' NOT NULL,
	CONSTRAINT pk_playerGame PRIMARY KEY (gameID, accountName),
	CONSTRAINT fk_gameID FOREIGN KEY (gameID)
		REFERENCES Game(gameID),
	CONSTRAINT fk_accountName FOREIGN KEY (accountName)
		REFERENCES Player(accountName)
	);

CREATE TABLE Player (
	accountName VARCHAR(25) NOT NULL PRIMARY KEY,
	password VARCHAR(10) NOT NULL,
	firstName VARCHAR(25) NOT NULL,
	lastName VARCHAR(50) NOT NULL,
	email VARCHAR(60) NOT NULL,
	CONSTRAINT uc_player UNIQUE (email)
	);

CREATE TABLE Deck (
	cardFace VARCHAR(10) NOT NULL,
	cardSuit VARCHAR(10) NOT NULL,
	CONSTRAINT deck_pk PRIMARY KEY (cardFace, cardSuit)
	CONSTRAINT chk_suit CHECK (cardSuit IN ('Hearts', 'Diamonds', 'Spades', 'Clubs'))
	);

CREATE TABLE ShuffledDeck (
	position INT NOT NULL PRIMARY KEY,
	cardFace VARCHAR(10) NOT NULL,
	cardSuit VARCHAR(10) NOT NULL
	);

/* INSERT VALUES */
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
INTO Deck (cardFace, cardSuit) VALUES('J', 'Hearts')
INTO Deck (cardFace, cardSuit) VALUES('Q', 'Hearts')
INTO Deck (cardFace, cardSuit) VALUES('K', 'Hearts')
INTO Deck (cardFace, cardSuit) VALUES('A', 'Hearts')
INTO Deck (cardFace, cardSuit) VALUES('2', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('3', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('4', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('5', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('6', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('7', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('8', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('9', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('10', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('J', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('Q', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('K', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('A', 'Diamonds')
INTO Deck (cardFace, cardSuit) VALUES('2', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('3', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('4', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('5', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('6', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('7', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('8', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('9', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('10', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('J', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('Q', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('K', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('A', 'Spades')
INTO Deck (cardFace, cardSuit) VALUES('2', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('3', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('4', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('5', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('6', 'Clubs')
INTO Deck (cardFace, cardSuit)VALUES('7', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('8', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('9', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('10', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('J', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('Q', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('K', 'Clubs')
INTO Deck (cardFace, cardSuit) VALUES('A', 'Clubs')
SELECT * FROM dual;

CREATE SEQUENCE seq_id START WITH 1 INCREMENT BY 1 MAXVALUE 52 CYCLE;

CREATE OR REPLACE TRIGGER insert_cards
BEFORE INSERT ON ShuffledDeck
FOR EACH ROW
BEGIN
  SELECT seq_id.NEXTVAL
  INTO   :new.position
  FROM   dual;
END;
