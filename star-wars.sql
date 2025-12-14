CREATE TABLE Jedi (
    id_jedi SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    especie VARCHAR(50),
    rango VARCHAR(50)
);

CREATE TABLE Sith (
    id_sith SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    maestro VARCHAR(100)
);

CREATE TABLE Clones (
    id_clon SERIAL PRIMARY KEY,
    nombre_clave VARCHAR(100),
    unidad VARCHAR(100)
);

CREATE TABLE Droides (
    id_droide SERIAL PRIMARY KEY,
    modelo VARCHAR(100),
    fabricante VARCHAR(100)
);

CREATE TABLE Sables (
    id_sable SERIAL PRIMARY KEY,
    color VARCHAR(50),
    modelo VARCHAR(50)
);

CREATE TABLE Tiene_Sable (
    id_sable INT REFERENCES Sables(id_sable),
    id_dueño INT,
    fecha_inicio DATE,
    fecha_fin DATE,
    PRIMARY KEY (id_sable, id_dueño, fecha_inicio)
);

CREATE TABLE Bandos (
    id_dueño INT,
    bando VARCHAR(50),
    fecha_inicio DATE,
    fecha_fin DATE,
    tipo_dueño VARCHAR(10) CHECK (tipo_dueño IN ('Jedi', 'Sith', 'Clon', 'Droide')),
    PRIMARY KEY (id_dueño, bando, fecha_inicio)
);

CREATE TABLE Guerras (
    id_guerra SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    fecha_inicio DATE,
    fecha_fin DATE
);

CREATE TABLE Participaciones (
    id_participante INT,
    id_guerra INT REFERENCES Guerras(id_guerra),
    fecha_participacion DATE,
    tipo_participante VARCHAR(10) CHECK (tipo_participante IN ('Jedi', 'Sith', 'Clon', 'Droide')),
    resultado VARCHAR(10) CHECK (resultado IN ('Gano', 'Perdio', 'Empate')),
    PRIMARY KEY (id_participante, id_guerra, fecha_participacion)
);

INSERT INTO Jedi (id_jedi, nombre, especie, rango)
VALUES
(1, 'Anakin Skywalker', 'Humano', 'Caballero'),
(2, 'Obi-Wan Kenobi', 'Humano', 'Maestro'),
(3, 'Luke Skywalker', 'Humano', 'Caballero'),
(4, 'Mace Windu', 'Humano', 'Maestro'),
(5, 'Qui-Gon Jinn', 'Humano', 'Maestro'),
(6, 'Ahsoka Tano', 'Togruta', 'Padawan'),
(7, 'Kit Fisto', 'Nautolano', 'Maestro'),
(8, 'Rey Palpatine', 'Humano', NULL);

INSERT INTO Sith (id_sith, nombre, maestro)
VALUES
(9, 'General Grievous', 'Conde Dooku'),
(10, 'Darth Vader', 'Darth Sidious'),
(11, 'Darth Maul', 'Darth Sidious'),
(12, 'Emperador Palpatine', 'Plagueis'),
(13, 'Conde Dooku', 'Yoda'),
(14, 'Kylo Ren', 'Snoke');

INSERT INTO Clones (id_clon, nombre_clave, unidad)
VALUES
(20, 'Rex', '501st'),
(21, 'Cody', '212th'),
(22, 'Bly', '327th'),
(23, 'Hevy', 'Domino'),
(24, 'Echo', '501st'),
(25, 'Fives', '501st');

INSERT INTO Droides (id_droide, modelo, fabricante)
VALUES
(15, 'Droide de combate', 'Techno Union'),
(16, 'Droide de taller', 'Tatooine Works'),
(18, 'R2-D2', 'Industrial Automaton'),
(19, 'Droide Asesino IG-88', 'Laboratorios Holowan'),
(17, 'C-3PO', 'Cybot Galactica');

INSERT INTO Sables (id_sable, color, modelo)
VALUES
(1, 'Azul', 'Sable original de Anakin'),
(2, 'Azul', 'Sable reconstruido de Anakin'),
(3, 'Rojo', 'Sable de Darth Vader'),
(5, 'Verde', 'Sable construido por Luke'),
(6, 'Morado', 'Sable de Mace Windu'),
(7, 'Rojo', 'Triple piedra rota de Kylo Ren'),
(8, 'Rojo', 'Doble hoja de Darth Maul'),
(9, 'Verde', 'Sable de Ahsoka'),
(4, 'Azul', 'Sable de Obi Wan');

INSERT INTO Tiene_Sable (id_sable, id_dueño, fecha_inicio, fecha_fin)
VALUES
(1, 1, '2000-01-01', '2005-05-04'),
(2, 1, '2005-05-04', '2005-05-19'),
(5, 3, '2010-01-01', NULL),
(6, 4, '2000-01-01', '2005-01-01'),
(1, 8, '2019-12-20', NULL),
(4, 2, '2005-05-19', '2008-01-01'),
(1, 3, '1999-01-01', '2001-01-01'),
(9, 6, '2008-01-01', NULL),
(7, 14, '2015-01-01', NULL);

INSERT INTO Bandos (id_dueño, bando, fecha_inicio, fecha_fin, tipo_dueño)
VALUES
(1, 'República', '2000-01-01', '2005-05-19', 'Jedi'),
(2, 'República', '2000-01-01', '2005-05-19', 'Jedi'),
(3, 'Rebeldes', '2000-01-01', '2035-12-20', 'Jedi'),
(4, 'República', '2000-01-01', '2005-05-19', 'Jedi'),
(5, 'República', '2000-01-01', '2000-12-01', 'Jedi'),
(6, 'República', '2000-01-01', '2003-12-31', 'Jedi'),
(7, 'República', '2000-01-01', '2005-05-19', 'Jedi'),
(20, 'República', '2002-01-01', '2005-05-19', 'Clon'),
(10, 'Imperio', '2005-05-19', '2008-01-01', 'Sith'),
(25, 'República', '2002-01-01', '2005-05-19', 'Clon'),
(15, 'Separatistas', '2001-05-01', '2005-05-19', 'Droide'),
(18, 'Rebeldes', '2000-07-08', '2035-12-20', 'Droide'),
(21, 'República', '2002-01-01', '2005-05-19', 'Clon'),
(13, 'Separatistas', '1999-01-01', '2000-12-01', 'Sith'),
(11, 'Imperio', '2000-01-01', '2004-12-31', 'Sith'),
(17, 'Rebeldes', '2000-01-06', '2035-12-20', 'Droide'),
(22, 'República', '2002-01-01', '2005-05-19', 'Clon'),
(23, 'República', '2002-01-01', '2005-05-19', 'Clon'),
(12, 'Separatistas', '2000-01-01', '2002-01-01', 'Sith'),
(14, 'Imperio', '2015-01-01', '2035-12-20', 'Sith'),
(24, 'República', '2002-01-01', '2005-05-19', 'Clon'),
(9, 'Separatistas', '1999-04-01', '2005-05-19', 'Sith');

INSERT INTO Guerras (id_guerra, nombre, fecha_inicio, fecha_fin)
VALUES
(1, 'Guerra de los Clones', '2002-01-01', '2005-05-19'),
(2, 'Guerra Civil Galactica', '2000-01-01', '2004-10-30'),
(3, 'Guerra Rebelde', '2002-01-01', '2000-12-15'),
(4, 'El Imperio Contraataca', '2003-01-01', '2003-12-31'),
(5, 'El Ascenso de Skywalker', '2035-01-01', '2035-12-20');

INSERT INTO Participaciones (id_participante, id_guerra, fecha_participacion, tipo_participante, resultado)
VALUES
(1, 1, '2002-01-01', 'Jedi', 'Gano'),
(2, 1, '2002-01-01', 'Jedi', 'Gano'),
(3, 2, '2000-01-01', 'Jedi', 'Gano'),
(4, 1, '2002-01-01', 'Jedi', 'Gano'),
(5, 1, '2002-01-01', 'Jedi', 'Perdio'),
(6, 2, '2000-01-01', 'Jedi', 'Gano'),
(7, 2, '2000-01-01', 'Jedi', 'Gano'),
(2, 3, '2002-01-01', 'Jedi', 'Perdio'),
(3, 4, '2003-01-01', 'Jedi', 'Perdio'),
(3, 5, '2035-01-01', 'Jedi', 'Gano'),
(4, 2, '2005-05-15', 'Clon', 'Gano'),
(23, 5, '2002-01-01', 'Clon', 'Perdio'),
(20, 1, '2005-05-15', 'Clon', 'Gano'),
(24, 1, '2035-01-01', 'Clon', 'Gano'),
(25, 2, '2005-05-15', 'Clon', 'Gano');

-- Listar todos Jedi y su rango
SELECT nombre, rango
FROM jedi;

-- Listar todos los sables laser de 'Anakin Skywalker'
SELECT sables.id_sable, color, modelo
FROM sables
JOIN tiene_sable ON sables.id_sable = tiene_sable.id_sable
JOIN jedi ON tiene_sable.id_dueño = jedi.id_jedi
WHERE jedi.nombre = 'Anakin Skywalker';


-- Listar todos los sables con el nombre de su propietario actual
SELECT id_sable AS id, jedi.nombre 
FROM tiene_sable
JOIN jedi ON id_jedi = id_dueño
WHERE fecha_fin IS NULL;


-- Contar cuantos clones hay en cada unidad
SELECT unidad, count(*) as cantidad_clones
FROM clones
GROUP BY unidad;


-- Listar todos los participantes de una guerra especifica (id_guerra = 1)
SELECT *
FROM participaciones
WHERE id_guerra = 1;


-- Numero de guerras en la que participo cada clon y su unidad
SELECT id_clon, COUNT(DISTINCT id_guerra) AS cantidad_guerras, unidad
FROM participaciones
JOIN clones ON id_participante = id_clon
WHERE tipo_participante = 'Clon'
GROUP BY id_clon;


-- Buscar todos los droides de un modelo especifico (IG-88)
SELECT * 
FROM droides
WHERE modelo LIKE '%IG-88%';


-- Jedi con mejor desempeño proporcional ASI quedaria god
/*
SELECT nombre, id_participante, COUNT(*) AS total_participaciones,
COUNT(CASE WHEN resultado = 'Gano' THEN 1 END) AS total_ganadas,
CONCAT(ROUND(COUNT(CASE WHEN resultado = 'Gano' THEN 1 END) * 100.0 / COUNT(*), 2), '%') AS desempeño
FROM Participaciones
JOIN jedi ON id_participante = id_jedi
WHERE tipo_participante = 'Jedi'
GROUP BY id_participante, nombre
ORDER BY (COUNT(CASE WHEN resultado = 'Gano' THEN 1 END) * 1.0 / COUNT(*)) DESC;
*/


-- asi bastaba
SELECT id_participante, COUNT(*) AS total_participaciones,
COUNT(CASE WHEN resultado = 'Gano' THEN 1 END) AS total_ganadas,
COUNT(CASE WHEN resultado = 'Gano' THEN 1 END) * 100.0 / COUNT(*) AS desempeño
FROM Participaciones
WHERE tipo_participante = 'Jedi'
GROUP BY id_participante
ORDER BY desempeño DESC
LIMIT 1;


-- Contar numeros de jedi por rango
SELECT count(*) AS cant_jedi, rango
FROM jedi
GROUP BY rango;


-- Promedio de victorias jedi
SELECT AVG(CASE WHEN resultado = 'Gano' THEN 1.0 ELSE 0 END) AS promedio_victorias
FROM Participaciones
WHERE tipo_participante = 'Jedi';


-- Numero de guerras ganadas por cada tipo de participante
SELECT tipo_participante, COUNT(*) AS guerras_ganadas
FROM Participaciones
WHERE resultado = 'Gano'
GROUP BY tipo_participante
ORDER BY guerras_ganadas DESC;


-- Droides que no participaron en ninguna guerra
-- aca no funciona pq hay otros participantes con el mismo id que son clones por ejemplo
-- para arreglar eso con la tabla personas se normaliza la base de datos tipo_persona
-- y las tablas jedi, sith, clon, droide tiene atributos propios de cada uno
/*
SELECT droides.*
FROM Droides
LEFT JOIN Participaciones ON id_droide = id_participante
WHERE id_participante IS NULL;
*/
-- otra opcion es asumir que los id no se repiten en ninguna tabla es decir si hay un jedi con id 1 
-- en nignguna otra tabla puede estar el 1, otra opcion es en el left join agregar que el participante tiene que ser droide
SELECT droides.*
FROM Droides
LEFT JOIN Participaciones ON id_droide = id_participante AND tipo_participante = 'Droide'
WHERE id_participante IS NULL;


-- Listar sables que han cambiado de dueño mas de 1 vez
SELECT sables.id_sable, color, modelo, COUNT(DISTINCT id_dueño) -1  AS veces_cambiado
FROM tiene_sable
JOIN sables ON sables.id_sable = tiene_sable.id_sable
GROUP BY sables.id_sable
HAVING COUNT(DISTINCT id_dueño) > 2;


-- Listar todas las guerras y cuantos clones participaron 
SELECT guerras.id_guerra,guerras.nombre,
COUNT(participaciones.id_participante) AS clones_participantes
FROM guerras
LEFT JOIN participaciones ON guerras.id_guerra = participaciones.id_guerra
AND tipo_participante = 'Clon'
GROUP BY guerras.id_guerra;


-- Nombre de todos los jedi que alguna vez usaron un sable de color verde
SELECT DISTINCT nombre
FROM jedi
JOIN tiene_sable ON id_dueño = id_jedi
JOIN sables ON sables.id_sable = tiene_sable.id_sable
WHERE color = 'Verde';


-- Listar todos los sith y sus maestros
SELECT nombre AS nombre_sith, maestro
FROM sith;


-- Listar todos los bandos
SELECT  DISTINCT bando
FROM bandos;


-- Total miembros de cualquier bando ejemplo Imperio
SELECT COUNT(*) AS miembros_imperio
FROM bandos
WHERE bando = 'Imperio';


-- Todas las participaciones de guerra en los ultimos 30 dias 
SELECT * 
FROM participaciones
WHERE fecha_participacion BETWEEN '2025-04-15' AND '2025-05-15';


-- Sables con mas de 2 años con Luke Skywalker
SELECT sables.*
FROM tiene_sable 
JOIN jedi ON id_jedi = id_dueño
JOIN sables ON sables.id_sable = tiene_sable.id_sable
WHERE fecha_fin - fecha_inicio > 730 AND nombre = 'Luke Skywalker';
