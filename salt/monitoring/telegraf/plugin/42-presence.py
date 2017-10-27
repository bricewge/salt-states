#!/usr/bin/python2
from __future__ import print_function
import json
from requests_oauthlib import OAuth2Session
from oauthlib.oauth2 import BackendApplicationClient

program_name = "42-presence"
client_id = "7808e2d5568fb3a75dd349aeac65446a4fd90bf5479333cb7ac447b34d4ceda8"
client_secret = "b4e0abd74a2c3580ffa449637347ba2de68635f6a2c9b28405a44f38b9157f5a"
url = "https://api.intra.42.fr"
users = ["bwaegene", "nbouteme"]
client = BackendApplicationClient(client_id=client_id)
ft_api = OAuth2Session(client=client)
token = ft_api.fetch_token(token_url=url + "/oauth/token",
                           client_id=client_id,
                           client_secret=client_secret)

print(program_name, end=" ")
for i in range(0, len(users)):
    response = ft_api.get(url + "/v2/users/" + users[i])
    result = json.loads(response.content)["location"]
    if result == None:
        result = 0
    else:
        result = 1
    if i < len(users) - 1:
        print(users[i] + "=" + str(result), end=",")
    else:
        print(users[i] + "=" + str(result))
