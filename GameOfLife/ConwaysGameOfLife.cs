using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ConwaysGameOfLife : MonoBehaviour
{
    public Texture input;

    public int width = 512;
    public int height = 512;

    public ComputeShader compute;
    public RenderTexture renderTexPing;
    public RenderTexture renderTexPong;

    public Material material;

    private int kernel;
    private bool pingPong;

	// Use this for initialization
	void Start () {
        if (height < 1 || width < 1) return;

        kernel = compute.FindKernel("GameOfLife");

        renderTexPing = new RenderTexture(width, height, 24);
        renderTexPing.wrapMode = TextureWrapMode.Repeat;
        renderTexPing.enableRandomWrite = true;
        renderTexPing.filterMode = FilterMode.Point;
        renderTexPing.useMipMap = false;
        renderTexPing.Create();

        renderTexPong = new RenderTexture(width, height, 24);
        renderTexPong.wrapMode = TextureWrapMode.Repeat;
        renderTexPong.enableRandomWrite = true;
        renderTexPong.filterMode = FilterMode.Point;
        renderTexPong.useMipMap = false;
        renderTexPong.Create();

        Graphics.Blit(input, renderTexPing);

        pingPong = true;

        compute.SetFloat("Width", width);
        compute.SetFloat("Height", height);
    }
	
	// Update is called once per frame
	void Update ()
	{
	    //if (!step) return;
	    //step = false;
	    if (height < 1 || width < 1) return;

        if (true == pingPong)
        {
            compute.SetTexture(kernel, "Input", renderTexPing);
            compute.SetTexture(kernel, "Result", renderTexPong);
            compute.Dispatch(kernel, width / 8, height / 8, 1);

            material.mainTexture = renderTexPong;

            pingPong = false;
        }
        else
        {
            compute.SetTexture(kernel, "Input", renderTexPong);
            compute.SetTexture(kernel, "Result", renderTexPing);
            compute.Dispatch(kernel, width / 8, height / 8, 1);

            material.mainTexture = renderTexPing;

            pingPong = true;
        }
	}
}
