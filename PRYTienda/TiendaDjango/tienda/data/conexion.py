# tienda/data/conexion.py

from django.db import connections

def obtener_conexion():

    return connections['default']
