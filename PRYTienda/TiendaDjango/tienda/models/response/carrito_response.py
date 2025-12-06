# tienda/models/response/carrito_response.py

class CarritoResponse:
    def __init__(self, id, usuario_id, producto_id, cantidad, fecha_creacion, 
                 producto_nombre=None, producto_precio=None, producto_imagen=None):
        self.id = id
        self.usuario_id = usuario_id
        self.producto_id = producto_id
        self.cantidad = cantidad
        self.fecha_creacion = fecha_creacion
        # Datos extras del producto
        self.producto_nombre = producto_nombre
        self.producto_precio = producto_precio
        self.producto_imagen = producto_imagen