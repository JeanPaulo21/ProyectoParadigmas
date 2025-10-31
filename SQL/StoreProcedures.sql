/* Stored Procedures for User Management */

--------------
/*USUARIOS*/
--------------
/*CREAR*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_CrearUsuario
    @Nombre VARCHAR(50),
    @Correo VARCHAR(100),
    @Contrasena VARCHAR(255)
AS
BEGIN
    INSERT INTO SC_Tienda.T_USUARIOS (Nombre, Correo, Contrasena, Rol, Estado, FechaCreacion)
    VALUES (@Nombre, @Correo, @Contrasena, 'cliente', 1, GETDATE());
END
GO

/*ACTUALIZAR*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_ActualizarUsuario
    @ID INT,
    @Nombre VARCHAR(50),
    @Correo VARCHAR(100),
    @Contrasena VARCHAR(255)
AS
BEGIN
    UPDATE SC_Tienda.T_USUARIOS
    SET Nombre = @Nombre,
        Correo = @Correo,
        Contrasena = @Contrasena
    WHERE ID = @ID;
END
GO
/*CAMBIAR ESTADO*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_CambiarEstadoUsuario
    @ID INT,
    @Estado BIT
AS
BEGIN
    UPDATE SC_Tienda.T_USUARIOS
    SET Estado = @Estado
    WHERE ID = @ID;
END
GO
/*OBTENER POR ID*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_ObtenerUsuarioPorID
    @ID INT
AS
BEGIN
    SELECT *
    FROM SC_Tienda.T_USUARIOS
    WHERE ID = @ID;
END
/*LISTAR TODOS LOS USUARIOS*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_ListarUsuarios
AS
BEGIN
    SELECT *
    FROM SC_Tienda.T_USUARIOS;
END
GO
--------------
/*PRODUCTOS*/
--------------
/*CREAR*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_CrearProducto
    @Nombre VARCHAR(100),
    @Descripcion TEXT,
    @Precio DECIMAL(10, 2),
    @Stock INT,
    @Imagen VARCHAR(255),
    @Categoria VARCHAR(20)
AS
BEGIN
    INSERT INTO SC_Tienda.T_PRODUCTOS (Nombre, Descripcion, Precio, Stock, Imagen, Categoria, Estado, FechaCreacion)
    VALUES (@Nombre, @Descripcion, @Precio, @Stock, @Imagen, @Categoria, 1, GETDATE());
END
GO
/*ACTUALIZAR*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_ActualizarProducto
    @ID INT,
    @Nombre VARCHAR(100),
    @Descripcion TEXT,
    @Precio DECIMAL(10, 2),
    @Stock INT,
    @Imagen VARCHAR(255),
    @Categoria VARCHAR(20)
AS
BEGIN
    UPDATE SC_Tienda.T_PRODUCTOS
    SET Nombre = @Nombre,
        Descripcion = @Descripcion,
        Precio = @Precio,
        Stock = @Stock,
        Imagen = @Imagen,
        Categoria = @Categoria
    WHERE ID = @ID;
END
GO
/*CAMBIAR ESTADO*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_CambiarEstadoProducto
    @ID INT,
    @Estado BIT
AS
BEGIN
    UPDATE SC_Tienda.T_PRODUCTOS
    SET Estado = @Estado
    WHERE ID = @ID;
END
GO
/*OBTENER POR ID*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_ObtenerProductoPorID
    @ID INT
AS
BEGIN
    SELECT *
    FROM SC_Tienda.T_PRODUCTOS
    WHERE ID = @ID;
END 
GO
/*LISTAR TODOS LOS PRODUCTOS*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_ListarProductos
AS
BEGIN
    SELECT *
    FROM SC_Tienda.T_PRODUCTOS;
END 
GO
-------------- 
/*PEDIDOS*/
--------------
/*CREAR*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_CrearPedido
    @UsuarioID INT,
    @Total DECIMAL(10,2),
    @Estado VARCHAR(20)
AS
BEGIN
    INSERT INTO SC_Tienda.T_PEDIDOS (UsuarioID, Total, Estado, Fecha, FechaCreacion)
    VALUES (@UsuarioID, @Total, @Estado, GETDATE(), GETDATE());
END
GO
/*ACTUALIZAR*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_ActualizarPedido
    @ID INT,
    @UsuarioID INT,
    @Total DECIMAL(10,2),
    @Estado VARCHAR(20)
AS
BEGIN
    UPDATE SC_Tienda.T_PEDIDOS
    SET UsuarioID = @UsuarioID,
        Total = @Total,
        Estado = @Estado
    WHERE ID = @ID;
END
GO
/*CAMBIAR ESTADO*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_CambiarEstadoPedido
    @ID INT,
    @Estado VARCHAR(20)
AS
BEGIN
    UPDATE SC_Tienda.T_PEDIDOS
    SET Estado = @Estado
    WHERE ID = @ID;
END
GO
/*OBTENER POR ID*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_ObtenerPedidoPorID
    @ID INT
AS
BEGIN
    SELECT *
    FROM SC_Tienda.T_PEDIDOS
    WHERE ID = @ID;
END
GO
/*LISTAR TODOS LOS PEDIDOS*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_ListarPedidos
AS
BEGIN
    SELECT *
    FROM SC_Tienda.T_PEDIDOS;
END
GO
-------------- 
/*DETALLE PEDIDOS*/
--------------
/*CREAR*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_CrearDetallePedido
    @PedidoID INT,
    @ProductoID INT,
    @Cantidad INT,
    @Precio DECIMAL(10,2)
AS
BEGIN
    INSERT INTO SC_Tienda.T_DETALLE_PEDIDOS (PedidoID, ProductoID, Cantidad, Precio, FechaCreacion)
    VALUES (@PedidoID, @ProductoID, @Cantidad, @Precio, GETDATE());
END
GO
/*ACTUALIZAR*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_ActualizarDetallePedido
    @ID INT,
    @PedidoID INT,
    @ProductoID INT,
    @Cantidad INT,
    @Precio DECIMAL(10,2)
AS
BEGIN
    UPDATE SC_Tienda.T_DETALLE_PEDIDOS
    SET PedidoID = @PedidoID,
        ProductoID = @ProductoID,
        Cantidad = @Cantidad,
        Precio = @Precio
    WHERE ID = @ID;
END
GO
/*OBTENER POR ID*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_ObtenerDetallePedidoPorID
    @ID INT
AS
BEGIN
    SELECT *
    FROM SC_Tienda.T_DETALLE_PEDIDOS
    WHERE ID = @ID;
END
GO
/*LISTAR TODOS LOS DETALLES*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_ListarDetallesPedidos
AS
BEGIN
    SELECT *
    FROM SC_Tienda.T_DETALLE_PEDIDOS;
END
GO
--------------
/*CARRITO*/
--------------
/*AGREGAR AL CARRITO*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_AgregarAlCarrito
    @UsuarioID INT,
    @ProductoID INT,
    @Cantidad INT
AS
BEGIN
    INSERT INTO SC_Tienda.T_CARRITO (UsuarioID, ProductoID, Cantidad, FechaAgregado)
    VALUES (@UsuarioID, @ProductoID, @Cantidad, GETDATE());
END
GO
/*REMOVER DEL CARRITO*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_RemoverDelCarrito
    @ID INT
AS
BEGIN
    DELETE FROM SC_Tienda.T_CARRITO
    WHERE ID = @ID;
END
GO
/*LISTAR CARRITO POR USUARIO*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_ListarCarritoPorUsuario
    @UsuarioID INT  
AS
BEGIN
    SELECT *
    FROM SC_Tienda.T_CARRITO
    WHERE UsuarioID = @UsuarioID;
END 
GO
/*LISTAR TODOS LOS CARRITOS*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_ListarTodosLosCarritos
AS
BEGIN
    SELECT *
    FROM SC_Tienda.T_CARRITO;
END
GO  
