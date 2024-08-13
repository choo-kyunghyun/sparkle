// Inherit the parent event
event_inherited();

//
var _width = display_get_gui_width();
var _height = display_get_gui_height();

//
image_xscale = _width / 2;
image_yscale = _height;

//
image_blend = #343434;

// Create buttons
var _fullscreen = instance_create_layer(x + 3, y + 4, layer, obj_button);
