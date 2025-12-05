from django import forms


CATEGORIA_CHOICES = [
    ("Computación", "Computación"),
    ("Consolas", "Consolas"),
    ("VideoJuegos", "VideoJuegos"),
    ("DispositivosMoviles", "Dispositivos Móviles"),
]


class ProductoForm(forms.Form):
    Nombre = forms.CharField(max_length=100, required=True)
    Descripcion = forms.CharField(
        widget=forms.Textarea(attrs={"rows": 3}), required=False
    )
    Precio = forms.DecimalField(max_digits=10, decimal_places=2, required=True)
    Stock = forms.IntegerField(min_value=0, required=True)
    Imagen = forms.CharField(
        max_length=255,
        required=False,
        help_text="URL o ruta relativa de la imagen del producto.",
    )
    Categoria = forms.ChoiceField(choices=CATEGORIA_CHOICES, required=True)


class ProductoEditarForm(ProductoForm):
    pass