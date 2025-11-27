-- DELIMITER //
-- CREATE OR REPLACE PROCEDURE pCreateDB()
-- BEGIN
		DROP TABLE IF EXISTS sets;
		DROP TABLE IF EXISTS matches;
		DROP TABLE IF EXISTS players;
		DROP TABLE IF EXISTS referees;
		DROP TABLE IF EXISTS people;
		
		
		CREATE TABLE people(
		person_id INT NOT NULL AUTO_INCREMENT,
		name VARCHAR(60) NOT NULL,
		age INT NOT NULL,
		nationality VARCHAR(60) NOT NULL,
		PRIMARY KEY(person_id),
		CONSTRAINT invalidPersonAge CHECK(age >= 18),
		CONSTRAINT uniqueName UNIQUE(name)
		);
		
		CREATE TABLE referees(
		referee_id INT NOT NULL AUTO_INCREMENT,
		license VARCHAR(60),
		PRIMARY KEY(referee_id),
		FOREIGN KEY(referee_id) REFERENCES people(person_id) ON DELETE CASCADE
		);
		
		CREATE TABLE players(
		player_id INT NOT NULL AUTO_INCREMENT,
		license VARCHAR(60),
		PRIMARY KEY(player_id),
		FOREIGN KEY(player_id) REFERENCES people(person_id) ON DELETE CASCADE
		);
		
		CREATE TABLE matches(
		match_id INT NOT NULL AUTO_INCREMENT,
		referee_id INT NOT NULL,
		player1_id INT NOT NULL,
		player2_id INT NOT NULL,
		winner_id INT NOT NULL,
		tournament VARCHAR(60) NOT NULL,
		match_date DATE NOT NULL,
		round VARCHAR(60),
		duration INT NOT NULL,
		PRIMARY KEY(match_id),
		FOREIGN KEY(referee_id) REFERENCES people(person_id) ON DELETE CASCADE,
		FOREIGN KEY(player1_id) REFERENCES people(person_id) ON DELETE CASCADE,
		FOREIGN KEY(player2_id) REFERENCES people(person_id) ON DELETE CASCADE,
		FOREIGN KEY(winner_id) REFERENCES people(person_id) ON DELETE CASCADE,
		CONSTRAINT notSamePlayer UNIQUE(player1_id, player2_id)
		);
		
		CREATE TABLE sets(
		match_id INT NOT NULL,
		winner_id INT NOT NULL,
		set_order INT NOT NULL,
		score VARCHAR(60) NOT NULL,
		PRIMARY KEY(set_order),
		FOREIGN KEY(match_id) REFERENCES matches(match_id) ON DELETE CASCADE,
		FOREIGN KEY(winner_id) REFERENCES players(player_id) ON DELETE CASCADE,
		CONSTRAINT allowed_order CHECK(set_order IN (1,2,3,4,5))
		);