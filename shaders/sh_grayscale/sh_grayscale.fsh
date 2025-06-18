varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    if (gm_AlphaTestEnabled && color.a <= gm_AlphaRefValue) {
        discard;
    }
    float gray = (color.r * 0.299) + (color.g * 0.587) + (color.b * 0.114);
    gl_FragColor = vec4(gray, gray, gray, color.a);
}
