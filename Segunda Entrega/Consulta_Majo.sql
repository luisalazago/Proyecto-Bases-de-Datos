--Consultas (Majo)

--Sentencia 2: Eliminar las adquisisiones de juegos realizadas en los últimos 3 días.
-- Se inserta un nuevo dato "basura" en las tablas TRANSACCIONES Y CONSUME para cumplir la compra de los últimos 3 días
INSERT INTO Transacciones
VALUES(3100000025, 090821, 1025, SYSDATE + 1, 80000);
COMMIT;

INSERT INTO Consume
VALUES(1000500000, 2, 3100000025);
COMMIT;

--Se actualiza la información borrando le adquisisión de compra
DELETE FROM Consume
WHERE idtransaccion IN (SELECT idtransaccion FROM transacciones NATURAL JOIN consume
WHERE fecha BETWEEN (SYSDATE + 1) - 3 AND SYSDATE + 1);
COMMIT;

--Sentencia 5: Haga un ranking de los juegos por el precio de venta. Listelos en orden ascendente del precio.
SELECT titulo, precio
FROM Producto ORDER BY precio ASC;

--Sentencia 12: Listar los clientes que no adquirieron juegos en marzo de 2022 y tampoco (los mismos clientes) adquirieron juegos en marzo de 2021.
SELECT DISTINCT idusuario, nombre
FROM Usuario NATURAL JOIN Consume NATURAL JOIN Transacciones
WHERE NOT ((transacciones.fecha  BETWEEN '01-MAR-21' AND '31-MAR-21') AND transacciones.fecha BETWEEN '01-MAR-22' AND '31-MAR-22');
