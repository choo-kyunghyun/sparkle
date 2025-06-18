varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 u_vOutlineColour;
uniform vec2 u_vTexelSize;

void main()
{
    vec4 color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    
    if (gm_AlphaTestEnabled && color.a <= gm_AlphaRefValue) {
        float alpha_up = texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, u_vTexelSize.y)).a;
        float alpha_down = texture2D(gm_BaseTexture, v_vTexcoord - vec2(0.0, u_vTexelSize.y)).a;
        float alpha_left = texture2D(gm_BaseTexture, v_vTexcoord - vec2(u_vTexelSize.x, 0.0)).a;
        float alpha_right = texture2D(gm_BaseTexture, v_vTexcoord + vec2(u_vTexelSize.x, 0.0)).a;

        if (alpha_up > gm_AlphaRefValue || alpha_down > gm_AlphaRefValue || alpha_left > gm_AlphaRefValue || alpha_right > gm_AlphaRefValue) {
            color = u_vOutlineColour;
        } else {
            discard;
        }
    }
    
    gl_FragColor = color;
}
