// Remove sprite from object
sprite_index = -1;

// Game
var _game = obj_game;

// Change camera
_game.camera.target = camera_target;
_game.camera.script = camera_update_script;
_game.camera.position(camera_x, camera_y, camera_z);
_game.camera.width = camera_width;
_game.camera.height = camera_height;
