using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ConwaysGameOfLife : MonoBehaviour
{
    public Texture input;

    public int width = 512;
    public int height = 512;

    public ComputeShader compute;
    public RenderTexture result;

    public Material material;

    public bool step = false;

    //TODO: Implement double buffering

	// Use this for initialization
	void Start () {
	    result = new RenderTexture(width, height, 24);
	    result.enableRandomWrite = true;
	    result.Create();
    }
	
	// Update is called once per frame
	void Update ()
	{
	    //if (!step) return;
	    //step = false;
	    if (height < 1 || width < 1) return;

	    int kernel = compute.FindKernel("GameOfLife");

	    compute.SetTexture(kernel, "Input", input);
	    compute.SetFloat("Width", width);
	    compute.SetFloat("Height", height);

	    result = new RenderTexture(width, height, 24);
        result.wrapMode = TextureWrapMode.Repeat;
	    result.enableRandomWrite = true;
        result.filterMode = FilterMode.Point;
	    result.useMipMap = false;
	    result.Create();

	    compute.SetTexture(kernel, "Result", result);
	    compute.Dispatch(kernel, width / 8, height / 8, 1);

	    input = result;
	    material.mainTexture = input;
	}
}
