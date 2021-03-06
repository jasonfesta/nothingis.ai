#!/usr/bin/env python
# -*- coding: UTF-8 -*-


import json
import os
import sys

import requests

#-- retrieve a sample of ello results
response = requests.get("{api_url}?action=SKETCH_ELLO&count={count}".format(api_url=os.environ['API_URL'], count=sys.argv[1] if len(sys.argv) == 2 else 10))

#-- create json list for slack
for image in response.json()['images']:
    images = []
    
    #-- compile image set per post
    for url in image['images']:
        images.append({'image_url' : url})

    #-- build out the json object for slack
    payload = {
        'channel'     : "#sources",
        'username '   : "ello",
        'icon_url'    : "https://ello.co/static/images/support/ello-open-graph-image.png",
        'text'        : "_{title}_ by *{author}*\n{url}".format(title=image['title'].encode('utf-8'), author=image['author'].encode('utf-8'), url=image['url']),
        'attachments' : images
    }
    
    #-- send each post w/ image set off to slack
    response = requests.post(os.environ['SLACK_WEBHOOK'], data={'payload': json.dumps(payload)})
