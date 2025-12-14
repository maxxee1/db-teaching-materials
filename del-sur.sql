CREATE TABLE region (
id_region SERIAL PRIMARY KEY ,
nombre_r VARCHAR (100) NOT NULL
);

CREATE TABLE comuna (
id_comuna SERIAL PRIMARY KEY ,
nombre_c VARCHAR (100) NOT NULL ,
id_region INT NOT NULL ,
FOREIGN KEY ( id_region ) REFERENCES region ( id_region )
);


CREATE TABLE centros (
id_centro SERIAL PRIMARY KEY ,
nombre_centro VARCHAR (100) NOT NULL ,
id_comuna INT NOT NULL ,
FOREIGN KEY ( id_comuna ) REFERENCES comuna ( id_comuna )
);


CREATE TABLE empleados (
id_t SERIAL PRIMARY KEY ,
nombre_e VARCHAR (100) NOT NULL ,
id_centro INT NOT NULL ,
FOREIGN KEY ( id_centro ) REFERENCES centros ( id_centro )
);


CREATE TABLE grifos (
id_grifo SERIAL PRIMARY KEY ,
id_centro INT NOT NULL ,
latitud DECIMAL (9 ,6) ,
altitud DECIMAL (9 ,6) ,
cerca_colegio BOOLEAN DEFAULT FALSE ,
cerca_hospital BOOLEAN DEFAULT FALSE ,
cerca_policia BOOLEAN DEFAULT FALSE ,
FOREIGN KEY ( id_centro ) REFERENCES centros ( id_centro )
);


CREATE TABLE mantencion (
id_mantencion SERIAL PRIMARY KEY ,
descripcion_acciones TEXT NOT NULL
);


CREATE TABLE hace (
id_grifo INT NOT NULL ,
id_t INT NOT NULL ,
id_mantencion INT NOT NULL ,
fecha DATE NOT NULL ,
PRIMARY KEY ( id_grifo , id_t , id_mantencion ) ,
FOREIGN KEY ( id_grifo ) REFERENCES grifos ( id_grifo ) ,
FOREIGN KEY ( id_t ) REFERENCES empleados ( id_t ) ,
FOREIGN KEY ( id_mantencion ) REFERENCES mantencion (
id_mantencion )
);


ALTER TABLE grifos 
DROP COLUMN cerca_colegio,
DROP COLUMN cerca_hospital,
DROP COLUMN cerca_policia;


CREATE TABLE instituciones (
    id_institucion SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL
);


CREATE TABLE grifo_institucion (
    id_grifo INT NOT NULL,
    id_institucion INT NOT NULL,
    distancia_metros DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_grifo, id_institucion),
    FOREIGN KEY (id_grifo) REFERENCES grifos(id_grifo),
    FOREIGN KEY (id_institucion) REFERENCES instituciones(id_institucion)
);


INSERT INTO region (nombre_r)
VALUES 
    ('Región Metropolitana'), 
    ('Región de Valparaíso'), 
    ('Región de Biobío');


INSERT INTO comuna (nombre_c, id_region)
VALUES 
    ('Santiago', 1), 
    ('Valparaíso', 2), 
    ('Concepción', 3),
    ('Viña del Mar', 2);


INSERT INTO centros (nombre_centro, id_comuna)
VALUES 
    ('Centro de Servicio 1', 1), 
    ('Centro de Servicio 2', 2),
    ('Centro de Servicio 3', 3),
    ('Centro de Servicio 4', 4);


INSERT INTO empleados (nombre_e, id_centro)
VALUES 
    ('Juan Pérez', 1), 
    ('María González', 1),
    ('Carlos Herrera', 2),
    ('Ana López', 2),
    ('Luis Fernández', 3),
    ('Javier Martínez', 4);


INSERT INTO grifos (id_centro, latitud, altitud)
VALUES 
    (1, -33.4569, -70.6483),
    (1, -33.4570, -70.6485),
    (2, -33.0250, -71.5500),
    (3, -36.8250, -73.0500),
    (4, -33.0260, -71.5505);


INSERT INTO mantencion (descripcion_acciones)
VALUES 
    ('Revisión de sistemas y limpieza de filtros'), 
    ('Reemplazo de válvulas y limpieza de bombas'),
    ('Reparación de fugas y mantenimiento preventivo');


INSERT INTO hace (id_grifo, id_t, id_mantencion, fecha)
VALUES 
    (1, 1, 1, '2025-04-10'),
    (2, 1, 1, '2025-04-10'), 
    (2, 2, 1, '2025-04-10'),  
    (1, 3, 1, '2025-04-10');


INSERT INTO hace (id_grifo, id_t, id_mantencion, fecha)
VALUES 
    (3, 4, 2, '2025-04-12'),  
    (3, 5, 2, '2025-04-12');


INSERT INTO hace (id_grifo, id_t, id_mantencion, fecha)
VALUES 
    (4, 6, 3, '2025-04-14'), 
    (5, 6, 3, '2025-04-14');  


INSERT INTO instituciones (tipo)
VALUES ('colegio'), ('hospital'), ('policía');


INSERT INTO grifo_institucion (id_grifo, id_institucion, distancia_metros)
VALUES 
    (1, 1, 120.50),  
    (1, 2, 300.00),  
    (1, 3, 450.75), 
    (2, 2, 200.00),  
    (2, 3, 180.20);

-- 1. Obtener todos los empleados
SELECT * FROM empleados;


-- 2. Obtener todos los centros
SELECT * FROM centros;


-- 3. Obtener todas las regiones
SELECT * FROM region;


-- 4. Obtener todas las comunas de una región específica (por ejemplo, región 1)
SELECT * FROM comuna WHERE id_region = 1;


-- 5. Obtener todos los grifos que están cerca de un colegio
SELECT grifos.id_grifo, grifos.id_centro, grifos.latitud, grifos.altitud, 
       instituciones.tipo, grifo_institucion.distancia_metros
FROM grifos
JOIN grifo_institucion ON grifos.id_grifo = grifo_institucion.id_grifo
JOIN instituciones ON grifo_institucion.id_institucion = instituciones.id_institucion
WHERE instituciones.tipo = 'colegio';


-- 6. Obtener los nombres de los grifos y sus coordenadas
SELECT nombre_centro, latitud, altitud 
FROM grifos
JOIN centros ON grifos.id_centro = centros.id_centro;


-- 7. Obtener el nombre y la comuna de un centro específico (por ejemplo, con id_comuna 1)
SELECT centros.nombre_centro, comuna.nombre_c 
FROM centros
JOIN comuna ON centros.id_comuna = comuna.id_comuna
WHERE centros.id_comuna = 1;


-- 8. Contar cuántos grifos hay en total
SELECT COUNT(*) FROM grifos;


-- 9. Obtener todos los empleados de un centro específico (por ejemplo, con id_centro 1)
SELECT nombre_e FROM empleados WHERE id_centro = 1;


-- 10. Obtener todas las mantenciones realizadas
SELECT * FROM mantencion;
