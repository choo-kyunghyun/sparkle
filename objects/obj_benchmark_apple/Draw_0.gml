if (shader != sh_depth && shader != -1) {
    shader_set(shader);
}

if (shader == sh_apple) {
    draw_clear(c_black);
} else if (shader == sh_outline) {
    shader_set_uniform_f_array(u_outline_colour, outline_colour);
    shader_set_uniform_f(u_texel_size, texel_w, texel_h);
}

vbuff.submit();

if (shader != sh_depth && shader != -1) {
    shader_reset();
}
