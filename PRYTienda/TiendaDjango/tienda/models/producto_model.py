# tienda/models/producto_model.py

class Producto:
    def __init__(self, id, nombre, descripcion, precio, stock, imagen, categoria, estado, fecha_creacion):
        self.id = id
        self.nombre = nombre
        self.descripcion = descripcion
        self.precio = precio
        self.stock = stock
        self.imagen = imagen
        self.categoria = categoria
        self.estado = estado
        self.fecha_creacion = fecha_creacion