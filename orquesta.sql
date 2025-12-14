CREATE TABLE Persona (
id_persona SERIAL PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
instrumento VARCHAR(50) NOT NULL
);

CREATE TABLE Orquesta (
id_orquesta SERIAL PRIMARY KEY,
comuna VARCHAR(50) NOT NULL,
provincia VARCHAR(50) NOT NULL,
region VARCHAR(50) NOT NULL
);

CREATE TABLE Pertenece (
id_persona INT NOT NULL,
id_orquesta INT NOT NULL,
fecha_inicio DATE NOT NULL,
fecha_fin DATE,
PRIMARY KEY (id_persona, id_orquesta),
FOREIGN KEY (id_persona) REFERENCES Persona(id_persona),
FOREIGN KEY (id_orquesta) REFERENCES Orquesta(id_orquesta)
);

CREATE TABLE Presentacion (
id_presentacion SERIAL PRIMARY KEY,
id_orquesta INT NOT NULL,
teatro VARCHAR(100) NOT NULL,
fecha DATE NOT NULL,
hora TIME NOT NULL,
FOREIGN KEY (id_orquesta) REFERENCES Orquesta(id_orquesta)
);

CREATE TABLE Participa (
id_persona INT NOT NULL,
id_presentacion INT NOT NULL,
tipo_presentacion VARCHAR(20) CHECK (tipo_presentacion IN ('titular',
'invitado')),
PRIMARY KEY (id_persona, id_presentacion),
FOREIGN KEY (id_persona) REFERENCES Persona(id_persona),
FOREIGN KEY (id_presentacion) REFERENCES Presentacion(id_presentacion)
);

CREATE TABLE Director (
id_director SERIAL PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
edad INT CHECK (edad > 0)
);

CREATE TABLE Dirige (
id_director INT NOT NULL,
id_orquesta INT NOT NULL,
PRIMARY KEY (id_director, id_orquesta),
FOREIGN KEY (id_director) REFERENCES Director(id_director),
FOREIGN KEY (id_orquesta) REFERENCES Orquesta(id_orquesta)
);


INSERT INTO Persona (nombre, instrumento) 
VALUES 
    ('Juan Pérez', 'Violín'), 
    ('Ana Gómez', 'Piano'), 
    ('Carlos Ruiz', 'Flauta');

INSERT INTO Orquesta (comuna, provincia, region) 
VALUES 
    ('Santiago', 'Santiago', 'Metropolitana'), 
    ('Valparaíso', 'Valparaíso', 'Valparaíso'), 
    ('Concepción', 'Biobío', 'Biobío');

INSERT INTO Pertenece (id_persona, id_orquesta, fecha_inicio, fecha_fin) 
VALUES 
    (1, 1, '2022-01-01', NULL),  
    (2, 2, '2021-06-15', NULL),  
    (3, 1, '2023-03-20', NULL);

INSERT INTO Presentacion (id_orquesta, teatro, fecha, hora) 
VALUES 
    (1, 'Teatro Municipal de Santiago', '2025-05-15', '19:30'), 
    (2, 'Teatro Coliseo', '2025-06-10', '20:00');

INSERT INTO Participa (id_persona, id_presentacion, tipo_presentacion) 
VALUES 
    (1, 1, 'titular'),   
    (2, 1, 'invitado'),  
    (3, 2, 'titular');

INSERT INTO Director (nombre, edad) 
VALUES 
    ('Francisco García', 45), 
    ('Luis Rodríguez', 50);

INSERT INTO Dirige (id_director, id_orquesta) 
VALUES 
    (1, 1),  
    (2, 2);
