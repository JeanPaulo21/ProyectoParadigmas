# tienda/models/usuario_model.py

class Usuario:
    def __init__(self, id, nombre, correo, contrasena, rol, estado, fecha_creacion):
        self.id = id
        self.nombre = nombre
        self.correo = correo
        self.contrasena = contrasena
        self.rol = rol
        self.estado = estado
        self.fecha_creacion = fecha_creacion
