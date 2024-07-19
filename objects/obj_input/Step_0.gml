// Input detection
var _hover = position_meeting(mouse_x, mouse_y, id);
var _pressed = mouse_check_button_pressed(mb_left);
var _released = mouse_check_button_released(mb_left);

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
