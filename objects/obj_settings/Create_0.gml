// Hide the object
visible = false;

// Get the display width and height
var _width = display_get_gui_width();
var _height = display_get_gui_height();

// Set the image scale
image_xscale = _width / 2;
image_yscale = _height;

// Set the image blend
image_blend = #343434;

// Create buttons
var _fullscreen = instance_create_layer(x + 3, y + 4, layer, obj_button);
