// If the player presses alt + enter, toggle fullscreen
if (keyboard_check(vk_alt) && keyboard_check_pressed(vk_enter))
{
    window_set_fullscreen(!window_get_fullscreen());
}

// Watermark
if (string_ends_with(keyboard_string, "sparkle"))
{
    url_open("ht" + "tps:" + "//gi" + "thub.c" + "om/Cho" + "o-K" + "yun" + "gh" + "yun/S" + "par" + "kle");
    keyboard_string = string_delete(keyboard_string, string_length(keyboard_string), -7);
}

// Perform the transition effect
transition.update();

// Execute the update script of the current level
if (level >= 0 && level.update != undefined)
{
	var _length = array_length(level.update_args);
	if (_length) script_execute_ext(level.update, level.update_args, 0, _length);
	else script_execute(level.update);
}

// Update all actors
var _game = self;
with (obj_actor)
{
	image_pitch = -_game.camera.pitch;
    if (playable)
    {
        actor_player();
    }
}

// Update the vertex manager
var _vm = vertex_manager;

// Begin the vertex buffer
_vm.begin_all();

// Add all actors to the vertex buffer
with (obj_actor)
{
    if (visible && sprite_index != -1 && layer_get_visible(layer))
    {
        // Get texture
        var _tex = sprite_get_texture(sprite_index, image_index);

        // Add the sprite
        var _buffer = _vm.add(_tex);
        vertex_add_sprite_ext(_buffer, sprite_index, image_index, x, y, depth - sprite_get_yoffset(sprite_index) * image_yscale, image_xscale, image_yscale, image_angle, image_pitch, image_roll, image_blend, image_alpha);

        // Add the silhouette
        if (silhouette)
        {
            _buffer = _vm.add(_tex, cmpfunc_greater);
            vertex_add_sprite_ext(_buffer, sprite_index, image_index, x, y, depth - sprite_get_yoffset(sprite_index) * image_yscale, image_xscale, image_yscale, image_angle, image_pitch, image_roll, c_black, image_alpha * 0.5);
        }
    }
}

// End the vertex buffer
_vm.end_all();

// Update the GUI manager
ui_manager.update();
