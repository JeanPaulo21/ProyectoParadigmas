from django.shortcuts import render, redirect
from django.contrib import messages
from tienda.forms.usuario_form import UsuarioForm
from tienda.forms.usuario_form import UsuarioEditarForm
from tienda.models.request.usuariorequest import UsuarioRequest
from tienda.data.usuario_data import UsuarioData


# ============================
# LISTAR USUARIOS
# ============================
def listar_usuarios(request):
    usuarios = UsuarioData.listar_usuarios()
    return render(request, "usuarios/listar.html", {"usuarios": usuarios})


# ============================
# CREAR USUARIO
# ============================
def crear_usuario(request):
    if request.method == "POST":
        form = UsuarioForm(request.POST)

        if form.is_valid():
            cd = form.cleaned_data

            req = UsuarioRequest(
                Nombre=cd["Nombre"],
                Correo=cd["Correo"],
                Contrasena=cd["Contrasena"]
            )

            UsuarioData().crear_usuario(req)
            return redirect("listar_usuarios")

    else:
        form = UsuarioForm()

    return render(request, "usuarios/crear.html", {"form": form})
# ============================
# CAMBIAR ESTADO
# ============================
def cambiar_estado_usuario(request, id):
    resultado = UsuarioData.cambiar_estado_usuario(id)

    if resultado:
        messages.success(request, "Estado actualizado correctamente.")
    else:
        messages.error(request, "Error al cambiar el estado.")

    return redirect("listar_usuarios")
# ============================
# EDITAR USUARIO
# ============================
def editar_usuario(request, id):
    usuario = UsuarioData.obtener_usuario_por_id(id)  # necesitas tener este método

    if not usuario:
        messages.error(request, "El usuario no existe.")
        return redirect("listar_usuarios")

    if request.method == "POST":
        form = UsuarioEditarForm(request.POST)

        if form.is_valid():
            cd = form.cleaned_data

            req = UsuarioRequest(
                ID=id,
                Nombre=cd["Nombre"],
                Correo=cd["Correo"],
                Contrasena=cd["Contrasena"] if cd["Contrasena"] else None
            )

            UsuarioData.actualizar_usuario(req)
            messages.success(request, "Usuario actualizado correctamente.")
            return redirect("listar_usuarios")

    else:
        form = UsuarioEditarForm(initial={
            "Nombre": usuario.nombre,
            "Correo": usuario.correo
        })

    return render(request, "usuarios/editar.html", {"form": form, "usuario": usuario})
