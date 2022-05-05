/*Tablas de la Base de Datos.*/

CREATE TABLE Usuario (
	idUsuario NUMBER(10) PRIMARY KEY,
	nombre CHAR(50) NOT NULL,
	contrasegna CHAR(30) NOT NULL,
	correo CHAR(30) UNIQUE NOT NULL,
	edad NUMBER(2) NOT NULL,
	ubicacion CHAR(20) NOT NULL,
	tipo CHAR(15) NOT NULL
);

CREATE TABLE Aplicacion (
	idTipo NUMBER(20) PRIMARY KEY,
	nroCuenta NUMBER(30) UNIQUE NOT NULL
);

CREATE TABLE Producto (
    idJuego NUMBER(10) PRIMARY KEY,
    titulo VARCHAR(40) NOT NULL,
    genero VARCHAR(20) NOT NULL,
    descripcion VARCHAR(60),
    precio NUMBER(6) NOT NULL,
    restriccionEdad NUMBER(2) NOT NULL
);

CREATE TABLE OfrecenDistribuidor (
    idUsuario NUMBER(10),
    idJuego NUMBER(10),
    FOREIGN KEY(idUsuario) REFERENCES Usuario(idUsuario),
    FOREIGN KEY(idJuego) REFERENCES Producto(idJuego)
);

CREATE TABLE Tarjeta (
    idTipo NUMBER(16) PRIMARY KEY,
    nombre CHAR(50) NOT NULL,
    numero NUMBER(16) UNIQUE NOT NULL,
    fechaVigencia DATE NOT NULL,
    CCV NUMBER(3) UNIQUE NOT NULL,
    Cuotas NUMBER(3) NOT NULL
);

CREATE TABLE Transacciones (
    idTransaccion NUMBER(10) PRIMARY KEY,
    codigoVerificacion NUMBER(6) UNIQUE NOT NULL,
    comprobante NUMBER(6) UNIQUE NOT NULL,
    fecha DATE NOT NULL,
    precio NUMBER(6) NOT NULL
);

CREATE TABLE MetodosPago (
    idTransaccion NUMBER(10) PRIMARY KEY,
    idTarjeta NUMBER(16),
    idAplicacion NUMBER(20),
    precio NUMBER(6) NOT NULL REFERENCES Transacciones,
    FOREIGN KEY(idTarjeta) REFERENCES Tarjeta(idTipo),
    FOREIGN KEY(idAplicacion) REFERENCES Aplicacion(idTipo),
    FOREIGN KEY(idTransaccion) REFERENCES Transacciones(idTransaccion)
);

CREATE TABLE Consume (
    idUsuario NUMBER(10),
    idJuego NUMBER(10),
    idTransaccion NUMBER(10),
    FOREIGN KEY(idUsuario) REFERENCES Usuario(idUsuario),
    FOREIGN KEY(idJuego) REFERENCES Producto(idJuego),
    FOREIGN KEY(idTransaccion) REFERENCES Transacciones(idTransaccion),
    CONSTRAINT PK_D PRIMARY KEY(idUsuario, idJuego, idTransaccion)
);

CREATE TABLE Ofrece(
    idJuego NUMBER(10) PRIMARY KEY,
    cantidadHoras NUMBER(3) NOT NULL,
    categoriaEdad NUMBER(2) NOT NULL,
    cantidadCompras NUMBER(6) NOT NULL,
    FOREIGN KEY(idJuego) REFERENCES Producto(idJuego)
);

CREATE TABLE Biblioteca (
    idUsuario NUMBER(10),
    idJuego NUMBER(10),
    FOREIGN KEY(idUsuario) REFERENCES Usuario(idUsuario),
    FOREIGN KEY(idJuego) REFERENCES Producto(idJuego),
    CONSTRAINT PK_A PRIMARY KEY(idUsuario, idJuego)
);

CREATE TABLE Favoritos (
    idUsuario NUMBER(10),
    idJuego NUMBER(10),
    FOREIGN KEY(idUsuario) REFERENCES Usuario(idUsuario),
    FOREIGN KEY(idJuego) REFERENCES Producto(idJuego),
    CONSTRAINT PK_B PRIMARY KEY(idUsuario, idJuego)
);