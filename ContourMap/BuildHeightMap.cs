using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BuildHeightMap : MonoBehaviour
{

    public float height;
    public float offset = 0.25f;
    public float step = 0.25f;
    public Material material;

	// Use this for initialization
	void Start ()
	{
	    for (float y = offset; y < height; y += step)
	    {
	        var gobject = GameObject.CreatePrimitive(PrimitiveType.Plane);
	        var renderer = gobject.GetComponent<MeshRenderer>();
	        renderer.material = material;
	        gobject.transform.position = Vector3.up * y;
	    }
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
