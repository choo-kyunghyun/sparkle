// Play the intro
intro = layer_sequence_create(layer, 0, 0, seq_intro);
layer_sequence_play(intro);

// Camera
var _camera = obj_game.camera;
_camera.resize(room_width, room_height);
_camera.x = -_camera.width / 2;
_camera.y = -_camera.height / 2;

// Check the intro
update = function()
{
	if (layer_sequence_is_finished(intro) || keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_any))
	{
		layer_sequence_destroy(intro);
		room_goto(rm_title);
	}
}
