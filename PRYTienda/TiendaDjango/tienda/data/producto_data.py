from .conexion import obtener_conexion
from tienda.models.response.producto_response import ProductoResponse


class ProductoData:

    # ================================
    #  LISTAR TODOS
    # ================================
    @staticmethod
    def listar_productos():
        conn = obtener_conexion()
        cursor = conn.cursor()

        cursor.execute("EXEC SC_Tienda.SP_ListarProductos")

        rows = cursor.fetchall()
        cursor.close()

        lista = []

        for r in rows:
            lista.append(
                ProductoResponse(
                    id=r[0],
                    nombre=r[1],
                    descripcion=r[2],
                    precio=r[3],
                    stock=r[4],
                    imagen=r[5],
                    categoria=r[6],
                    estado=r[7],
                    fecha_creacion=r[8],
                )
            )

        return lista

    # ================================
    #  CREAR PRODUCTO
    # ================================
    @staticmethod
    def crear_producto(req):
        conn = obtener_conexion()
        cursor = conn.cursor()

        cursor.execute(
            """
            EXEC SC_Tienda.SP_CrearProducto 
                @Nombre=%s,
                @Descripcion=%s,
                @Precio=%s,
                @Stock=%s,
                @Imagen=%s,
                @Categoria=%s
            """,
            [
                req.Nombre,
                req.Descripcion,
                req.Precio,
                req.Stock,
                req.Imagen,
                req.Categoria,
            ],
        )

        conn.commit()
        cursor.close()
        return True

    # ================================
    #  ACTUALIZAR PRODUCTO
    # ================================
    @staticmethod
    def actualizar_producto(req):
        conn = obtener_conexion()
        cursor = conn.cursor()

        cursor.execute(
            """
            EXEC SC_Tienda.SP_ActualizarProducto 
                @ID=%s,
                @Nombre=%s,
                @Descripcion=%s,
                @Precio=%s,
                @Stock=%s,
                @Imagen=%s,
                @Categoria=%s
            """,
            [
                req.ID,
                req.Nombre,
                req.Descripcion,
                req.Precio,
                req.Stock,
                req.Imagen,
                req.Categoria,
            ],
        )

        conn.commit()
        cursor.close()
        return True

    # ================================
    #  CAMBIAR ESTADO
    # ================================
    @staticmethod
    def cambiar_estado_producto(id):
        conn = obtener_conexion()
        cursor = conn.cursor()

        producto = ProductoData.obtener_producto_por_id(id)
        nuevo_estado = 0 if producto.estado == 1 else 1

        cursor.execute(
            """
            EXEC SC_Tienda.SP_CambiarEstadoProducto 
                @ID=%s,
                @Estado=%s
            """,
            [id, nuevo_estado],
        )

        conn.commit()
        cursor.close()
        return True

    # ================================
    #  OBTENER POR ID
    # ================================
    @staticmethod
    def obtener_producto_por_id(id):
        conn = obtener_conexion()
        cursor = conn.cursor()

        cursor.execute(
            """
            EXEC SC_Tienda.SP_ObtenerProductoPorID @ID=%s
            """,
            [id],
        )

        row = cursor.fetchone()
        cursor.close()

        if row is None:
            return None

        return ProductoResponse(
            id=row[0],
            nombre=row[1],
            descripcion=row[2],
            precio=row[3],
            stock=row[4],
            imagen=row[5],
            categoria=row[6],
            estado=row[7],
            fecha_creacion=row[8],
        )
