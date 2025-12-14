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
WHERE e.codenc IS NULL;

-- Encuestas que aun no han sido respondidas por nadie
SELECT e.codenc, e.nomenc 
FROM Encuesta e 
LEFT JOIN Respuesta r ON e.codenc = r.codenc 
WHERE r.folio IS NULL;
