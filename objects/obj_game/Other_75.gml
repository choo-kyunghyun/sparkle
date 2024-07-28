// 
switch (async_load[? "event_type"])
{
	case "gamepad discovered":
		var _index = async_load[? "pad_index"];
		break;
	case "gamepad lost":
		var _index = async_load[? "pad_index"];
		break;
}
