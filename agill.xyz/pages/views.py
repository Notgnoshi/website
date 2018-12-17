from django.views import generic

class IndexView(generic.TemplateView):
    template_name = 'index.html'

class AboutView(generic.TemplateView):
    template_name = 'about.html'

class UbuntuConfigView(generic.TemplateView):
    template_name = 'ubuntu.html'
