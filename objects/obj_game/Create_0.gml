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

// Camera
camera =
{
    id : -1,
    x : 0,
    y : 0,
    z : 0,
    width : room_width,
    height : room_height
};

// Set window size
window_set_size(window.width, window.height);
surface_resize(application_surface, window.width, window.height);

// Set gui size
display_set_gui_size(room_width, room_height);

// Center window
window_center();

// Set game speed
game_set_speed(display_get_frequency(), gamespeed_fps);

// Randomize
randomize();

// Set gpu settings
gpu_set_ztestenable(true);
gpu_set_alphatestenable(true);
gpu_set_cullmode(cull_counterclockwise);

// Set display settings
if (display_aa >= 8)
{
    display_reset(8, false);
}
else if (display_aa >= 4)
{
    display_reset(4, false);
}
else if (display_aa >= 2)
{
    display_reset(2, false);
}
else
{
    display_reset(0, false);
}

// Show debug overlay
show_debug_overlay(true);

// Set release mode
gml_release_mode(false);

// Go to next room
room_goto_next();
