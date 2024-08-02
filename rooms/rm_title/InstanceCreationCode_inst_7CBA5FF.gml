actions[BUTTON_STATE.RELEASED] = function() { image_index = 1; image_alpha = 1; game_end(); };
text.string = "Exit";
icon.sprite = spr_icon;
icon.subimg = 3;
icon.xscale = 4;
icon.yscale = 4;
icon.y = y - 16;
text.y = y + 24;
tooltip.string = "Exit the game.";
