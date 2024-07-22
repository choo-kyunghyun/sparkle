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
camera = new Camera();

// Vertex format
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_color();
vertex_format_add_texcoord();
vertex_format = vertex_format_end();

// Vertex buffer
vertex_buffer = vertex_create_buffer();

// Vertex texture
vertex_texture = -1;

// Set gpu settings
gpu_set_ztestenable(true);
gpu_set_alphatestenable(true);
gpu_set_cullmode(cull_counterclockwise);

// Reset display
if (display_aa >= 8)        display_reset(8, false);
else if (display_aa >= 4)   display_reset(4, false);
else if (display_aa >= 2)   display_reset(2, false);
else                        display_reset(0, false);

// Set gui size
display_set_gui_size(room_width, room_height);

// Set window size
window_set_size(window.width, window.height);
surface_resize(application_surface, window.width, window.height);

// Center window
window_center();

// Set game speed
game_set_speed(display_get_frequency(), gamespeed_fps);

// Randomize
randomize();

// Set debug overlay
show_debug_overlay(false);

// Set release mode
gml_release_mode(false);

// Go to next room
room_goto_next();
