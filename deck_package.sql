CREATE OR REPLACE PACKAGE deck_package IS  
  PROCEDURE shuffle_deck;
  -- Include other functions/procedures --
END deck_of_cards;

CREATE OR REPLACE PACKAGE BODY deck_package IS
  PROCEDURE shuffle_deck IS   
  BEGIN
    INSERT INTO ShuffledDeck (cardFace, cardSuit)
     SELECT cardFace, cardSuit FROM Deck
           ORDER BY dbms_random.value;
  END shuffle_deck;     
END deck_package;
     
CREATE TABLE ShuffleDeck (
  position INT NOT NULL PRIMARY KEY,
  cardFace VARCHAR(10) NOT NULL,
  cardSuit VARCHAR(10) NOT NULL
);  
