// Button state enum
enum BUTTON_STATE
{
    IDLE,
    HOVER,
    PRESSED,
    RELEASED,
    DISABLED
}

/// @desc User Interface Manager
function UIManager() constructor
{
    // Create panel manager
    panel_manager = new PanelManager();

    // Create button manager
    button_manager = new ButtonManager();

    // Scale
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
        string : "",
		color : c_black,
		alpha : 0.5
        // font : -1,
        // sep : 0,
        // w : 64,
        // xscale : 1,
        // yscale : 1,
        // angle : 0
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
        }
        else
        {
            // Reset tooltip
            tooltip.string = "";
        }
    }

    /// @desc Draw the user interface
    /// @param {Constant.EventType} _event The event that called this function
    static draw = function(_event = event_number)
    {
        // Draw panels
        panel_manager.draw(_event);

        // Draw buttons
        button_manager.draw(_event);
    }

    /// @desc Draw the tooltip
    static draw_tooltip = function()
    {
        // Check the event
        if (event_number != ev_gui && event_number != ev_gui_begin && event_number != ev_gui_end)
        {
            debug_event("UIManager: Tooltip isn't drawn in GUI event");
        }

        // Draw tooltip
        if (tooltip.sprite != -1 && tooltip.string != "")
        {
            // Get width and height
            // Note: Doing calculations in the Draw event will result in poor performance. We need to see if we can move this operation to the Step event.
            // Issue: When using draw_text_format() instead of draw_text(), you must check whether width and height can be calculated properly. It may be necessary to implement string_width_format() and string_height_format().
            tooltip.width = string_width(tooltip.string);
            tooltip.height = string_height(tooltip.string);

            // Offscreen handling
            // Note: Doing calculations in the Draw event will result in poor performance. We need to see if we can move this operation to the Step event.
            if (tooltip.x + tooltip.width > display_get_gui_width()) tooltip.x -= tooltip.width + tooltip.xoffset * 2;
            if (tooltip.y + tooltip.height > display_get_gui_height()) tooltip.y -= tooltip.height + tooltip.yoffset * 2;

            // Draw tooltip
            draw_sprite_stretched_ext(tooltip.sprite, tooltip.subimg, tooltip.x - tooltip.margin_x, tooltip.y - tooltip.margin_y, tooltip.width + tooltip.margin_x * 2, tooltip.height + tooltip.margin_y * 2, tooltip.color, tooltip.alpha);
            draw_text(tooltip.x, tooltip.y, tooltip.string);
            // Note: The following code is commented out temporarily.
            // draw_text_ext_transformed_color(tooltip.x, tooltip.y, tooltip.string, tooltip.sep, tooltip.w, tooltip.xscale, tooltip.yscale, tooltip.angle, tooltip.c1, tooltip.c2, tooltip.c3, tooltip.c4, tooltip.alpha);
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
    panels_draw_begin = [];
    panels_draw = [];
    panels_draw_end = [];
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
            case ev_draw_begin:
                return panels_draw_begin;
            case ev_draw:
                return panels_draw;
            case ev_draw_end:
                return panels_draw_end;
            case ev_gui_begin:
                return panels_gui_begin;
            case ev_gui:
                return panels_gui;
            case ev_gui_end:
                return panels_gui_end;
            default:
                debug_event("PanelManager: Invalid event type");
                return undefined;
        }
    }

    /// @desc Remove all panels in the manager array and add new panels
    static refresh = function()
    {
        // Remove all panels
        var _list = [panels_draw_begin, panels_draw, panels_draw_end, panels_gui_begin, panels_gui, panels_gui_end];
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
        var _list = [panels_draw_begin, panels_draw, panels_draw_end, panels_gui_begin, panels_gui, panels_gui_end];
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
    buttons_draw_begin = [];
    buttons_draw = [];
    buttons_draw_end = [];
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
            case ev_draw_begin:
                return buttons_draw_begin;
            case ev_draw:
                return buttons_draw;
            case ev_draw_end:
                return buttons_draw_end;
            case ev_gui_begin:
                return buttons_gui_begin;
            case ev_gui:
                return buttons_gui;
            case ev_gui_end:
                return buttons_gui_end;
            default:
                debug_event("ButtonManager: Invalid event type");
                return undefined;
        }
    }

    /// @desc Remove all buttons in the manager array and add new buttons
    static refresh = function()
    {
        // Remove all buttons
        var _list = [buttons_draw_begin, buttons_draw, buttons_draw_end, buttons_gui_begin, buttons_gui, buttons_gui_end];
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
        var _list = [buttons_draw_begin, buttons_draw, buttons_draw_end, buttons_gui_begin, buttons_gui, buttons_gui_end];
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
                    if (actions[state] != undefined) actions[state]();
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

        // Store alignment and font
        var _halign = draw_get_halign();
        var _valign = draw_get_valign();
        var _font = draw_get_font();

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
                // Text
                if (text.string != "")
                {
                    if (text.font >= 0) draw_set_font(text.font);
                    draw_set_halign(text.halign);
                    draw_set_valign(text.valign);
                    draw_text_ext_transformed_color(text.x, text.y, text.string, text.sep, text.w, text.xscale, text.yscale, text.angle, text.c1, text.c2, text.c3, text.c4, text.alpha);
                }
            }

            // Draw visual effects
            with (_array[_i])
            {
                if (vfx[state] != undefined) vfx[state]();
            }
        }

        // Restore alignment and font
        draw_set_halign(_halign);
        draw_set_valign(_valign);
        draw_set_font(_font);
    }
}
