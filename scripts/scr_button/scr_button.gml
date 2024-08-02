// Button state enum
enum BUTTON_STATE
{
    IDLE,
    HOVER,
    PRESSED,
    RELEASED,
    DISABLED
}

// Button manager class
function ButtonManager() constructor
{
    // Buttons
    buttons = [];

    /// @desc Remove all buttons in the manager array and add new buttons
    static refresh = function()
    {
        // Remove all buttons
        array_delete(buttons, 0, array_length(buttons));

        // Add new buttons
        for (var _i = 0; _i < instance_number(obj_button); _i++)
        {
            array_push(buttons, instance_find(obj_button, _i));
        }
    }

    /// @desc Add button to the manager array
    /// @param {Id.Instance} _inst The button instance to add
    static add = function(_inst)
    {
        array_push(buttons, _inst);
    }

    /// @desc Update buttons
    static update = function()
    {
        for (var _i = 0; _i < array_length(buttons); _i++)
        {
            with (buttons[_i])
            {
                // Input detection
                var _hover = position_meeting(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), id);
                var _pressed = mouse_check_button_pressed(mb_left);
                var _released = mouse_check_button_released(mb_left);

                // Cursor size
                if (state == BUTTON_STATE.IDLE || state == BUTTON_STATE.DISABLED)
                {
                    cursor.w = 0;
                    cursor.h = 0;
                }
                else
                {
                    cursor.w = lerp(cursor.w, sprite_width, cursor.speed * obj_game.time.delta);
                    cursor.h = lerp(cursor.h, sprite_height, cursor.speed * obj_game.time.delta);
                }

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
                if (sfx[state] != -1) audio_play_sound(sfx[state], 1, false);

                // Cursor
                cursor.display = state == BUTTON_STATE.HOVER || state == BUTTON_STATE.PRESSED;

                // Tooltip
                tooltip.display = _hover;

                // Button actions
                if (actions[state] != -1) actions[state]();
            }
        }
    }

    /// @desc Draw buttons
    static draw = function()
    {
        // Store alignment and font
        var _halign = draw_get_halign();
        var _valign = draw_get_valign();
        var _font = draw_get_font();

        // Draw sprites
        for (var _i = 0; _i < array_length(buttons); _i++)
        {
            with (buttons[_i])
            {
                // Button
                draw_self();

                // Icon
                if (icon.sprite != -1)
                {
                    draw_sprite_ext(icon.sprite, icon.subimg, icon.x, icon.y, icon.xscale, icon.yscale, icon.rot, icon.color, icon.alpha);
                }

                // Cursor
                if (cursor.display && cursor.sprite != -1)
                {
                    draw_sprite_stretched_ext(cursor.sprite, cursor.subimg, cursor.x, cursor.y, cursor.w, cursor.h, cursor.color, cursor.alpha);
                }
            }
        }

        // Draw tooltip box
        for (var _i = 0; _i < array_length(buttons); _i++)
        {
            with (buttons[_i])
            {
                if (tooltip.display && tooltip.box.sprite != -1)
                {
                    draw_sprite_stretched_ext(tooltip.box.sprite, tooltip.box.subimg, device_mouse_x_to_gui(0) + tooltip.box.x, device_mouse_y_to_gui(0) + tooltip.box.y, tooltip.box.w, tooltip.box.h, tooltip.box.color, tooltip.box.alpha);
                }
            }
        }

        // Draw text and tooltip
        for (var _i = 0; _i < array_length(buttons); _i++)
        {
            with (buttons[_i])
            {
                // Text
                if (text.string != "")
                {
                    if (text.font != -1) draw_set_font(text.font);
                    draw_set_halign(text.halign);
                    draw_set_valign(text.valign);
                    draw_text_ext_transformed_color(text.x, text.y, text.string, text.sep, text.w, text.xscale, text.yscale, text.angle, text.c1, text.c2, text.c3, text.c4, text.alpha);
                }

                // Tooltip
                if (tooltip.display)
                {
                    // Text
                    if (tooltip.string != "")
                    {
                        if (tooltip.font != -1) draw_set_font(tooltip.font);
                        draw_set_halign(tooltip.halign);
                        draw_set_valign(tooltip.valign);
                        // draw_text_ext_transformed_color(device_mouse_x_to_gui(0) + tooltip.box.x, device_mouse_y_to_gui(0) + tooltip.box.y, tooltip.string, tooltip.sep, tooltip.w, tooltip.xscale, tooltip.yscale, tooltip.angle, tooltip.c1, tooltip.c2, tooltip.c3, tooltip.c4, tooltip.alpha);
                        draw_text(device_mouse_x_to_gui(0) + tooltip.box.x, device_mouse_y_to_gui(0) + tooltip.box.y, tooltip.string);
                        tooltip.box.w = string_width(tooltip.string);
                        tooltip.box.h = string_height(tooltip.string);
                    }
                }
            }
        }

        // Draw visual effects
        for (var _i = 0; _i < array_length(buttons); _i++)
        {
            with (buttons[_i])
            {
                if (vfx[state] != -1) vfx[state]();
            }
        }

        // Restore alignment and font
        draw_set_halign(_halign);
        draw_set_valign(_valign);
        draw_set_font(_font);
    }
}
