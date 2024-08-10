// Change position of buttons
var _width = display_get_gui_width();
var _height = display_get_gui_height();
inst_7596D186.x = 64;
inst_7596D186.y = 64;
inst_547064D0.x = 128;
inst_547064D0.y = 64;
inst_66F1C3A1.x = _width - 64;
inst_66F1C3A1.y = 64;
inst_37930913.x = _width - 128;
inst_37930913.y = 64;



// Book
book =
{
	name : "Sparkle",
	author : "Choo Kyunghyun",
	desc : ""
};

// Draw GUI
draw_gui = function()
{
	// Local variables
	var _width = display_get_gui_width();
	var _height = display_get_gui_height();
	var _halign = draw_get_halign();
	var _valign = draw_get_valign();
	
	// White bar
	draw_sprite_stretched(spr_roundrect, 0, 32, 32, _width - 64, 64);
	
	// White area
	draw_sprite_stretched(spr_roundrect, 0, 32, _height - _height * 0.4, _width - 64, _height * 0.4 - 32);
	
	// Time
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text_color(_width / 2, 64, string(current_hour) + ":" + string(current_minute) + ":" + string(current_second), c_black, c_black, c_black, c_black, 1);
	
	// 
	draw_text(_width * 0.5, _height * 0.75, book.name + "\n" + book.author + "\n" + book.desc);
	
	// Restore alignment
	draw_set_halign(_halign);
	draw_set_valign(_valign);
}
