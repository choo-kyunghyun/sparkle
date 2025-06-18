varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    if (gm_AlphaTestEnabled && color.a <= gm_AlphaRefValue) {
        discard;
    }
    gl_FragColor = vec4(1.0, 1.0, 1.0, color.a);
}
