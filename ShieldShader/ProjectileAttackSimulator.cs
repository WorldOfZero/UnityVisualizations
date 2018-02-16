using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProjectileAttackSimulator : MonoBehaviour {

    public float radius;
    public float shotCooldown;
    private float timer;
    public GameObject projectile;

    // Use this for initialization
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {

        timer += Time.deltaTime;
        while (timer > shotCooldown)
        {
            timer -= shotCooldown;
            var point = Random.onUnitSphere * radius;
            var direction = Quaternion.LookRotation(-point);
            Instantiate(projectile, point, direction);
            Debug.Log("New Projectile");
        }
    }
}
