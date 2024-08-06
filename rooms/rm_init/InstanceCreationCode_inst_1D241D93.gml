// Play the intro
intro = layer_sequence_create(layer, 0, 0, seq_intro);
layer_sequence_play(intro);

// Check the intro
update = function()
{
	if (layer_sequence_is_finished(intro))
	{
		layer_sequence_destroy(intro);
		room_goto_next();
	}
}
