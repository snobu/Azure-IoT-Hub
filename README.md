# Azure-IoT-Hub

#### make-token.sh ####
Construct authorization header for Azure IoT Hub

Expected output:
```bash
$ ./make-token.sh

Authorization: SharedAccessSignature sr=heresthething.azure-devices.net%2Fdevices%3Ftop%3D100%26api-version%3D2015-08-15-preview&sig=A%2B53mdXXXXXXXXXXXXXgyRq403mFpGhoi6vPZU%3D&se=1446291265&skn=iothubowner

[
  {
    "deviceId": "jazzy",
    "generationId": "6358087410000036",
    "etag": "MA==",
    "connectionState": "Disconnected",
    "status": "enabled",
    "statusReason": null,
    "connectionStateUpdatedTime": "2015-10-22T11:44:55.0815837",
    "statusUpdatedTime": "0001-01-01T00:00:00",
    "lastActivityTime": "2015-10-22T11:39:50.0085655",
    "cloudToDeviceMessageCount": 0,
    "authentication": {
      "symmetricKey": {
        "primaryKey": "PrbtgXXXXXXXXXXXXXXXXXXX/o0bIBxSS8=",
        "secondaryKey": "xxXdWFKJQLfXXXXXXXXXXXXXXXDN9vNiarApc="
      }
    }
  }
]
```
