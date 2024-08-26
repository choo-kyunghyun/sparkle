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

        // Get number of objects
        var _num = instance_number(obj_ui);

        // Input detection
        var _pressed = mouse_check_button_pressed(mb_left);
        var _released = mouse_check_button_released(mb_left);

        // Update objects
        for (var _i = 0; _i < _num; _i++)
        {
            // Get instance
            var _inst = instance_find(obj_ui, _i);

            // Update instance
            if (object_is_ancestor(_inst.object_index, obj_button) || _inst.object_index == obj_button)
            {
                // Skip if instance is invisible
                if (!_inst.visible || !layer_get_visible(_inst.layer)) continue;

                // Input detection
                var _hover = position_meeting(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _inst.id);

                // State transition
                if (_inst.state == BUTTON_STATE.IDLE && _hover) _inst.state = BUTTON_STATE.HOVER;
                else if (_inst.state == BUTTON_STATE.HOVER && _pressed) _inst.state = BUTTON_STATE.PRESSED;
                else if (_inst.state == BUTTON_STATE.HOVER && !_hover) _inst.state = BUTTON_STATE.IDLE;
                else if (_inst.state == BUTTON_STATE.PRESSED && _released && _hover) _inst.state = BUTTON_STATE.RELEASED;
                else if (_inst.state == BUTTON_STATE.PRESSED && _released && !_hover) _inst.state = BUTTON_STATE.IDLE;
                else if (_inst.state == BUTTON_STATE.RELEASED && !_hover) _inst.state = BUTTON_STATE.IDLE;
                else if (_inst.state == BUTTON_STATE.RELEASED && _hover) _inst.state = BUTTON_STATE.HOVER;
                else continue;

                // Sound effects
                if (_inst.sfx[_inst.state] >= 0) audio_play_sound(_inst.sfx[_inst.state], 1, false);

                // Cursor
                _inst.cursor_display = (_inst.state == BUTTON_STATE.HOVER || _inst.state == BUTTON_STATE.PRESSED);

                // Button actions
                if (_inst.actions[_inst.state] != undefined)
                {
                    script_execute_ext(_inst.actions[_inst.state], _inst.actions_args[_inst.state]);
                }
            }
            else if (object_is_ancestor(_inst.object_index, obj_panel) || _inst.object_index == obj_panel)
            {
                for (var _j = 0; _j < array_length(_inst.children); _j++)
                {
                    if (_inst.visible) instance_activate_object(_inst.children[_j].id);
                    else instance_deactivate_object(_inst.children[_j].id);
                }
            }
        }

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
    static draw = function()
    {
        // Check the event
        if (event_number != ev_gui) debug_event("UIManager: draw() must be called in the Draw GUI event.");

        // Get number of objects
        var _num = instance_number(obj_ui);

        // Draw objects
        for (var _i = 0; _i < _num; _i++)
        {
            // Get instance
            var _inst = instance_find(obj_ui, _i);

            // Draw instance
            if (object_is_ancestor(_inst.object_index, obj_button) || _inst.object_index == obj_button)
            {
                // Skip if instance is invisible
                if (!_inst.visible || !layer_get_visible(_inst.layer)) continue;

                // Draw button
                with (_inst)
                {
                    // Button
                    draw_self();

                    // Icon
                    if (icon_sprite >= 0)
                    {
                        draw_sprite_ext(icon_sprite, icon_subimg, x + icon_xoffset, y + icon_yoffset, icon_xscale, icon_yscale, icon_rot, icon_color, icon_alpha);
                    }

                    // Cursor
                    if (cursor_display && cursor_sprite >= 0)
                    {
                        draw_sprite_stretched_ext(cursor_sprite, cursor_subimg, bbox_left - cursor_xoffset, bbox_top - cursor_yoffset, bbox_right - bbox_left + cursor_xoffset * 2, bbox_bottom - bbox_top + cursor_yoffset * 2, cursor_color, cursor_alpha);
                    }

                    // Text
                    text.draw(text_x, text_y);

                    // Visual effects
                    if (vfx[state] != undefined) vfx[state]();
                }
            }
            else if (object_is_ancestor(_inst.object_index, obj_panel) || _inst.object_index == obj_panel)
            {
                with (_inst)
                {
                    if (visible && sprite_index >= 0) draw_self();
                }
            }
        }

        // Draw tooltip
        if (tooltip.sprite != -1 && tooltip.string != -1)
        {
            draw_sprite_stretched_ext(tooltip.sprite, tooltip.subimg, tooltip.x - tooltip.margin_x, tooltip.y - tooltip.margin_y, tooltip.width + tooltip.margin_x * 2, tooltip.height + tooltip.margin_y * 2, tooltip.color, tooltip.alpha);
            tooltip.string.draw(tooltip.x, tooltip.y);
        }
    }
}
