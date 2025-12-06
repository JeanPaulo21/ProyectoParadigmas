# tienda/models/response/pedido_response.py

class PedidoResponse:
    def __init__(self, id, usuario_id, fecha, total, estado, fecha_creacion):
        self.id = id
        self.usuario_id = usuario_id
        self.fecha = fecha
        self.total = total
        self.estado = estado
        self.fecha_creacion = fecha_creacion