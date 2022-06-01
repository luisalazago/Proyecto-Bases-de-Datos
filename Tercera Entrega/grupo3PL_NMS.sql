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