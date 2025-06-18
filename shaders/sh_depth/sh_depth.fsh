precision highp float;

varying vec2 v_vTexcoord;
// varying vec4 v_vColour;

uniform float u_fZParam;

/// @param depth Non-linear depth.
/// @param zparam Equals (zfar / znear).
/// @return Linearized depth, in range 0..1.
float LinearizeDepth(float depth, float zparam)
{
#if !defined(_YY_HLSL11_)
    depth = depth * 2.0 - 1.0;
#endif
    return 1.0 / ((1.0 - zparam) * depth + zparam);
}

void main()
{
    float depth = texture2D(gm_BaseTexture, v_vTexcoord).r;
    depth = LinearizeDepth(depth, u_fZParam);
    gl_FragColor = vec4(vec3(depth), 1.0);
}
