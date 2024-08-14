// Inherit the parent event
event_inherited();

// Action
actions[BUTTON_STATE.RELEASED] = function()
{
	game_end();
}
