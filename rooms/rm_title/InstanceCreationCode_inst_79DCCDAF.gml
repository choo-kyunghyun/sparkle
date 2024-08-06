// Animations
sequence = layer_sequence_create(layer, 0, 0, seq_title);
layer_sequence_play(sequence);

// Camera
var _game = obj_game;
var _ratio = _game.window.width / _game.window.height;
if (_ratio > 1)
{
	_game.camera.width = 320;
	_game.camera.height = 320 / _ratio;
}
else
{
	_game.camera.width = 320 * _ratio;
	_game.camera.height = 320;
}
_game.camera.x = 160 - _game.camera.width / 2;
_game.camera.y = 160 - _game.camera.height / 2;

// Text
text_y = obj_game.camera.y + obj_game.camera.height * 0.8;

// Update
update = function()
{
	// Next room
	if (keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_any))
	{
		if (sequence != -1)
		{
			layer_sequence_destroy(sequence);
		}
		room_goto_next();
	}
	
	// Text position
	text_y = obj_game.camera.y + obj_game.camera.height * 0.8 + 8 * dsin(current_time / 10);
	
	// Sequence
	if (sequence != -1 && layer_sequence_is_finished(sequence))
	{
		layer_sequence_destroy(sequence);
		sequence = -1;
	}
}

// Draw
draw = function()
{
	var _halign = draw_get_halign();
	var _valign = draw_get_valign();
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text(obj_game.camera.x + obj_game.camera.width * 0.5, text_y, "PRESS ANY KEY TO START");
	draw_set_halign(_halign);
	draw_set_valign(_valign);
}
