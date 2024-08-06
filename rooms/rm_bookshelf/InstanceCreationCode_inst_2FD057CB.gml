// Camera
var _game = obj_game;
var _ratio = _game.window.width / _game.window.height;
if (_ratio > 1)
{
	_game.camera.width = 320;
	_game.camera.height = 320 / _ratio;
}
else
{
	_game.camera.width = 320 * _ratio;
	_game.camera.height = 320;
}
_game.camera.x = 160 - _game.camera.width / 2;
_game.camera.y = 160 - _game.camera.height / 2;

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
	var _halign = draw_get_halign();
	var _valign = draw_get_valign();
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	var _width = display_get_gui_width();
	var _height = display_get_gui_height();
	draw_text(_width * 0.5, _height * 0.75, book.name + "\n" + book.author + "\n" + book.desc);
	draw_set_halign(_halign);
	draw_set_valign(_valign);
}
