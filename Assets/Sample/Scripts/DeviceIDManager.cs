using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

public static class DeviceIDManager {

	[DllImport("__Internal")]
	static extern string _Get_Device_id();

	// Use this for initialization
	public static string GetDeviceID () {
		string password = string.Empty;

		#if UNITY_IPHONE && !UNITY_EDITOR
		password = _Get_Device_id();
		#elif UNITY_ANDROID && !UNITY_EDITOR
		using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer")) {
			using (AndroidJavaObject currentActivity = unityPlayer.GetStatic<AndroidJavaObject> ("currentActivity")) {
				using (AndroidJavaObject wifiManager = currentActivity.Call<AndroidJavaObject> ("getSystemService", "wifi")) {
	
					using (AndroidJavaObject wInfo = wifiManager.Call<AndroidJavaObject> ("getConnectionInfo")) {
				
						password = wInfo.Call<string> ("getMacAddress");
					}
				}
			}
		}
		if (!string.IsNullOrEmpty(password)) {
			password = calcMd5(password);
		}
		#else
		password = SystemInfo.deviceUniqueIdentifier;
		#endif
		return password;
	}

	private static string calcMd5( string srcStr ) {

		System.Security.Cryptography.MD5 md5 = System.Security.Cryptography.MD5.Create();

		byte[] srcBytes = System.Text.Encoding.UTF8.GetBytes(srcStr);
		byte[] destBytes = md5.ComputeHash(srcBytes);

		System.Text.StringBuilder destStrBuilder;
		destStrBuilder = new System.Text.StringBuilder();
		foreach (byte curByte in destBytes) {
			destStrBuilder.Append(curByte.ToString("x2"));
		}

		return destStrBuilder.ToString();
	}
}
