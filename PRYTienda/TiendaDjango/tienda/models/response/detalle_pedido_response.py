# tienda/models/response/detalle_pedido_response.py

class DetallePedidoResponse:
    def __init__(self, id, pedido_id, producto_id, cantidad, precio, fecha_creacion,
                 producto_nombre=None, producto_imagen=None):
        self.id = id
        self.pedido_id = pedido_id
        self.producto_id = producto_id
        self.cantidad = cantidad
        self.precio = precio
        self.fecha_creacion = fecha_creacion
        self.producto_nombre = producto_nombre
        self.producto_imagen = producto_imagen