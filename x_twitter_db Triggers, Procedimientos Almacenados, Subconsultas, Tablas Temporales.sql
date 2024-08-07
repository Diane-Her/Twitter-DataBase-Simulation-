/*
PARTE 02.
2. La Creación de procesos almacenados y triggers para mantener actualizada la base de datos.
   El script puede ejecutarse por completo en una solo ejecución sin embargo para poder revisar cada proceso se recomienda ejecutarse por pasos.
   Fuente de Información: https://www.udemy.com/course/sql-para-analisis-de-datos-de-cero-a-experto/learn/lecture/40773024?start=0#overview
*/

/* PASO 01. CREACIÓN DE TRIGGERS PARA EL UPDATE DE CONTEOS Y SU COMPROBACIÓN DE EFECTIVIDAD
Iniciar por el trigger para la actualización de seguidores-usuarios */

SET GLOBAL log_bin_trust_function_creators = 1;

DROP TRIGGER IF EXISTS increase_follower_count;
DELIMITER //
	CREATE TRIGGER  increase_follower_count
	AFTER INSERT ON followers_2
	FOR EACH ROW
	BEGIN
		UPDATE users_1 SET follower_count = follower_count + 1
        WHERE user_id = NEW.following_id;
	END //
DELIMITER ;

-- COMPROBANDO LA DE ACTIVACIÓN DE TRIGGER

INSERT INTO followers_2 (follower_id, following_id)
VALUES
(1,2), (2,1),(3,1),(4,1),(5,6),(6,5),(2,5),(3,5),(4,6),(6,4),
(6,10),(7,8),(8,3),(10,7),(7,9),(9,7),(10,11),(10,4),(9,10),(10,9);

-- CREANDO TRIGGER PARA LA ELIMINACIÓN DE SEGUIDORES

DROP TRIGGER IF EXISTS decrease_follower_count;
DELIMITER //
CREATE TRIGGER decrease_follower_count
AFTER DELETE ON followers_2
FOR EACH ROW
BEGIN
    IF OLD.follower_id IS NOT NULL AND OLD.following_id IS NOT NULL THEN
        UPDATE users_1 SET follower_count = follower_count - 1
        WHERE user_id = OLD.following_id;
    END IF;
END //
DELIMITER ;

-- COMPROBANDO LA ACTIVACIÓN DEL TRIGGER

DELETE FROM followers_2 WHERE follower_id = 10 AND following_id = 9;
SELECT * FROM users_1;

/* PASO 03. CREACIÓN DE PROCESOS ALMACENADOS PARA LA RECUPERACIÓN Y ACTUALIZACIÓN DE INFORMACIÓN.*/


/* PASO 02. CREACIÓN DE PROCESOS ALMACENADOS PARA LA RECUPERACIÓN Y ACTUALIZACIÓN DE INFORMACIÓN.*/

-- CREANDO PROCEDIMIENTO ALMACENADO PARA LLEVAR EL CONTEO DE USUARIOS Y FECHA DE CREACIÓN

SET SQL_MODE = 1;

DROP PROCEDURE IF EXISTS p1_users_history;
DELIMITER //
CREATE PROCEDURE p1_users_history()
BEGIN
   SELECT user_id, user_handle, created_at
   FROM users_1;
END //
DELIMITER ;

CALL p1_users_history();

-- CREANDO P.A PARA EL CONTEO TOTAL DE USUARIOS

DROP PROCEDURE IF EXISTS p2_total_users;
DELIMITER //
CREATE PROCEDURE p2_total_users()
BEGIN
   SELECT CONCAT('El Total de Usuarios a la fecha ', CURDATE() , ' es: ', COUNT(user_id)) AS Total_users
   FROM users_1;
END //
DELIMITER ;

CALL p2_total_users();

-- CREANDO PROCESO ALMACENADO PARA LA INSERCIÓN DE NUEVOS USUARIOS

DROP PROCEDURE IF EXISTS p3_new_user;

DELIMITER //
CREATE PROCEDURE p3_new_user (IN user_handle VARCHAR (50),
						   IN email_address VARCHAR (50),
						   IN first_name VARCHAR (100),
						   IN last_name VARCHAR (100),
						   IN phonenumber CHAR (10))
BEGIN
    INSERT INTO users_1 (user_handle, email_address, first_name, last_name, phonenumber)
    VALUES (user_handle, email_address, first_name, last_name, phonenumber);
END //
DELIMITER ;

CALL p3_new_user ('user12','user12@outlook.com','Loren','Vela','6578910924');
CALL p1_users_history();

/*CREANDO TOP 3 CON MÁS SEGUIDORES A TRAVÉS DE LA CREACIÓN DE UNA TABLA TEMPORAL MEDIANTE UN PROCESO ALMACENADO*/

DROP PROCEDURE IF EXISTS PA_TOP_3;
DELIMITER //
CREATE PROCEDURE PA_TOP_3 ()
BEGIN
    DROP TEMPORARY TABLE IF EXISTS TOP_3;
    CREATE TEMPORARY TABLE TOP_3 AS
    SELECT user_id, user_handle, MAX(follower_count) AS follower_count
    FROM users_1
    GROUP BY user_id, user_handle
    ORDER BY follower_count DESC
    LIMIT 3;
    SELECT * FROM TOP_3;
END //
DELIMITER ;
CALL PA_TOP_3;

/* LAS TABLAS TEMPORALES SON IDEALES PARA ALMACENAR INFORMACIÓN DESECHABLE O QUE ESTÁ EN CONSTANTE CAMBIO,
COMO EN ESTE CASO, EL TOP 3 DE USUARIOS CON MÁS SEGUIDORES */

