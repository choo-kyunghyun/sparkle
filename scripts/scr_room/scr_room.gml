/// @desc Transition effect for room change
/// @param {Struct} _filter The filter to use
/// @param {String} _param The name of the parameter to change
/// @param {Real} _val_min The minimum value of the parameter
/// @param {Real} _val_max The maximum value of the parameter
/// @param {Real} _delta The change in the parameter value per second
function Transition(_filter = fx_create("_filter_contrast"), _param = "g_ContrastBrightness", _val_min = 0, _val_max = 1, _delta = 5) constructor
{
	// Internal variables
	active = false;
	filter_layer = -1;
	
	// Transition parameters
	filter = _filter;
	param = _param;
	val_min = _val_min;
	val_max = _val_max;
	delta = _delta;
	target_room = -1;

	/// @desc Update the transition
	static update = function()
	{
		// If the filter is not active, return
		if (!active) return;

		// Get the parameter value
		var _val = fx_get_parameter(filter, param);
		var _delta = delta * obj_game.time.delta;

		// Check the sign of the delta
		if (delta > 0)
		{
			// Increase the parameter value
			fx_set_parameter(filter, param, _val + _delta);

			// If the parameter value is greater than max value, stop the transition
			if (_val + _delta >= val_max)
			{
				stop();
			}
		}
		else
		{
			// Decrease the parameter value
			fx_set_parameter(filter, param, _val - _delta);

			// If the parameter value is less than min value, stop the transition
			if (_val <= val_min)
			{
				stop();
			}
		}
	}

	/// @desc Set the transition parameters
	/// @param {Struct} _filter The filter to use
	/// @param {String} _param The name of the parameter to change
	/// @param {Real} _val_min The minimum value of the parameter
	/// @param {Real} _val_max The maximum value of the parameter
	/// @param {Real} _delta The change in the parameter value per second
	static set = function(_filter, _param, _val_min, _val_max, _delta)
	{
		filter = _filter;
		param = _param;
		delta = _delta;
		val_min = _val_min;
		val_max = _val_max;
	}

	/// @desc Start the transition
	static start = function(_room = -1)
	{
		// Create the filter layer
		filter_layer = layer_create(-16000);

		// Set the parameter to the start value
		if (delta > 0)
		{
			fx_set_parameter(filter, param, val_min);
		}
		else
		{
			fx_set_parameter(filter, param, val_max);
		}

		// Set the filter to the start value
		layer_set_fx(filter_layer, filter);

		// Set the target room
		target_room = _room;

		// Set the transition to active
		active = true;
	}

	/// @desc Stop the transition
	static stop = function()
	{
		// If the transition is not active, return
		if (!active) return;

		// Set the parameter to the target value
		if (delta > 0)
		{
			fx_set_parameter(filter, param, val_max);
		}
		else
		{
			fx_set_parameter(filter, param, val_min);
		}

		// Set the transition to inactive
		active = false;

		// Destroy the filter layer
		layer_clear_fx(filter_layer);
		layer_destroy(filter_layer);
		filter_layer = -1;

		// If a target room is set, go to the target room
		if (target_room != -1)
		{
			room_goto(target_room);
		}
	}
}

/// @desc Transition effect for room change
function room_transition(_room)
{
	with (obj_game)
	{
		// Set the transition parameters
		transition.delta = transition.delta > 0 ? -transition.delta : transition.delta;
		transition.start(_room);
	}
}
