// Inherit the parent event
event_inherited();

// Actions
actions[BUTTON_STATE.IDLE] = function() { image_index = 0; image_alpha = 1; };
actions[BUTTON_STATE.HOVER] = function() { image_index = 1; image_alpha = 1; };
actions[BUTTON_STATE.PRESSED] = function() { image_index = 2; image_alpha = 1; };
actions[BUTTON_STATE.RELEASED] = function() { image_index = 1; image_alpha = 1; };
actions[BUTTON_STATE.DISABLED] = function() { image_alpha = 0.5; };

// Sound effects
sfx[BUTTON_STATE.HOVER] = snd_tick;
sfx[BUTTON_STATE.PRESSED] = snd_pressed;
sfx[BUTTON_STATE.RELEASED] = snd_released;
