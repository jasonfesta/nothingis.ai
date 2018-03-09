#!/usr/bin/env python
# -*- coding: UTF-8 -*-


import json
import os
import sys

import requests


response = requests.get("{api_url}action=SKETCH_DRIBBBLE&count={count}".format(api_url=os.environ['API_URL'], count=sys.argv[1] if len(sys.argv) == 2 else 10))

images = []
for image in response.json()['images']:
    images.append({
        'title'     : "_{title}_ by {author}".format(title=image['title'].encode('utf-8'), author=image['author'].encode('utf-8')),
        'text'      : "{colors}\n#{tags}".format(colors=" ".join(image['colors']), tags=" #".join(image['tags'])),
        'image_url' : image['url']
    })

payload = {
    'channel'    : "#sources",
    'username '  : "dribble",
    'icon_url'   : "https://cdn.dribbble.com/assets/apple-touch-icon-precomposed-4a188d3f4dd693b67971fda843fd4bdeae751f9a245e3b878cae17e0a9d6a0a3.png",
    'attachments': images
}
response = requests.post(os.environ['SLACK_WEBHOOK'], data={'payload': json.dumps(payload)})
#print ("{title} - {author} ({colors})".format(title=image['title'].encode('utf-8'), author=image['author'].encode('utf-8'), colors=" ".join(image['colors'])))
