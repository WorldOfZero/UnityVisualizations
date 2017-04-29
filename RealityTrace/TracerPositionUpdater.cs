//Attach to the game object which will serve as the Trace Origin.

using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.Rendering;

[ExecuteInEditMode]
public class TracerPositionUpdater : MonoBehaviour {

    public Material material;
    public Transform parent; 

	// Use this for initialization
	void Start () {
        if (parent == null) parent = Camera.main.transform;
	}
	
	// Update is called once per frame
	void Update () {
	    if (material != null)
	    {
            material.SetVector("_EchoLocation", new Vector4(this.transform.position.x, this.transform.position.y, this.transform.position.z, 0));
        }
	}
}
