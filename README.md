# technical-challenge -3

Here I am using the python scripting to fetech the value from the nested object.

The below is the list of actions performed while running the script

1. The get_value function takes an object and a key as input and retrieves the value associated with the key from the object.
2. The key parameter is a string representing the key path in the object. If the key path contains nested keys, they are separated by slashes ("/").
3. The function splits the key path into individual keys using the split('/') method.
4. The value variable is initialized as the input object.
5. The function then attempts to retrieve the value associated with each key in the key path by iterating over the keys.
6. If a key is found, the value variable is updated to the corresponding value in the object.
7. If a key is not found or if a TypeError occurs, the function returns None.
8. The script checks if command-line arguments are provided (i.e., sys.argv contains at least 3 elements).

![image](https://user-images.githubusercontent.com/97170585/235222144-7015bbc5-12b1-43b1-9db2-0612b8c04a90.png)
