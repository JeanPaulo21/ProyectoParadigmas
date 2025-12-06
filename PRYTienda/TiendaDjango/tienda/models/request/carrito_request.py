# tienda/models/request/carrito_request.py

class CarritoRequest:
    def __init__(self, UsuarioID=None, ProductoID=None, Cantidad=None, ID=None):
        self.ID = ID
        self.UsuarioID = UsuarioID
        self.ProductoID = ProductoID
        self.Cantidad = Cantidad