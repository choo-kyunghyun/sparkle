// Local variable
var _index = -1;

// Update gamepad
switch (async_load[? "event_type"])
{
	case "gamepad discovered":
		_index = async_load[? "pad_index"];
		break;
	case "gamepad lost":
		_index = async_load[? "pad_index"];
		break;
}
