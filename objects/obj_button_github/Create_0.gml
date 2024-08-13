// Inherit the parent event
event_inherited();

// Change the icon
image_index = 4;
image_blend = #666666;

// Open the repository
actions[BUTTON_STATE.RELEASED] = function()
{
	url_open("https://github.com/Choo-Kyunghyun/Sparkle");
}

tooltip = "Open GitHub repository";
