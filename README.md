# Unity-iOS-DeviceID
Use keychain to solve SystemInfo.deviceUniqueIdentifier for iOS.

It is so easy to use it on unity:

```
[DllImport("__Internal")]
static extern string _Get_Device_id();

void Start () {
	string password = _Get_Device_id();
	// do something...
}
```
