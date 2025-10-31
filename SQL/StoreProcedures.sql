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