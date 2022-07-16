using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Controller : MonoBehaviour
{
    public Material material;
    public Vector2 position;
    public float scale;
    public float angle;

    private float _aspect;
    private float _scaleX;
    private float _scaleY;

    private Vector2 _smoothPos;
    private float _smoothScale;
    private float _smoothAngle;

    private void Start()
    {
        _aspect = (float) Screen.width / Screen.height;
    }

    private void FixedUpdate()
    {
        _smoothPos = Vector2.Lerp(_smoothPos, position, .02f);
        _smoothScale = Mathf.Lerp(_smoothScale, scale, .02f);
        _smoothAngle = Mathf.Lerp(_smoothAngle, angle, .02f);
        
        HandleInputs();
        ResolutionUpdateShader();
    }

    private void ResolutionUpdateShader()
    {
        _scaleX = _smoothScale;
        _scaleY = _smoothScale;

        if (_aspect > 1f)
            _scaleY /= _aspect;
        else
            _scaleX *= _aspect;
        
        material.SetVector("_Area", new Vector4(_smoothPos.x, _smoothPos.y, _scaleX, _scaleY));
        material.SetFloat("_Angle", _smoothAngle);
    }

    private void HandleInputs()
    {
        // Zooming in and out
        if (Input.GetKey(KeyCode.KeypadPlus))
            scale *= .99f;
        if (Input.GetKey(KeyCode.KeypadMinus))
            scale *= 1.01f;
        
        // Movement
        Vector2 direction = new Vector2(.01f * scale, 0);
        float sine = Mathf.Sin(angle);
        float cosine = Mathf.Cos(angle);
        direction = new Vector2(direction.x * cosine - direction.y * sine, direction.x * sine + direction.y * cosine);
        
        if (Input.GetKey(KeyCode.A))
            position -= direction;
        if (Input.GetKey(KeyCode.D))
            position += direction;

        direction = new Vector2(-direction.y, direction.x);
        
        if (Input.GetKey(KeyCode.S))
            position -= direction;
        if (Input.GetKey(KeyCode.W))
            position += direction;
        
        // Rotation
        if (Input.GetKey(KeyCode.Q))
            angle -= .01f;
        if (Input.GetKey(KeyCode.E))
            angle += .01f;
    }
}
