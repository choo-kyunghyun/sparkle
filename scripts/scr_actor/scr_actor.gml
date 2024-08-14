/// @desc Actor manager.
function ActorManager() constructor
{
    /// @desc Update all actors.
    // Note: This function needs to be rewritten.
    static update = function()
    {
        // Gravity

        // Movement
        var _game = GAME;
        with (obj_actor)
        {
            image_pitch = -_game.camera.pitch;
            if (playable)
            {
                // Input
                var _input_x = _game.input.check("right") - _game.input.check("left");
                var _input_y = _game.input.check("down") - _game.input.check("up");
                var _input_z = _game.input.check("jump");

                // Movement
                if (_input_x != 0 || _input_y != 0)
                {
                    var _dir = point_direction(0, 0, _input_x, _input_y);
                    var _dist = movement_speed * _game.time.delta;

                    move_and_collide(lengthdir_x(_dist, _dir), lengthdir_y(_dist, _dir), obj_wall);
                }
            }
        }
    }
}
