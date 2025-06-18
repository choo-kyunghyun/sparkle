if (array_length(path_array) > 1) {
    for (var _i = 0, _len = array_length(path_array); _i < _len - 1; _i++) {
        var _p1 = path_array[_i];
        var _p2 = path_array[_i + 1];
        draw_rectangle_color(_p1.x, _p1.y, _p2.x, _p2.y, c_green, c_green, c_green, c_green, false);
    }
}
draw_sprite_ext(spr_alien, 0, draw_start_x, draw_start_y, 1, 1, 0, c_white, 1);
draw_sprite_ext(spr_apple, 0, draw_end_x, draw_end_y, 1, 1, 0, c_white, 1);
