-- Creación de tablas
CREATE TABLE Empleado (
    id_empleado SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    sueldo DECIMAL(10,2) NOT NULL
);

CREATE TABLE Producto (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

CREATE TABLE Cliente (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100)
);

CREATE TABLE Ventas (
    id_venta SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

CREATE TABLE Bitacora (
    id_bitacora SERIAL PRIMARY KEY,
    id_venta INT NOT NULL,
    descripcion TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_venta) REFERENCES Ventas(id_venta)
);


-- 1. TRIGGER: Registrar en bitácora después de insertar venta
CREATE OR REPLACE FUNCTION registrar_venta_bitacora()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Bitacora (id_venta, descripcion)
    VALUES (
        NEW.id_venta, 
        'Nueva venta registrada: Producto ID ' || NEW.id_producto || 
        ', Cantidad: ' || NEW.cantidad || ', Cliente ID: ' || NEW.id_cliente
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_registrar_venta
AFTER INSERT ON Ventas
FOR EACH ROW
EXECUTE FUNCTION registrar_venta_bitacora();


-- 2. PROCEDIMIENTO: Subir el sueldo a un empleado
CREATE OR REPLACE PROCEDURE subir_sueldo(
    id_emp INT,
    aumento DECIMAL(10,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Empleado
    SET sueldo = sueldo + aumento
    WHERE id_empleado = id_emp;
    
    RAISE NOTICE 'Sueldo del empleado % actualizado con un aumento de %', id_emp, aumento;
END;
$$;


-- 3. TRIGGER: Aumentar precio por inflación cuando stock sube 50% o más
CREATE OR REPLACE FUNCTION ajustar_precio_por_restock()
RETURNS TRIGGER AS $$
DECLARE
    incremento_porcentaje DECIMAL;
BEGIN
    -- Solo si el stock aumenta (no disminuye por ventas)
    IF NEW.stock > OLD.stock THEN
        -- Calcular el porcentaje de incremento
        incremento_porcentaje = ((NEW.stock - OLD.stock)::DECIMAL / OLD.stock) * 100;
        
        -- Si el incremento es mayor o igual a 50% (restock significativo)
        IF incremento_porcentaje >= 50 THEN
            NEW.precio := NEW.precio + 0.01;
            RAISE NOTICE 'Precio del producto % aumentado en $0.01 por restock. Stock anterior: %, Stock nuevo: %', 
                         NEW.id_producto, OLD.stock, NEW.stock;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_ajustar_precio_restock
BEFORE UPDATE ON Producto
FOR EACH ROW
WHEN (NEW.stock > OLD.stock)
EXECUTE FUNCTION ajustar_precio_por_restock();


-- Inserts de prueba
INSERT INTO Empleado (nombre, sueldo) VALUES
('Juan Pérez', 500000),
('María González', 600000),
('Carlos López', 550000);

INSERT INTO Producto (nombre, precio, stock) VALUES
('Laptop', 800000, 10),
('Mouse', 15000, 50),
('Teclado', 45000, 30);

INSERT INTO Cliente (nombre, email) VALUES
('Pedro Ramírez', 'pedro@email.com'),
('Ana Silva', 'ana@email.com'),
('Luis Torres', 'luis@email.com');


-- Pruebas de triggers y procedimientos

-- Prueba 1: Insertar venta (activa trigger de bitácora)
INSERT INTO Ventas (id_cliente, id_producto, cantidad)
VALUES (1, 1, 2);

-- Verificar bitácora
SELECT * FROM Bitacora;


-- Prueba 2: Subir sueldo a empleado
CALL subir_sueldo(1, 50000);

-- Verificar aumento
SELECT * FROM Empleado WHERE id_empleado = 1;


-- Prueba 3: Actualizar stock con incremento menor a 50% (NO aumenta precio)
UPDATE Producto 
SET stock = 12 
WHERE id_producto = 1;

SELECT * FROM Producto WHERE id_producto = 1;


-- Prueba 4: Actualizar stock con incremento de 50% o más (SÍ aumenta precio)
UPDATE Producto 
SET stock = 75  -- De 50 a 75 = 50% de incremento
WHERE id_producto = 2;

SELECT * FROM Producto WHERE id_producto = 2;


-- Prueba 5: Restock masivo (más de 50%)
UPDATE Producto 
SET stock = 100  -- De 30 a 100 = 233% de incremento
WHERE id_producto = 3;

SELECT * FROM Producto WHERE id_producto = 3;
