DROP TABLE IF EXISTS sets;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS fans;
DROP TABLE IF EXISTS referees;
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS people;

CREATE TABLE people(
	person_id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(60) NOT NULL,
	age INT NOT NULL,
	nationality VARCHAR(60) NOT NULL,
	PRIMARY KEY (person_id),
	CONSTRAINT invalid_age CHECK (age >= 13),
	CONSTRAINT repeated_name UNIQUE (name)
);

CREATE TABLE players(
	player_id INT NOT NULL AUTO_INCREMENT,
	ranking INT NOT NULL,
	PRIMARY KEY (player_id),
	FOREIGN KEY (player_id) REFERENCES people (person_id) ON DELETE CASCADE,
	CONSTRAINT invalid_ranking CHECK (ranking >= 0 AND ranking <= 1000)
);

CREATE TABLE referees(
	referee_id INT NOT NULL AUTO_INCREMENT,
	license VARCHAR(60) NOT NULL,
	PRIMARY KEY (referee_id),
	FOREIGN KEY (referee_id) REFERENCES people (person_id) ON DELETE CASCADE
);

CREATE TABLE fans(
	fan_id INT NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (fan_id),
	FOREIGN KEY (fan_id) REFERENCES people (person_id) ON DELETE CASCADE
);

CREATE TABLE matches(
   match_id INT NOT NULL AUTO_INCREMENT,
	referee_id INT NOT NULL,
	player1_id INT NOT NULL,
	player2_id INT NOT NULL,
	winner_id INT NOT NULL,
	tournament VARCHAR(60) NOT NULL,
	match_date DATE NOT NULL,
	round VARCHAR(60) NOT NULL,
	duration INT NOT NULL,
	PRIMARY KEY (match_id),
	FOREIGN KEY (referee_id) REFERENCES referees (referee_id) ON DELETE CASCADE,
	FOREIGN KEY (player1_id) REFERENCES players (player_id) ON DELETE CASCADE,
   FOREIGN KEY (player2_id) REFERENCES players (player_id) ON DELETE CASCADE,
   FOREIGN KEY (winner_id) REFERENCES players (player_id) ON DELETE CASCADE,
	CONSTRAINT invalid_winner CHECK (winner_id IN (player1_id, player2_id)),
	CONSTRAINT equal_players CHECK (player1_id != player2_id)
);

CREATE TABLE tickets(
	ticket_id INT NOT NULL AUTO_INCREMENT,
	fan_id INT NOT NULL,
	match_id INT NOT NULL,
	price INT NOT NULL,
	locality VARCHAR(60) NOT NULL,
	purchase_date DATE NOT NULL,
	PRIMARY KEY (ticket_id),
	FOREIGN KEY (fan_id) REFERENCES fans (fan_id) ON DELETE CASCADE,
	FOREIGN KEY (match_id) REFERENCES matches (match_id) ON DELETE CASCADE
);

CREATE TABLE sets(
	match_id INT NOT NULL,
	winner_id INT NOT NULL,
	set_order INT NOT NULL,
	score VARCHAR(60) NOT NULL,
	FOREIGN KEY (match_id) REFERENCES matches (match_id) ON DELETE CASCADE,
	FOREIGN KEY (winner_id) REFERENCES players (player_id) ON DELETE CASCADE,
	CONSTRAINT incorrect_score CHECK (set_order IN (1, 2, 3, 4, 5))
);


DELIMITER //
CREATE OR REPLACE TRIGGER incorrect_arbitration_quantity
BEFORE INSERT ON matches
FOR EACH ROW
BEGIN
		DECLARE num_matches INT;
		
		SELECT COUNT(*)
		INTO num_matches
		FROM matches
		WHERE match_date = NEW.match_date AND referee_id = NEW.referee_id;
		
			IF num_matches > 3 THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'A referee cannot be in more than 3 matches per day.';
		END IF;
END //
DELIMITER ;
	

DELIMITER //
CREATE OR REPLACE TRIGGER incorrect_referee_nationality
BEFORE INSERT ON matches
FOR EACH ROW
BEGIN	
		DECLARE ref_nat VARCHAR(60);
		DECLARE p1_nat VARCHAR(60);
		DECLARE p2_nat VARCHAR(60);
		
		SELECT nationality
		INTO ref_nat
		FROM people
		WHERE person_id = NEW.referee_id
		LIMIT 1;
		
		SELECT nationality
		INTO p1_nat
		FROM people
		WHERE person_id = NEW.player1_id
		LIMIT 1;
		
		SELECT nationality
		INTO p2_nat
		FROM people
		WHERE person_id = NEW.player2_id
		LIMIT 1;
	
		IF ref_nat = p1_nat OR ref_nat = p2_nat THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'The referee cannot have the same nationality as any of the two players of the match.';
		END IF;
END //
DELIMITER ;	
		
		
DELIMITER //
CREATE OR REPLACE TRIGGER incorrect_referee_age
BEFORE INSERT ON referees
FOR EACH ROW
BEGIN
		DECLARE ref_age INT;
		
		SELECT age
		INTO ref_age
		FROM people
		WHERE person_id = NEW.referee_id;
		
		IF ref_age < 18 THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'A referee cannot be a minor.';
		END IF;
END //
DELIMITER ;


DELIMITER //
CREATE OR REPLACE TRIGGER incorrect_player_age
BEFORE INSERT ON players
FOR EACH ROW
BEGIN
		DECLARE player_age INT;
		
		SELECT age
		INTO player_age
		FROM people
		WHERE person_id = NEW.player_id;
		
		IF player_age < 18 THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'A player cannot be a minor.';
		END IF;
END //
DELIMITER ;