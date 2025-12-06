# tienda/views/carrito_views.py

from django.shortcuts import render, redirect
from django.contrib import messages
from django.http import JsonResponse
from tienda.data.carrito_data import CarritoData
from tienda.data.pedido_data import PedidoData
from tienda.models.request.carrito_request import CarritoRequest


# ============================
# VER CARRITO
# ============================
def ver_carrito(request):
    usuario_id = request.session.get("usuario_id")
    
    if not usuario_id:
        messages.error(request, "Debes iniciar sesión para ver tu carrito.")
        return redirect("login")
    
    items = CarritoData.listar_carrito_por_usuario(usuario_id)
    total = CarritoData.obtener_total_carrito(usuario_id)
    
    return render(request, "carrito/ver_carrito.html", {
        "items": items,
        "total": total
    })


# ============================
# AGREGAR AL CARRITO
# ============================
def agregar_al_carrito(request, producto_id):
    usuario_id = request.session.get("usuario_id")
    
    if not usuario_id:
        messages.error(request, "Debes iniciar sesión para agregar productos al carrito.")
        return redirect("login")
    
    cantidad = int(request.POST.get("cantidad", 1))
    
    req = CarritoRequest(
        UsuarioID=usuario_id,
        ProductoID=producto_id,
        Cantidad=cantidad
    )
    
    CarritoData.agregar_al_carrito(req)
    messages.success(request, "Producto agregado al carrito correctamente.")
    
    return redirect("listar_productos_publico")


# ============================
# REMOVER DEL CARRITO
# ============================
def remover_del_carrito(request, item_id):
    usuario_id = request.session.get("usuario_id")
    
    if not usuario_id:
        messages.error(request, "Debes iniciar sesión.")
        return redirect("login")
    
    CarritoData.remover_del_carrito(item_id)
    messages.success(request, "Producto eliminado del carrito.")
    
    return redirect("ver_carrito")


# ============================
# OBTENER CONTADOR CARRITO (AJAX)
# ============================
def obtener_contador_carrito(request):
    usuario_id = request.session.get("usuario_id")
    
    if not usuario_id:
        return JsonResponse({"count": 0})
    
    count = CarritoData.contar_items_carrito(usuario_id)
    return JsonResponse({"count": count})


# ============================
# PÁGINA DE CHECKOUT
# ============================
def checkout(request):
    usuario_id = request.session.get("usuario_id")
    
    if not usuario_id:
        messages.error(request, "Debes iniciar sesión para proceder al pago.")
        return redirect("login")
    
    items = CarritoData.listar_carrito_por_usuario(usuario_id)
    
    if not items:
        messages.warning(request, "Tu carrito está vacío.")
        return redirect("ver_carrito")
    
    total = CarritoData.obtener_total_carrito(usuario_id)
    
    return render(request, "carrito/checkout.html", {
        "items": items,
        "total": total
    })


# ============================
# PROCESAR PAGO
# ============================
def procesar_pago(request):
    if request.method != "POST":
        return redirect("checkout")
    
    usuario_id = request.session.get("usuario_id")
    
    if not usuario_id:
        messages.error(request, "Debes iniciar sesión.")
        return redirect("login")
    
    items = CarritoData.listar_carrito_por_usuario(usuario_id)
    if not items:
        messages.warning(request, "Tu carrito está vacío.")
        return redirect("ver_carrito")
    
    try:
        # Llamar al stored procedure que:
        # 1. Crea el pedido
        # 2. Inserta los detalles
        # 3. Actualiza el stock
        # 4. Vacía el carrito
        pedido_id = PedidoData.crear_pedido_desde_carrito(usuario_id)
        
        if pedido_id:
            messages.success(request, f"¡Pago procesado correctamente! Tu número de pedido es: {pedido_id}")
            return redirect("confirmacion_pedido", pedido_id=pedido_id)
        else:
            messages.error(request, "Hubo un error al procesar tu pedido.")
            return redirect("checkout")
            
    except Exception as e:
        messages.error(request, f"Error al procesar el pago: {str(e)}")
        return redirect("checkout")


# ============================
# CONFIRMACIÓN DE PEDIDO
# ============================
def confirmacion_pedido(request, pedido_id):
    usuario_id = request.session.get("usuario_id")
    
    if not usuario_id:
        messages.error(request, "Debes iniciar sesión.")
        return redirect("login")
    
    pedido = PedidoData.obtener_pedido_por_id(pedido_id)
    detalles = PedidoData.obtener_detalles_pedido(pedido_id)
    
    return render(request, "carrito/confirmacion.html", {
        "pedido": pedido,
        "detalles": detalles
    })