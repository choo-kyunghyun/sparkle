// Inherit the parent event
event_inherited();

// Go to the rm_home when the player presses a key
update = function()
{
	if (keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_any))
	{
		room_transition(rm_home);
	}
}

// Draw the Title screen
draw_gui = function()
{
	// Save alignment
	var _halign = draw_get_halign();
	var _valign = draw_get_valign();
	
	// Get width and height of the GUI layer
	var _width = display_get_gui_width();
	var _height = display_get_gui_height();
	
	// Set alignment
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	// Draw the text
	draw_text(_width * 0.5, _height * 0.75 - 16 * dsin(current_time / 10), "PRESS ANY KEY TO START");
	
	// Restore alignment
	draw_set_halign(_halign);
	draw_set_valign(_valign);
}
