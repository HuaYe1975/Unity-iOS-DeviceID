using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class TestDeviceID : MonoBehaviour {
	public Text deviceID = null;
	// Use this for initialization
	void Start () {
        DeviceIDManager.deviceIDHandler += (string deviceid) => {

            if (!string.IsNullOrEmpty(deviceid))
            {
                deviceID.text = deviceid;
            }
            
        };
		DeviceIDManager.GetDeviceID();
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
