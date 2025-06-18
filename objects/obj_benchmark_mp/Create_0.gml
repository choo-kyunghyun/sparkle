MotionPlanning.init(0, 0, room_width, room_height);
draw_start_x = 0;
draw_strat_y = 0;
draw_end_x = 0;
draw_end_y = 0;
path_array = [];
density = 0.3;
allowdiag = false;

roll = function(_density, _allowdiag) {
    var _maze = event_benchmark_maze(_density, _allowdiag);
    draw_start_x = _maze.xstart;
    draw_start_y = _maze.ystart;
    draw_end_x = _maze.xend;
    draw_end_y = _maze.yend;
    path_array = _maze.path;
};
roll(density, allowdiag);
