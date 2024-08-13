// Inherit the parent event
event_inherited();

// Change the icon
image_index = 5;
image_blend = #FF6565;

actions[BUTTON_STATE.RELEASED] = function()
{
	game_end();
}

tooltip = "Quit the game.";
