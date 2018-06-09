from django.views import generic

class IndexView(generic.TemplateView):
    template_name = 'index.html'

class CommunityView(generic.TemplateView):
    template_name = 'community.html'
