// Get width and height of the GUI layer
var _width = display_get_gui_width();
var _height = display_get_gui_height();

// Align the GUI elements
inst_7596D186.x = 64;
inst_7596D186.y = 64;
obj_button_quit.x = 128;
obj_button_quit.y = 64;
inst_681EDCF8.x = _width - 64;
inst_681EDCF8.y = 64;
obj_button_github.x = _width - 128;
obj_button_github.y = 64;

// Draw the GUI
draw_gui = function()
{
	// Get width and height of the GUI layer
	var _width = display_get_gui_width();
	var _height = display_get_gui_height();

	// Save alignment
	var _halign = draw_get_halign();
	var _valign = draw_get_valign();
	
	// Top bar
	draw_sprite_stretched(spr_roundrect, 0, 32, 32, _width - 64, 64);
	
	// Bottom bar
	draw_sprite_stretched(spr_roundrect, 0, 32, _height - _height * 0.4, _width - 64, _height * 0.4 - 32);
	
	// Get the current time
	var _time = string(current_hour) + ":" + string(current_minute) + ":" + string(current_second);

	// Align the text
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);

	// Draw the time
	var _color = draw_get_color();
	draw_set_color(c_black);
	draw_text(_width / 2, 64, _time);
	draw_set_color(_color);
	
	// Restore alignment
	draw_set_halign(_halign);
	draw_set_valign(_valign);
}
