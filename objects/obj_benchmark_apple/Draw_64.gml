if (shader == sh_depth) {
    var _texture = surface_get_texture_depth(application_surface);
    shader_set(sh_depth);
    shader_set_uniform_f(u_zparam, zparam);
    draw_primitive_begin_texture(pr_trianglestrip, _texture);
    var _window = min(display_get_gui_width(), display_get_gui_height());
    draw_vertex_texture(0, 0, 0, 0);
    draw_vertex_texture(_window, 0, 1, 0);
    draw_vertex_texture(0, _window, 0, 1);
    draw_vertex_texture(_window, _window, 1, 1);
    draw_primitive_end();
    shader_reset();
}

var _string = $"{input_guide}shader: {shader} | sprite: {sprite}\nnum: {num} | max_depth: {max_depth} | zparam: {zparam}";
draw_sprite_stretched_ext(spr_unit, 0, 60, 188, string_width(_string) * 4 + 8, string_height(_string) * 4 + 8, #161616, 0.5);
draw_text_transformed(64, 192, _string, 4, 4, 0);
