from django.urls import path
from . import views

urlpatterns = [
    path('', views.IndexView.as_view(), name='index'),
    path('rules/', views.RulesView.as_view(), name='rules'),
    path('community/', views.CommunityView.as_view(), name='community'),
]
