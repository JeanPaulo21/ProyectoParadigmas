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
]
