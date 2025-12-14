-- Item I
CREATE TABLE Zona (
    idZona SERIAL,
    nombre_zona VARCHAR(50) NOT NULL,
    comuna VARCHAR(50) NOT NULL,
    PRIMARY KEY (idZona)
);

CREATE TABLE Repartidor (
    idRepartidor SERIAL,
    nombre VARCHAR(50) NOT NULL,
    edad INT,
    zona_asignada INT NOT NULL,
    PRIMARY KEY (idRepartidor),
    FOREIGN KEY (zona_asignada) REFERENCES Zona(idZona)
);

CREATE TABLE Cliente (
    idCliente SERIAL,
    nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(100),
    telefono VARCHAR(15),
    PRIMARY KEY (idCliente)
);

CREATE TABLE Pedido (
    idPedido SERIAL,
    idCliente INT NOT NULL,
    idRepartidor INT NOT NULL,
    fecha DATE NOT NULL,
    monto_total INT,
    PRIMARY KEY (idPedido),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) ON DELETE CASCADE,
    FOREIGN KEY (idRepartidor) REFERENCES Repartidor(idRepartidor)
);

CREATE TABLE PedidoDetalle (
    idDetalle SERIAL,
    idPedido INT NOT NULL,
    producto VARCHAR(50),
    cantidad INT,
    precio_unitario INT,
    PRIMARY KEY (idDetalle),
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
);


INSERT INTO Zona(nombre_zona, comuna) VALUES
('Centro', 'Santiago'),
('Norte', 'Huechuraba'),
('Sur', 'San Bernardo'),
('Poniente', 'Maipú');

INSERT INTO Repartidor(nombre, edad, zona_asignada) VALUES
('Pedro Rojas', 25, 1),
('Ana Díaz', 30, 2),
('Luis Peña', 28, 3),
('Claudia Soto', 32, 4);

INSERT INTO Cliente(nombre, direccion, telefono) VALUES
('Valentina López', 'Av. Siempre Viva 123', '912345678'),
('Jorge Ramírez', 'Calle Falsa 456', '976543210'),
('Camila Reyes', 'Pasaje Real 789', '998877665'),
('Marco Sánchez', 'Villa Feliz 101', '934567890'),
('Ignacio Pérez', 'Portal Sur 303', '923456789'),  -- este NO hará pedidos
('Sofía Muñoz', 'Las Rosas 456', '987654321');      -- tampoco

INSERT INTO Pedido(idCliente, idRepartidor, fecha, monto_total) VALUES
(1, 1, '2023-01-15', 65000), -- enero
(2, 2, '2023-02-10', 52000), -- febrero
(3, 1, '2023-03-25', 80000), -- marzo
(4, 3, '2023-04-01', 40000), -- fuera del rango
(1, 1, '2023-02-20', 55000), -- más para cumplir los "al menos 5 pedidos"
(2, 1, '2023-01-05', 30000),
(3, 1, '2023-03-10', 45000);

INSERT INTO PedidoDetalle(idPedido, producto, cantidad, precio_unitario) VALUES
(1, 'Pizza Familiar', 2, 15000),
(1, 'Bebida 1.5L', 2, 2500),
(2, 'Sushi 20 piezas', 1, 22000),
(3, 'Hamburguesa Doble', 3, 10000),
(4, 'Wrap Veggie', 2, 8000),
(5, 'Lasagna', 1, 20000),
(6, 'Empanadas', 3, 5000),
(7, 'Helado', 2, 6000);


-- Item II
-- a) Cantidad de repartidores que han entregado pedidos entre enero y marzo de 2023
SELECT COUNT(DISTINCT Pedido.idRepartidor) AS cantidad_repartidores
FROM Pedido
WHERE Pedido.fecha BETWEEN '2023-01-01' AND '2023-03-31';

-- b) Ranking de zonas con más pedidos, de forma descendente
SELECT Zona.nombre_zona, COUNT(Pedido.idPedido) AS cantidad_pedidos
FROM Pedido
JOIN Repartidor ON Pedido.idRepartidor = Repartidor.idRepartidor
JOIN Zona ON Repartidor.zona_asignada = Zona.idZona
GROUP BY Zona.nombre_zona
ORDER BY cantidad_pedidos DESC;

-- c) Nombres de los clientes que han realizado pedidos con monto superior a $50.000
SELECT Cliente.nombre
FROM Pedido
JOIN Cliente ON Pedido.idCliente = Cliente.idCliente
WHERE Pedido.monto_total > 50000;

-- d) Zona y comuna del pedido con mayor monto total
SELECT Zona.nombre_zona, Zona.comuna
FROM Pedido
JOIN Repartidor ON Pedido.idRepartidor = Repartidor.idRepartidor
JOIN Zona ON Repartidor.zona_asignada = Zona.idZona
ORDER BY Pedido.monto_total DESC
LIMIT 1;

-- e) Repartidores que han realizado al menos cinco pedidos
SELECT Repartidor.nombre, COUNT(Pedido.idPedido) AS cantidad_pedidos
FROM Pedido
JOIN Repartidor ON Pedido.idRepartidor = Repartidor.idRepartidor
GROUP BY Repartidor.idRepartidor, Repartidor.nombre
HAVING COUNT(Pedido.idPedido) >= 5;

-- f) Clientes que no han realizado ningún pedido
SELECT Cliente.nombre
FROM Cliente
LEFT JOIN Pedido ON Cliente.idCliente = Pedido.idCliente
WHERE Pedido.idPedido IS NULL;


-- Item III
-- a) Crear un procedimiento que actualice el MontoTotal de un pedido dado su ID
CREATE OR REPLACE PROCEDURE actualizarMonto(
    pedidoaCambiar INT,
    nuevoMonto INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Pedido
    SET monto_total = nuevoMonto
    WHERE pedido.idPedido = pedidoaCambiar;
    
    RAISE NOTICE 'Monto del pedido % cambiado a %', pedidoaCambiar, nuevoMonto;
END;
$$;


-- b) Crear un procedimiento que elimine un cliente y todos sus pedidos asociados. 
CREATE OR REPLACE PROCEDURE eliminar_cliente(idClienteEliminar INT)
LANGUAGE plpgsql
AS $$
BEGIN

    DELETE FROM PedidoDetalle
    WHERE idPedido IN (
        SELECT idPedido FROM Pedido WHERE idCliente = idClienteEliminar
    );

    DELETE FROM Pedido
    WHERE idCliente = idClienteEliminar;


    DELETE FROM Cliente
    WHERE idCliente = idClienteEliminar;

    RAISE NOTICE 'Cliente con ID % eliminado junto con sus pedidos y detalles.', idClienteEliminar;
END;
$$;


-- c) Crear un procedimiento que genere una tabla PedidosPremium con pedidos superiores a $100.000
-- incluyendo el nombre del repartidor, cliente y fecha.
CREATE OR REPLACE PROCEDURE generarPedidosPremium()
LANGUAGE plpgsql
AS $$
BEGIN
 
    CREATE TABLE IF NOT EXISTS PedidosPremium (
        idPedido INT PRIMARY KEY,
        nombre_repartidor VARCHAR(50),
        nombre_cliente VARCHAR(50),
        fecha DATE,
        montoTotal INT
    );


    INSERT INTO PedidosPremium (idPedido, nombre_repartidor, nombre_cliente, fecha, montoTotal)
    SELECT Pedido.idPedido, 
           Repartidor.nombre AS nombre_repartidor, 
           Cliente.nombre AS nombre_cliente, 
           Pedido.fecha, 
           Pedido.monto_total AS montoTotal
    FROM Pedido
    JOIN Repartidor ON Pedido.idRepartidor = Repartidor.idRepartidor
    JOIN Cliente ON Pedido.idCliente = Cliente.idCliente
    WHERE Pedido.monto_total > 100000;

    RAISE NOTICE 'Pedidos premium insertados correctamente.';
END;
$$;


-- d) rear un trigger que, al insertar un nuevo pedido, verifique que el MontoTotal sea al
-- menos $5.000. Si no lo es, ajustarlo autom ́aticamente a dicho valor
CREATE OR REPLACE FUNCTION validar_monto_minimo()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.monto_total < 5000 THEN
        NEW.monto_total := 5000;
        RAISE NOTICE 'Monto muy bajo. Ajustado automáticamente a $5.000';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_monto
BEFORE INSERT ON Pedido
FOR EACH ROW
EXECUTE FUNCTION validar_monto_minimo();



-- Llamado procedimientos y funciones
CALL actualizarMonto(2, 90000);
CALL eliminar_cliente(1);
CALL generarPedidosPremium();

-- INSERT malo (menor a 5000)
INSERT INTO Pedido(idCliente, idRepartidor, fecha, monto_total)
VALUES (2, 1, '2023-05-01', 3000);

-- SELECT para checkear
SELECT * FROM Pedido
WHERE fecha = '2023-05-01' AND idCliente = 2;


