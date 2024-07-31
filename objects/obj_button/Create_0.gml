// Button state
state = BUTTON_STATE.IDLE;

// Actions
actions = array_create(BUTTON_STATE.DISABLED + 1, -1);

// Sound effects
sfx = array_create(BUTTON_STATE.DISABLED + 1, -1);

// Visual effects
vfx = array_create(BUTTON_STATE.DISABLED + 1, -1);

// Predefined actions
actions[BUTTON_STATE.IDLE] = function() { image_index = 0; image_alpha = 1; };
actions[BUTTON_STATE.HOVER] = function() { image_index = 1; image_alpha = 1; };
actions[BUTTON_STATE.PRESSED] = function() { image_index = 2; image_alpha = 1; };
actions[BUTTON_STATE.RELEASED] = function() { image_index = 1; image_alpha = 1; };
actions[BUTTON_STATE.DISABLED] = function() { image_alpha = 0.5; };

// Predefined sound effects
sfx[BUTTON_STATE.HOVER] = snd_tick;
sfx[BUTTON_STATE.PRESSED] = snd_pressed;
sfx[BUTTON_STATE.RELEASED] = snd_released;

// Icon
icon =
{
    sprite : -1,
    subimg : 0,
    x : x + 4,
    y : y + 4,
    xscale : 1,
    yscale : 1,
    rot : 0,
    color : c_white,
    alpha : 1
};

// Cursor
cursor =
{
    display : false,
    sprite : spr_cursor,
    subimg : 0,
    x : x - sprite_xoffset,
    y : y - sprite_yoffset,
    w : 0,
    h : 0,
    rot : 0,
    color : c_white,
    alpha : 1,
    speed : 20
};

// Text
text =
{
    font : -1,
    x : x,
    y : y,
    string : "",
    sep : 0,
    w : 64,
    xscale : 1,
    yscale : 1,
    angle : 0,
    c1 : c_white,
    c2 : c_white,
    c3 : c_white,
    c4 : c_white,
    halign : fa_center,
    valign : fa_middle,
    alpha : 1
};

// Tooltip
tooltip =
{
    display : false,
    font : -1,
    x : x + 4,
    y : y + sprite_height + 8,
    string : "",
    sep : 0,
    w : 64,
    xscale : 1,
    yscale : 1,
    angle : 0,
    c1 : c_white,
    c2 : c_white,
    c3 : c_white,
    c4 : c_white,
    halign : fa_left,
    valign : fa_top,
    alpha : 1,
    box :
    {
        sprite : spr_tooltip,
        subimg : 0,
        xoffset : 16,
        yoffset : 16,
        x : 0,
        y : 0,
        w : 0,
        h : 0,
        color : c_white,
        alpha : 1
    }
};
