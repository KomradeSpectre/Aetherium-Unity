using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LineRendererTwoObjects : MonoBehaviour
{
    // Start is called before the first frame update
    public GameObject go1;
    public GameObject go2;
    LineRenderer l;
    void Start()
    {
        l = gameObject.AddComponent<LineRenderer>();

    }



    // Update is called once per frame
    void Update()
    {
        List<Vector3> pos = new List<Vector3>();
        pos.Add(go1.transform.position);
        pos.Add(go2.transform.position);
        l.startWidth = 0.1f;
        l.endWidth = 0.1f;
        l.SetPositions(pos.ToArray());
        l.useWorldSpace = true;
    }
}