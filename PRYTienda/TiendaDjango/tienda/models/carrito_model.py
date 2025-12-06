# tienda/models/carrito_model.py

class Carrito:
    def __init__(self, id, usuario_id, producto_id, cantidad, fecha_creacion):
        self.id = id
        self.usuario_id = usuario_id
        self.producto_id = producto_id
        self.cantidad = cantidad
        self.fecha_creacion = fecha_creacion