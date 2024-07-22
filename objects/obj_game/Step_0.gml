// Fullscreen toggle
if (keyboard_check(vk_alt) && keyboard_check_pressed(vk_enter))
{
    window_set_fullscreen(!window_get_fullscreen());
}

// Update vertex buffer
var _tex = -1;
var _buffer = vertex_buffer;
vertex_begin(vertex_buffer, vertex_format);
with (obj_actor)
{
    _tex = vertex_add_self(_buffer, -45, 0);
}
vertex_end(vertex_buffer);
vertex_texture = _tex;
