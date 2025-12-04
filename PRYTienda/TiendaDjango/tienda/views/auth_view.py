import bcrypt
from django.shortcuts import render, redirect
from django.contrib import messages
from tienda.data.usuario_data import UsuarioData
from tienda.models.request.usuariorequest import UsuarioRequest

def login(request):
    if request.method == "POST":
        correo = request.POST.get("correo")
        contrasena = request.POST.get("contrasena")

        usuario = UsuarioData.autenticar_usuario(correo)

        if usuario is None:
            messages.error(request, "Credenciales incorrectas.")
            return redirect("login")

        # Validación con bcrypt
        if not bcrypt.checkpw(contrasena.encode(), usuario["contrasena_hash"].encode()):
            messages.error(request, "Credenciales incorrectas.")
            return redirect("login")

        # Guardar sesión
        request.session["usuario_id"] = usuario["id"]
        request.session["nombre"] = usuario["nombre"]
        request.session["rol"] = usuario["rol"]

        messages.success(request, f"Bienvenido {usuario['nombre']}")
        # redirecciones según rol
        if usuario["rol"] == "admin":
            return redirect("/panel/home/")
        else:
            return redirect("/home/index")

    return render(request, "auth/login.html")

def register(request):
    if request.method == "POST":
        nombre = request.POST.get("nombre")
        correo = request.POST.get("correo")
        contrasena = request.POST.get("contrasena")
        confirmar = request.POST.get("confirmar")

        # Validar contraseñas iguales
        if contrasena != confirmar:
            messages.error(request, "Las contraseñas no coinciden.")
            return redirect("register")

        # Hashear contraseña
        hashed = bcrypt.hashpw(contrasena.encode(), bcrypt.gensalt()).decode()

        # Crear request
        req = UsuarioRequest(
            Nombre=nombre,
            Correo=correo,
            Contrasena=hashed
        )

        # Guardar en BD
        try:
            UsuarioData.crear_usuario(req)
            messages.success(request, "Cuenta creada correctamente. Ahora puedes iniciar sesión.")
            return redirect("login")
        except Exception as ex:
            messages.error(request, "Error al registrar: " + str(ex))
            return redirect("register")

    return render(request, "auth/register.html")
def logout(request):
    # Limpiar toda la sesión
    request.session.flush()
    
    # Mensaje de cierre de sesión
    messages.success(request, "Has cerrado sesión correctamente.")
    
    # Redirigir al login
    return redirect("login")
