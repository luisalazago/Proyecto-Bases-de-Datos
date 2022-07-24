/*

Segunda Entrega: proyecto tienda de juegos.
Autores: Luis Alberto Salazar, María José Suárez, Luis Andrés Mendoza, Nicole Molineros.

1. Listar los datos de los juegos que han sido comprados por más de 5 usuarios 
(si no maneja la figura de compra, use la figura que permite el uso del juego).
*/

WITH Juegos AS(SELECT COUNT(*) AS Compras, idJuego
FROM Consume
GROUP BY idJuego
HAVING COUNT(*) > 2) -- Se hizo con 2 y no con 5 porque no hay mas de 2
SELECT idjuego, compras, producto.titulo, producto.genero, producto.descripcion, producto.precio, producto.restriccionedad -- Son los datos del juego
FROM Producto INNER JOIN Juegos
USING(idJuego);

/*
2. Eliminar las adquisisiones de juegos realizadas en los últimos 3 días.
*/

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

/*
3. Agregue (si no lo tiene) un atributo con porcentaje de descuento en la tabla que
almacena los datos de los usuarios (o clientes).
Escriba una sentencia que le sume 3% al porcentaje de descuento de los clientes
que compraron más de 3 juegos en el último mes.
*/

ALTER TABLE Usuario
ADD descuento_porcentaje NUMBER(3) DEFAULT 2;

-- Se hace una subconsulta y se retorna una tabla con los usuarios que cumplen la condición.
-- Se verifica si esos usuarios están en la tabla y cuando eso sea cierto hace un update.
UPDATE usuario
SET descuento_porcentaje = descuento_porcentaje + (descuento_porcentaje * 3) / 100
WHERE idusuario IN (SELECT idusuario
	   				FROM usuario NATURAL JOIN consume NATURAL JOIN transacciones
	   				WHERE EXTRACT(MONTH FROM fecha) = 5 AND EXTRACT(YEAR FROM fecha) = 2022
	   				GROUP BY idusuario
	   				HAVING(COUNT(idjuego) > 3));

/*
4. Listar el promedio, la moda y la desviación estándar del precio de venta de los
juegos.
*/

-- Se calculan el promedio, la moda y la desviación a parte y luego se muestran en el select.
-- Para calcular la moda se cuenta el precio y se ordena respecto al mismo y solo se retorna una fila.
WITH promedio AS (SELECT AVG(precio) AS prom
				  FROM producto),
	 moda AS (SELECT COUNT(*) AS moda1, precio
	 		  FROM producto
	 		  WHERE ROWNUM = 1
	 		  GROUP BY precio
	 		  ORDER BY moda1),
	 desv_esta AS (SELECT STDDEV(precio) AS desv_estan
	 			   FROM producto)
SELECT prom, precio AS moda2, desv_estan
FROM promedio NATURAL JOIN moda NATURAL JOIN desv_esta;

/*
5. Haga un ranking de los juegos por el precio de venta. Listelos en orden ascendente del precio.
*/

SELECT titulo, precio
FROM Producto ORDER BY precio ASC;

/*
6. Listar la última palabra del nombre o del apellido de los clientes, lístelos en orden
alfabético (asegúrese que el atributo tiene varias palabras separadas por espacio,
no es válido suponer que se registra solamente una palabra).
*/

SELECT REGEXP_SUBSTR(NOMBRE,'[^ ]+') FROM USUARIO ORDER BY USUARIO.NOMBRE ASC;

/*
7. Liste en mayúsculas el nombre de los usuarios (o clientes) que pagaron por los
juegos adquiridos en el año 2021 (total de año) $300.000 o más.
*/

--Ya que no existen en nuestra tienda juegos por un valor tan alto de 300k usaremos juegos valuados en 30k.
SELECT DISTINCT NOMBRE FROM USUARIO INNER JOIN CONSUME ON (USUARIO.IDUSUARIO = CONSUME.IDUSUARIO)
INNER JOIN TRANSACCIONES ON (TRANSACCIONES.IDTRANSACCION = CONSUME.IDTRANSACCION) JOIN PRODUCTO ON(producto.idjuego = consume.idjuego)
WHERE SUM(PRODUCTO.PRECIO) > 30000 AND 2021 = EXTRACT(YEAR FROM TRANSACCIONES.FECHA);
--TRANSACCIONES.PRECIO > 30000 AND 2021 = EXTRACT(YEAR FROM TRANSACCIONES.FECHA);

/*
8. Liste el nombre de los clientes (o usuarios) que no han comprado juegos durante el
presente año.
*/

-- Se hace una consulta de la cantidad de juegos que los usuarios tienen en la fecha indicada.
-- Si no tienen juegos comprados en esas fechas, entonces se muestra en la consulta principal.
WITH cant_juegos AS (SELECT COUNT(idjuego) AS juegos
					 FROM usuario INNER JOIN consume
					 ON(usuario.idusuario = consume.idusuario) INNER JOIN transacciones
					 ON(transacciones.idtransaccion = consume.idtransaccion)
					 WHERE EXTRACT(YEAR FROM fecha) = EXTRACT(YEAR FROM CURRENT_DATE))
SELECT nombre
FROM usuario NATURAL JOIN cant_juegos
WHERE juegos = 0;

/*
9. Actualice los datos y escriba una sentencia para encontrar los números de teléfono que no tienen el formato.
*/

SELECT telefono
FROM Usuario
WHERE NOT REGEXP_LIKE (telefono, '^\(\d{2}\)(\s+)\d{3}(\s+)-\d{7}$'); -- Se pasa el formato correcto para comparar

/*
10. Listar la identificación y nombre de todos los clientes, y si han adquirido juegos en
el presente mes, agregar la fecha de cada compra y su valor.
*/

SELECT DISTINCT USUARIO.IDUSUARIO, USUARIO.NOMBRE, TRANSACCIONES.FECHA, TRANSACCIONES.PRECIO
FROM USUARIO LEFT OUTER JOIN (CONSUME INNER JOIN TRANSACCIONES 
ON(TRANSACCIONES.IDTRANSACCION = CONSUME.IDTRANSACCION 
AND EXTRACT(MONTH FROM TRANSACCIONES.FECHA) = EXTRACT(MONTH FROM CURRENT_DATE))) 
ON(USUARIO.IDUSUARIO = CONSUME.IDUSUARIO);

/*
11. Hacer un ranking de los clientes según la cantidad de juegos adquiridos en el año anterior. 
Liste los 5 clientes con mayor cantidad.
*/

WITH r AS ( -- r sería el ranking
SELECT idusuario, COUNT(*) AS Cantidad,  RANK() OVER (ORDER BY COUNT(*) DESC) as ranking --Se usa la función RANK para sacar el top 5 de clientes.
FROM Consume JOIN Transacciones ON(consume.idtransaccion = transacciones.idtransaccion)
WHERE EXTRACT(YEAR FROM fecha) = 2021
GROUP BY idusuario)
SELECT r.idusuario, Cantidad, ranking, nombre
FROM r JOIN usuario ON (r.idusuario = usuario.idusuario)
ORDER BY ranking ASC; -- Se hace esto para que imprima en orden ascendente el ranking de los clientes

/*
12. Listar los clientes que no adquirieron juegos en marzo de 2022 y tampoco (los mismos clientes) 
adquirieron juegos en marzo de 2021.
*/

SELECT DISTINCT idusuario, nombre
FROM Usuario NATURAL JOIN Consume NATURAL JOIN Transacciones
WHERE NOT ((transacciones.fecha  BETWEEN '01-MAR-21' AND '31-MAR-21') AND transacciones.fecha BETWEEN '01-MAR-22' AND '31-MAR-22');
