// Note: This script is used for button actions. Recommended naming convention is button_action_{action}.

function button_action_window_fullscreen()
{
    window_set_fullscreen(true);
}

function button_action_window_windowed()
{
    window_set_fullscreen(false);
    window_set_showborder(true);
}

function button_action_borderless()
{
    window_set_fullscreen(false);
    window_set_showborder(false);
}

function button_action_window_center()
{
    window_center();
}

function button_action_quit()
{
    game_end();
}
