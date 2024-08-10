// Change the room settings
view_enabled = true;
view_visible[0] = true;
view_camera[0] = camera.id;

// Change level instance
if (instance_exists(obj_level))
{
	// Check for multiple instances of obj_level
	if (instance_number(obj_level) > 1) debug_event("Multiple obj_level detected.");

	// Change the level instance
	level = instance_find(obj_level, 0);
	
	// Change the camera size
	if (level.camera_width != 0) camera.width = level.camera_width;
	if (level.camera_height != 0) camera.height = level.camera_height;
	camera.resize(camera.width, camera.height);

	// Change the camera
	camera.target = level.camera_target;
	camera.script = level.camera_update_script;
	// camera.position(level.camera_x, level.camera_y, level.camera_z);
	
	// Transition
	if (level.transition)
	{
		transition.delta = transition.delta > 0 ? transition.delta : -transition.delta;
		transition.start();
	}
}

// Refresh the button manager
ui_manager.refresh();

// Update the vertex buffer
var _vm = vertex_manager;
_vm.begin_all();
with (obj_wall)
{
    if (visible && sprite_index != -1)
    {
        var _buffer = _vm.add(sprite_get_texture(sprite_index, image_index));
        vertex_add_cube(_buffer, sprite_index, image_index, x, y, depth - sprite_height, image_xscale, image_yscale, image_angle, image_pitch, image_roll, image_blend, image_alpha);
    }
}
_vm.end_all();
_vm.freeze_all();
