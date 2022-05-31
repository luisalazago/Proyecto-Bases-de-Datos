-- 2. Test.

INSERT INTO transacciones
VALUES(3100000026, 20014, 1080, '30/05/22', 50000);

INSERT INTO consume
VALUES(1000000300, 10, 3100000026);

INSERT INTO biblioteca
VALUES(1000000300, 10);

DELETE FROM transacciones
WHERE idtransaccion = 3100000026 AND codigoverificacion = 20014 AND comprobante = 1080 AND precio = 50000;

DELETE FROM consume
WHERE idusuario = 1000000300 AND idjuego = 10 AND idtransaccion = 3100000026;

DELETE FROM biblioteca
WHERE idusuario = 1000000300 AND idjuego = 10;

COMMIT;

-- 7. Test.

BEGIN
    agregarInterfazUsuario(0, 15);
END;

