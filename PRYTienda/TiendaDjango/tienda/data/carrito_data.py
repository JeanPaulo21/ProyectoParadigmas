# tienda/data/carrito_data.py

from .conexion import obtener_conexion
from tienda.models.response.carrito_response import CarritoResponse


class CarritoData:


    @staticmethod
    def agregar_al_carrito(req):
        conn = obtener_conexion()
        cursor = conn.cursor()

        cursor.execute(
            """
            EXEC SC_Tienda.SP_AgregarAlCarrito 
                @UsuarioID=%s,
                @ProductoID=%s,
                @Cantidad=%s
            """,
            [req.UsuarioID, req.ProductoID, req.Cantidad],
        )

        conn.commit()
        cursor.close()
        return True


    @staticmethod
    def remover_del_carrito(id):
        conn = obtener_conexion()
        cursor = conn.cursor()

        cursor.execute(
            """
            EXEC SC_Tienda.SP_RemoverDelCarrito @ID=%s
            """,
            [id],
        )

        conn.commit()
        cursor.close()
        return True


    @staticmethod
    def listar_carrito_por_usuario(usuario_id):
        conn = obtener_conexion()
        cursor = conn.cursor()

        cursor.execute(
            """
            SELECT 
                c.ID,
                c.UsuarioID,
                c.ProductoID,
                c.Cantidad,
                c.FechaCreacion,
                p.Nombre,
                p.Precio,
                p.Imagen
            FROM SC_Tienda.T_CARRITO c
            INNER JOIN SC_Tienda.T_PRODUCTOS p ON c.ProductoID = p.ID
            WHERE c.UsuarioID = %s
            """,
            [usuario_id],
        )

        rows = cursor.fetchall()
        cursor.close()

        lista = []
        for r in rows:
            lista.append(
                CarritoResponse(
                    id=r[0],
                    usuario_id=r[1],
                    producto_id=r[2],
                    cantidad=r[3],
                    fecha_creacion=r[4],
                    producto_nombre=r[5],
                    producto_precio=r[6],
                    producto_imagen=r[7],
                )
            )

        return lista


    @staticmethod
    def obtener_total_carrito(usuario_id):
        items = CarritoData.listar_carrito_por_usuario(usuario_id)
        total = sum(item.cantidad * item.producto_precio for item in items)
        return total


    @staticmethod
    def contar_items_carrito(usuario_id):
        items = CarritoData.listar_carrito_por_usuario(usuario_id)
        return len(items)