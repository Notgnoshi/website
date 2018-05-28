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
        'SITE_DESCRIPTION': 'A personal Minecraft server',
        'SITE_URL': '',
        'HEADER_PAGES': [
            {
                'title': 'About',
                'url': '/about/'
            }
        ]
    }
    return context
