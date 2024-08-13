// Time object
time =
{
    delta : 0,
    speed : 1
};

// Collider instance for precise collision checks
collider = instance_create_layer(0, 0, layer, obj_collider);

// Camera object
camera = new Camera();
camera.resize(room_width, room_height);

// Vertex manager
vertex_manager = new VertexManager();

// UI manager
ui_manager = new UIManager();
ui_manager.scale = 2;

// Input object
input =
{
    left : function() { return keyboard_check(ord("A")); },
    right : function() { return keyboard_check(ord("D")); },
    up : function() { return keyboard_check(ord("W")); },
    down : function() { return keyboard_check(ord("S")); },
    jump : function() { return keyboard_check(vk_space); },
    attack : function() { return mouse_check_button(mb_left); },
    interact : function() { return keyboard_check_pressed(ord("E")); },
    pause : function() { return keyboard_check_pressed(vk_escape); },
    scan : function() { return keyboard_check_pressed(ord("F")); },
	screenshot : function() { return keyboard_check_pressed(vk_printscreen); }
};

// Level instance
level = noone;

// Transition manager
transition = new Transition();

// Language
language = os_get_language();

// Region
region = os_get_region();

// Directory paths
directory =
{
	screenshot : working_directory + "\Screenshots\\"
};

// Special day flags
fools = (current_month == 4 && current_day == 1);

// Set gpu settings
gpu_set_ztestenable(true);
gpu_set_alphatestenable(true);

// Set display settings
if (display_aa >= 8)        display_reset(8, false);
else if (display_aa >= 4)   display_reset(4, false);
else if (display_aa >= 2)   display_reset(2, false);
else                        display_reset(0, false);

// Set window size
window_set_size(display_get_width() * 0.5, display_get_height() * 0.5);
surface_resize(application_surface, window_get_width(), window_get_height());

// Center window
window_center();

// Set framerate
game_set_speed(display_get_frequency(), gamespeed_fps);

// Set font
draw_set_font(fnt_sparkle);

// Audio settings

// Randomize
randomize();

// Set debug overlay
// Note: Set to false for release
show_debug_overlay(true);

// Set release mode
// Note: Set to true for release
gml_release_mode(false);

// DELETE THIS
sample = new String("He<color=c_black>ll<alpha=0.5>o, <alpha=1>\n<color=c_white>world!\nI'm <font=fnt_sparkle_large>BIG!<font=fnt_sparkle>YES\nReally huge it is");
