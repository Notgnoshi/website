from django.urls import path
from . import views

urlpatterns = [
    path('', views.IndexView.as_view(), name='index'),
    path('community/', views.CommunityView.as_view(), name='community'),
]
