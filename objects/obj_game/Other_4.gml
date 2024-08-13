// Change the room settings
view_enabled = true;
view_visible[0] = true;
view_camera[0] = camera.id;

// Get the level instance
// Note: Only one level instance should exist in the room
level = instance_find(obj_level, 0);

// If the level instance exists
if (level != noone)
{	
	// Update the camera size
	if (level.camera_width != 0) camera.width = level.camera_width;
	if (level.camera_height != 0) camera.height = level.camera_height;
	camera.resize(camera.width, camera.height);

	// Change the camera settings
	camera.script = level.camera_update_script;
	camera.target = level.camera_target;

	// Update the camera position
	if (camera.target == noone) camera.position(level.camera_x, level.camera_y, level.camera_z);
	else camera.position(camera.target.x - camera.width / 2, camera.target.y - camera.height / 2, camera.target.depth - camera.dist);
	
	// Start the transition effect
	// Note: This code isn't complete and should be modified to fit your needs
	if (level.transition)
	{
		transition.delta = transition.delta > 0 ? transition.delta : -transition.delta;
		transition.start();
	}
}

// Refresh the GUI manager
ui_manager.refresh();

// Add static objects to the vertex buffer
var _vm = vertex_manager;

// Begin the vertex buffer
_vm.begin_all();

// Add all walls to the vertex buffer
with (obj_wall)
{
    if (visible && sprite_index != -1)
    {
        var _buffer = _vm.add(sprite_get_texture(sprite_index, image_index));
        vertex_add_cube(_buffer, sprite_index, image_index, x, y, depth - sprite_height, image_xscale, image_yscale, image_angle, image_pitch, image_roll, image_blend, image_alpha);
    }
}

// Add all actors to the vertex buffer
_vm.end_all();

// Freeze the vertex buffer to improve performance
_vm.freeze_all();
