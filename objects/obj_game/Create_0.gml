// Time
time =
{
    delta : 0,
    speed : 1
};

// Window
window =
{
    width : display_get_width() * 0.5,
    height : display_get_height() * 0.5
};

// Set window size
window_set_size(window.width, window.height);
surface_resize(application_surface, window.width, window.height);

// Center window
window_center();

// Set game speed
game_set_speed(display_get_frequency(), gamespeed_fps);

// Set gpu settings
gpu_set_ztestenable(true);
gpu_set_alphatestenable(true);
gpu_set_cullmode(cull_counterclockwise);

// Show debug overlay
show_debug_overlay(true);

// Randomize
randomize();
