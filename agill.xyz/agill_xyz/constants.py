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
        'SITE_TITLE': 'agill.xyz',
        'SITE_DESCRIPTION': 'Personal stuff.',
        'SITE_URL': '',
        'HEADER_PAGES': [
            {
                'title': "Recipes",
                'url': '/static/pdfs/recipes.pdf'
            },
            {
                'title': 'Resume',
                'url': '/static/pdfs/Resume.pdf'
            },
            {
                'title': 'About',
                'url': '/about/'
            }
        ]
    }
    return context
