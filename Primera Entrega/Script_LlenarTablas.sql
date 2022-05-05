/* LLenar Tablas */

/* Datos de la tabla: Usuario */
INSERT INTO Usuario
VALUES(1000000000, 'Juan Salazar', 'juan.salazar@pipiolo.com', 'Spaguetti10*', 20, 'Colombia', 'Cliente');
INSERT INTO Usuario
VALUES(2000000157, 'Atreus Santorum', 'atreus.santorum@pipiolo.com', 'PolloFrito21<', 40, 'Colombia', 'Cliente');
INSERT INTO Usuario
VALUES(1000000150, 'Aquiles Castro', 'aquiles.castro@pipiolo.com', 'Lasagna32>', 18, 'Colombia', 'Cliente');
INSERT INTO Usuario
VALUES(1000000300, 'Alan Brito', 'alan.brito@pipiolo.com', 'TomateVerde43!', 35, 'Argentina', 'Distribuidor');
INSERT INTO Usuario
VALUES(1000000575, 'Pepe Mojica', 'pepe.mojica@pipiolo.com', 'Zanahoria54#', 27, 'Colombia', 'Cliente');
INSERT INTO Usuario
VALUES(1000500000, 'Esteban Cardona', 'esteban.cardona@pipiolo.com', 'PolloRojo65$', 58, 'Colombia', 'Cliente');
INSERT INTO Usuario
VALUES(1000003456, 'Luis Sneyder', 'luis.sneyder@pipiolo.com', 'PrestoBurger76%', 23, 'Estados Unidos', 'Distribuidor');
INSERT INTO Usuario
VALUES(1020000489, 'Jose Suarez', 'jose.suarez@pipiolo.com', 'PizzaLoca87&', 31, 'Colombia', 'Cliente');
INSERT INTO Usuario
VALUES(1000000001, 'Nicolle Smith', 'nicolle.smith@pipiolo.com', 'ChaquetaMex98/', 42, 'Colombia', 'Cliente');
INSERT INTO Usuario
VALUES(1005000201, 'Andres Perez', 'andres.perez@pipiolo.com', 'Tramajo09(', 19, 'Kenia', 'Distribuidor');

/* Datos de la tabla: Tarjeta */
INSERT INTO Tarjeta 
VALUES(2000000000000000, 'Juan Salazar',  34982746098302, '08-04-2022', 335, 2 );
COMMIT;
INSERT INTO Tarjeta 
VALUES(2000000000000001, 'Atreus Santorum',  4094824174921347, '02-09-2021', 763, 4 );
COMMIT;
INSERT INTO Tarjeta 
VALUES(2000000000000002, 'Aquiles Castro',  34982746098350, '01-04-2020', 221, 1 );
COMMIT;
INSERT INTO Tarjeta 
VALUES(2000000000000003, 'Alan Brito',  2208651186673094, '03-06-2021', 541, 1 );
COMMIT;
INSERT INTO Tarjeta 
VALUES(2000000000000004, 'Pepe Mojica',  1029384756473829, '23-02-2021', 981, 1 );
COMMIT;
INSERT INTO Tarjeta 
VALUES(2000000000000005, 'Esteban Cardona',  3680965223116490, '14-08-2021', 671, 2 );
COMMIT;
INSERT INTO Tarjeta 
VALUES(2000000000000006, 'Luis Sneyder',  0836288631203725, '12-01-2021', 338, 5 );
COMMIT;
INSERT INTO Tarjeta 
VALUES(2000000000000007, 'Jose Suarez',  1234567890654378, '09-03-2021', 072, 2 );
COMMIT;
INSERT INTO Tarjeta 
VALUES(2000000000000008, 'Nicolle Smith',  9673488729736491, '28-04-2021', 112, 3 );
COMMIT;
INSERT INTO Tarjeta 
VALUES(2000000000000009, 'Andres Perez',  8896567784122346, '03-05-2021', 947, 1 );
COMMIT;

/* Datos de la tabla: Transacciones */
INSERT INTO Transacciones
VALUES(3100000000, 890008, 009749, '15-10-2021', 25000);
INSERT INTO Transacciones
VALUES(3100000001, 908090, 009879, '01-02-2021', 30000);
INSERT INTO Transacciones
VALUES(3100000002, 389874, 009978, '06-02-2022', 40000);
INSERT INTO Transacciones
VALUES(3100000003, 097363, 009784, '03-02-2022', 35000);
INSERT INTO Transacciones
VALUES(3100000004, 389875, 009578, '09-01-2022', 60000);
INSERT INTO Transacciones
VALUES(3100000005, 097756, 009667, '24-02-2022', 120000);
INSERT INTO Transacciones
VALUES(3100000006, 597203, 009789, '09-01-2022', 15000);
INSERT INTO Transacciones
VALUES(3100000007, 097660, 009715, '07-12-2021', 80000);
INSERT INTO Transacciones
VALUES(3100000008, 192774, 009790, '18-02-2022', 12000);
INSERT INTO Transacciones
VALUES(3100000009, 095568, 009902, '26-12-2021', 67000);

/*  */