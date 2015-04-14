/* My version of Deck entity */

CREATE TABLE Deck (
	cardID VARCHAR(3) NOT NULL PRIMARY KEY,
    faceValue VARCHAR(2) NOT NULL,
	cardSuit VARCHAR(10) NOT NULL,	
	cardValue INT NOT NULL,
	CONSTRAINT chk_suit CHECK (cardSuit IN ('Hearts', 'Diamonds', 'Spades', 'Clubs'))	
);

/* INSERT VALUES */
INSERT INTO Deck VALUES('2H','2', 'Hearts', 2);
INSERT INTO Deck VALUES('3H','3', 'Hearts', 3);
INSERT INTO Deck VALUES('4H','4', 'Hearts', 4);
INSERT INTO Deck VALUES('5H','5', 'Hearts', 5);
INSERT INTO Deck VALUES('6H','6', 'Hearts', 6);
INSERT INTO Deck VALUES('7H','7', 'Hearts', 7);
INSERT INTO Deck VALUES('8H','8', 'Hearts', 8);
INSERT INTO Deck VALUES('9H','9', 'Hearts', 9);
INSERT INTO Deck VALUES('10H','10', 'Hearts', 10);
INSERT INTO Deck VALUES('JH','J', 'Hearts', 10);
INSERT INTO Deck VALUES('QH','Q', 'Hearts', 10);
INSERT INTO Deck VALUES('KH','K', 'Hearts', 10);
INSERT INTO Deck VALUES('AH','A', 'Hearts', 11);

INSERT INTO Deck VALUES('2C','2', 'Clubs', 2);
INSERT INTO Deck VALUES('3C','3', 'Clubs', 3);
INSERT INTO Deck VALUES('4C','4', 'Clubs', 4);
INSERT INTO Deck VALUES('5C','5', 'Clubs', 5);
INSERT INTO Deck VALUES('6C','6', 'Clubs', 6);
INSERT INTO Deck VALUES('7C','7', 'Clubs', 7);
INSERT INTO Deck VALUES('8C','8', 'Clubs', 8);
INSERT INTO Deck VALUES('9C','9', 'Clubs', 9);
INSERT INTO Deck VALUES('10C','10', 'Clubs', 10);
INSERT INTO Deck VALUES('JC','J', 'Clubs', 10);
INSERT INTO Deck VALUES('QC','Q', 'Clubs', 10);
INSERT INTO Deck VALUES('KC','K', 'Clubs', 10);
INSERT INTO Deck VALUES('AC','A', 'Clubs', 11);

INSERT INTO Deck VALUES('2D','2', 'Diamonds', 2);
INSERT INTO Deck VALUES('3D','3', 'Diamonds', 3);
INSERT INTO Deck VALUES('4D','4', 'Diamonds', 4);
INSERT INTO Deck VALUES('5D','5', 'Diamonds', 5);
INSERT INTO Deck VALUES('6D','6', 'Diamonds', 6);
INSERT INTO Deck VALUES('7D','7', 'Diamonds', 7);
INSERT INTO Deck VALUES('8D','8', 'Diamonds', 8);
INSERT INTO Deck VALUES('9D','9', 'Diamonds', 9);
INSERT INTO Deck VALUES('10D','10', 'Diamonds', 10);
INSERT INTO Deck VALUES('JD','J', 'Diamonds', 10);
INSERT INTO Deck VALUES('QD','Q', 'Diamonds', 10);
INSERT INTO Deck VALUES('KD','K', 'Diamonds', 10);
INSERT INTO Deck VALUES('AD','A', 'Diamonds', 11);

INSERT INTO Deck VALUES('2S','2', 'Spades', 2);
INSERT INTO Deck VALUES('3S','3', 'Spades', 3);
INSERT INTO Deck VALUES('4S','4', 'Spades', 4);
INSERT INTO Deck VALUES('5S','5', 'Spades', 5);
INSERT INTO Deck VALUES('6S','6', 'Spades', 6);
INSERT INTO Deck VALUES('7S','7', 'Spades', 7);
INSERT INTO Deck VALUES('8S','8', 'Spades', 8);
INSERT INTO Deck VALUES('9S','9', 'Spades', 9);
INSERT INTO Deck VALUES('10S','10', 'Spades', 10);
INSERT INTO Deck VALUES('JS','J', 'Spades', 10);
INSERT INTO Deck VALUES('QS','Q', 'Spades', 10);
INSERT INTO Deck VALUES('KS','K', 'Spades', 10);
INSERT INTO Deck VALUES('AS','A', 'Spades', 11);

