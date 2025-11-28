-- Trigger de la restriccion numero 2_1 (referee)
DELIMITER //
CREATE OR REPLACE TRIGGER RN02_1_adultAgeReferee
BEFORE INSERT ON referees
FOR EACH ROW
BEGIN
	DECLARE age_R INT;
	SET age_R = (SELECT age
	FROM people
	WHERE person_id = NEW.referee_id);
	
	if (age_R < 18) then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
		'Los arbitros no pueden ser menores de edad';
	END if;
END//
DELIMITER ;

-- Trigger de la restriccion numero 2_2 (player)
DELIMITER //
CREATE OR REPLACE TRIGGER RN02_2_adultAgePlayer
BEFORE INSERT ON players
FOR EACH ROW
BEGIN
	DECLARE age_P INT;
	SET age_P = (SELECT age
	FROM people WHERE person_id = NEW.player_id);
	
	if (age_P < 18) then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
		'Los jugadores no pueden ser menores de edad';
	END if;
END//
DELIMITER ;

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

-- Trigger de la restriccion numero 8
DELIMITER //
CREATE OR REPLACE TRIGGER RN08_ageAficionado
BEFORE INSERT ON aficionados
FOR EACH ROW
BEGIN
	DECLARE age_A INT;
	SET age_A = (SELECT age
	FROM people WHERE person_id = NEW.aficionado_id);
	
	if (age_A < 12) then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
		'Los aficionados no pueden tener menos de 12 años';
	END if;
END//
DELIMITER ;

-- Trigger de la restriccion numero 9
DELIMITER //
CREATE OR REPLACE TRIGGER RN09_CompraAntesPartido
BEFORE INSERT ON entradas
FOR EACH ROW
BEGIN
	DECLARE fecha_M DATE;
	SET fecha_M = (SELECT match_date
	FROM matches WHERE match_id = NEW.match_id);
	
	if (NEW.fecha_Entrada > fecha_M) then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
		'La fecha de la compra de la entrada no puede ser posterior al partido';
	END if;
END//
DELIMITER ;