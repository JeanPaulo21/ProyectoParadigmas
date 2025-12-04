from django.shortcuts import render

def panel_home(request):
    return render(request, "panel/home.html")
