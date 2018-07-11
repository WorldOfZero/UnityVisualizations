using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chunk : MonoBehaviour {

    public int width;

    private Color[,,] chunkData;

    private void Awake()
    {
        chunkData = new Color[width, width, width];
    }

    internal void SetBlock(int x, int y, int z, Color blockData)
    {
        chunkData[x, y, z] = blockData;
        SendMessage("BlockUpdate", this);
    }

    internal Color GetBlock(int x, int y, int z)
    {
        return chunkData[x, y, z];
    }
}
