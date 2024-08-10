// Time
time =
{
    delta : 0,
    speed : 1
};

// Collider
collider = instance_create_layer(0, 0, layer, obj_collider);

// Camera
camera = new Camera();

// Vertex manager
vertex_manager = new VertexManager();

// UI manager
ui_manager = new UIManager();
// ui_manager.scale = 4;

// Input
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

// Level
level = noone;

// Transition
transition = new Transition();

// Language
language = os_get_language();

// Region
region = os_get_region();

// Special day
fools = (current_month == 4 && current_day == 1);

// Set gpu settings
gpu_set_ztestenable(true);
gpu_set_alphatestenable(true);

// Reset display
if (display_aa >= 8)        display_reset(8, false);
else if (display_aa >= 4)   display_reset(4, false);
else if (display_aa >= 2)   display_reset(2, false);
else                        display_reset(0, false);

// Set window size
window_set_size(display_get_width() * 0.5, display_get_height() * 0.5);
surface_resize(application_surface, window_get_width(), window_get_height());
// display_set_gui_maximize();

// Center window
window_center();

// Set game speed
game_set_speed(display_get_frequency(), gamespeed_fps);

// Audio settings

// Draw settings

// Randomize
randomize();

// Set debug overlay
show_debug_overlay(true);

// Set release mode
gml_release_mode(false);
