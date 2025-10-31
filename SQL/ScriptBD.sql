CREATE DATABASE BD_TiendaProyecto;

USE BD_TiendaProyecto;
-------------------------------------------
CREATE TABLE T_USUARIOS (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50),
    Correo VARCHAR(100) UNIQUE,
    Contraseña VARCHAR(255),
    Rol ENUM('admin', 'cliente'),
    Estado BOOLEAN DEFAULT TRUE,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE T_PRODUCTOS (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100),
    Descripcion TEXT,
    Precio DECIMAL(10, 2),
    Stock INT,
    Imagen VARCHAR(255),
    Categoria ENUM('Computación', 'Consolas', 'VideoJuegos', 'DispositivosMoviles'),
    Estado BOOLEAN DEFAULT TRUE,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE T_PEDIDOS (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    UsuarioID INT,
    Fecha DATETIME,
    Total DECIMAL(10, 2),
    Estado ENUM('pendiente', 'procesando', 'completado', 'cancelado'),
    FOREIGN KEY (UsuarioID) REFERENCES T_USUARIOS(ID),
    Estado BOOLEAN DEFAULT TRUE,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE T_DETALLE_PEDIDOS (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    PedidoID INT,
    ProductoID INT,
    Cantidad INT,
    Precio DECIMAL(10, 2),
    FOREIGN KEY (PedidoID) REFERENCES T_PEDIDOS(ID),
    FOREIGN KEY (ProductoID) REFERENCES T_PRODUCTOS(ID),
    Estado BOOLEAN DEFAULT TRUE,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE T_CARRITO (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    UsuarioID INT,
    ProductoID INT,
    Cantidad INT,
    FOREIGN KEY (UsuarioID) REFERENCES T_USUARIOS(ID),
    FOREIGN KEY (ProductoID) REFERENCES T_PRODUCTOS(ID),
    Estado BOOLEAN DEFAULT TRUE,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
);