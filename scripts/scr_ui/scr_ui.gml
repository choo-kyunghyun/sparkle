// Button state enum
enum BUTTON_STATE
{
    IDLE,
    HOVER,
    PRESSED,
    RELEASED,
    DISABLED
}

/// @desc User interface manager.
function UIManager() constructor
{
    // Create panel manager
    panel_manager = new PanelManager();

    // Create button manager
    button_manager = new ButtonManager();

    // GUI scale
    scale = 1;
	
	// Tooltip
	tooltip =
    {
        sprite : spr_roundrect,
        subimg : 0,
        x : 0,
        y : 0,
        width : 0,
        height : 0,
        margin_x : 8,
        margin_y : 8,
        xoffset : 16,
        yoffset : 16,
        string : -1,
		color : c_black,
		alpha : 0.5
    };

    /// @desc Update the user interface
    static update = function()
    {
        // Update scale
        display_set_gui_maximise(scale, scale);

        // Update panels
        panel_manager.update();

        // Update buttons
        button_manager.update();

        // Get mouse position
        var _mouse_x = device_mouse_x_to_gui(0);
        var _mouse_y = device_mouse_y_to_gui(0);

        // Get button instance under mouse
        var _inst = instance_position(_mouse_x, _mouse_y, obj_button);

        // Update tooltip
        if (_inst != noone && _inst.visible && layer_get_visible(_inst.layer))
        {
            // Get tooltip string
            tooltip.string = _inst.tooltip;

            // Set tooltip position
            tooltip.x = _mouse_x + tooltip.xoffset;
            tooltip.y = _mouse_y + tooltip.yoffset;

            // Set tooltip size
            tooltip.width = tooltip.string.width();
            tooltip.height = tooltip.string.height();

            // Offscreen handling
            if (tooltip.x + tooltip.width > display_get_gui_width()) tooltip.x -= tooltip.width + tooltip.xoffset * 2;
            if (tooltip.y + tooltip.height > display_get_gui_height()) tooltip.y -= tooltip.height + tooltip.yoffset * 2;
        }
        else
        {
            // Reset tooltip
            tooltip.string = -1;
        }
    }

    /// @desc Draw the user interface.
    /// @param {Constant.EventType} _event The event that called this function.
    static draw = function(_event = event_number)
    {
        // Draw panels
        panel_manager.draw(_event);

        // Draw buttons
        button_manager.draw(_event);
    }

    /// @desc Draw the tooltip.
	// Note: This function is called in the Draw GUI event.
    static draw_tooltip = function()
    {
        // Draw tooltip
        if (tooltip.sprite != -1 && tooltip.string != -1)
        {
            draw_sprite_stretched_ext(tooltip.sprite, tooltip.subimg, tooltip.x - tooltip.margin_x, tooltip.y - tooltip.margin_y, tooltip.width + tooltip.margin_x * 2, tooltip.height + tooltip.margin_y * 2, tooltip.color, tooltip.alpha);
            tooltip.string.draw(tooltip.x, tooltip.y);
        }
    }

    /// @desc Refresh the button manager
    static refresh = function()
    {
        // Refresh button manager
        button_manager.refresh();

        // Refresh panel manager
        panel_manager.refresh();
    }
}

// Panel manager
function PanelManager() constructor
{
    // Arrays
    panels_gui_begin = [];
    panels_gui = [];
    panels_gui_end = [];

    /// @desc Get panel array by event
    /// @param {Constant.EventType} _event The event to get
    /// @return {Array} The panel array
    /// @pure
    static get_array = function(_event)
    {
        switch (_event)
        {
            case ev_gui_begin:
                return panels_gui_begin;
            case ev_gui:
                return panels_gui;
            case ev_gui_end:
                return panels_gui_end;
            default:
                return undefined;
        }
    }

    /// @desc Remove all panels in the manager array and add new panels
    static refresh = function()
    {
        // Remove all panels
        var _list = [panels_gui_begin, panels_gui, panels_gui_end];
        for (var _i = 0; _i < array_length(_list); _i++)
        {
            array_delete(_list[_i], 0, array_length(_list[_i]));
        }

        // Add new panels
        for (var _i = 0; _i < instance_number(obj_panel); _i++)
        {
            var _inst = instance_find(obj_panel, _i);
            var _array = get_array(_inst.event);
            if (_array == undefined) continue;
            array_push(_array, _inst);
        }
    }

    /// @desc Update panels
    static update = function()
    {
        var _list = [panels_gui_begin, panels_gui, panels_gui_end];
        for (var _i = 0; _i < array_length(_list); _i++)
        {
            for (var _j = 0; _j < array_length(_list[_i]); _j++)
            {
                with (_list[_i][_j])
                {
                    for (var _k = 0; _k < array_length(children); _k++)
                    {
                        if (visible) instance_activate_object(children[_k].id);
                        else instance_deactivate_object(children[_k].id);
                    }
                }
            }
        }
    }

    /// @desc Draw panels
    /// @param {Constant.EventType} _event The event to draw
    static draw = function(_event)
    {
        // Get array
        var _array = get_array(_event);

        // Check if array is valid
        if (array_length(_array) == 0) return;

        // Draw each panel
        for (var _i = 0; _i < array_length(_array); _i++)
        {
            with (_array[_i])
            {
                if (visible && sprite_index >= 0) draw_self();
            }
        }
    }
}

// Button manager class
function ButtonManager() constructor
{
    // Arrays
    buttons_gui_begin = [];
    buttons_gui = [];
    buttons_gui_end = [];

    /// @desc Get button array by event
    /// @param {Constant.EventType} _event The event to get
    /// @return {Array} The button array
    /// @pure
    static get_array = function(_event)
    {
        switch (_event)
        {
            case ev_gui_begin:
                return buttons_gui_begin;
            case ev_gui:
                return buttons_gui;
            case ev_gui_end:
                return buttons_gui_end;
            default:
                return undefined;
        }
    }

    /// @desc Remove all buttons in the manager array and add new buttons
    static refresh = function()
    {
        // Remove all buttons
        var _list = [buttons_gui_begin, buttons_gui, buttons_gui_end];
        for (var _i = 0; _i < array_length(_list); _i++)
        {
            array_delete(_list[_i], 0, array_length(_list[_i]));
        }

        // Add new buttons
        for (var _i = 0; _i < instance_number(obj_button); _i++)
        {
            var _inst = instance_find(obj_button, _i);
            var _array = get_array(_inst.event);
            if (_array == undefined) continue;
            array_push(_array, _inst);
        }
    }

    /// @desc Update buttons
    static update = function()
    {
        // Update each array
        var _list = [buttons_gui_begin, buttons_gui, buttons_gui_end];
        for (var _i = 0; _i < array_length(_list); _i++)
        {
            for (var _j = 0; _j < array_length(_list[_i]); _j++)
            {
                with (_list[_i][_j])
                {
                    // Skip if button is invisible
                    if (!_list[_i][_j].visible || !layer_get_visible(_list[_i][_j].layer)) continue;

                    // Input detection
                    var _hover = position_meeting(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), id);
                    var _pressed = mouse_check_button_pressed(mb_left);
                    var _released = mouse_check_button_released(mb_left);

                    // State transition
                    if (state == BUTTON_STATE.IDLE && _hover) state = BUTTON_STATE.HOVER;
                    else if (state == BUTTON_STATE.HOVER && _pressed) state = BUTTON_STATE.PRESSED;
                    else if (state == BUTTON_STATE.HOVER && !_hover) state = BUTTON_STATE.IDLE;
                    else if (state == BUTTON_STATE.PRESSED && _released && _hover) state = BUTTON_STATE.RELEASED;
                    else if (state == BUTTON_STATE.PRESSED && _released && !_hover) state = BUTTON_STATE.IDLE;
                    else if (state == BUTTON_STATE.RELEASED && !_hover) state = BUTTON_STATE.IDLE;
                    else if (state == BUTTON_STATE.RELEASED && _hover) state = BUTTON_STATE.HOVER;
                    else continue;

                    // Sound effects
                    if (sfx[state] >= 0) audio_play_sound(sfx[state], 1, false);

                    // Cursor
                    cursor.display = (state == BUTTON_STATE.HOVER || state == BUTTON_STATE.PRESSED);

                    // Button actions
                    if (actions[state] != undefined)
					{
                        script_execute_ext(actions[state], actions_args[state]);
					}
                }
            }
        }
    }

    /// @desc Draw buttons
    /// @param {Constant.EventType} _event The event to draw
    static draw = function(_event)
    {
        // Get array
        var _array = get_array(_event);

        // Check if array is valid
        if (array_length(_array) == 0) return;

        // Draw each button
        for (var _i = 0; _i < array_length(_array); _i++)
        {
            // Skip if button is invisible
            if (!_array[_i].visible || !layer_get_visible(_array[_i].layer)) continue;

            with (_array[_i])
            {
                // Button
                draw_self();

                // Icon
                if (icon.sprite >= 0)
                {
                    draw_sprite_ext(icon.sprite, icon.subimg, icon.x, icon.y, icon.xscale, icon.yscale, icon.rot, icon.color, icon.alpha);
                }

                // Cursor
                if (cursor.display && cursor.sprite >= 0)
                {
                    draw_sprite_stretched_ext(cursor.sprite, cursor.subimg, bbox_left - cursor.xoffset, bbox_top - cursor.yoffset, bbox_right - bbox_left + cursor.xoffset * 2, bbox_bottom - bbox_top + cursor.yoffset * 2, cursor.color, cursor.alpha);
                }
            }

            // Draw text
            with (_array[_i])
            {
                text.draw(text_x, text_y);
            }

            // Draw visual effects
            with (_array[_i])
            {
                if (vfx[state] != undefined) vfx[state]();
            }
        }
    }
}
