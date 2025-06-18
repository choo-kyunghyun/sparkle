new UserInterface();
new UILayer();
new Textbox();
new Button();
new Tooltip();
new Transition();
new Notification();
new Dialogue();

/**
 * UserInterface class for handling the user interface elements in the game.
 * @returns {Struct.UserInterface}
 */
function UserInterface() constructor {
    /**
     * This function is used to update all user interface elements.
     * @returns {Undefined}
     */
    static update = function() {
        Textbox.update();
        Button.update();
        Tooltip.update();
        Transition.update();
        Notification.update();
        Dialogue.update();
    }

    /**
     * This function is used to draw all user interface elements.
     * @returns {Undefined}
     */
    static draw = function() {
        Textbox.draw();
        // Button.draw(); // Button is inherited from Textbox, so it doesn't need to be drawn separately
        Tooltip.draw();
        Transition.draw();
        Notification.draw();
        Dialogue.draw();
    }
}

/**
 * UILayer class for managing UI layers in the game.
 * This class provides functions to show, hide, and manage layers in the user interface.
 * @returns {Struct.UILayer}
 */
function UILayer() constructor {
    static prefix = "uily_"; // Prefix for UI layers to avoid conflicts with other layers
    static layers = []; // Array to hold the layer IDs or names
    static force_ids = true; // Whether to force the use of layer IDs instead of names

    call_later(1, time_source_units_frames, function() {
        self.scan();
    });

    // layer_set_visible() function accepts both layer IDs and layer names as strings.
    // Be careful when pushing layers into the array! Mixing IDs and names can lead to unexpected behavior.
    // If you follow the naming convention, you can use scan() to automatically populate the layers array.

    /**
     * This function converts a layer name to its corresponding ID.
     * If `force_ids` is true, it retrieves the ID of the layer by its name.
     * If the layer is not found, it throws an error.
     * @returns {Id.Layer}
     * @param {String|Id.Layer} _layer - The layer ID or name to convert.
     */
    static convert_layer_name_to_id = function(_layer) {
        if (self.force_ids && is_string(_layer)) {
            var _id = layer_get_id(_layer);
            if (_id == -1) {
                throw new Error("Layer not found: " + _layer);
            }
            return _id;
        }
        return _layer;
    }

    /**
     * This function adds a layer to the layers array if it is not already present.
     * If the layer is successfully added, it returns true; otherwise, it returns false.
     * @returns {Bool}
     * @param {String|Id.Layer} _layer - The layer ID or name to add.
     */
    static add = function(_layer) {
        _layer = self.convert_layer_name_to_id(_layer);
        if (!array_contains(self.layers, _layer)) {
            array_push(self.layers, _layer);
            return true;
        }
        return false;
    }

    /**
     * This function removes a layer from the layers array if it exists.
     * If the layer is successfully removed, it returns true; otherwise, it returns false.
     * @returns {Bool}
     * @param {String|Id.Layer} _layer - The layer ID or name to remove.
     */
    static show = function(_layer) {
        _layer = self.convert_layer_name_to_id(_layer);
        if (array_contains(self.layers, _layer)) {
            layer_set_visible(_layer, true);
            return true;
        }
        return false;
    }
    
    /**
     * This function hides a layer if it exists in the layers array.
     * If the layer is successfully hidden, it returns true; otherwise, it returns false.
     * @returns {Bool}
     * @param {String|Id.Layer} _layer - The layer ID or name to hide.
     */
    static hide = function(_layer) {
        _layer = self.convert_layer_name_to_id(_layer);
        if (array_contains(self.layers, _layer)) {
            layer_set_visible(_layer, false);
            return true;
        }
        return false;
    }

    /**
     * This function toggles the visibility of a layer.
     * If the layer is currently visible, it hides it; if it is hidden, it shows it.
     * @returns {Bool}
     * @param {String|Id.Layer} _layer - The layer ID or name to toggle.
     */
    static toggle = function(_layer) {
        _layer = self.convert_layer_name_to_id(_layer);
        if (array_contains(self.layers, _layer)) {
            layer_set_visible(_layer, !layer_get_visible(_layer));
            return true;
        }
        return false;
    }

    /**
     * This function checks if a layer is visible.
     * @returns {Undefined}
     */
    static hide_all = function() {
        array_foreach(self.layers, function(_layer) {
            layer_set_visible(_layer, false);
        });
    }

    /**
     * This function scans all layers in the game and populates the layers array with those that start with the specified prefix.
     * It retrieves all layers using `layer_get_all()` and filters them based on the prefix.
     * @returns {Undefined}
     */
    static scan = function() {
        var _layers = layer_get_all();
        array_foreach(_layers, function(_layer) {
            var _name = layer_get_name(_layer);
            if (string_starts_with(_name, self.prefix)) {
                array_push(self.layers, _layer);
            }
        });
    }

    /**
     * This function clears the layers array, removing all layers.
     * It effectively resets the UILayer state.
     * @returns {Undefined}
     */
    static clear = function() {
        self.layers = [];
    }

    /**
     * This function shows a specific layer while hiding all others.
     * @returns {Undefined}
     * @param {String|Id.Layer} _layer - The layer ID or name to show.
     */
    static show_only = function(_layer) {
        _layer = self.convert_layer_name_to_id(_layer);
        if (array_contains(self.layers, _layer)) {
            self.hide_all();
            layer_set_visible(_layer, true);
        }
    }

    /**
     * This function shows only the specified layers while hiding all others.
     * It iterates through the provided layers and sets their visibility to true if they exist in the layers array.
     * @returns {Undefined}
     * @param {Array<String|Id.Layer>} _layers - An array of layer IDs or names to show.
     */
    static show_only_ext = function(_layers) {
        self.hide_all();
        array_foreach(_layers, function(_layer) {
            _layer = self.convert_layer_name_to_id(_layer);
            if (array_contains(self.layers, _layer)) {
                layer_set_visible(_layer, true);
            }
        });
    }
}

/**
 * Textbox class for handling textbox in the game.
 * @returns {Struct.Textbox}
 */
function Textbox() constructor {
    static margin = 4; // TODO: This margin should be an object variable
    
    /**
     * This function updates the textbox state.
     * @returns {Undefined}
     */
    static update = function() {
        var _hour = string_replace_all(string_format(current_hour, 2, 0), " ", "0");
        var _min = string_replace_all(string_format(current_minute, 2, 0), " ", "0");
        var _sec = string_replace_all(string_format(current_second, 2, 0), " ", "0");
        
        with (obj_clock) {
            self.text = $"{_hour}:{_min}:{_sec}";
        }
    }

    /**
     * This function draws the textbox on the screen.
     * @returns {Undefined}
     */
    static draw = function() {
        with (obj_textbox) {
            draw_self();
            if (string_length(self.text)) {
                var _text = i18n.get(self.text);
                var _width = string_width(_text) + Textbox.margin * 2;
                var _height = string_height(_text) + Textbox.margin * 2;
                var _scale = self.text_scale == 0 ? min(sprite_width / _width, sprite_height / _height) : self.text_scale;
                if (self.integer_scaling) {
                    _scale = floor(_scale);
                }
                var _x = self.x + (sprite_width - _width * _scale) / 2 + Textbox.margin * _scale;
                var _y = self.y + (sprite_height - _height * _scale) / 2 + Textbox.margin * _scale;
                draw_text_transformed_color(_x, _y, _text, _scale, _scale, self.text_angle, self.text_color, self.text_color, self.text_color, self.text_color, color_get_alpha(self.text_color));
            }
        }
    }
}

/**
 * Button class for handling button interactions in the user interface.
 * @returns {Struct.Button}
 */
function Button() : Textbox() constructor {
    /**
     * This function will update the button state based on user input.
     * @returns {Undefined}
     */
    static update = function() {
        // TODO: Use scr_input
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        var _click = mouse_check_button_pressed(mb_left);
        var _release = mouse_check_button_released(mb_left);
        var _tooltip = "";

        with (obj_button) {
            var _hover_previous = self.hover;
            var _hold_previous = self.hold;
            
            self.hover = position_meeting(_mx, _my, self.id);
            if (self.hover && _click) {
                self.hold = true;
            } else if (!self.hover) {
                self.hold = false;
            }
            
            if (self.hover) {
                _tooltip = self.tooltip;
            }
            
            if (self.hover && !_hover_previous && self.snd_hover != noone) {
                audio_play_sound(self.snd_hover, 1, false);
            }
            
            if (_release && self.hold) {
                if (self.snd_click != noone) {
                    audio_play_sound(self.snd_click, 1, false);
                }
				script_execute(self.onActive);
            }
            
            if (self.hover) {
                self.image_index = 1;
            } else {
                self.image_index = 0;
            }
        }
        
        Tooltip.text = _tooltip;
    }
}

function Tooltip() constructor {
    static text = "";
    static sprite = spr_unit;
    static subimg = 0;
    static color = #242424;
    static alpha = 0.75;
    static offset = 32;
    static scale = 6;
    static angle = 0;
    static x = 0;
    static y = 0;
    static width = 0;
    static height = 0;
    static sep = 12;
    static w = display_get_gui_width() / 2;

    /**
     * This function will update the tooltip position and size based on the mouse position.
     * @returns {Undefined}
     */
    static update = function() {
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        self.text = i18n.get(self.text);

        self.x = _mx + self.offset / 2;
        self.y = _my + self.offset / 2;
        self.width = string_width_ext(self.text, self.sep, self.w / self.scale) * self.scale + self.offset;
        self.height = string_height_ext(self.text, self.sep, self.w / self.scale) * self.scale + self.offset;

        if (self.x + self.width >= display_get_gui_width()) {
            self.x -= self.width + self.offset;
        }
        if (self.y + self.height >= display_get_gui_height()) {
            self.y -= self.height + self.offset;
        }
    }

    /**
     * This function will draw the tooltip on the screen.
     * @returns {Undefined}
     */
    static draw = function() {
        if (string_length(self.text) == 0) {
            return;
        }

        draw_sprite_stretched_ext(self.sprite, self.subimg, self.x, self.y, self.width, self.height, self.color, self.alpha);
        // draw_text_transformed(self.x + self.offset / 2, self.y + self.offset / 2, self.text, self.scale, self.scale, self.angle);
        draw_text_ext_transformed(self.x + self.offset / 2, self.y + self.offset / 2, self.text, self.sep, self.w / self.scale, self.scale, self.scale, self.angle);
    }
}

/**
 * Transition class for handling screen transitions in the game.
 * @returns {Struct.Transition}
 */
function Transition() constructor {
    static enable = false;
    static alpha = 0;
    static color = #262626;
    static delta = 0;
    static callback = noop;
    static sprite = spr_unit;
    static subimg = 0;

    /**
     * This function starts the transition with a specified delta and callback.
     * @returns {Undefined}
     * @param {Real} delta - The delta value for the transition.
     * @param {Function} callback - The callback function to execute when the transition completes.
     */
    static start = function(_delta, _callback) {
        if (self.enable) {
            return;
        }
        self.delta = _delta;
        self.callback = _callback;
        self.enable = true;
    }

    /**
     * This function updates the transition state based on the delta and time.
     * @returns {Undefined}
     */
    static update = function() {
        if (!self.enable) {
            return;
        }

        self.alpha += self.delta * Time.raw;
        if (self.delta > 0) {
            if (self.alpha >= 1) {
                self.delta *= -1;
                script_execute(self.callback);
            }
        } else {
            if (self.alpha <= 0) {
                self.enable = false;
            }
        }
    }

    /**
     * This function draws the transition effect on the screen.
     * @returns {Undefined}
     */
    static draw = function() {
        if (!self.enable) {
            return;
        }

        draw_sprite_stretched_ext(self.sprite, self.subimg, 0, 0, display_get_gui_width(), display_get_gui_height(), self.color, self.alpha);
    }
}

/**
 * Notification class for handling notifications in the game.
 * @returns {Struct.Notification}
 */
function Notification() constructor {
    static queue = [];
    static history = [];

    /**
     * This function adds a notification to the queue.
     * @returns {Undefined}
     * @param {String} message - The message to display in the notification.
     * ...
     */
    static enqueue = function() {

    }

    /**
     * This function updates the notification queue and processes notifications.
     * @returns {Undefined}
     */
    static update = function() {

    }

    /**
     * This function draws the notifications on the screen.
     * @returns {Undefined}
     */
    static draw = function() {
        
    }
}

/**
 * Dialogue class for handling dialogue interactions in the game.
 * @returns {Struct.Dialogue}
 */
function Dialogue() constructor {
    static text = "";
    static name = "";
    static portrait = {
        sprite: spr_unit,
        subimg: 0,
        scale: 1,
    };

    /**
     * This function updates the dialogue state based on user input.
     * @returns {Undefined}
     */
    static update = function() {

    }

    /**
     * This function draws the dialogue on the screen.
     * @returns {Undefined}
     */
    static draw = function() {
        
    }
}
