from django import forms

class UsuarioForm(forms.Form):
    Nombre = forms.CharField(max_length=50, required=True)
    Correo = forms.EmailField(max_length=100, required=True)
    Contrasena = forms.CharField(max_length=255, required=True, widget=forms.PasswordInput())
    
class UsuarioEditarForm(forms.Form):
    Nombre = forms.CharField(max_length=50, required=True)
    Correo = forms.EmailField(max_length=100, required=True)

    # La contraseña puede quedar en blanco si NO quiere cambiarla
    Contrasena = forms.CharField(
        max_length=255,
        required=False,
        widget=forms.PasswordInput(),
        help_text="Deja en blanco si no deseas cambiar la contraseña."
    )
