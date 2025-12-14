CREATE TABLE Encuesta (
  codenc SERIAL PRIMARY KEY,
  nomenc TEXT,
  fecenc DATE DEFAULT CURRENT_DATE
);

CREATE TABLE Preguntas (
  codpre SERIAL PRIMARY KEY,
  nombre TEXT
);

CREATE TABLE EncPre (
  codenc INT NOT NULL REFERENCES Encuesta(codenc),
  codpre INT NOT NULL REFERENCES Preguntas(codpre),
  PRIMARY KEY (codenc, codpre)
);

CREATE TABLE Respuesta (
  folio INT NOT NULL,
  respuesta INT CHECK (respuesta IN (1, 2, 3, 4, 5)),
  codenc INT NOT NULL REFERENCES Encuesta(codenc),
  codpre INT NOT NULL REFERENCES Preguntas(codpre),
  PRIMARY KEY (codpre, codenc, folio)
);

INSERT INTO Encuesta (codenc, nomenc) VALUES
(1, 'Encuesta General A'),
(2, 'Encuesta Especifica B'),
(3, 'Encuesta equisde');

INSERT INTO Preguntas (codpre, nombre) VALUES
(1, 'Pregunta Común 1'),
(2, 'Pregunta Común 2'), 
(3, 'Pregunta Específica B1'), 
(4, 'Pregunta Sin Asignar');

INSERT INTO EncPre (codenc, codpre) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 2),
(2, 3),
(3, 1),
(3, 2);


INSERT INTO Respuesta (folio, respuesta, codenc, codpre) VALUES
(1, 5, 1, 1),
(1, 4, 1, 2);

INSERT INTO Respuesta (folio, respuesta, codenc, codpre) VALUES
(2, 5, 2, 1),
(2, 5, 2, 2);


-- Preguntas que estan en todas las encuestas
SELECT p.codpre, p.nombre 
FROM Preguntas p 
JOIN EncPre e ON e.codpre = p.codpre 
GROUP BY p.codpre 
HAVING COUNT(DISTINCT e.codenc) = (SELECT COUNT(codenc) FROM Encuesta);

-- Encuestas donde todas las respuestas son 5
SELECT e.codenc, e.nomenc 
FROM Encuesta e 
JOIN Respuesta r ON e.codenc = r.codenc 
GROUP BY e.codenc 
HAVING MIN(r.respuesta) = 5;

-- Preguntas definidas pero no asociadas a ninguna encuesta
SELECT p.codpre, p.nombre 
FROM Preguntas p 
LEFT JOIN EncPre ep ON ep.codpre = p.codpre 
WHERE ep.codenc IS NULL;

-- Encuestas que aun no han sido respondidas por nadie
SELECT e.codenc, e.nomenc 
FROM Encuesta e 
LEFT JOIN Respuesta r ON e.codenc = r.codenc 
WHERE r.folio IS NULL;
