// Draw Level GUI
if (level != noone && level.draw_gui != undefined)
{
	var _length = array_length(level.draw_gui_args);
	if (_length) script_execute_ext(level.draw_gui, level.draw_gui_args, 0, _length);
	else script_execute(level.draw_gui);
}

// Draw UI
ui_manager.draw();

// DELETE ME
sample.draw(64, 64);
