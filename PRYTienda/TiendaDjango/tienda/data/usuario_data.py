import bcrypt
from .conexion import obtener_conexion
from tienda.models.response.usuario_response import UsuarioResponse


class UsuarioData:

    # ================================
    #  LISTAR TODOS
    # ================================
    @staticmethod
    def listar_usuarios():
        conn = obtener_conexion()
        cursor = conn.cursor()

        cursor.execute("EXEC SC_Tienda.SP_ListarUsuarios")

        rows = cursor.fetchall()
        cursor.close()

        lista = []

        for r in rows:
            lista.append(
                UsuarioResponse(
                    id=r[0],
                    nombre=r[1],
                    correo=r[2],
                    rol=r[4],
                    estado=r[5],
                    fecha_creacion=r[6]
                )
            )

        return lista

    # ================================
    #  CREAR USUARIO (con BCrypt)
    # ================================
    @staticmethod
    def crear_usuario(req):
        conn = obtener_conexion()
        cursor = conn.cursor()

        # 🔐 Hash de contraseña
        hashed = bcrypt.hashpw(req.Contrasena.encode('utf-8'), bcrypt.gensalt())
        hashed = hashed.decode('utf-8')

        cursor.execute("""
            EXEC SC_Tienda.SP_CrearUsuario 
                @Nombre=%s, 
                @Correo=%s, 
                @Contrasena=%s
        """, [req.Nombre, req.Correo, hashed])

        conn.commit()
        cursor.close()
        return True

    # ================================
    #  ACTUALIZAR USUARIO (con BCrypt inteligente)
    # ================================
    @staticmethod
    def actualizar_usuario(req):
        conn = obtener_conexion()
        cursor = conn.cursor()

        # Si trae contraseña → la hasheamos
        if req.Contrasena:
            hashed = bcrypt.hashpw(req.Contrasena.encode('utf-8'), bcrypt.gensalt())
            hashed = hashed.decode('utf-8')
        else:
            # Si no viene nada, obtener la contraseña actual
            cursor.execute("""
                SELECT Contrasena 
                FROM SC_Tienda.T_USUARIOS 
                WHERE ID=%s
            """, [req.ID])

            hashed = cursor.fetchone()[0]  # contraseña actual

        cursor.execute("""
            EXEC SC_Tienda.SP_ActualizarUsuario 
                @ID=%s,
                @Nombre=%s,
                @Correo=%s,
                @Contrasena=%s
        """, [req.ID, req.Nombre, req.Correo, hashed])

        conn.commit()
        cursor.close()
        return True

    # ================================
    #  CAMBIAR ESTADO
    # ================================
    @staticmethod
    def cambiar_estado_usuario(id):
        conn = obtener_conexion()
        cursor = conn.cursor()

        usuario = UsuarioData.obtener_usuario_por_id(id)
        nuevo_estado = 0 if usuario.estado == 1 else 1

        cursor.execute("""
            EXEC SC_Tienda.SP_CambiarEstadoUsuario 
                @ID=%s,
                @Estado=%s
        """, [id, nuevo_estado])

        conn.commit()
        cursor.close()
        return True

    # ================================
    #  OBTENER POR ID
    # ================================
    @staticmethod
    def obtener_usuario_por_id(id):
        conn = obtener_conexion()
        cursor = conn.cursor()

        cursor.execute("""
            EXEC SC_Tienda.SP_ObtenerUsuarioPorID @ID=%s
        """, [id])

        row = cursor.fetchone()
        cursor.close()

        if row is None:
            return None

        return UsuarioResponse(
            id=row[0],
            nombre=row[1],
            correo=row[2],
            rol=row[4],
            estado=row[5],
            fecha_creacion=row[6]
        )
    # ================================
    #  AUTENTICAR USUARIO (LOGIN)
    # ================================
    @staticmethod
    def autenticar_usuario(correo):        
        conn = obtener_conexion()
        cursor = conn.cursor()

        cursor.execute("""
            EXEC SC_Tienda.SP_AutenticarUsuario @Correo=%s
        """, [correo])

        row = cursor.fetchone()
        cursor.close()

        if row is None:
            return None

        return {
            "id": row[0],
            "nombre": row[1],
            "correo": row[2],
            "contrasena_hash": row[3], 
            "rol": row[4],
            "estado": row[5],
            "fecha_creacion": row[6]
        }

