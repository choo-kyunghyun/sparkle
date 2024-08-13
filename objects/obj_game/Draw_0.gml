// Submit vertex buffer
vertex_manager.submit();

// Draw level
if (level != noone && level.draw != undefined)
{
	var _length = array_length(level.draw_args);
	if (_length) script_execute_ext(level.draw, level.draw_args, 0, _length);
	else script_execute(level.draw);
}

// Draw UI
ui_manager.draw();
