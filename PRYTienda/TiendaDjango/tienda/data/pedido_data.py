# tienda/data/pedido_data.py

from .conexion import obtener_conexion
from tienda.models.response.pedido_response import PedidoResponse
from tienda.models.response.detalle_pedido_response import DetallePedidoResponse


class PedidoData:

    @staticmethod
    def crear_pedido_desde_carrito(usuario_id):
        conn = obtener_conexion()
        cursor = conn.cursor()

        try:
            cursor.execute(
                """
                EXEC SC_Tienda.SP_CrearPedidoDesdeCarrito @UsuarioID=%s
                """,
                [usuario_id],
            )

            row = cursor.fetchone()
            conn.commit()

            if row:
                pedido_id = row[0]
                cursor.close()
                return pedido_id

            cursor.close()
            return None

        except Exception as e:
            conn.rollback()
            cursor.close()
            raise e

    @staticmethod
    def obtener_pedido_por_id(pedido_id):
        conn = obtener_conexion()
        cursor = conn.cursor()

        cursor.execute(
            """
            EXEC SC_Tienda.SP_ObtenerPedidoPorID @ID=%s
            """,
            [pedido_id],
        )

        row = cursor.fetchone()
        cursor.close()

        if row is None:
            return None

        return PedidoResponse(
            id=row[0],
            usuario_id=row[1],
            fecha=row[2],
            total=row[3],
            estado=row[4],
            fecha_creacion=row[5],
        )

    @staticmethod
    def obtener_detalles_pedido(pedido_id):
        conn = obtener_conexion()
        cursor = conn.cursor()

        cursor.execute(
            """
            SELECT 
                dp.ID,
                dp.PedidoID,
                dp.ProductoID,
                dp.Cantidad,
                dp.Precio,
                dp.FechaCreacion,
                p.Nombre,
                p.Imagen
            FROM SC_Tienda.T_DETALLE_PEDIDOS dp
            INNER JOIN SC_Tienda.T_PRODUCTOS p ON dp.ProductoID = p.ID
            WHERE dp.PedidoID = %s
            """,
            [pedido_id],
        )

        rows = cursor.fetchall()
        cursor.close()

        lista = []
        for r in rows:
            lista.append(
                DetallePedidoResponse(
                    id=r[0],
                    pedido_id=r[1],
                    producto_id=r[2],
                    cantidad=r[3],
                    precio=r[4],
                    fecha_creacion=r[5],
                    producto_nombre=r[6],
                    producto_imagen=r[7],
                )
            )

        return lista

    @staticmethod
    def listar_pedidos_por_usuario(usuario_id):
        conn = obtener_conexion()
        cursor = conn.cursor()

        cursor.execute(
            """
            SELECT * 
            FROM SC_Tienda.T_PEDIDOS 
            WHERE UsuarioID = %s
            ORDER BY FechaCreacion DESC
            """,
            [usuario_id],
        )

        rows = cursor.fetchall()
        cursor.close()

        lista = []
        for r in rows:
            lista.append(
                PedidoResponse(
                    id=r[0],
                    usuario_id=r[1],
                    fecha=r[2],
                    total=r[3],
                    estado=r[4],
                    fecha_creacion=r[5],
                )
            )

        return lista

    @staticmethod
    def listar_pedidos():
        """Lista todos los pedidos (uso para administradores)."""
        conn = obtener_conexion()
        cursor = conn.cursor()

        cursor.execute(
            """
            EXEC SC_Tienda.SP_ListarPedidos
            """
        )

        rows = cursor.fetchall()
        cursor.close()

        lista = []
        for r in rows:
            lista.append(
                PedidoResponse(
                    id=r[0],
                    usuario_id=r[1],
                    fecha=r[2],
                    total=r[3],
                    estado=r[4],
                    fecha_creacion=r[5],
                )
            )

        return lista

    @staticmethod
    def cambiar_estado_pedido(pedido_id, nuevo_estado=None):
        """Cambia el estado de un pedido.

        Si no se indica "nuevo_estado", alterna entre 'pendiente' y 'completado',
        usando los valores permitidos por el CHECK de la tabla.
        """
        conn = obtener_conexion()
        cursor = conn.cursor()

        if nuevo_estado is None:
            pedido = PedidoData.obtener_pedido_por_id(pedido_id)
            if not pedido:
                cursor.close()
                return False

            estado_actual = str(pedido.estado)

            if estado_actual.lower() == "pendiente":
                nuevo_estado = "completado"
            else:
                nuevo_estado = "pendiente"

        cursor.execute(
            """
            EXEC SC_Tienda.SP_CambiarEstadoPedido 
                @ID=%s,
                @Estado=%s
            """,
            [pedido_id, nuevo_estado],
        )

        conn.commit()
        cursor.close()

        return True