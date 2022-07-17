using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class UIHandler : MonoBehaviour
{
    public Material materialUsed;

    public Slider angleSlider;
    public Slider maxIterSlider;
    public Slider colorSlider;
    public Slider symmSlider;

    public TMP_InputField repeatInput;
    public TMP_InputField speedInput;

    private float _angle, _maxIter, _color, _repeat, _speed, _symmetry;

    private void Start()
    {
        materialUsed.shader = Shader.Find("Mandelbrot/Mandelbrot");
        SetValues();
        SetMinAndMaxSliderValues();
        SetAllValues();
    }

    private void Update()
    {
        SetMaterialValues();
    }

    private void SetMinAndMaxSliderValues()
    {
        angleSlider.minValue = -3.14f;
        angleSlider.maxValue = 3.14f;
        
        maxIterSlider.minValue = 4;
        maxIterSlider.maxValue = 1024;

        colorSlider.minValue = 0;
        colorSlider.maxValue = 1;

        symmSlider.minValue = 0;
        symmSlider.maxValue = 1;
    }
    
    private void SetAllValues()
    {
        angleSlider.value = _angle;
        maxIterSlider.value = _maxIter;
        colorSlider.value = _color;
        symmSlider.value = _symmetry;

        speedInput.text = _speed.ToString();
        repeatInput.text = _repeat.ToString();
    }

    private void SetValues()
    {
        _angle = materialUsed.GetFloat("_Angle");
        _maxIter = materialUsed.GetFloat("_MaxIterator");
        _color = materialUsed.GetFloat("_Color");
        _repeat = materialUsed.GetFloat("_Repeat");
        _speed = materialUsed.GetFloat("_Speed");
        _symmetry = materialUsed.GetFloat("_Symmetry");
        
        // Debug.LogError($"values: {_angle}, {_maxIter}, {_color}, {_repeat}, {_speed}, {_symmetry}");
    }

    private void SetMaterialValues()
    {
         materialUsed.SetFloat("_Angle", angleSlider.value);
         materialUsed.SetFloat("_MaxIterator", maxIterSlider.value);
         materialUsed.SetFloat("_Color", colorSlider.value);
         materialUsed.SetFloat("_Repeat", float.Parse(repeatInput.text));
         materialUsed.SetFloat("_Speed", float.Parse(speedInput.text));
         materialUsed.SetFloat("_Symmetry", symmSlider.value);
    }
}
