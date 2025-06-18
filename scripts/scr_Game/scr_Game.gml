/**
 * This function does nothing. It is a placeholder for cases where no action is needed.
 * It can be used to avoid errors in situations where a function is expected but no action is required.
 * Never delete this function or it will cause errors in the game.
 * @returns {Undefined}
 */
function noop() {
	return;
}

/**
 * This function opens the repository page. You can change the URL to your own homepage or repository.
 * @returns {Undefined}
 */
function homepage() {
    url_open("https://github.com/choo-kyunghyun/sparkle");
}

/**
 * This function check keyboard input for a specific keyword.
 * If the keyword is found at the end of the keyboard string, it will remove the keyword and call the homepage function.
 * You can change the keyword to your own keyword.
 * @returns {Undefined}
 */
function watermark() {
	var _keyword = "sparkle";
	if (string_ends_with(keyboard_string, _keyword)) {
		keyboard_string = string_delete(keyboard_string, string_length(keyboard_string), -1 * string_length(_keyword));
		homepage();
	}
}

/**
 * This function checks for a fullscreen toggle shortcut.
 * It toggles the fullscreen mode when the Alt key is pressed and Enter is pressed.
 * @returns {Undefined}
 */
function fullscreen_shortcut() {
	if (keyboard_check(vk_alt) && keyboard_check_pressed(vk_enter)) {
		window_set_fullscreen(!window_get_fullscreen());
	}
}

// TODO: Move to scr_color and encapsulate color operations
/**
 * This function extracts the alpha component from a color value.
 * @returns {Real}
 * @param {Real} col - The color value from which to extract the alpha.
 */
function color_get_alpha(_col) {
	return (_col >> 24) / 0xFF;
}

// TODO: Move to scr_screen and generalize to take screenshots with different formats
// TODO: Why there is no webP support in GameMaker?
/**
 * This function takes a screenshot of the current game window.
 * It saves the screenshot in the "screenshots" directory with a timestamped filename.
 * This function must be called in the Draw GUI End Event of the game object.
 * @returns {Undefined}
 */
function screenshot() {
	if (Input.check("screenshot")) {
        var _datetime = string(current_year);
        _datetime += "-" + string_replace_all(string_format(current_month, 2, 0), " ", "0");
        _datetime += "-" + string_replace_all(string_format(current_day, 2, 0), " ", "0");
        _datetime += "_" + string_replace_all(string_format(current_hour, 2, 0), " ", "0");
        _datetime += "-" + string_replace_all(string_format(current_minute, 2, 0), " ", "0");
        _datetime += "-" + string_replace_all(string_format(current_second, 2, 0), " ", "0");
		_datetime += $"_{current_time}";
		var _fname = working_directory + "screenshots\\" + _datetime + ".png";
		screen_save(_fname);
	}
}

// TODO: Move to scr_display and encapsulate display operations
/**
 * This function will return all available anti-aliasing options as an array.
 * @returns {Array<real>}
 */
function display_get_aa() {
    var _arr = [];
    if (display_aa & 0b1000) {
        array_push(_arr, 8);
    }
    if (display_aa & 0b0100) {
        array_push(_arr, 4);
    }
    if (display_aa & 0b0010) {
        array_push(_arr, 2);
    }
    array_push(_arr, 0);
    return _arr;
}

// TODO: Move to scr_input or scr_window.
/**
 * This function checks if the window has focus and sets the mouse to be locked or not based on that.
 * It returns true if the window has focus, otherwise false.
 * @returns {Bool}
 */
function window_mouse_lock() {
    var _focus = window_has_focus();
    window_mouse_set_locked(_focus);
    return _focus;
}

/**
 * This function toggles the debug overlay.
 * If the debug overlay is open, it will close it; if it is closed, it will open it.
 * @returns {Undefined}
 */
function debug_overlay_toggle() {
    var _open = is_debug_overlay_open();
    show_debug_log(!_open);
}
