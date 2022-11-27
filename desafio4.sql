-----crear base de datos----    
CREATE DATABASE desafio4_valeria_cortes_008;


1.-Crea el modelo (revisa bien cuál es el tipo de relación antes de crearlo), respeta las 
claves primarias, foráneas y tipos de datos.

----primera tabla----
CREATE TABLE films(
id SERIAL PRIMARY KEY,
name VARCHAR (255),
year INT); 


----segunda tabla----
CREATE TABLE tags(
id SERIAL PRIMARY KEY,
tag VARCHAR (32));
 



----tabla intermedia---
CREATE TABLE films_tag(
id SERIAL PRIMARY KEY,
films_id INT,
tag_id INT,
FOREIGN KEY ("films_id")
REFERENCES films(id),
FOREIGN KEY ("tag_id")
REFERENCES tags(id));



2.   Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la 
segunda película debe tener dos tags asociados. 

-----5 peliculas-----
INSERT INTO films(name, year)
VALUES('desde mi cielo', 2009), ('contratiempo', 2016), 
('isla siniestra', 2010), ('la vida es bella', 1997), ('titanic', 1997);

----5 tags-----
INSERT INTO tags(tag)
VALUES('violencia'),('drama'), ('suspenso'), ('vida real'), ('romance');


-----tags asociados a las peliculas-----
INSERT INTO films_tag(films_id, tag_id)
VALUES(1,1), (1,2),(1,3),(2,1), (2,2);


3.   Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe 
mostrar 0.

 SELECT films.name, COUNT(films_tag.tag_id) FROM films LEFT JOIN films_tag ON films.id = films_tag.films_id
 GROUP BY films.name DESC;



4. Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y  tipos de 
datos.
----primera tabla-----
CREATE TABLE questions(
    id SERIAL PRIMARY KEY,
    question VARCHAR (255),
    correct_answer VARCHAR);

    

----segunda tabla-----
CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    age INT CHECK (age >= 18));

  

-----tabla intermedia----
CREATE TABLE answers(
    id SERIAL PRIMARY KEY,
    answer VARCHAR (255),
    user_id INT,
    question_id INT,
    FOREIGN KEY ("user_id") REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY ("question_id") REFERENCES questions(id)
    );    





5. Agrega datos, 5 usuarios y 5 preguntas, la primera pregunta debe estar contestada 
dos veces correctamente por distintos usuarios, la pregunta 2 debe estar contestada 
correctamente sólo por un usuario, y las otras 2 respuestas deben estar incorrectas. 

---insertar 5 usuarios-----
  INSERT INTO users(name, age)
    VALUES('valeria', 27),
    ('sebastian', 41),
    ('juan', 43),
    ('oscar', 31),
    ('yarenla', 30);


----insertar 5 preguntas----
INSERT INTO questions(question, correct_answer)
    VALUES('¿cuántos minutos tiene una hora?', '60'),
    ('¿cuántas patas tiene una araña?' , '8'),
    ('¿cuantos kilos tiene una tonelada?','1000'),
    ('¿quién pintó la mona lisa?', 'leonardo da vinci'),
    ('¿cuál es el ave mas grande del mundo?', 'condor');    


----insertar respuestas-----
INSERT INTO answers(answer, user_id, question_id)
VALUES('60',1,1),
('60',2,1),
('1000', 4,3),
('pablo picasso', 5,4),
('avestruz', 3,5);



6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la 
pregunta). 

SELECT users.name, COUNT(answers.answer) as correct_answer FROM questions 
INNER JOIN answers ON questions.id = answers.question_id 
INNER JOIN users ON answers.user_id = users.id WHERE questions.correct_answer = answers.answer
 GROUP BY  users.name;





7. Por  cada  pregunta,  en  la  tabla  preguntas,  cuenta  cuántos  usuarios  tuvieron  la 
respuesta correcta.

SELECT questions.question, COUNT (users.id) AS users FROM users 
INNER JOIN answers ON users.id = answers.user_id INNER JOIN questions ON answers.question_id = questions.id 
WHERE questions.correct_answer = answers.answer GROUP BY questions.question; 


8.    Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el 
primer usuario para probar la implementación.
CREATE TABLE answers(
    id SERIAL PRIMARY KEY,
    answer VARCHAR (255),
    user_id INT,
    question_id INT,
    FOREIGN KEY ("user_id") REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY ("question_id") REFERENCES questions(id)
    );    

----en el caso de no haber aplicado del comienzo ON DELETE CASCADE se hacía de esta manera-----
    ALTER TABLE answers DROP CONSTRAINT answers_user_id_fkey, ADD FOREIGN KEY (users_id) REFERENCES users(id) ON DELETE CASCADE;


-----borrar el primer usuario----
   DELETE FROM users WHERE id= 1;    


   9.   Crea una restricción que impida insertar usuarios menores de 18 años en la base de 
datos.

----agregar restricción----
     ALTER TABLE users ADD CHECK (age >= 18);




10. Altera la tabla existente de usuarios agregando el campo email con la restricción de 
único.
---agregar campo email---
ALTER TABLE users ADD COLUMN email VARCHAR(30) UNIQUE;
