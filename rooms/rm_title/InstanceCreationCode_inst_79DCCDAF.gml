layer_sequence_play(layer_sequence_create(layer, 0, 0, seq_fade_out));
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
