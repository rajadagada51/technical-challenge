# technical-challenge -2

##### Prerequisites

```
We are using requests module to call the azure IMDS API, to get the JSON data and save it as object to parse.
In Python, the requests module is not part of the standard library, so we need to install it separately. Use pip, the package installer for Python to install the requests module.

pip install requests
```

#### It dynamically fetch the Azure instance metadata JSON and prompt us to enter a key to search for within the data.

1. find_value function recursively searches for a key within a nested JSON object and returns the corresponding value.
2. url variable represents the Azure instance metadata URL.
3. headers variable contains the required headers, specifically the Metadata: true header to indicate that the request is for metadata.
4. code makes a GET request to the metadata URL using requests.get and passing the headers.
5. response is then parsed as JSON using response.json() to obtain the JSON object.
6. metadata information is printed using print json.dumps(object_data, indent=4) to display the JSON data with proper indentation.
7. code prompts the user to enter a key to search for within the JSON data.
8. find_value function is called with the JSON object and the entered key to retrieve the corresponding value.
9. value for the key is printed using print "The value for key '{0}' is: {1}".format(key, value).
10. Error handling is implemented using try-except blocks:
11. If a requests.RequestException occurs during the request, an error message is printed.
12. If a ValueError occurs while parsing the JSON data, an error message is printed.
13. For any other exception, a generic error message is printed.

```python
root@python:~/technical-challenge# python parse-azure-imds-json.py
Metadata Information:
{
    "compute": {
        "azEnvironment": "AzurePublicCloud",
        "licenseType": "",
        "resourceId": "/subscriptions/XXXXXXXXXXXXXXXXXXXXX/resourceGroups/dev/providers/Microsoft.Compute/virtualMachines/python",
        "vmId": "f4ed82e2-d101-407c-9410-c2502bf59025",
        "platformFaultDomain": "0",
        "osType": "Linux",
        "sku": "18_04-lts-gen2",
        "osProfile": {
            "adminUsername": "Azure",
            "computerName": "python",
            "disablePasswordAuthentication": "false"
        },
        "zone": "",
        "offer": "UbuntuServer",
        "priority": "",
        "version": "18.04.202304260",
        "location": "eastus",
        "provider": "Microsoft.Compute",
        "subscriptionId": "XXXXXXXXXXXXXXXXXXXXXXX",
        "userData": "",
        "evictionPolicy": "",
        "customData": "",
        "platformUpdateDomain": "0",
        "placementGroupId": "",
        "plan": {
            "publisher": "",
            "product": "",
            "name": ""
        },
        "tags": "",
        "publisher": "Canonical",
        "name": "python",
        "storageProfile": {
            "imageReference": {
                "sku": "18_04-lts-gen2",
                "publisher": "Canonical",
                "version": "latest",
                "id": "",
                "offer": "UbuntuServer"
            },
            "resourceDisk": {
                "size": "34816"
            },
            "osDisk": {
                "diffDiskSettings": {
                    "option": ""
                },
                "name": "python_disk1_e1b153c7822b44e1be5592cfb9fbcf2f",
                "writeAcceleratorEnabled": "false",
                "image": {
                    "uri": ""
                },
                "managedDisk": {
                    "storageAccountType": "Premium_LRS",
                    "id": "/subscriptions/XXXXXXXXXXXX/resourceGroups/DEV/providers/Microsoft.Compute/disks/python_disk1_e1b153c7822b44e1be5592cfb9fbcf2f"
                },
                "encryptionSettings": {
                    "enabled": "false"
                },
                "diskSizeGB": "30",
                "createOption": "FromImage",
                "caching": "ReadWrite",
                "vhd": {
                    "uri": ""
                },
                "osType": "Linux"
            },
            "dataDisks": []
        },
        "vmScaleSetName": "",
        "resourceGroupName": "dev",
        "publicKeys": [],
        "isHostCompatibilityLayerVm": "false",
        "securityProfile": {
            "virtualTpmEnabled": "false",
            "secureBootEnabled": "false"
        },
        "vmSize": "Standard_B1s",
        "tagsList": []
    },
    "network": {
        "interface": [
            {
                "macAddress": "000D3A8B673A",
                "ipv4": {
                    "subnet": [
                        {
                            "prefix": "24",
                            "address": "10.0.0.0"
                        }
                    ],
                    "ipAddress": [
                        {
                            "privateIpAddress": "10.0.0.5",
                            "publicIpAddress": ""
                        }
                    ]
                },
                "ipv6": {
                    "ipAddress": []
                }
            }
        ]
    }
}
Enter the key to search for: privateIpAddress
The value for key 'privateIpAddress' is: 10.0.0.5
```
