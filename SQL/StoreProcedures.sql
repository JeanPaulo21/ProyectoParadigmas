/* Stored Procedures for User Management */

--------------
/*USUARIOS*/
--------------
/*CREAR*/
DELIMITER //
CREATE PROCEDURE sp_CrearUsuario (
    IN p_Nombre VARCHAR(50),
    IN p_Correo VARCHAR(100),
    IN p_Contrasena VARCHAR(255),    
)
BEGIN
    INSERT INTO T_USUARIOS (Nombre, Correo, Contraseña, Rol, Estado, FechaCreacion)
    VALUES (p_Nombre, p_Correo, p_Contrasena, 'cliente', TRUE, NOW());
END //
DELIMITER ;
/*ACTUALIZAR*/
DELIMITER //
CREATE PROCEDURE sp_ActualizarUsuario (
    IN p_ID INT,
    IN p_Nombre VARCHAR(50),
    IN p_Correo VARCHAR(100),
    IN p_Contrasena VARCHAR(255),
    IN p_Rol ENUM('admin', 'cliente')
)
BEGIN
    UPDATE T_USUARIOS
    SET 
        Nombre = p_Nombre,
        Correo = p_Correo,
        Contraseña = p_Contrasena,
        Rol = p_Rol
    WHERE ID = p_ID AND Estado = TRUE;
END //
DELIMITER ;
/*CAMBIAR ESTADO*/
DELIMITER //
CREATE PROCEDURE sp_CambiarEstadoUsuario (
    IN p_ID INT,
    IN p_Estado BOOLEAN
)
BEGIN
    UPDATE T_USUARIOS
    SET Estado = p_Estado
    WHERE ID = p_ID;
END //
DELIMITER ;
/*OBTENER POR ID*/
DELIMITER //
CREATE PROCEDURE sp_ObtenerUsuarioPorId (
    IN p_ID INT
)
BEGIN
    SELECT ID, Nombre, Correo, Rol, Estado, FechaCreacion
    FROM T_USUARIOS
    WHERE ID = p_ID;
END //
DELIMITER ;
/*LISTAR TODOS LOS USUARIOS*/
DELIMITER //
CREATE PROCEDURE sp_ListarUsuariosActivos ()
BEGIN
    SELECT ID, Nombre, Correo, Rol, Estado, FechaCreacion
    FROM T_USUARIOS
    ORDER BY FechaCreacion DESC;
END //
DELIMITER ;
--------------
/*PRODUCTOS*/
--------------
/*CREAR*/
DELIMITER //
CREATE PROCEDURE sp_CrearProducto (
    IN p_Nombre VARCHAR(50),
    IN p_Descripcion TEXT,
    IN p_Precio DECIMAL(10, 2),
    IN p_Categoria VARCHAR(50)
)
BEGIN
    INSERT INTO T_PRODUCTOS (Nombre, Descripcion, Precio, Categoria, FechaCreacion)
    VALUES (p_Nombre, p_Descripcion, p_Precio, p_Categoria, NOW());
END //
DELIMITER ;
/*ACTUALIZAR*/
DELIMITER //    
CREATE PROCEDURE sp_ActualizarProducto (
    IN p_ID INT,
    IN p_Nombre VARCHAR(50),
    IN p_Descripcion TEXT,
    IN p_Precio DECIMAL(10, 2),
    IN p_Categoria VARCHAR(50)
)
BEGIN
    UPDATE T_PRODUCTOS
    SET 
        Nombre = p_Nombre,
        Descripcion = p_Descripcion,
        Precio = p_Precio,
        Categoria = p_Categoria
    WHERE ID = p_ID;
END //
DELIMITER ;
/*CAMBIAR ESTADO*/
DELIMITER //    
CREATE PROCEDURE sp_CambiarEstadoProducto (
    IN p_ID INT,
    IN p_Estado BOOLEAN
)
BEGIN
    UPDATE T_PRODUCTOS
    SET Estado = p_Estado
    WHERE ID = p_ID;
END //
DELIMITER ;
/*OBTENER POR ID*/
DELIMITER //
CREATE PROCEDURE sp_ObtenerProductoPorId (
    IN p_ID INT
)
BEGIN
    SELECT ID, Nombre, Descripcion, Precio, Categoria, Estado, FechaCreacion
    FROM T_PRODUCTOS
    WHERE ID = p_ID;
END //
DELIMITER ;
/*LISTAR TODOS LOS PRODUCTOS*/
DELIMITER //
CREATE PROCEDURE sp_ListarProductos ()
BEGIN
    SELECT ID, Nombre, Descripcion, Precio, Categoria, Estado, FechaCreacion
    FROM T_PRODUCTOS
    ORDER BY FechaCreacion DESC;
END //
DELIMITER ;
--------------
/*CARRITO*/
--------------
/*AGREGAR AL CARRITO*/
DELIMITER //    
CREATE PROCEDURE sp_AgregarAlCarrito (
    IN p_UsuarioID INT,
    IN p_ProductoID INT,
    IN p_Cantidad INT
)
BEGIN
    INSERT INTO T_CARRITO (UsuarioID, ProductoID, Cantidad, FechaCreacion)
    VALUES (p_UsuarioID, p_ProductoID, p_Cantidad, NOW());
END //
DELIMITER ;
/*ACTUALIZAR CANTIDAD EN CARRITO*/
DELIMITER //
CREATE PROCEDURE sp_ActualizarCantidadEnCarrito (
    IN p_UsuarioID INT,
    IN p_ProductoID INT,
    IN p_Cantidad INT
)
BEGIN
    UPDATE T_CARRITO
    SET Cantidad = p_Cantidad
    WHERE UsuarioID = p_UsuarioID AND ProductoID = p_ProductoID;
END //
DELIMITER ;
/*REMOVER DEL CARRITO*/
DELIMITER //
CREATE PROCEDURE sp_RemoverDelCarrito (
    IN p_UsuarioID INT,
    IN p_ProductoID INT
)
BEGIN
    DELETE FROM T_CARRITO
    WHERE UsuarioID = p_UsuarioID AND ProductoID = p_ProductoID;
END //
DELIMITER ;
/*LISTAR CARRITO POR USUARIO*/
DELIMITER //
CREATE PROCEDURE sp_ListarCarritoPorUsuario (
    IN p_UsuarioID INT
)
BEGIN
    SELECT C.ProductoID, P.Nombre, P.Precio, C.Cantidad
    FROM T_CARRITO C
    JOIN T_PRODUCTOS P ON C.ProductoID = P.ID
    WHERE C.UsuarioID = p_UsuarioID;
END //
DELIMITER ;

