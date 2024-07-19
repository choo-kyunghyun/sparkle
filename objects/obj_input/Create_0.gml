// States
enum BUTTON_STATES
{
    NORMAL,
    HOVERED,
    PRESSED,
    RELEASED,
    DISABLED
}

// State variables
state = BUTTON_STATES.NORMAL;

// Actions
actions = array_create_ext(BUTTON_STATES.DISABLED + 1, function() { return undefined; });
actions[BUTTON_STATES.NORMAL] = function() { image_index = 0; image_alpha = 1; };
actions[BUTTON_STATES.HOVERED] = function() { image_index = 1; image_alpha = 1; };
actions[BUTTON_STATES.PRESSED] = function() { image_index = 2; image_alpha = 1; };
actions[BUTTON_STATES.RELEASED] = function() { image_index = 1; image_alpha = 1; };
actions[BUTTON_STATES.DISABLED] = function() { image_alpha = 0.5; };

// Hotkey
hotkey = -1;

// Sound effects
sfx = array_create_ext(BUTTON_STATES.DISABLED + 1, function() { return -1; });
sfx[BUTTON_STATES.HOVERED] = snd_tick;
sfx[BUTTON_STATES.PRESSED] = snd_pressed;
sfx[BUTTON_STATES.RELEASED] = snd_released;

// Visual effects
vfx = array_create_ext(BUTTON_STATES.DISABLED + 1, function() { return undefined; });

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

// Text
text =
{
    font : -1,
    x : x + 4,
    y : y + 4,
    string : "Button",
    sep : 0,
    w : 64,
    xscale : 1,
    yscale : 1,
    angle : 0,
    c1 : c_white,
    c2 : c_white,
    c3 : c_white,
    c4 : c_white,
    alpha : 1
};

// Cursor
cursor =
{
    display : false,
    sprite : spr_cursor,
    subimg : 0,
    x : x,
    y : y,
    w : 0,
    h : 0,
    rot : 0,
    color : c_white,
    alpha : 1,
    speed : 0.1
};

// Tooltip
tooltip =
{
    display : false,
    header :
    {
        font : -1,
        x : x + 4,
        y : y + sprite_height + 8,
        string : "tooltip_header",
        sep : 0,
        w : 64,
        xscale : 1,
        yscale : 1,
        angle : 0,
        c1 : c_white,
        c2 : c_white,
        c3 : c_white,
        c4 : c_white,
        alpha : 1
    },
    body :
    {
        font : -1,
        x : x + 4,
        y : y + sprite_height + 24,
        string : "tooltip_body",
        sep : 0,
        w : 64,
        xscale : 1,
        yscale : 1,
        angle : 0,
        c1 : c_white,
        c2 : c_white,
        c3 : c_white,
        c4 : c_white,
        alpha : 1
    },
    box :
    {
        sprite : -1,
        subimg : 0,
        x : x,
        y : y + sprite_height + 4,
        w : 0,
        h : 0,
        color : c_white,
        alpha : 1,
        margin_width : 8,
        margin_height : 4
    }
};
