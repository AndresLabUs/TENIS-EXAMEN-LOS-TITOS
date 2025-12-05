DROP TABLE if EXISTS sets;
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS referees;
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS people;

-- Creacion tabla people
CREATE TABLE people (
person_id INT NOT NULL AUTO_INCREMENT,
`name` VARCHAR(60) NOT NULL,
age INT NOT NULL,
nationality VARCHAR(60) NOT NULL,
PRIMARY KEY(person_id),
CONSTRAINT uniqueName UNIQUE (`name`),
CONSTRAINT minAge CHECK(age >= 18)
);

-- Creacion tabla referees		
CREATE TABLE referees (
referee_id INT NOT NULL AUTO_INCREMENT,
license VARCHAR(60) NOT NULL,
PRIMARY KEY(referee_id),
FOREIGN KEY(referee_id) REFERENCES people (person_id) ON DELETE CASCADE
);

-- Creacion tabla players
CREATE TABLE players (
player_id INT NOT NULL AUTO_INCREMENT,
ranking INT NOT NULL,
PRIMARY KEY(player_id),
FOREIGN KEY(player_id) REFERENCES people (person_id) ON DELETE CASCADE,
CONSTRAINT minPlayerRanking CHECK(ranking > 0 AND ranking <= 1000)
);

-- Creacion tabla matches
CREATE TABLE matches (
match_id INT NOT NULL AUTO_INCREMENT,
referee_id INT NOT NULL,
player1_id INT NOT NULL,
player2_id INT NOT NULL,
winner_id INT NOT NULL,
tournament VARCHAR(60) NOT NULL,
match_date DATE NOT NULL,
`round` VARCHAR (60) NOT NULL,
duration INT NOT NULL,
PRIMARY KEY(match_id),
FOREIGN KEY(referee_id) REFERENCES people(person_id) ON DELETE CASCADE,
FOREIGN KEY(player1_id) REFERENCES people(person_id) ON DELETE CASCADE,
FOREIGN KEY(player2_id) REFERENCES people(person_id) ON DELETE CASCADE,
FOREIGN KEY(winner_id) REFERENCES people(person_id) ON DELETE CASCADE,
CONSTRAINT notSamePlayer check (player1_id != player2_id)
);

-- Creacion tabla sets
CREATE TABLE sets (
set_order INT NOT NULL AUTO_INCREMENT,
match_id INT NOT NULL,
winner_id INT NOT NULL,
score VARCHAR(60) NOT NULL,
PRIMARY KEY (set_order, match_id),
FOREIGN KEY (match_id) REFERENCES matches(match_id) ON DELETE CASCADE
);

-- Trigger de la restriccion numero 6
DELIMITER //
CREATE OR REPLACE TRIGGER RN06_maxRefereeMatches
BEFORE INSERT ON matches
FOR EACH ROW
BEGIN 
	DECLARE num INT;
	SET num = (SELECT COUNT(*)
	FROM matches
	WHERE referee_id = NEW.referee_id
	AND match_date = NEW.match_date);
	
	if (num >= 3) then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
		'Un arbitro no puede arbitrar mas de 3 partidos en un dia';
	END if;
END//
DELIMITER ;

-- Trigger de la restriccion numero 7
DELIMITER //
CREATE OR REPLACE TRIGGER RN07_diferenteNacionalidad
BEFORE INSERT ON matches
FOR EACH ROW
BEGIN
	DECLARE n1 VARCHAR(60);
	DECLARE n2 VARCHAR(60);
	DECLARE n3 VARCHAR(60);
	SET n1 = (SELECT nationality
	FROM people WHERE person_id = NEW.referee_id);
	SET n2 = (SELECT nationality
	FROM people WHERE person_id = NEW.player1_id);
	SET n3 = (SELECT nationality
	FROM people WHERE person_id = NEW.player2_id);
	
	if (n1 = n2 OR n1 = n3) then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
		'La nacionalidad de un arbitro no puede coincidir con la de cualquiera de los tenistas';
	END if;
END//
DELIMITER ;