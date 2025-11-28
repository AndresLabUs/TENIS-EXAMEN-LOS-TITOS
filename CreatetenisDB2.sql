DROP TABLE if EXISTS entradas;
DROP TABLE IF EXISTS sets;
DROP TABLE IF EXISTS matches;
DROP TABLE if EXISTS aficionados;
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
CONSTRAINT uniqueName UNIQUE (`name`)
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
CONSTRAINT minPlayerRanking CHECK(ranking <= 1000)
);

-- Creacion tabla aficionados
CREATE TABLE aficionados (
aficionado_id INT NOT NULL AUTO_INCREMENT,
PRIMARY KEY (aficionado_id),
FOREIGN KEY(aficionado_id) REFERENCES people(person_id) ON DELETE CASCADE
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
PRIMARY KEY (set_order, match_id) ,
FOREIGN KEY (match_id) REFERENCES matches(match_id) ON DELETE CASCADE
);

-- Creacion tabla entradas
CREATE TABLE entradas (
entrada_id INT NOT NULL AUTO_INCREMENT,
aficionado_id INT NOT NULL,
match_id INT NOT NULL,
precio DECIMAL(4,2) NOT NULL,
localidad VARCHAR(60) NOT NULL,
fecha_entrada DATE NOT NULL,
PRIMARY KEY (entrada_id),
FOREIGN KEY (aficionado_id) REFERENCES aficionados(aficionado_id) ON DELETE CASCADE,
FOREIGN KEY (match_id) REFERENCES matches(match_id) ON DELETE CASCADE
);