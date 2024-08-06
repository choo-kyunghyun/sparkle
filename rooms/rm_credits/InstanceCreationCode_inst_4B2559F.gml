// Play the intro
intro = layer_sequence_create(layer, 0, 0, seq_intro);
layer_sequence_play(intro);

// Check the intro
update = function()
{
	if (layer_sequence_is_finished(intro) || keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_any))
	{
		layer_sequence_destroy(intro);
		room_goto(rm_bookshelf);
	}
}
