from django.urls import path

# AUTH
from tienda.views.auth_view import login, logout, register

# PANEL
from tienda.views.panel_view import panel_home

# HOME (tienda pública)
from tienda.views.home_view import home

# USUARIOS
from tienda.views import usuario_view

# PRODUCTOS
from tienda.views import producto_view

# CARRITO
from tienda.views import carrito_views


urlpatterns = [
    # HOME
    path("home/index", home, name="home"),

    # AUTH
    path('login/', login, name='login'),
    path('logout/', logout, name='logout'),
    path('register/', register, name='register'),

    # PANEL ADMIN
    path("panel/home/", panel_home, name="panel_home"),

    # USUARIOS
    path('usuarios/', usuario_view.listar_usuarios, name='listar_usuarios'),
    path('usuarios/crear/', usuario_view.crear_usuario, name='crear_usuario'),
    path('usuarios/estado/<int:id>/', usuario_view.cambiar_estado_usuario, name='cambiar_estado_usuario'),
    path("usuarios/editar/<int:id>/", usuario_view.editar_usuario, name="editar_usuario"),

    # PRODUCTOS (ADMIN)
    path('productos/', producto_view.listar_productos, name='listar_productos'),
    path('productos/crear/', producto_view.crear_producto, name='crear_producto'),
    path('productos/estado/<int:id>/', producto_view.cambiar_estado_producto, name='cambiar_estado_producto'),
    path("productos/editar/<int:id>/", producto_view.editar_producto, name="editar_producto"),

    # PRODUCTOS (CLIENTE)
    path('tienda/productos/', producto_view.listar_productos_publico, name='listar_productos_publico'),
    
    # CARRITO
    path('carrito/', carrito_views.ver_carrito, name='ver_carrito'),
    path('carrito/agregar/<int:producto_id>/', carrito_views.agregar_al_carrito, name='agregar_al_carrito'),
    path('carrito/remover/<int:item_id>/', carrito_views.remover_del_carrito, name='remover_del_carrito'),
    path('carrito/contador/', carrito_views.obtener_contador_carrito, name='obtener_contador_carrito'),
    path('carrito/checkout/', carrito_views.checkout, name='checkout'),
    path('carrito/procesar-pago/', carrito_views.procesar_pago, name='procesar_pago'),
    path('carrito/confirmacion/<int:pedido_id>/', carrito_views.confirmacion_pedido, name='confirmacion_pedido'),
]