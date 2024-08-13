// Inherit the parent event
event_inherited();

// Start the sequence
credits = layer_sequence_create(layer, room_width / 2, room_height / 2, seq_intro);
layer_sequence_play(credits);

// Go to the rm_home when the sequence is finished or the player presses a key
update = function()
{
	if (layer_sequence_is_finished(obj_level_credits.credits) || keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_any))
	{
		layer_sequence_destroy(obj_level_credits.credits);
		room_transition(rm_home);
	}
}
