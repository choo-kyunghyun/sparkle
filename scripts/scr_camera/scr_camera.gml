/// @desc The camera object.
/// @arg {Real} _x The x position of the camera.
/// @arg {Real} _y The y position of the camera.
/// @arg {Real} _z The z position of the camera.
/// @arg {Real} _width The width of the camera.
/// @arg {Real} _height The height of the camera.
/// @arg {Asset.GMObject, Id.Instance} _target The target of the camera.
/// @arg {Real} _dist The distance of the camera.
/// @arg {Real} _speed The speed of the camera.
/// @arg {Real} _yaw The yaw of the camera.
/// @arg {Real} _pitch The pitch of the camera.
/// @arg {Real} _roll The roll of the camera.
/// @arg {Real} _fov The field of view of the camera.
/// @arg {Real} _znear The near clipping plane of the camera.
/// @arg {Real} _zfar The far clipping plane of the camera.
/// @arg {Function, Real} _script The script of the camera.
function Camera(_x = 0, _y = 0, _z = 0, _width = room_width, _height = room_height, _target = noone, _dist = 256, _speed = 5, _yaw = 270, _pitch = 45, _roll = 0, _fov = 60, _znear = 1, _zfar = 32000, _script = camera_update_default) constructor
{
    id = camera_create_view(_x, _y, _width, _height);
    x = _x;
    y = _y;
    z = _z;
    width = _width;
    height = _height;
    target = _target;
    dist = _dist;
    speed = _speed;
    yaw = _yaw;
    pitch = _pitch;
    roll = _roll;
    fov = _fov;
    znear = _znear;
    zfar = _zfar;
    script = _script;
    custom = undefined;
    
    /// @desc Destroys the camera.
    static destroy = function()
    {
        camera_destroy(id);
    };

    /// @desc Updates the camera.
    static update = function()
    {
        script();
        if (custom != undefined)
        {
            custom();
        }
    };

    /// @desc Updates the position of the camera.
    /// @arg {Real} _x The x position of the camera.
    /// @arg {Real} _y The y position of the camera.
    /// @arg {Real} _z The z position of the camera.
    static position = function(_x = 0, _y = 0, _z = 0)
    {
        x = _x;
        y = _y;
        z = _z;
    };

    /// @desc Updates the size of the camera.
    /// @arg {Real} _width The width of the camera.
    /// @arg {Real} _height The height of the camera.
    static size = function(_width = room_width, _height = room_height)
    {
        width = _width;
        height = _height;
    };

    /// @desc Updates the axes of the camera.
    /// @arg {Real} _yaw The yaw of the camera.
    /// @arg {Real} _pitch The pitch of the camera.
    /// @arg {Real} _roll The roll of the camera.
    static axes = function(_yaw = 0, _pitch = 0, _roll = 0)
    {
        yaw = _yaw;
        pitch = _pitch;
        roll = _roll;
    };
}

/// @desc Updates the camera for a default game.
function camera_update_default()
{
    with (obj_game)
    {
        // Update the position
        if (camera.target >= 0)
        {
            camera.x = lerp(camera.x, camera.target.x, camera.speed * time.delta);
            camera.y = lerp(camera.y, camera.target.y, camera.speed * time.delta);
        }

        // Check the bounds
        camera.x = clamp(camera.x, 0, room_width - camera.width);
        camera.y = clamp(camera.y, 0, room_height - camera.height);

        // Update the camera
        camera_set_view_pos(camera.id, camera.x, camera.y);
        camera_set_view_size(camera.id, camera.width, camera.height);
        camera_apply(camera.id);
    }
}

/// @desc Updates the camera for an RPG game.
function camera_update_rpg()
{
    with (obj_game)
    {
        // Calculate the distances of the camera from the target
        var _dist_x = camera.dist * dcos(-camera.yaw) * dcos(-camera.pitch);
        var _dist_y = camera.dist * dsin(-camera.yaw) * dcos(-camera.pitch);
        var _dist_z = camera.dist * dsin(-camera.pitch);
        
        // Update the position
        if (camera.target >= 0)
        {
            camera.x = lerp(camera.x, camera.target.x + _dist_x, camera.speed * time.delta);
            camera.y = lerp(camera.y, camera.target.y + _dist_y, camera.speed * time.delta);
            camera.z = lerp(camera.z, camera.target.depth + _dist_z, camera.speed * time.delta);
        }

        // Update the camera
        camera_set_view_mat(camera.id, matrix_build_lookat(camera.x, camera.y, camera.z, camera.x - _dist_x, camera.y - _dist_y, camera.z - _dist_z, dsin(camera.roll), 0, dcos(camera.roll)));
        camera_set_proj_mat(camera.id, matrix_build_projection_perspective_fov(camera.fov, camera.width / camera.height, camera.znear, camera.zfar));
        camera_apply(camera.id);
    }
}
