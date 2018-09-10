##############################################################################
# Copyright (c) 2018 Enea AB and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################
from docs_conf.conf import *

extensions = ['sphinxcontrib.httpdomain', 'sphinx.ext.autodoc',
              'sphinx.ext.viewcode', 'sphinx.ext.napoleon',
              'sphinx.ext.intersphinx']

intersphinx_mapping = {}
intersphinx_mapping['armband'] = ('https://opnfv-armband.readthedocs.io/en/latest/', None)
