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
