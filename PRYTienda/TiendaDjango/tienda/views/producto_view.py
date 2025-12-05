from django.shortcuts import render, redirect
from django.contrib import messages
from tienda.forms.producto_form import ProductoForm
from tienda.forms.producto_form import ProductoEditarForm
from tienda.models.request.productorequest import ProductoRequest
from tienda.data.producto_data import ProductoData



# ============================
# LISTAR PRODUCTOS
# ============================

def listar_productos(request):
    productos = ProductoData.listar_productos()
    return render(request, "productos/listar.html", {"productos": productos})

def listar_productos_publico(request):
    productos = ProductoData.listar_productos()
    return render(request, "productos/productos_publico.html", {"productos": productos})


# ============================
# CREAR PRODUCTO
# ============================

def crear_producto(request):
    if request.method == "POST":
        form = ProductoForm(request.POST)

        if form.is_valid():
            cd = form.cleaned_data

            req = ProductoRequest(
                Nombre=cd["Nombre"],
                Descripcion=cd["Descripcion"],
                Precio=cd["Precio"],
                Stock=cd["Stock"],
                Imagen=cd["Imagen"],
                Categoria=cd["Categoria"],
            )

            ProductoData.crear_producto(req)
            messages.success(request, "Producto creado correctamente.")
            return redirect("listar_productos")
    else:
        form = ProductoForm()

    return render(request, "productos/crear.html", {"form": form})


# ============================
# CAMBIAR ESTADO
# ============================

def cambiar_estado_producto(request, id):
    resultado = ProductoData.cambiar_estado_producto(id)

    if resultado:
        messages.success(request, "Estado del producto actualizado correctamente.")
    else:
        messages.error(request, "Error al cambiar el estado del producto.")

    return redirect("listar_productos")


# ============================
# EDITAR PRODUCTO
# ============================

def editar_producto(request, id):
    producto = ProductoData.obtener_producto_por_id(id)

    if not producto:
        messages.error(request, "El producto no existe.")
        return redirect("listar_productos")

    if request.method == "POST":
        form = ProductoEditarForm(request.POST)

        if form.is_valid():
            cd = form.cleaned_data

            req = ProductoRequest(
                ID=id,
                Nombre=cd["Nombre"],
                Descripcion=cd["Descripcion"],
                Precio=cd["Precio"],
                Stock=cd["Stock"],
                Imagen=cd["Imagen"],
                Categoria=cd["Categoria"],
            )

            ProductoData.actualizar_producto(req)
            messages.success(request, "Producto actualizado correctamente.")
            return redirect("listar_productos")
    else:
        form = ProductoEditarForm(
            initial={
                "Nombre": producto.nombre,
                "Descripcion": producto.descripcion,
                "Precio": producto.precio,
                "Stock": producto.stock,
                "Imagen": producto.imagen,
                "Categoria": producto.categoria,
            }
        )

    return render(
        request,
        "productos/editar.html",
        {"form": form, "producto": producto},
    )