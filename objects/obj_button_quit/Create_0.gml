// Inherit the parent event
event_inherited();

actions[BUTTON_STATE.RELEASED] = function()
{
	game_end();
}
