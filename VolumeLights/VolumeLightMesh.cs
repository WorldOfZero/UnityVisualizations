using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(Light))]
public class VolumetricLightMesh : MonoBehaviour
{

    public float maximumOpacity = 0.25f;

    private MeshFilter filter;
    private Light light;

    private Mesh mesh;

    // Use this for initialization
    void Start()
    {
        filter = GetComponent<MeshFilter>();
        light = GetComponent<Light>();
        if (light.type != LightType.Spot)
        {
            Debug.LogError("Attached Volumetric Light Mesh to a non-supported Light Type. Please use Spotlight lights.");
        }
    }

    // Update is called once per frame
    void Update()
    {
        mesh = BuildMesh();

        filter.mesh = mesh;
    }

    private Mesh BuildMesh()
    {
        mesh = new Mesh();

        float farPosition = Mathf.Tan(light.spotAngle * 0.5f * Mathf.Deg2Rad) * light.range;
        mesh.vertices = new Vector3[] {
            new Vector3(0,0,0),
            new Vector3(farPosition, farPosition, light.range),
            new Vector3(-farPosition, farPosition, light.range),
            new Vector3(-farPosition, -farPosition, light.range),
            new Vector3(farPosition, -farPosition, light.range)
        };
        mesh.colors = new Color[] {
            new Color(light.color.r, light.color.g, light.color.b, light.color.a * maximumOpacity),
            new Color(light.color.r, light.color.g, light.color.b, 0),
            new Color(light.color.r, light.color.g, light.color.b, 0),
            new Color(light.color.r, light.color.g, light.color.b, 0),
            new Color(light.color.r, light.color.g, light.color.b, 0)
        };
        mesh.triangles = new int[] {
            0,1,2,
            0,2,3,
            0,3,4,
            0,4,1
        };

        return mesh;
    }
}
