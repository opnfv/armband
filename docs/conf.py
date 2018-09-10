from docs_conf.conf import *

extensions = ['sphinxcontrib.httpdomain', 'sphinx.ext.autodoc',
              'sphinx.ext.viewcode', 'sphinx.ext.napoleon',
              'sphinx.ext.intersphinx']

intersphinx_mapping = {}
intersphinx_mapping['fuel'] = ('https://opnfv-fuel.readthedocs.io/en/latest/', None)
