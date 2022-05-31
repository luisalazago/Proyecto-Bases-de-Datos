/*
2. Agregue en el cliente el atributo NumeroJuegos que tenga la cantidad de juegos que
ha adquirido. Desarrollen el(los) triggers necesarios para que ese se mantenga
actualizado automáticamente cada vez que adquiere o cancela (o devuelve) juegos.
*/

ALTER TABLE Usuario
ADD NumeroJuegos NUMERIC(4);

CREATE OR REPLACE TRIGGER ver_cantJuegos
AFTER INSERT OR DELETE ON Biblioteca FOR EACH ROW
DECLARE
	trans NUMBER(10) DEFAULT 0;
	consu NUMBER(10) DEFAULT 0;
BEGIN
	CASE
		WHEN INSERTING THEN
			/* Primero verifica que el juego puede ser consumido,
			   es decir, que esté en la tabla de consumo.*/
			SELECT idtransaccion INTO consu
			FROM producto INNER JOIN consume
			ON(producto.idjuego = consume.idjuego)
			WHERE :NEW.idjuego = producto.idjuego;

			IF consu != 0 THEN
				/* Una vez verificado que se pude consumir, se verifica
				   que la compra exista y sea correcta.*/
				SELECT transacciones.idtransaccion INTO trans
				FROM transacciones INNER JOIN consume
				ON(transacciones.idtransaccion = consume.idtransaccion)
				WHERE consu = transacciones.idtransaccion;

				IF trans != 0 THEN
					UPDATE Usuario
					SET NumeroJuegos = NumeroJuegos + 1;
				END IF;
			END IF;
			
		WHEN DELETING THEN
			UPDATE Usuario
			SET NumeroJuegos = NumeroJuegos - 1;

			/* Se elimina la posibilidad de consumir el juego nuevamente,
			   cuando se cancela o se devuelve.*/
			DELETE FROM consume
			WHERE :OLD.idjuego = idjuego AND :OLD.idusuario = idusuario;
	END CASE;
END;

/*
7. Identifique una funcionalidad que considere en el funcionamiento de su base de datos
que requiera manejo transaccional y de excepciones. Implemente esa funcionalidad en
su base de datos.
*/

CREATE OR REPLACE PROCEDURE agregarInterfazUsuario(juego NUMBER, identificacion NUMBER) AS
BEGIN
	/* Este procedimiento permite agregar tanto a la biblioteca como a los favoritos
	   los juegos que les pertenecen.*/
	BEGIN
		SAVEPOINT cero;
		INSERT INTO favoritos
		VALUES(identificacion, juego);
		EXCEPTION WHEN NO_DATA_FOUND THEN ROLLBACK TO cero;
	END;

	BEGIN
		SAVEPOINT uno;
		INSERT INTO Biblioteca
		VALUES(identificacion, juego);
		EXCEPTION WHEN NO_DATA_FOUND THEN ROLLBACK TO uno;
	END;
END;

