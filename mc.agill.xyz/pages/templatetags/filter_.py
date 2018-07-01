from django import template

register = template.Library()

@register.filter
def filter_(value):
    """The font I'm using doesn't have underscores..."""
    return value.replace('_', '<span style="font-family:sans-serif">_</span>')
