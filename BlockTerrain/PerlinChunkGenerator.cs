using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PerlinChunkGenerator : MonoBehaviour {

    public int seed;
    private Chunk chunk;

	void Start () {
        chunk = GetComponent<Chunk>();
        Generate(chunk, seed);
	}

    private void Generate(Chunk chunk, int seed)
    {
        Random.InitState(seed);
        for (var x = 0; x < chunk.width; ++x)
        {
            for (var y = 0; y < chunk.width; ++y)
            {
                for (var z = 0; z < chunk.width; ++z)
                {
                    // TODO: This needs work.
                    var gen = (
                        Mathf.PerlinNoise(x / (float)chunk.width, y / (float)chunk.width) +
                        Mathf.PerlinNoise(x / (float)chunk.width, z / (float)chunk.width) +
                        Mathf.PerlinNoise(z / (float)chunk.width, y / (float)chunk.width)
                        ) / 3.0f;
                    var color = default(Color);
                    if (gen > 0.75)
                    {
                        color = Color.red;
                    }
                    else if (gen > 0.5)
                    {
                        color = Color.green;
                    }
                    else if (gen > 0.25)
                    {
                        color = Color.blue;
                    }
                    chunk.SetBlock(x, y, z, color);
                }
            }
        }
    }
}
