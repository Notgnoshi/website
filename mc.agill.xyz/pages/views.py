from django.views import generic
from .community import PLAYERS

class IndexView(generic.TemplateView):
    template_name = 'index.html'

class RulesView(generic.TemplateView):
    template_name = 'rules.html'

class CommunityView(generic.TemplateView):
    template_name = 'community.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['PLAYERS'] = PLAYERS['players']
        return context
