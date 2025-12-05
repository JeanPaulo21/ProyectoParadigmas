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

CREATE OR ALTER PROCEDURE SC_Tienda.SP_ActualizarUsuario
    @ID INT,
    @Nombre VARCHAR(50),
    @Correo VARCHAR(100),
    @Contrasena VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Si la contraseña viene NULL, se mantiene la existente
    IF @Contrasena IS NULL OR LTRIM(RTRIM(@Contrasena)) = ''
    BEGIN
        SELECT @Contrasena = Contrasena
        FROM SC_Tienda.T_USUARIOS
        WHERE ID = @ID;
    END

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
CREATE OR ALTER PROCEDURE SC_Tienda.SP_AutenticarUsuario
    @Correo VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ID,
        Nombre,
        Correo,
        Contrasena,  
        Rol,
        Estado,
        FechaCreacion
    FROM SC_Tienda.T_USUARIOS
    WHERE Correo = @Correo
          AND Estado = 1;  
END

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
/*CREAR DESDE CARRITO*/
CREATE OR ALTER PROCEDURE SC_Tienda.SP_CrearPedidoDesdeCarrito
    @UsuarioID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @PedidoID INT;
        DECLARE @Subtotal DECIMAL(10,2);
        DECLARE @Total DECIMAL(10,2);

        -------------------------------------------
        -- 1) Calcular subtotal de productos del carrito
        -------------------------------------------
        SELECT @Subtotal = SUM(c.Cantidad * p.Precio)
        FROM SC_Tienda.T_CARRITO c
        INNER JOIN SC_Tienda.T_PRODUCTOS p ON c.ProductoID = p.ID
        WHERE c.UsuarioID = @UsuarioID;

        IF @Subtotal IS NULL OR @Subtotal = 0
        BEGIN
            RAISERROR('El carrito está vacío o no tiene productos válidos.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -------------------------------------------
        -- 2) Calcular total (si deseas agregar impuesto, aquí se modifica)
        -------------------------------------------
        SET @Total = @Subtotal;  -- ← SIN impuesto, igual que tus pedidos actuales
        -- SET @Total = @Subtotal + (@Subtotal * 0.13); -- ← Activa esto si quieres impuesto

        -------------------------------------------
        -- 3) Crear pedido
        -------------------------------------------
        INSERT INTO SC_Tienda.T_PEDIDOS (UsuarioID, Total, Estado, Fecha, FechaCreacion)
        VALUES (@UsuarioID, @Total, 'pendiente', GETDATE(), GETDATE());

        SET @PedidoID = SCOPE_IDENTITY();

        -------------------------------------------
        -- 4) Insertar detalles del pedido
        -------------------------------------------
        INSERT INTO SC_Tienda.T_DETALLE_PEDIDOS (PedidoID, ProductoID, Cantidad, Precio, FechaCreacion)
        SELECT
            @PedidoID,
            c.ProductoID,
            c.Cantidad,
            p.Precio,
            GETDATE()
        FROM SC_Tienda.T_CARRITO c
        INNER JOIN SC_Tienda.T_PRODUCTOS p ON c.ProductoID = p.ID
        WHERE c.UsuarioID = @UsuarioID;

        -------------------------------------------
        -- 5) Actualizar stock de productos
        -------------------------------------------
        UPDATE p
        SET p.Stock = p.Stock - c.Cantidad
        FROM SC_Tienda.T_PRODUCTOS p
        INNER JOIN SC_Tienda.T_CARRITO c ON p.ID = c.ProductoID
        WHERE c.UsuarioID = @UsuarioID;

        -- Validar stock negativo
        IF EXISTS (SELECT 1 FROM SC_Tienda.T_PRODUCTOS WHERE Stock < 0)
        BEGIN
            RAISERROR('No hay suficiente stock para completar la compra.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -------------------------------------------
        -- 6) Vaciar carrito del usuario
        -------------------------------------------
        DELETE FROM SC_Tienda.T_CARRITO WHERE UsuarioID = @UsuarioID;

        -------------------------------------------
        -- 7) Finalizar
        -------------------------------------------
        COMMIT TRANSACTION;

        PRINT 'Pedido creado correctamente y stock actualizado.';

        -- 8) Retornar pedido
        SELECT @PedidoID AS PedidoID;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH
END;
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
