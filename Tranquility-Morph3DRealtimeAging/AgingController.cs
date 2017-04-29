using UnityEngine;
using System.Collections;
using System.Runtime.CompilerServices;

[ExecuteInEditMode]
[RequireComponent(typeof(MORPH3D.M3DCharacterManager))]
public class AgingController : MonoBehaviour {

    public float age;

    public AnimationCurve fiveYearOldCurve;
    public AnimationCurve tenYearOldCurve;
    public AnimationCurve youngteenCurve;
    public AnimationCurve oldteenCurve;
    public AnimationCurve adultCurve;
    public AnimationCurve agedCurve;

    public string[] fiveYearOldTraits;
    public string[] tenYearOldTraits;
    public string[] youngteenTraits;
    public string[] oldteenTraits;
    public string[] adultTraits;
    public string[] agedTraits;
     
    private MORPH3D.M3DCharacterManager manager;

	// Use this for initialization
	void Start () {
        manager = GetComponent<MORPH3D.M3DCharacterManager>();
	}
	
	// Update is called once per frame
	void Update ()
    {
        UpdateManager(fiveYearOldCurve, fiveYearOldTraits);
        UpdateManager(tenYearOldCurve, tenYearOldTraits);
        UpdateManager(youngteenCurve, youngteenTraits);
        UpdateManager(oldteenCurve, oldteenTraits);
        UpdateManager(adultCurve, adultTraits);
        UpdateManager(agedCurve, agedTraits);

        ChoiceMaster.Age = age;
    }

    private void UpdateManager(AnimationCurve curve, string[] traits)
    {
        float value = curve.Evaluate(age) * 100;
        foreach (var trait in traits)
        {
            manager.SetBlendshapeValue(trait, value);
        }
    }
}
