#!/bin/bash

#-- uses python to post dribbble shots into slack channel
cd $PY_CRON
python dribbble.py 10

exit 0;
