CREATE DATABASE BD_TiendaProyecto;

USE BD_TiendaProyecto;

CREATE SCHEMA SC_PROYECTO;
CREATE TABLE SC_PROYECTO.T_USUARIOS (
    ID INT PRIMARY KEY,
    Nombre VARCHAR(50),
    Correo VARCHAR(100) UNIQUE,
    Contraseña VARCHAR(255),
    Role enum('admin', 'cliente')
);
CREATE TABLE SC_PROYECTO.T_PRODUCTOS (
    ID INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Descripcion TEXT,
    Precio DECIMAL(10, 2),
    Stock INT,
    Imagen VARCHAR(255),
    Categoria enum('Computación', 'Consolas', 'VideoJuegos','DispositivosMoviles')
);
CREATE TABLE SC_PROYECTO.T_DETALLE_PEDIDOS (
    ID INT PRIMARY KEY,
    PedidoID INT,
    ProductoID INT,
    Cantidad INT,
    Precio DECIMAL(10, 2),
    FOREIGN KEY (PedidoID) REFERENCES SC_PROYECTO.T_PEDIDOS(ID),
    FOREIGN KEY (ProductoID) REFERENCES SC_PROYECTO.T_PRODUCTOS(ID)
);
CREATE TABLE SC_PROYECTO.T_PEDIDOS (
    ID INT PRIMARY KEY,
    Fecha DATETIME,
    Total DECIMAL(10, 2),
    Estado enum('pendiente', 'procesando', 'completado', 'cancelado'),
    FOREIGN KEY (UsuarioID) REFERENCES SC_PROYECTO.T_USUARIOS(ID)
);  

/*usar base de datos 
crear llaves primarias,foraneas
podemos usar stored procedures (sp)*/