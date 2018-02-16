using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShieldProjectile : MonoBehaviour
{

    public float projectileBias = 0.25f;
    public float speed = 10;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update ()
	{
	    float distance = speed * Time.deltaTime;
        this.transform.position += this.transform.forward * distance;

	    Ray ray = new Ray(this.transform.position, this.transform.forward);
	    RaycastHit hit;
	    if (Physics.Raycast(ray, out hit, distance + projectileBias))
	    {
	        hit.collider.gameObject.SendMessage("OnProjectileHit", hit.point, SendMessageOptions.DontRequireReceiver);
	        Destroy(this.gameObject);
	    }
	}
}
