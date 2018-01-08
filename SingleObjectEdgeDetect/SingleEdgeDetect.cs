using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class SingleEdgeDetect : MonoBehaviour {

    public Shader edgeDetectShader;
    private Material edgeDetectMaterial = null;
    public Material material
    {
        get
        {
            edgeDetectMaterial = CheckShaderAndCreateMaterial(edgeDetectShader, edgeDetectMaterial);
            return edgeDetectMaterial;
        }
    }


    public Color edgeColor = Color.black;
    [Range(0f, 1f)]
    public float threshold = 0.5f;

    private Mesh mesh;
    private void Awake()
    {
        if (GetComponent<MeshFilter>())
            mesh = GetComponent<MeshFilter>().sharedMesh;
        else
        {
            Debug.LogError("GameObject'" + gameObject.name + "'没有MESH,此脚本无效");
            this.enabled = false;
        }
    }

    //[ImageEffectOpaque]
    public void Update()
    {
        if (material != null)
        {
            material.SetColor("_EdgeColor", edgeColor);
            material.SetFloat("_Threshold", threshold);

            Graphics.DrawMesh(mesh, Matrix4x4.TRS(transform.position, transform.rotation, transform.localScale), material,1);
        }
    }

    protected Material CheckShaderAndCreateMaterial(Shader shader, Material material)
    {
        if (shader == null)
        {
            return null;
        }

        if (shader.isSupported && material && material.shader == shader)
            return material;

        if (!shader.isSupported)
        {
            return null;
        }
        else
        {
            material = new Material(shader);
            material.hideFlags = HideFlags.DontSave;
            if (material)
                return material;
            else
                return null;
        }
    }
}
