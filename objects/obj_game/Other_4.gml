// Change the room settings
view_enabled = true;
view_visible[0] = true;
view_camera[0] = camera.id;

// Update the vertex buffer
var _vm = vertex_manager;
_vm.begin_all();
with (obj_plane)
{
	var _buffer = _vm.add(sprite_get_texture(sprite_index, image_index));
	vertex_add_sprite_ext(_buffer, sprite_index, image_index, x, y, depth, image_xscale, image_yscale, image_angle, image_pitch, image_roll, image_blend, image_alpha);
	
}
with (obj_cube)
{
	var _buffer = _vm.add(sprite_get_texture(sprite_index, image_index));
	vertex_add_cube(_buffer, sprite_index, image_index, x, y, depth - sprite_height, image_xscale, image_yscale, image_angle, image_pitch, image_roll, image_blend, image_alpha);
}
with (obj_wall)
{
    // Check if the wall is visible
    if (visible && sprite_index != -1)
    {
        var _buffer = _vm.add(sprite_get_texture(sprite_index, image_index));
        vertex_add_cube(_buffer, sprite_index, image_index, x, y, depth - sprite_height, image_xscale, image_yscale, image_angle, image_pitch, image_roll, image_blend, image_alpha);
    }
}
_vm.end_all();
_vm.freeze_all();
