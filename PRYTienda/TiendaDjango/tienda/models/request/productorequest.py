class ProductoRequest:
    def __init__(self, ID=None, Nombre=None, Descripcion=None, Precio=None, Stock=None, Imagen=None, Categoria=None):
        self.ID = ID
        self.Nombre = Nombre
        self.Descripcion = Descripcion
        self.Precio = Precio
        self.Stock = Stock
        self.Imagen = Imagen
        self.Categoria = Categoria