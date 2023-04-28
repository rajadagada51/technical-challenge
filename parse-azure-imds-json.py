import json
import requests

def find_value(obj, key):
    if isinstance(obj, list):  # Handle arrays
        for item in obj:
            result = find_value(item, key)
            if result is not None:
                return result
    elif isinstance(obj, dict):  # Handle dictionaries
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
    object_data = response.json()  # Parse the JSON response

    # Print the metadata information
    print "Metadata Information:"
    print json.dumps(object_data, indent=4)

    # Prompt for the key
    key = raw_input("Enter the key to search for: ")

    # Search for the key within the JSON data
    value = find_value(object_data, key)
    print "The value for key '{0}' is: {1}".format(key, value)
except requests.RequestException as e:
    print "Error occurred during the request:", str(e)
except ValueError:
    print "Error occurred while parsing the JSON data."

