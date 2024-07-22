// Input detection
var _hover = position_meeting(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), id);
var _pressed = mouse_check_button_pressed(mb_left);
var _released = mouse_check_button_released(mb_left);

// Hotkey detection
if (hotkey != -1)
{
    if (keyboard_check_pressed(hotkey))
    {
        _hover = true;
        _pressed = true;
    }
    else if (keyboard_check_released(hotkey))
    {
        _hover = true;
        _released = true;
    }
    else if (keyboard_check(hotkey))
    {
        _hover = true;
        _pressed = true;
    }
}

// State transition with sfx
var _transition = function(_state)
{
    if (state != _state)
    {
        if (sfx[_state] != -1 && state != BUTTON_STATES.RELEASED)
        {
            audio_play_sound(sfx[_state], 10, false);
        }
        state = _state;
    }
};

// State transition
if (state == BUTTON_STATES.NORMAL && _hover)
{
    _transition(BUTTON_STATES.HOVERED);
}
else if (state == BUTTON_STATES.HOVERED && _pressed)
{
    _transition(BUTTON_STATES.PRESSED);
}
else if (state == BUTTON_STATES.HOVERED && !_hover)
{
    _transition(BUTTON_STATES.NORMAL);
}
else if (state == BUTTON_STATES.PRESSED && _released && _hover)
{
    _transition(BUTTON_STATES.RELEASED);
}
else if (state == BUTTON_STATES.PRESSED && _released && !_hover)
{
    _transition(BUTTON_STATES.NORMAL);
}
else if (state == BUTTON_STATES.RELEASED && !_hover)
{
    _transition(BUTTON_STATES.NORMAL);
}
else if (state == BUTTON_STATES.RELEASED && _hover)
{
    _transition(BUTTON_STATES.HOVERED);
}

// Cursor
if (cursor.sprite != -1)
{
    if (state == BUTTON_STATES.NORMAL || state == BUTTON_STATES.DISABLED)
    {
        cursor.display = false;
        cursor.w = 0;
        cursor.h = 0;
    }
    else
    {
        cursor.display = true;
        cursor.w = lerp(cursor.w, sprite_width, cursor.speed * obj_game.time.delta);
        cursor.h = lerp(cursor.h, sprite_height, cursor.speed * obj_game.time.delta);
    }
}

// Tooltip
if (_hover)
{
    tooltip.display = true;
}
else
{
    tooltip.display = false;
}

// Actions
if (actions[state] != undefined)
{
    actions[state]();
}
