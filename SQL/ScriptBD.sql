CREATE DATABASE BD_TiendaProyecto;
USE BD_TiendaProyecto;
CREATE SCHEMA SC_Tienda;

-- ============================================
-- Tabla de Usuarios
-- ============================================
CREATE TABLE SC_Tienda.T_USUARIOS (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Correo VARCHAR(100) NOT NULL UNIQUE,
    Contrasena VARCHAR(255) NOT NULL,
    Rol VARCHAR(10) NOT NULL CHECK (Rol IN ('admin', 'cliente')),
    Estado BIT DEFAULT 1,
    FechaCreacion DATETIME DEFAULT GETDATE()
);
GO
-- ============================================
-- Tabla de Productos
-- ============================================
CREATE TABLE SC_Tienda.T_PRODUCTOS (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT NULL,
    Precio DECIMAL(10, 2) NOT NULL,
    Stock INT DEFAULT 0,
    Imagen VARCHAR(255) NULL,
    Categoria VARCHAR(20) NOT NULL CHECK (Categoria IN ('Computación', 'Consolas', 'VideoJuegos', 'DispositivosMoviles')),
    Estado BIT DEFAULT 1,
    FechaCreacion DATETIME DEFAULT GETDATE()
);
GO
-- ============================================
-- Tabla de Pedidos
-- ============================================
CREATE TABLE SC_Tienda.T_PEDIDOS (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT NOT NULL,
    Fecha DATETIME DEFAULT GETDATE(),
    Total DECIMAL(10, 2) NOT NULL,
    Estado VARCHAR(20) NOT NULL CHECK (Estado IN ('pendiente', 'procesando', 'completado', 'cancelado')),
    FechaCreacion DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Pedidos_Usuarios FOREIGN KEY (UsuarioID) REFERENCES SC_Tienda.T_USUARIOS(ID)
);
GO
-- ============================================
-- Tabla de Detalle Pedidos
-- ============================================
CREATE TABLE SC_Tienda.T_DETALLE_PEDIDOS (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    PedidoID INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad INT NOT NULL,
    Precio DECIMAL(10, 2) NOT NULL,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_DetallePedidos_Pedidos FOREIGN KEY (PedidoID) REFERENCES SC_Tienda.T_PEDIDOS(ID),
    CONSTRAINT FK_DetallePedidos_Productos FOREIGN KEY (ProductoID) REFERENCES SC_Tienda.T_PRODUCTOS(ID)
);
GO
-- ============================================
-- Tabla de Carrito
-- ============================================
CREATE TABLE SC_Tienda.T_CARRITO (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad INT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Carrito_Usuarios FOREIGN KEY (UsuarioID) REFERENCES SC_Tienda.T_USUARIOS(ID),
    CONSTRAINT FK_Carrito_Productos FOREIGN KEY (ProductoID) REFERENCES SC_Tienda.T_PRODUCTOS(ID)
);
GO
