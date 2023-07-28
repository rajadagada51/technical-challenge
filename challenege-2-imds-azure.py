import json
import requests

def find_value(obj, key):
    if isinstance(obj, list):
        for item in obj:
            result = find_value(item, key)
            if result is not None:
                return result
    elif isinstance(obj, dict):
        if key in obj:
            return obj[key]
        for value in obj.values():
            result = find_value(value, key)
            if result is not None:
                return result
    return None

url = "http://169.254.169.254/metadata/instance?api-version=2021-02-01"
headers = {
    "Metadata": "true"
}
try:
    response = requests.get(url,headers=headers)
    object_data = response.json()

    print json.dumps(object_data, indent=4)
    key = raw_input("Search the key: ")

    value = find_value(object_data, key)
    print "The value for key '{0}' is: {1}".format(key, value)
except requests.RequestException as e:
    print "Error calling the request:", str(e)
except ValueError:
    print "Error parsing the JSON data."

