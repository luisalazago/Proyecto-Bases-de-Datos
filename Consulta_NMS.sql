ALTER TABLE Usuario 
MODIFY telefono VARCHAR(22);

    
INSERT INTO Usuario
VALUES(1000000100, 'Juan S', 'juan.s@pipiolo.com', 'SpongeBob', 23, 'Colombia', 'Cliente','1', '1111111');

-----------------------------------------------

-- Mas compras listo

INSERT INTO CONSUME VALUES (1000000000, 3,3100000010);
INSERT INTO CONSUME VALUES (1000000000, 5,3100000011);
INSERT INTO CONSUME VALUES (1000000000, 7,3100000012);
INSERT INTO CONSUME VALUES (2000000157, 3,3100000013);
INSERT INTO CONSUME VALUES (2000000157, 1,3100000014);
INSERT INTO CONSUME VALUES (1000000150, 4,3100000015);
INSERT INTO CONSUME VALUES (1000000150, 5,3100000016);
INSERT INTO CONSUME VALUES (1000000575, 6,3100000017);
INSERT INTO CONSUME VALUES (1000500000, 8,3100000018); 
INSERT INTO CONSUME VALUES (1020000489, 1,3100000019);

-- Mas transacciones listo

-- despues 3100000007

INSERT INTO Transacciones
VALUES(3100000010, 890088, 009748, '15-12-2020', 25000);
INSERT INTO Transacciones
VALUES(3100000011, 908010, 009877, '01-03-2021', 30000);
INSERT INTO Transacciones
VALUES(3100000012, 389854, 009976, '06-05-2022', 40000);
INSERT INTO Transacciones
VALUES(3100000013, 097373, 009785, '02-10-2022', 35000);
INSERT INTO Transacciones
VALUES(3100000014, 389865, 009574, '08-10-2022', 60000);
INSERT INTO Transacciones
VALUES(3100000015, 097746, 009663, '24-02-2021', 120000);
INSERT INTO Transacciones
VALUES(3100000016, 597233, 009782, '09-01-2020', 15000);
INSERT INTO Transacciones
VALUES(3100000017, 097620, 009711, '07-12-2020', 80000);
INSERT INTO Transacciones
VALUES(3100000018, 192714, 009792, '18-02-2021', 12000);
INSERT INTO Transacciones
VALUES(3100000019, 095508, 009905, '25-02-2021', 67000);


--Biblioteca listo

INSERT INTO Biblioteca VALUES(1000000000,005);
INSERT INTO Biblioteca VALUES(1000000000,007);
INSERT INTO Biblioteca VALUES(2000000157,003);
INSERT INTO Biblioteca VALUES(2000000157,001);
INSERT INTO Biblioteca VALUES(1000000150,004);
INSERT INTO Biblioteca VALUES(1000000150,005);
INSERT INTO Biblioteca VALUES(1000000575,006);
INSERT INTO Biblioteca VALUES(1000500000,008);
INSERT INTO Biblioteca VALUES(1000003456,002);
INSERT INTO Biblioteca VALUES(1020000489,003);
INSERT INTO Biblioteca VALUES(1000000001,005);
INSERT INTO Biblioteca VALUES(1005000201,001);
--------------------------------------------------
--Consultas

--CONSULTAS

--1 Listar los datos de los juegos que han sido comprados por más de 5 usuarios (si no maneja la figura de compra, use la figura que permite el uso del juego)
WITH Juegos AS(SELECT COUNT(*) AS Compras, idJuego
FROM Consume
GROUP BY idJuego
HAVING COUNT(*) >2)
SELECT idjuego, compras, producto.titulo, producto.genero, producto.descripcion, producto.precio, producto.restriccionedad
FROM Producto INNER JOIN Juegos
USING(idJuego);


--9 Actualice los datos y escriba una sentencia para encontrar los números de teléfono que no tienen el formato

SELECT telefono
FROM Usuario
WHERE NOT REGEXP_LIKE (telefono, '^\(\d{2}\)(\s+)\d{3}(\s+)-\d{7}$');

--11  Hacer un ranking de los clientes según la cantidad de juegos adquiridos en el año anterior. Liste los 5 clientes con mayor cantidad.
 
WITH r AS (
SELECT idusuario, COUNT(*) AS Cantidad,  RANK() OVER (ORDER BY COUNT(*) DESC) as ranking
FROM Consume JOIN Transacciones ON(consume.idtransaccion = transacciones.idtransaccion)
WHERE EXTRACT(YEAR FROM fecha) = 2021
GROUP BY idusuario)
SELECT r.idusuario, Cantidad, ranking, nombre
FROM r JOIN usuario ON (r.idusuario = usuario.idusuario)
ORDER BY ranking ASC;