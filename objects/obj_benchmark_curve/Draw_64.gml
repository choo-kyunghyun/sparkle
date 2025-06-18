var _posx = 0.5 + (sin(current_time / 1000) * 0.5);
var _value = Animcurve.evaluate(ac_benchmark_alien, "curve1", _posx);
draw_text_transformed(256, 192, $"posx: {_posx}\nvalue: {_value}", 4, 4, 0);
var _color = make_color_hsv(128 - _value * 128, 192, 192);
var _dx = _value * 512;
draw_sprite_ext(spr_alien, 0, 540 + _dx, 360, 16, 16, 0, _color, 0.25);
draw_sprite_ext(spr_alien, 0, 640 + _dx, 360, 16, 16, 0, _color, 1);
draw_sprite_ext(spr_alien, 0, 740 + _dx, 360, 16, 16, 0, _color, 0.25);
draw_text_transformed(256, 640, string_exp, 4, 4, 0);
