DROP DATABASE IF EXISTS x_twitter_db;
CREATE DATABASE x_twitter_db;
USE x_twitter_db;

-- CREANDO SIMULACIÓN DE BASE DE DATOS X_TWITTER. PARTE 01. 

/*PASO 01. CREAR LA BASE DE DATOS E INGRESAR A ELLA. */

/* PASO 02. CREACIÓN DE LA TABLA DE USUARIOS. 
Asegurarse de indicar "auto_increment" para la columna de user_id,
Definir como PK la columna de user_id al final.
Se utiliza la función NOW en la columna created_at para registrar la hora exacta de creación*/

DROP TABLE IF EXISTS users_1;
CREATE TABLE users_1 (
  user_id INT NOT NULL AUTO_INCREMENT,
  user_handle VARCHAR (50) NOT NULL UNIQUE,
  email_address VARCHAR (50) NOT NULL UNIQUE,
  first_name VARCHAR (100) NOT NULL,
  last_name VARCHAR (100) NOT NULL,
  phonenumber CHAR (10) UNIQUE,
  created_at TIMESTAMP NOT NULL DEFAULT (NOW()),
  follower_count INT NOT NULL DEFAULT 0,
  PRIMARY KEY(user_id)
  );
  
  -- PASO 03. CREAR VALORES FICTICIOS PARA INSERTAR EN LAS COLUMNAS DE LA TABLA DE USUARIOS.
  
INSERT INTO users_1(user_handle, email_address, first_name, last_name, phonenumber)
VALUES
('deidher','deidher@gmail.com', 'Diana','Herrera','6410912365'),
('Mike1','user1@gmail.com','Miguel','Lopez','6157859082'),
('Tan2', 'user2@outlook.com','Tanhia','Moriel','8709437162'),
('Jo3','user3@gmail.com','José', 'Hernandez','7689501429'),
('Isa4', 'user4gmail.com','Isabel','Martinez','0873561928'),
('Anton5','user5@outlook.com','Antonio','Ezpinoza','8791620567'),
('Lu6', 'user6@hotmail.com','Lucy','Rodriguez','6789560354'),
('anni7','user7@gmail.com','Anna','Díaz','4598013465'),
('Dav8','user8@hotmail.com','David','Fuentes','9809651245'),
('Hell9', 'user9@gmail.com','Helena','Lugo','7865674534'),
('Oli10','user10@gmail.com','Oliver','Medina','1243587901');

/* PASO 04. CREACIÓN DE LA TABLA PARA ALMACENAR LA RELACIÓN DE SEGUIDORES.
Se crean solo dos columnas, id de quien sigue (follower_id) y id de a quien sigue (following_id)
Se agrega una restricción usando CHECK, el id no puede ser el mismo.
Se indican ambas columnas como llaves foraneas referenciando a la columna user_id de la tabla users_1
Finalmente se indican las PK de la tabla que son las dos columnas creadas.
*/

DROP TABLE IF EXISTS followers_2;
CREATE TABLE followers_2 (
follower_id INT NOT NULL,
following_id INT NOT NULL,
CHECK(follower_id <> following_id),
FOREIGN KEY(follower_id) REFERENCES users_1(user_id),
FOREIGN KEY(following_id) REFERENCES users_1(user_id),
PRIMARY KEY(follower_id, following_id)
);

/* PASO 05. Creación de la tabla para almacenar el contenido de los "tweets".
Se crea bajo los mismos términos de la tabla de usuarios.
La columna de user_id se indica como FK referenciando la columna de user_id de la tabla users_1.
Se define como PK la columna de tweet_id.
*/

DROP TABLE IF EXISTS tweets_3;
CREATE TABLE tweets_3 ( 
tweet_id INT NOT NULL AUTO_INCREMENT,
user_id INT NOT NULL,
tweet_text VARCHAR (290) NOT NULL,
likes INT DEFAULT 0,
num_retweets INT DEFAULT 0,
num_comments INT DEFAULT 0,
created_at TIMESTAMP NOT NULL DEFAULT (NOW()),
FOREIGN KEY (user_id) REFERENCES users_1(user_id),
PRIMARY KEY (tweet_id)
);

-- PASO 06. CREAR VALORES FICTICIOS PARA INSERTAR EN LAS COLUMNAS DE LA TABLA DE TWEETS.

INSERT INTO tweets_3 (user_id, tweet_text)
VALUES
(1,'¡Explorando nuevos horizontes! 🚀 #Aventuras #Viajes'),
(2,'Disfrutando de un día soleado en el parque. 🌞 #Naturaleza #Relax'),
(3,'Última lectura: "El misterio del jardín". Recomiendo este libro a todos los amantes de los enigmas. 📚 #Libros #Misterio'),
(4,'¡Practicando cocina! Hoy hice una deliciosa pizza casera. 🍕 #CocinaCasera #Foodie'),
(5,'Increíble concierto anoche. 🎶 La música tiene el poder de unir a las personas. #Música #Concierto'),
(6,'Nuevo hobby: la fotografía. Comparto una de mis capturas favoritas. 📷 #Fotografía #Pasión'),
(7,'Reflexionando sobre la vida y la gratitud. ¿Cuál es tu mantra diario? ✨ #Reflexiones #Gratitud'),
(8,'¡Comienza mi viaje de fitness! 💪 Primer día en el gimnasio. #Fitness #VidaSaludable'),
(9,'No hay nada como una tarde de películas. ¿Algún recomendación? 🍿🎬 #Películas #Entretenimiento'),
(10,'Creando arte con acuarelas. 🎨 Comparto mi última obra. #Arte #Creatividad'),
(11,'Aprendiendo algo nuevo cada día. Hoy: programación en Python. 🐍 #Aprendizaje #Programación'),
(4,'Disfrutando de un día de sol y lectura en el parque. 🌞📖 #DomingoRelajante'),
(3,'¡Nuevo récord en el gimnasio! 💪 Superando mis límites. #Fitness #LogrosPersonales'),
(5,'Cocinando algo especial para la cena. ¿Alguna sugerencia de receta? 🍲 #CocinaCreativa'),
(11,'Aprendiendo a tocar la guitarra. 🎸 ¡La música es mi nueva terapia! #AprendizajeMusical'),
(11,'No hay nada como una película en casa y palomitas. 🍿🎬 #NocheDePelículas'),
(7,'Explorando nuevos destinos en el mapa. ¿Recomendaciones de viaje? ✈️ #AventurasPorVivir'),
(5,'¡El arte de la fotografía me tiene cautivado! 📷 Capturando momentos únicos. #PasiónPorLaFoto'),
(4,'Reflexionando sobre metas y sueños. ¡A por ellos con determinación! 💫 #ReflexionesPersonales'),
(5, 'Practicando la jardinería en mi pequeño oasis. 🌷🌿 #JardínFeliz')
;

/* PASO 07. CREACIÓN DE LA TABLA PARA ALMACENAR LA RELACIÓN DE LOS LIKES PARA CADA TWEET.
Contiene solo dos columnas que se indican como FK refrenciando columnas de las tablas de usuarios y de tweets.
Ambas columnas se indican al final como PK.
*/

CREATE TABLE tweet_likes_4 (
user_id INT NOT NULL,
tweet_id INT NOT NULL,
FOREIGN KEY (user_id) REFERENCES users_1 (user_id),
FOREIGN KEY (tweet_id) REFERENCES tweets_3 (tweet_id),
PRIMARY KEY (user_id, tweet_id)
);

-- PASO 08. CREAR CONTENIDO FICTICIO DE RELACIÓN PARA INSERTAR EN LA TABLA.

INSERT INTO tweet_likes_4 (user_id, tweet_id)
VALUES
(1,3),(1,6),(3,7),(4,7),(1,7),(3,6),(2,7),(5,7),(8,1),(9,8),(10,11),(11,9),(11,10);


/* PASO 09.EJEMPLOS DE CONSULTAS PARA LA RECUPERACIÓN DE INFORMACIÓN EN x_twitter_db*/

USE x_twitter_db;

-- OBTENIENDO LOS TWEETS DE LOS USUARIOS CON UN NÚMERO DE SEGUIDORES RELEVANTE MEDIANTE UN JOIN Y UNA SUBCONSULTA

SELECT t.tweet_text, t.user_id, u.follower_count FROM tweets_3 AS t
JOIN users_1 AS u ON t.user_id = u.user_id
WHERE t.user_id IN (
       SELECT following_id FROM followers_2
       GROUP BY following_id
       HAVING COUNT(*)>2)
;

/*PARA CREAR LOS TWEETS CON MÁS LIKES, USUARIOS CON MÁS SEGUIDORES,
SE SIGUE LA LÓGICA DE LOS PASOS ANTERIORES SEGÚN LOS REQUERIMIENTOS */

SELECT * FROM users_1;


