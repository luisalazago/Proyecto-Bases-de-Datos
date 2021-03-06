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
