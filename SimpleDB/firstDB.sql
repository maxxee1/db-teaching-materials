CREATE TABLE Cliente (
    idCliente INT,
    Nombre VARCHAR(50),
    Direccion VARCHAR(200),
    Telefono VARCHAR(9),
    Ciudad VARCHAR(20),
    PRIMARY KEY (idCliente)
);

CREATE TABLE Producto (
    idProducto INT,
    Descripcion VARCHAR(200),
    Precio INT,
    PRIMARY KEY (idProducto)
);

CREATE TABLE Venta (
    idProducto INT,
    idCliente INT,
    Cantidad INT,
    Fecha DATE,
    idVenta INT,
    PRIMARY KEY (idVenta),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

INSERT INTO Cliente VALUES 
(1, 'Pretoriano', 'Temuco 426, Queens', '944781240', 'Santiago'),
(2, 'Pectoriano', 'Gimnasio 2233, Santiago', '992548109', 'Santiago'),
(3, 'Guido Meza', 'Mitnik 2245, Renca', '941228304', 'Santiago'),
(4, 'Jorge Perez', 'Mojon 2', '982350183', 'Antartida'),
(5, 'Willy Perez del Anular', 'Kuchen 448', '959273048', 'Villa Baviera'),
(6, 'Redro Alcanizo', 'Talavera 811', '933204755', 'Valparaiso'),
(7, 'Tato Hernandez', 'Argentina 347', '914238210', 'Valparaiso'),
(8, 'Flavio', 'Tortugas 112', '967822193', 'Vallenar');

INSERT INTO Producto VALUES 
(1, 'Router (ecologico) en forma de pepino', 400000),
(2, 'Lentes 3D anti-eclipse', 27000),
(3, 'Flaystation 1', 800000),
(4, 'Papel higienico reutilizable', 5000),
(5, 'Horno-refrigerador', 700000),
(6, 'Celular de palo de prepago', 3500);

INSERT INTO Venta VALUES 
(2, 1, 5, '2021-09-22', 1),
(4, 1, 10, '2021-05-08', 2),
(6, 1, 1, '2021-08-25', 3),
(1, 2, 1, '2021-07-03', 4);



SELECT Cliente.Nombre, Cliente.Direccion 
FROM Cliente
WHERE Ciudad = 'Valparaiso';
  
select distinct Cliente.Nombre
from Cliente
join Venta on Venta.idCliente = Cliente.idCliente;


select distinct Cliente.Nombre, Cliente.Direccion from Cliente
join venta on Cliente.idCliente = venta.idCliente
join Producto on venta.idProducto = Producto.idProducto
where Cliente.Ciudad = 'Santiago' and Producto.precio > 6000;


SELECT Venta.idProducto, Producto.Precio 
FROM Venta 
JOIN Producto ON Producto.idProducto = Venta.idProducto 
WHERE Venta.Fecha IN (
    SELECT Fecha 
    FROM Venta 
    WHERE Fecha BETWEEN '2021-04-01' AND '2021-09-01'
);


  
