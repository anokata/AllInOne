import requests
from requests_toolbelt.utils import dump
import json


cities = [
"Нью-Йорк",
"Дели",
"Tokyo"
]

for city in cities:
    url = "https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address"
    headers = {
            "Content-Type": "application/json", 
            "Accept": "application/json", 
            "Authorization": "Token a21ae8d8246ebf44e4c99a8dd9e6786d3a56ca0a"}
    data = {
            "query": city, 
            "count":"10",
            "locations": [ { "country": "*" }]
            }
    data = json.dumps(data)
    r = requests.post(url, data=data, params=data, headers=headers)
    #print(r)
    data = dump.dump_all(r)
    #print(data.decode('utf-8'))
    #print(r.text)
    j = r.json()
    #print(j)
    print(city, j["suggestions"][0]["data"]["geo_lon"], j["suggestions"][0]["data"]["geo_lat"])

