DROP TABLE games;
DROP TABLE players;
DROP TABLE player_games;
DROP TABLE decks;
DROP TABLE shuffled_decks;
DROP TABLE error_logs;
DROP TABLE score_trackers;

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
	err_msg VARCHAR2(3072) NOT NULL,
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
INTO players VALUES('Ashika123','sherocks','Ashika','Shallow','ashika@email.com')
INTO players VALUES('Jasmyn234','shekicks','Jasmyn','Newton','jasmyn@email.com')
INTO players VALUES('Dylan365','hethrows','Dylan','Huculak','dylan@email.com')
INTO players VALUES('Dealer4','hetakes','Shannon','Smith','dealer@email.com')
SELECT * FROM dual;

INSERT ALL
INTO score_trackers (player_num) VALUES(1)
INTO score_trackers (player_num) VALUES(2)
INTO score_trackers (player_num) VALUES(3)
INTO score_trackers (player_num) VALUES(4)
INTO score_trackers (player_num) VALUES(5)
SELECT * FROM dual;
