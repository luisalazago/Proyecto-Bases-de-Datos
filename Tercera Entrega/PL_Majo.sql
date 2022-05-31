--Sentencias en PL
--Majo


--Ejercicio 3 
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