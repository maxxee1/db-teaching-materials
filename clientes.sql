CREATE TABLE localidades (
    id_localidad INT PRIMARY KEY,
    region VARCHAR(100) NOT NULL,
    provincia VARCHAR(100) NOT NULL,
    comuna VARCHAR(100) NOT NULL,
    UNIQUE(region, provincia, comuna) -- En papel esta linea no es necesaria
);


CREATE TABLE cliente (
    NumeroCliente SERIAL PRIMARY KEY,
    direccion TEXT NOT NULL,
    id_localidad INT,
    FOREIGN KEY (id_localidad) REFERENCES localidades(id_localidad)
);

-- asumiendo un cliente puede tener muchos reclamos
-- un reclamo solo tiene un cliente, no se aceptan reclamos colectivos
-- relacion 1:N
CREATE TABLE reclamos (
  id_reclamo SERIAL PRIMARY KEY,
  tipo_reclamo TEXT, -- esto es extra 
  id_cliente INT,
  FOREIGN KEY (id_cliente) REFERENCES cliente(NumeroCliente)
);


-- Insert 
INSERT INTO localidades (id_localidad, region, provincia, comuna) VALUES
(1, 'Región Metropolitana', 'Santiago', 'Maipú'),
(2, 'Valparaíso', 'Valparaíso', 'Viña del Mar'),
(3, 'Biobío', 'Concepción', 'Talcahuano');


INSERT INTO cliente (direccion, id_localidad) VALUES
('Av. Pajaritos 1234', 1),
('Calle 1 Norte 234', 2),
('Pasaje Mar 567', 3);


INSERT INTO reclamos (tipo_reclamo, id_cliente) VALUES
('Retraso en entrega', 1),
('Servicio malo', 1),
('Producto defectuoso', 2),
('Falla técnica', 3),
('Corte de servicio inesperado', 3);

SELECT * FROM cliente;

-- a que comuna pertenece el cliente 2?
SELECT comuna 
FROM localidades
JOIN cliente ON localidades.id_localidad = cliente.id_localidad
WHERE NumeroCliente = 2;

-- localidade donde hubo retraso en la entrega
-- se usa DISTINCT para no devolver la misma localidad 2 o mas veces
SELECT DISTINCT localidades.* -- asterisco para seleccionar la tabla completa
FROM reclamos
JOIN cliente ON reclamos.id_cliente = cliente.NumeroCliente
JOIN localidades ON cliente.id_localidad = localidades.id_localidad
WHERE reclamos.tipo_reclamo = 'Retraso en entrega';


-- clientes con reclamos que contengan la palabra: servicio
SELECT DISTINCT cliente.*
FROM reclamos
JOIN cliente ON reclamos.id_cliente = cliente.NumeroCliente
WHERE reclamos.tipo_reclamo ILIKE '%servicio%'; -- ilike es para las mayus, % es para caracteres (revisar documentacion)
