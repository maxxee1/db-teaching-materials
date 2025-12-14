-- Creación de tablas
CREATE TABLE Artistas (
    id_artista SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    genero VARCHAR(50),
    nacionalidad VARCHAR(50)
);

CREATE TABLE Canciones (
    id_cancion SERIAL PRIMARY KEY,
    titulo VARCHAR(100),
    anio_lanzamiento INT,
    id_artista INT REFERENCES Artistas(id_artista)
);

CREATE TABLE Beats (
    id_beat SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    productor VARCHAR(100)
);

CREATE TABLE Usa_Beat (
    id_cancion INT REFERENCES Canciones(id_cancion),
    id_beat INT REFERENCES Beats(id_beat),
    PRIMARY KEY (id_cancion, id_beat)
);

CREATE TABLE Nominaciones (
    id_nom SERIAL PRIMARY KEY,
    categoria VARCHAR(100),
    id_artista INT REFERENCES Artistas(id_artista),
    id_cancion INT REFERENCES Canciones(id_cancion),
    anio INT,
    gano BOOLEAN
);

CREATE TABLE Beef (
    id_beef SERIAL PRIMARY KEY,
    id_artista1 INT REFERENCES Artistas(id_artista),
    id_artista2 INT REFERENCES Artistas(id_artista),
    motivo VARCHAR(200),
    anio_inicio INT
);


-- Inserts de ejemplo
INSERT INTO Artistas (nombre, genero, nacionalidad) VALUES
('Rihana', 'Pop', 'Barbados'),
('Drake', 'Hip Hop', 'Canada'),
('Kendrick Lamar', 'Hip Hop', 'USA'),
('Taylor Swift', 'Pop', 'USA'),
('Bad Bunny', 'Reggaeton', 'Puerto Rico');

INSERT INTO Canciones (titulo, anio_lanzamiento, id_artista) VALUES
('Umbrella', 2007, 1),
('Work', 2016, 1),
('Gods Plan', 2018, 2),
('HUMBLE', 2017, 3),
('Shake It Off', 2014, 4),
('Titi Me Pregunto', 2022, 5);

INSERT INTO Beats (nombre, productor) VALUES
('MetroBoominTypeBeat', 'Metro Boomin'),
('DrDreBeat', 'Dr. Dre'),
('TimbalandBeat', 'Timbaland'),
('MikeDeanBeat', 'Mike Dean');

INSERT INTO Usa_Beat (id_cancion, id_beat) VALUES
(1, 3),
(2, 1),
(3, 1),
(4, 2),
(5, 4),
(6, 1),
(3, 2);

INSERT INTO Nominaciones (categoria, id_artista, id_cancion, anio, gano) VALUES
('Álbum del Año', 1, 1, 2024, FALSE),
('Canción del Año', 2, 3, 2024, TRUE),
('Mejor Álbum de Rap', 3, 4, 2024, TRUE),
('Álbum del Año', 4, 5, 2024, FALSE),
('Canción del Año', 1, 2, 2025, FALSE),
('Mejor Álbum Urbano', 5, 6, 2025, TRUE);

INSERT INTO Beef (id_artista1, id_artista2, motivo, anio_inicio) VALUES
(2, 3, 'Competencia artística', 2024),
(1, 2, 'Colaboración fallida', 2016);


-- Consultas SQL

-- 1. Listar todos los artistas y su nacionalidad
SELECT nombre, nacionalidad
FROM Artistas;


-- 2. Listar todas las canciones del artista 'Rihana'
SELECT titulo
FROM Canciones
JOIN Artistas ON Canciones.id_artista = Artistas.id_artista
WHERE Artistas.nombre = 'Rihana';


-- 3. Listar todos los beats utilizados y qué canciones los usan
SELECT Beats.nombre AS beat, Canciones.titulo AS cancion
FROM Beats
JOIN Usa_Beat ON Beats.id_beat = Usa_Beat.id_beat
JOIN Canciones ON Usa_Beat.id_cancion = Canciones.id_cancion;


-- 4. Contar cuántas nominaciones tiene cada artista
SELECT Artistas.nombre, COUNT(Nominaciones.id_nom) AS total_nominaciones
FROM Artistas
JOIN Nominaciones ON Artistas.id_artista = Nominaciones.id_artista
GROUP BY Artistas.nombre;


-- 5. Listar todos los nominados en la categoría 'Álbum del Año' para el año 2024
SELECT Artistas.nombre
FROM Nominaciones
JOIN Artistas ON Nominaciones.id_artista = Artistas.id_artista
WHERE Nominaciones.categoria = 'Álbum del Año' AND Nominaciones.anio = 2024;


-- 6. Contar cuántas categorías distintas ha sido nominado cada artista
SELECT Artistas.nombre, COUNT(DISTINCT Nominaciones.categoria) AS categorias_distintas
FROM Artistas
JOIN Nominaciones ON Artistas.id_artista = Nominaciones.id_artista
GROUP BY Artistas.nombre;


-- 7. Buscar todas las canciones que usan un beat específico ('MetroBoominTypeBeat')
SELECT Canciones.titulo
FROM Canciones
JOIN Usa_Beat ON Canciones.id_cancion = Usa_Beat.id_cancion
JOIN Beats ON Usa_Beat.id_beat = Beats.id_beat
WHERE Beats.nombre = 'MetroBoominTypeBeat';


-- 8. Mostrar el artista con mejor desempeño proporcional (mayor % de nominaciones ganadas)
SELECT Artistas.nombre,
       COUNT(*) AS total_nominaciones,
       COUNT(CASE WHEN gano = TRUE THEN 1 END) AS total_ganadas,
       COUNT(CASE WHEN gano = TRUE THEN 1 END) * 100.0 / COUNT(*) AS porcentaje_ganadas
FROM Nominaciones
JOIN Artistas ON Nominaciones.id_artista = Artistas.id_artista
GROUP BY Artistas.nombre
ORDER BY porcentaje_ganadas DESC
LIMIT 1;


-- 9. Contar el número de artistas por nacionalidad
SELECT nacionalidad, COUNT(*) AS cantidad_artistas
FROM Artistas
GROUP BY nacionalidad;


-- 10. Mostrar el número de premios ganados agrupado por género musical
SELECT Artistas.genero, COUNT(Nominaciones.id_nom) AS premios_ganados
FROM Nominaciones
JOIN Artistas ON Nominaciones.id_artista = Artistas.id_artista
WHERE Nominaciones.gano = TRUE
GROUP BY Artistas.genero;


-- 11. Listar todos los artistas que nunca ganaron un Grammy
SELECT Artistas.nombre
FROM Artistas
LEFT JOIN Nominaciones ON Artistas.id_artista = Nominaciones.id_artista AND Nominaciones.gano = TRUE
WHERE Nominaciones.id_nom IS NULL;


-- 12. Listar los beats que han sido usados en más de 3 canciones
SELECT Beats.nombre, COUNT(Usa_Beat.id_cancion) AS veces_usado
FROM Beats
JOIN Usa_Beat ON Beats.id_beat = Usa_Beat.id_beat
GROUP BY Beats.nombre
HAVING COUNT(Usa_Beat.id_cancion) > 3;


-- 13. Listar todas las categorías y cuántos artistas participaron en cada una en 2025
SELECT categoria, COUNT(DISTINCT id_artista) AS artistas_participantes
FROM Nominaciones
WHERE anio = 2025
GROUP BY categoria;


-- 14. Listar los artistas que usaron beats producidos por 'Dr. Dre'
SELECT DISTINCT Artistas.nombre
FROM Artistas
JOIN Canciones ON Artistas.id_artista = Canciones.id_artista
JOIN Usa_Beat ON Canciones.id_cancion = Usa_Beat.id_cancion
JOIN Beats ON Usa_Beat.id_beat = Beats.id_beat
WHERE Beats.productor = 'Dr. Dre';


-- 15. Listar todos los beefs mostrando los nombres de ambos artistas involucrados
SELECT A1.nombre AS artista1, A2.nombre AS artista2, Beef.motivo
FROM Beef
JOIN Artistas A1 ON Beef.id_artista1 = A1.id_artista
JOIN Artistas A2 ON Beef.id_artista2 = A2.id_artista;


-- 16. Listar todas las categorías distintas
SELECT DISTINCT categoria
FROM Nominaciones;


-- 17. Mostrar el total de nominaciones por categoría en 2025
SELECT categoria, COUNT(*) AS total_nominaciones
FROM Nominaciones
WHERE anio = 2025
GROUP BY categoria;


-- 18. Listar todas las nominaciones realizadas en los últimos 30 días
SELECT *
FROM Nominaciones
WHERE fecha_nominacion BETWEEN CURRENT_DATE - INTERVAL '30 days' AND CURRENT_DATE;


-- 19. Listar los beats que han sido utilizados por canciones nominadas durante más de 5 años
SELECT Beats.nombre, COUNT(DISTINCT Nominaciones.anio) AS anios_nominado
FROM Beats
JOIN Usa_Beat ON Beats.id_beat = Usa_Beat.id_beat
JOIN Nominaciones ON Usa_Beat.id_cancion = Nominaciones.id_cancion
GROUP BY Beats.nombre
HAVING COUNT(DISTINCT Nominaciones.anio) > 5;
