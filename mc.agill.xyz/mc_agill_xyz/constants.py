def domain_constants(request):
    """
        Makes domain-wide constants available to every template.
    """
    context = {
        'EMAIL': 'Notgnoshi@gmail.com',
        'TWITTER': 'Notgnoshi',
        'GITHUB': 'Notgnoshi',
    }
    return context


def subdomain_constants(request):
    """
        Makes subdomain-wide constants available to every template.
    """
    context = {
        'SITE_TITLE': 'mc.agill.xyz',
        'SITE_DESCRIPTION': 'A communal Minecraft server',
        'SITE_URL': '',
        'HEADER_PAGES': [
            {
                'title': 'Rules',
                'url': '/rules/'
            },
            {
                'title': 'Community',
                'url': '/community/'
            },
        ]
    }
    return context
