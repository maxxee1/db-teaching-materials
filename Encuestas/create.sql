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
