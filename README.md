# Unity-iOS-DeviceID
Use keychain to solve SystemInfo.deviceUniqueIdentifier for iOS.

It is so easy to use it on unity:

```

	string deviceID = DeviceIDManager.GetDeviceID();
```

Note:
You'd better change the value of macroes in KeyChain.mm for ios:

```
#define SERVICE_NAME    @"my_service_name"
#define IDENTIFIER      @"my_app_identifier"
#define ACOUNT_ID       @"my_account"
```

# About DeviceID

1. It will create a uuid string and save it to keychain for ios
2. It will return mac address for android
3. return SystemInfo.deviceUniqueIdentifier for other platforms.

