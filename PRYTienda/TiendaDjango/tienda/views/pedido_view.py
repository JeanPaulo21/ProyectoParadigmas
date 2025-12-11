from django.shortcuts import render, redirect
from django.contrib import messages

from tienda.data.pedido_data import PedidoData


# LISTAR PEDIDOS (ADMIN)
def listar_pedidos(request):
    rol = request.session.get("rol")
    if rol != "admin":
        messages.error(request, "No tienes permiso para acceder a esta sección.")
        return redirect("home")

    pedidos = PedidoData.listar_pedidos()

    return render(request, "pedidos/listar.html", {
        "pedidos": pedidos,
    })


# CAMBIAR ESTADO PEDIDO (ADMIN)
def cambiar_estado_pedido(request, id):
    rol = request.session.get("rol")
    if rol != "admin":
        messages.error(request, "No tienes permiso para realizar esta acción.")
        return redirect("home")

    ok = PedidoData.cambiar_estado_pedido(id)

    if ok:
        messages.success(request, "Estado del pedido actualizado correctamente.")
    else:
        messages.error(request, "No se encontró el pedido.")

    return redirect("listar_pedidos")


# LISTAR PEDIDOS DEL CLIENTE
def mis_pedidos(request):
    usuario_id = request.session.get("usuario_id")

    if not usuario_id:
        messages.error(request, "Debes iniciar sesión para ver tus pedidos.")
        return redirect("login")

    pedidos = PedidoData.listar_pedidos_por_usuario(usuario_id)

    return render(request, "pedidos/mis_pedidos.html", {
        "pedidos": pedidos,
    })