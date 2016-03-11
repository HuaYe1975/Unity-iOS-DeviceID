using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using System.Runtime.InteropServices;

public class DeviceIDManager : MonoBehaviour {

	public Text deviceID = null;

	[DllImport("__Internal")]
	static extern string _Get_Device_id();

	// Use this for initialization
	void Start () {
		string password = _Get_Device_id();
		if (!string.IsNullOrEmpty(password)) {
			deviceID.text = password;
		}
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
