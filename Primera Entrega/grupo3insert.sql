INSERT INTO Producto VALUES (1, 'Valorant', 'Shooter', 'Shooter multijugador 5v5 basado en personajes de Riot Games', 120000, 16 );
INSERT INTO Producto VALUES (002, 'Warzone', 'Shooter','Permite el combate multijugador online entre 150 jugadores', 80000, 18);
INSERT INTO Producto VALUES (003, 'Battlefront 1', 'Shooter','Es un videojuego donde se narran las películas de Star Wars', 15000, 13);
INSERT INTO Producto VALUES (004, 'Battlefront 2','Shooter','Es un videojuego de disparos en tercera y primera persona.', 25000, 13);
INSERT INTO Producto VALUES (005, 'Halo Infinite','Shooter','El juego es secuela de la historia de Halo 5 y Halo Wars 2',35000, 16);
INSERT INTO Producto VALUES (006, 'Counter Strike', 'Shooter', 'Es un videojuego de disparos en primera persona multijugador', 40000, 18 );
INSERT INTO Producto VALUES (007, '7 days to die', 'Terror','Es un videojuego de acción en primera y tercera persona.', 30000, 13);
INSERT INTO Producto VALUES (008, 'Terraria','Aventura','Es un videojuego de mundo abierto en 2D.', 60000, 12);
INSERT INTO Producto VALUES (009, 'Minecraft', 'Sandbox','Es un videojuego de construcción de tipo mundo abierto', 67000, 10);
INSERT INTO Producto VALUES (010, 'League of Legends', 'Multijugador','Es un videojuego de arena de batalla en línea.', 12000, 13);


INSERT INTO Ofrece VALUES (001, 12, 16, 5);
INSERT INTO Ofrece VALUES (002, 18, 18, 8);
INSERT INTO Ofrece VALUES (003, 35, 13, 100);
INSERT INTO Ofrece VALUES (004, 46, 13, 25);
INSERT INTO Ofrece VALUES (005, 53, 16, 48);
INSERT INTO Ofrece VALUES (006, 27, 18, 1000);
INSERT INTO Ofrece VALUES (007, 8, 13, 30000);
INSERT INTO Ofrece VALUES (008, 10, 12, 80);
INSERT INTO Ofrece VALUES (009, 15, 10, 68);
INSERT INTO Ofrece VALUES (010, 23, 13, 56);

INSERT INTO Favoritos VALUES(1000000000,001);
INSERT INTO Favoritos VALUES(2000000157,002);
INSERT INTO Favoritos VALUES(1000000150,004);
INSERT INTO Favoritos VALUES(1000000300,003);
INSERT INTO Favoritos VALUES(1000000575,005);
INSERT INTO Favoritos VALUES(1000500000,006);
INSERT INTO Favoritos VALUES(1000003456,007);
INSERT INTO Favoritos VALUES(1020000489,001);
INSERT INTO Favoritos VALUES(1000000001,003);
INSERT INTO Favoritos VALUES(1005000201,010);

INSERT INTO Biblioteca VALUES(1000000000,003);
INSERT INTO Biblioteca VALUES(2000000157,006);
INSERT INTO Biblioteca VALUES(1000000150,008);
INSERT INTO Biblioteca VALUES(1000000300,009);
INSERT INTO Biblioteca VALUES(1000000575,010);
INSERT INTO Biblioteca VALUES(1000500000,006);
INSERT INTO Biblioteca VALUES(1000003456,008);
INSERT INTO Biblioteca VALUES(1020000489,005);
INSERT INTO Biblioteca VALUES(1000000001,004);
INSERT INTO Biblioteca VALUES(1005000201,002);

COMMIT;