obj_game.camera.script = camera_update_rpg;
obj_game.camera.custom = function ()
{ 
	if (keyboard_check(ord("Q")))
	{
		obj_game.camera.yaw -= 0.5;
	}
	else if (keyboard_check(ord("R")))
	{
		obj_game.camera.yaw += 0.5;
	}
}
