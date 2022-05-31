-- Requerimientos PL

--1 
-- Creen el(los) trigger(s) necesarios para que cuando se registre un movimiento 
--en una cuenta (ej. Consignación, retiro) la fecha de la transacción quede 
--registrada con la fecha y hora actual.
CREATE OR REPLACE TRIGGER verificarProducto
AFTER INSERT ON transacciones FOR EACH ROW
BEGIN
    UPDATE transacciones
    SET fecha = current_timestamp
    WHERE idtransaccion = :OLD.idtransaccion;
END;

--2 
-- Si las cuentas no tienen el atributo Saldo agréguenlo y desarrollen el(los) 
--triggers necesarios para que el valor del saldo de la cuenta se mantenga actualizado 
--automáticamente cada vez que se registran movimientos.
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

-- 3 
--Identifique una restricción que considere importante en el funcionamiento 
--de su base de datos y que requiera ser gestionada con un trigger 

CREATE OR REPLACE TRIGGER verificarPrecio
BEFORE INSERT ON Transacciones FOR EACH ROW
DECLARE 
valorPago NUMBER(6) DEFAULT 0; -- Monto que va a pagar el cliente
costoJuego NUMBER(6) DEFAULT 0; --Costo del prodcuto a comprar
BEGIN
    --Verificar que el costo del juego no sea mayor o menor al monto dado
    SELECT precio INTO costoJuego FROM producto JOIN consume ON (producto.idJuego = consume.idJuego);
    SELECT :NEW.precio INTO valorPago FROM DUAL;
    IF costoJuego != valorPago THEN
        Raise_application_error(-20000, 'ERROR: El costo del producto no coincide con el monto dado');
    END IF;
END;

-- 4 
--Para cada cuenta, retorna la fecha y valor de los 3 últimos movimientos realizados. 
--La información de la cuenta está en un solo registro.

CREATE OR REPLACE TYPE tipoTabla
AS OBJECT (cuenta NUMBER(10), fechaUlt DATE, valorUlt NUMBER(12), fechaUlt2 DATE, valorUlt2 NUMBER(12), fechaUlt3 DATE, valorUlt3 NUMBER(12));

CREATE OR REPLACE TYPE tabla AS TABLE OF tipoTabla;

CREATE OR REPLACE FUNCTION punto4
RETURN tabla AS res tabla;
fila tipoTabla;
nmov NUMBER(10);
CURSOR cur IS 
SELECT DISTINCT idusuario
FROM consume;
BEGIN
    res := tabla();
    fila := tipoTabla('', TO_DATE('01/01/1000','DD/MM/YYYY'), 0, TO_DATE('01/01/1000','DD/MM/YYYY'), 0, TO_DATE('01/01/1000','DD/MM/YYYY'), 0);
    FOR user IN cur LOOP
        nmov := 0;
        fila.cuenta := user.idusuario;

        FOR mov IN (SELECT fecha, precio FROM consume 
                    JOIN transacciones ON (consume.idtransaccion = transacciones.idtransaccion) 
                    WHERE idusuario = user.idusuario
                    ORDER BY fecha DESC
                    FETCH NEXT 3 ROWS ONLY)
                    
        LOOP
            IF nmov = 0 THEN
                fila.fechaUlt := mov.fecha;
                fila.valorUlt := mov.precio;
            ELSIF nmov = 1 THEN
                fila.fechaUlt2 := mov.fecha;
                fila.valorUlt2 := mov.precio;
            ELSIF nmov = 2 THEN
                fila.fechaUlt3 := mov.fecha;
                fila.valorUlt3 := mov.precio;
            END IF;
            nmov := nmov + 1;
        END LOOP;
        res.extend;
        res(res.count) := fila;
    END LOOP;
    return res;
END;

-- 5 (PROCEDIMIENTO PARA LISTAR EL NOMBRE DE LOS USUARIOS QUE HAN TENIDO COMPRAS EN UN RANGO X y Y)
create or replace PROCEDURE userCompras(priceInit NUMBER, priceEnd NUMBER) AS
    CURSOR getUser(initPrice NUMBER DEFAULT 0, endPrice NUMBER DEFAULT 150000) 
        IS SELECT NOMBRE FROM USUARIO NATURAL JOIN CONSUME NATURAL JOIN TRANSACCIONES
        WHERE PRECIO BETWEEN initPrice AND endPrice;
        nombresCompradores CHAR(50);
        BEGIN
            OPEN getUser(priceInit,priceEnd);
                LOOP
                    FETCH getUser INTO nombresCompradores;
                    EXIT WHEN getUser%NOTFOUND;
                    dbms_output.put_line(nombresCompradores);
                END LOOP;
            CLOSE getUser;
        END;

-- 6 

--Procedimiento para realizar la transferencia entre dos cuentas
CREATE OR REPLACE PROCEDURE CompraDuo(transaccionID1 number, transaccionID2 number, 
usuarioID number, juegoID1 number, juegoID2 number, codVerf1 number, codVerf2 number, 
comprobante1 number, comprobante2 number) AS 
precio1 NUMBER(6);
precio2 NUMBER(6);
usuarioComprador NUMBER(10);
BEGIN
    SELECT PRECIO INTO precio1 FROM PRODUCTO WHERE IDJUEGO =  juegoID1;
    SELECT PRECIO INTO precio2 FROM PRODUCTO WHERE IDJUEGO =  juegoID2;
    SELECT IDUSUARIO INTO usuarioComprador FROM USUARIO WHERE IDUSUARIO = usuarioID;
    BEGIN
        SAVEPOINT compraFallaCons;
        INSERT INTO CONSUME VALUES(usuarioComprador,juegoID1,transaccionID1);
        INSERT INTO CONSUME VALUES(usuarioComprador,juegoID2,transaccionID2);
        EXCEPTION WHEN NO_DATA_FOUND THEN ROLLBACK TO compraFallaCons;
    END;
    BEGIN
        SAVEPOINT compraFallaTrans;
        INSERT INTO TRANSACCIONES VALUES(transaccionID1,codVerf1,comprobante1,CURRENT_DATE,((precio1+precio2)*20)/100);
        EXCEPTION WHEN NO_DATA_FOUND THEN ROLLBACK TO compraFalla;
    END;
    COMMIT;
END;

-- 7.
-- Manejo transaccional y de excepciones

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