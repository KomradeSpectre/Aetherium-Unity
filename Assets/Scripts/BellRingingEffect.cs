using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BellRingingEffect : MonoBehaviour
{
	public ParticleSystem BellParticleSystem;
	
    public void Start()
    {
        BellParticleSystem = GetComponentInChildren<ParticleSystem>();
    }
	
	public void RingBell()
	{
		BellParticleSystem.Play();
	}
}
