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
			SELECT idtransaccion INTO consu
			FROM producto INNER JOIN consume
			ON(producto.idjuego = consume.idjuego)
			WHERE :NEW.idjuego = producto.idjuego;

			IF consu != 0 THEN
				SELECT transacciones.idtransaccion INTO trans
				FROM transacciones INNER JOIN consume
				ON(transacciones.idtransaccion = consume.idtransaccion)
				WHERE consu = transacciones.idtransaccion;

				IF trans != 0 THEN
					UPDATE Usuario
					SET NumeroJuegos = NumeroJuegos + 1;
				ELSE
					Raise_application_error(20000, 'El juego: '||:NEW.idjuego||', aun no ha sido comprado.');
				END IF;
			ELSE
				Raise_application_error(20000, 'El juego: '||:NEW.idjuego||', aun no ha sido comprado.');
			END IF;
			
		WHEN DELETING THEN
			SELECT idtransaccion INTO consu
			FROM producto INNER JOIN consume
            ON(producto.idjuego = consume.idjuego)
			WHERE :OLD.idjuego = producto.idjuego;

			IF consu = 0 THEN
				UPDATE Usuario
				SET NumeroJuegos = NumeroJuegos - 1;
			ELSE
				Raise_application_error(-20000, 'El juego: '||:OLD.idjuego||', aun sigue agregado.');
			END IF;
	END CASE;
END;

/*
7. Identifique una funcionalidad que considere en el funcionamiento de su base de datos
que requiera manejo transaccional y de excepciones. Implemente esa funcionalidad en
su base de datos.
*/

