var _color_delta = make_color_hsv(time_delta % $ffffff, 128, 192);
var _color_raw = make_color_hsv(time_raw % $ffffff, 128, 192);
draw_text_transformed(64, 256, $"time.delta: {time_delta}\ntime.raw: {time_raw}", 4, 4, 0);
draw_circle_color(256, 480, 128, _color_delta, _color_delta, false);
draw_circle_color(640, 480, 128, _color_raw, _color_raw, false);
draw_sprite_ext(spr_tree, 0, 360, 800, 4, 4, time_delta * 30, _color_delta, 1);
draw_sprite_ext(spr_tree, 0, 800, 800, 4, 4, time_raw * 30, _color_raw, 1);
