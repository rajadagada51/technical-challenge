import sys

def get_value(obj, key):
    keys = key.split('/')
    value = obj
    try:
        for k in keys:
            value = value[k]
        return value
    except (KeyError, TypeError):
        return None

if len(sys.argv) >= 3:
    object_str = sys.argv[1]
    key = sys.argv[2]

    try:
        object = eval(object_str)
        value = get_value(object, key)
        print(value)
    except (NameError, SyntaxError):
        print("Wrong object format.")
else:
    print("Usage: python challenge-3-parse-nested-object.py <object> <key>")

