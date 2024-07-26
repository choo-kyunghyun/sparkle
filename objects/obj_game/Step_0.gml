// Local variables
var _game = obj_game;
var _vm = vertex_manager;

// Fullscreen toggle
if (keyboard_check(vk_alt) && keyboard_check_pressed(vk_enter))
{
    window_set_fullscreen(!window_get_fullscreen());
}

// Update actor
with (obj_actor)
{
	image_pitch = -_game.camera.pitch;
    if (playable)
    {
        actor_player();
    }
}

// Update vertex buffer
_vm.begin_all();
with (obj_actor)
{
    if (visible && sprite_index != -1)
    {
        // Get texture
        var _tex = sprite_get_texture(sprite_index, image_index);

        // Self
        var _buffer = _vm.add(_tex);
        vertex_add_sprite_ext(_buffer, sprite_index, image_index, x, y, depth - sprite_get_yoffset(sprite_index) * image_yscale, image_xscale, image_yscale, image_angle, image_pitch, image_roll, image_blend, image_alpha);

        // Silhouette
        if (silhouette)
        {
            _buffer = _vm.add(_tex, cmpfunc_greater);
            vertex_add_sprite_ext(_buffer, sprite_index, image_index, x, y, depth - sprite_get_yoffset(sprite_index) * image_yscale, image_xscale, image_yscale, image_angle, image_pitch, image_roll, c_black, image_alpha * 0.5);
        }
    }
}
with (obj_wall)
{
    if (visible && sprite_index != -1)
    {
        // Get texture
        var _tex = sprite_get_texture(sprite_index, image_index);

        // Cube
        var _buffer = _vm.add(_tex);
        vertex_add_cube(_buffer, sprite_index, image_index, x, y, depth - sprite_height, image_xscale, image_yscale, image_angle, image_pitch, image_roll, image_blend, image_alpha);
    }
}
_vm.end_all();
