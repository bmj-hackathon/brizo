#  Copyright 2018 Ocean Protocol Foundation
#  SPDX-License-Identifier: Apache-2.0

import logging
import os
import sys

from flask import Flask
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

if 'CONFIG_FILE' in os.environ and os.environ['CONFIG_FILE']:
    logging.info("os.environ['CONFIG_FILE']: ".format(os.environ['CONFIG_FILE']))
    app.config['CONFIG_FILE'] = os.environ['CONFIG_FILE']
else:
    logging.debug("'CONFIG_FILE' not found, using default: {} ".format('config.ini'))
    app.config['CONFIG_FILE'] = 'config.ini'
