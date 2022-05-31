CREATE OR REPLACE TRIGGER verificarProducto
AFTER INSERT ON transacciones FOR EACH ROW
BEGIN
    UPDATE transacciones
    SET fecha = current_timestamp
    WHERE idtransaccion = :OLD.idtransaccion;
END;