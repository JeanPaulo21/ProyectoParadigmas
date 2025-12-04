class UsuarioResponse:
    def __init__(self, id, nombre, correo, rol, estado, fecha_creacion):
        self.id = id
        self.nombre = nombre
        self.correo = correo
        self.rol = rol
        self.estado = estado
        self.fecha_creacion = fecha_creacion