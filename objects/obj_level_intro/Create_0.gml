// Inherit the parent event
event_inherited();

// Start the intro sequence
intro = layer_sequence_create(layer, 0, 0, seq_intro);
layer_sequence_play(intro);

// Go to the rm_title when the sequence is finished
update = function()
{
	if (layer_sequence_is_finished(obj_level_intro.intro))
	{
		layer_sequence_destroy(obj_level_intro.intro);
		room_transition(rm_title);
	}
}
