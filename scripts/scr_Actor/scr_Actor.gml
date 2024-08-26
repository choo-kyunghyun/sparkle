/// @desc Actor manager.
function ActorManager() constructor
{
    // Collider
    collider = instance_create_depth(0, 0, 0, obj_collider);
    collider.visible = false;
    collider.persistent = true;

    /// @desc Update all actors.
    // Note: This function needs to be rewritten.
    static update = function()
    {
        // Input
        var _game = GAME;
        var _input_x = _game.input.check("right") - _game.input.check("left");
        var _input_y = _game.input.check("down") - _game.input.check("up");
        var _input_z = _game.input.check("jump");

        with (obj_actor)
        {
            // Variables
            var _dx = 0;
            var _dy = 0;
            var _dz = 0;

            // Gravity
            if (!place_meeting(x, y + bbox_bottom, obj_wall))
            {
                grav += 60 * _game.time.delta;
                _dy += grav * _game.time.delta;
            }
            else
            {
                grav = 0;
            }

            // Movement
            if (playable)
            {
                if (_input_x != 0 || _input_y != 0)
                {
                    var _dir = point_direction(0, 0, _input_x, _input_y);
                    var _dist = movement_speed * _game.time.delta;

                    move_and_collide(lengthdir_x(_dist, _dir), lengthdir_y(_dist, _dir), obj_wall);
                }
            }

            // Update position
            move_and_collide(_dx, _dy, obj_wall);
            image_pitch = -_game.camera.pitch;
        }
    }
}
