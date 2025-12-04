from django.urls import path

# AUTH
from tienda.views.auth_view import login, logout, register

# PANEL
from tienda.views.panel_view import panel_home

# HOME (tienda pública)
from tienda.views.home_view import home

# USUARIOS
from tienda.views import usuario_view


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
]
