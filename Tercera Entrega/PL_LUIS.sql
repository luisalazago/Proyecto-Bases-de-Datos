--PUNTO 5 (PROCEDIMIENTO PARA LISTAR EL NOMBRE DE LOS USUARIOS QUE HAN TENIDO COMPRAS EN UN RANGO X y Y)
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

--PUNTO 6
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