-- Test para el rn02a
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_adult_age_player()
BEGIN
	DECLARE exit handler FOR sqlexception
		CALL p_log_test('RN-02a', 'RN-02a: No se permite un player menor de 18', 'PASS');
		
	CALL p_populate_db2();
	INSERT INTO people (NAME, age, nationality) VALUES ('Young Player', 10, 'España');
	
	SET @player_id = LAST_INSERT_ID();
	INSERT INTO players (player_id, ranking) VALUES (@player_id, '100');
	CALL p_log_status('RN-02a', 'ERROR: Se insertó una persona menor de edad', 'FAIL');
END //
DELIMITER ;

-- Test para el rn02b
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_adult_age_referee()
BEGIN
	DECLARE exit handler FOR sqlexception
		CALL p_log_test('RN-02b', 'RN-02b: No se permite un referee menor de 18', 'PASS');
		
	CALL p_populate_db2();
	INSERT INTO people (NAME, age, nationality) VALUES ('Young Player', 10, 'España');
	
	SET @referee_id = LAST_INSERT_ID();
	INSERT INTO referees (referee_id, license) VALUES (@referee_id, 'Nacional');
	CALL p_log_status('RN-02b', 'ERROR: Se insertó una persona menor de edad', 'FAIL');
END //
DELIMITER ;

-- Test para el rn03
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn03_unique_name()
BEGIN
	DECLARE exit handler FOR sqlexception
		CALL p_log_test('RN-03', 'RN-03: El nombre debe de ser unico', 'PASS');
	
	CALL p_populate_db2();
	INSERT INTO people (NAME, age, nationality) VALUES ('Carlos Alcaraz', 20, 'España');
	CALL p_log_test('RN-03', 'ERROR: Se insertó una persona con nombre repetido', 'FAIL');
END //
DELIMITER ;

-- Test para el rn04a
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn04_invalid_ranking()
BEGIN
	DECLARE exit handler FOR sqlexception
		CALL p_log_test('RN-04', 'RN-04a: El ranking de un jugador debe de ser menor de 1000', 'PASS');
	
	CALL p_populate_db2();
	INSERT INTO players (ranking) VALUES (2000);
	CALL p_log_test('RN-04', 'ERROR: Se insertó un jugador con ranking mayor que 1000', 'FAIL');
END //
DELIMITER ;

-- Test para el rn04b
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn04_zero_ranking()
BEGIN
	DECLARE exit handler FOR sqlexception
		CALL p_log_test('RN-04a', 'RN-04b: El ranking de un jugador no puede ser nulo', 'PASS');
	
	CALL p_populate_db2();
	INSERT INTO players (ranking) VALUES (0);
	CALL p_log_test('RN-04b', 'ERROR: Se insertó un jugador con ranking nulo', 'FAIL');
END //
DELIMITER ;

-- Test para el rn05
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn05_same_player()
BEGIN
	DECLARE exit handler FOR sqlexception
		CALL p_log_test('RN-05', 'RN-05: Un jugador no puede jugar con el mismo', 'PASS');
	
	CALL p_populate_db2();
	INSERT INTO matches (referee_id, player1_id, player2_id, winner_id, tournament, match_date, `round`, duration)
	VALUES (16, 17, 14, 14, 14, 'Laver Cup 2025', '2025-09-25', 'Exhibición', 120);
	CALL p_log_test('RN-05', 'ERROR: Se insertó un partido con un jugador contra el mismo', 'FAIL');
END //
DELIMITER ;

-- Test para el rn06
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn06_max_matches_referee()
BEGIN
	DECLARE exit handler FOR sqlexception
		CALL p_log_test('RN-06', 'RN-06: Un arbitro no puede arbitrar mas de 3 partidos el mismo dia', 'PASS');
	
	CALL p_populate_db2();
	INSERT INTO matches (referee_id, player1_id, player2_id, winner_id, tournament, match_date, `round`, duration)
	VALUES (16, 17, 14, 13, 14, 'Laver Cup 2026', '2025-09-25', 'Exhibición', 120);
	INSERT INTO matches (referee_id, player1_id, player2_id, winner_id, tournament, match_date, `round`, duration)
	VALUES (16, 17, 14, 13, 14, 'Laver Cup 2027', '2025-09-25', 'Exhibición', 120);
	INSERT INTO matches (referee_id, player1_id, player2_id, winner_id, tournament, match_date, `round`, duration)
	VALUES (16, 17, 14, 13, 14, 'Laver Cup 2028', '2025-09-25', 'Exhibición', 120);
	INSERT INTO matches (referee_id, player1_id, player2_id, winner_id, tournament, match_date, `round`, duration)
	VALUES (16, 17, 14, 13, 14, 'Laver Cup 2029', '2025-09-25', 'Exhibición', 120);
	CALL p_log_test('RN-06', 'ERROR: Un arbitro no puede tener mas de 3 partidos arbitrados en un mismo dia', 'FAIL');
END //
DELIMITER ;

-- Test para el rn07a
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn07_same_nationality_p1_r()
BEGIN
	DECLARE exit handler FOR sqlexception
		CALL p_log_test('RN-07a', 'RN-07a: Un arbitro no puede tener la misma nacionalidad que los jugadores', 'PASS');
		
	CALL p_populate_db2();
	
	INSERT INTO matches (referee_id, player1_id, player2_id, winner_id, tournament, match_date, `round`, duration)
	VALUES (7, 17, 2, 13, 2, 'Laver Cup 2026', '2025-09-25', 'Exhibición', 120);
	CALL p_log_test('RN-07a', 'ERROR: Se insertaron un jugador y un arbitro con la misma nacinalidad', 'FAIL');
END //
DELIMITER ;

-- Test para el rn07b
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn07_same_nationality_p2_r()
BEGIN
	DECLARE exit handler FOR sqlexception
		CALL p_log_test('RN-07b', 'RN-07b: Un arbitro no puede tener la misma nacionalidad que los jugadores', 'PASS');
		
	CALL p_populate_db2();
	
	INSERT INTO matches (referee_id, player1_id, player2_id, winner_id, tournament, match_date, `round`, duration)
	VALUES (7, 17, 13, 2, 2, 'Laver Cup 2026', '2025-09-25', 'Exhibición', 120);
	CALL p_log_test('RN-07b', 'ERROR: Se insertaron un jugador y un arbitro con la misma nacinalidad', 'FAIL');
END //
DELIMITER ;

-- Test para el rn08
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn08_age_aficionado()
BEGIN
	DECLARE exit handler FOR sqlexception
		CALL p_log_test('RN-08', 'RN-08: No se permite un aficionado con menos de 12 años', 'PASS');
		
	CALL p_populate_db2();
	INSERT INTO people (NAME, age, nationality) VALUES ('Young Player', 10, 'España');
	
	SET @aficionado_id = LAST_INSERT_ID();
	INSERT INTO players (afionado_id) VALUES (@aficionado_id);
	CALL p_log_test('RN-08', 'ERROR: Se insertó un aficionado con menos de 12 años', 'FAIL');
END //
DELIMITER ;

-- Test para el rn09
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn09_entrada_date()
BEGIN
	DECLARE exit handler FOR sqlexception
		CALL p_log_test('RN-09', 'RN-09: No se permite comprar una entrada despues de la fecha del partido', 'PASS');
		
	CALL p_populate_db2();
	INSERT INTO entradas (aficionado_id, match_id, precio, localidad, fecha_entrada) VALUES (19, 1, 10.00, 'Sevilla', '2027-07-14');
	
	SET @aficionado_id = LAST_INSERT_ID();
	INSERT INTO players (afionado_id) VALUES (@aficionado_id);
	CALL p_log_test('RN-09', 'ERROR: Se insertó una entrada comprada despues de la fecha de un partido', 'FAIL');
END //
DELIMITER ;

CREATE OR REPLACE TABLE test_results (
	test_id VARCHAR(20) NOT NULL PRIMARY KEY,
	test_name VARCHAR(200) NOT NULL,
	test_message VARCHAR(500) NOT NULL,
	test_status ENUM('PASS','FAIL','ERROR') NOT NULL,
	execution_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE OR REPLACE PROCEDURE p_log_test(
	IN p_test_id VARCHAR(20),
	IN p_message VARCHAR(500),
	IN p_status ENUM('PASS','FAIL','ERROR')
)
BEGIN
	INSERT INTO test_results(test_id, test_name, test_message, test_status)
	VALUES (p_test_id, SUBSTRING_INDEX(p_message, ':', 1), p_message, p_status);
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_all_tests()
BEGIN
	DELETE FROM test_results;
	CALL p_test_rn02_adult_age_player();
	CALL p_test_rn02_adult_age_referee();
	CALL p_test_rn03_unique_name();
	CALL p_test_rn04_invalid_ranking();
	CALL p_test_rn04_zero_ranking();
	CALL p_test_rn05_same_player();
	CALL p_test_rn06_max_matches_referee();
	CALL p_test_rn07_same_nationality_p1_r();
	CALL p_test_rn07_same_nationality_p2_r();
	CALL p_test_rn08_age_aficionado();
	CALL p_test_rn09_entrada_date();
	
	
	SELECT * FROM test_results ORDER BY execution_time, test_id;
	SELECT test_status, COUNT(*) AS COUNT FROM test_results GROUP BY test_status;
END //
DELIMITER ;

CALL p_run_all_tests();