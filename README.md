# Unity-iOS-DeviceID
UDID solution for Android/iOS.

## About DeviceID

1. It will create a uuid string and save it to keychain for ios
2. It will return mac address's MD5 (ADID when >= API Level23) for android
3. return SystemInfo.deviceUniqueIdentifier for other platforms.



## How to use

It is so easy to use it on unity:

1. Add event handle

	```

        DeviceIDManager.deviceIDHandler += (string deviceid) => {

            if (!string.IsNullOrEmpty(deviceid))
            {
                deviceID.text = deviceid;
            }
            
        };
	```

2. Call 'GetDeviceID' method

	```
	DeviceIDManager.GetDeviceID();
	```

## Note

You'd better change the value of macroes in KeyChain.mm for ios:

```
#define SERVICE_NAME    @"my_service_name"
#define IDENTIFIER      @"my_app_identifier"
#define ACOUNT_ID       @"my_account"
```
