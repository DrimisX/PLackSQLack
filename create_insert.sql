DROP TABLE Game;
DROP TABLE Player;
DROP TABLE PlayerGame;
DROP TABLE Deck;
DROP TABLE ShuffledDeck;
DROP TABLE GameErrorLog;

CREATE TABLE Game (
	gameID RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
	gameDate DATE DEFAULT SYSDATE
	);

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

CREATE TABLE Player (
	accountName VARCHAR22(25) NOT NULL PRIMARY KEY,
	password VARCHAR2(10) NOT NULL,
	firstName VARCHAR2(25) NOT NULL,
	lastName VARCHAR2(50) NOT NULL,
	email VARCHAR2(60) NOT NULL,
	CONSTRAINT uc_player UNIQUE (email)
	);

CREATE TABLE Deck (
	cardFace VARCHAR2(10) NOT NULL,
	cardSuit VARCHAR2(10) NOT NULL,
	CONSTRAINT deck_pk PRIMARY KEY (cardFace, cardSuit),
	CONSTRAINT chk_suit CHECK (cardSuit IN ('Hearts', 'Diamonds', 'Spades', 'Clubs'))
	);

CREATE TABLE ShuffledDeck (
	position INT NOT NULL PRIMARY KEY,
	cardFace VARCHAR2(10) NOT NULL,
	cardSuit VARCHAR2(10) NOT NULL
	);

CREATE TABLE GameErrorLog (
	errorDateTime DATE DEFAULT SYSDATE PRIMARY KEY,
	errorCode NUMBER NOT NULL,
	errorMessage VARCHAR2(250) NOT NULL,
	relatedFunctionality VARCHAR2(250) NOT NULL,
	gameID RAW(16) NOT NULL,
	CONSTRAINT fk_gameID2 FOREIGN KEY (gameID)
		REFERENCES Game(gameID) ON DELETE CASCADE
	);

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


INSERT ALL
INTO Player VALUES('Ashika123','sherocks','Ashika','Shallow','ashika@email.com')
INTO Player VALUES('Jasmyn234','shekicks','Jasmyn','Newton','jasmyn@email.com')
INTO Player VALUES('Dylan365','hethrows','Dylan','Huculak','dylan@email.com')
INTO Player VALUES('Dealer4','hetakes','Shannon','Smith','dealer@email.com')
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
