/// @desc Actor manager
function ActorManager() constructor
{
	
}

/// @desc Control the player
// Note: This function needs to be rewritten.
function actor_player()
{
    // Game
    var _game = obj_game;

    // Input
    var _input_x = _game.input.right() - _game.input.left();
    var _input_y = _game.input.down() - _game.input.up();
    var _input_z = _game.input.jump();

    // Movement
    if (_input_x != 0 || _input_y != 0)
    {
        var _dir = point_direction(0, 0, _input_x, _input_y);
        var _dist = movement_speed * obj_game.time.delta;

        move_and_collide(lengthdir_x(_dist, _dir), lengthdir_y(_dist, _dir), obj_wall);
    }
}

/// @desc Apply gravity to the actor
/// @param _dx The x-axis delta
/// @param _dy The y-axis delta
/// @param _dz The z-axis delta
function actor_gravity(_dx, _dy, _dz, _max)
{
    
}
