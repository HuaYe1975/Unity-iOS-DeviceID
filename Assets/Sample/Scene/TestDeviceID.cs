using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class TestDeviceID : MonoBehaviour {
	public Text deviceID = null;
	// Use this for initialization
	void Start () {
		string password = DeviceIDManager.GetDeviceID();
		if (!string.IsNullOrEmpty(password)) {
			deviceID.text = password;
		}
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
