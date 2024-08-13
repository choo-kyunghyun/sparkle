/// @desc The camera object.
/// @param {Real} _x The x position of the camera.
/// @param {Real} _y The y position of the camera.
/// @param {Real} _z The z position of the camera.
/// @param {Real} _width The width of the camera.
/// @param {Real} _height The height of the camera.
/// @param {Asset.GMObject, Id.Instance} _target The target of the camera.
/// @param {Real} _dist The distance of the camera.
/// @param {Real} _speed The speed of the camera.
/// @param {Real} _yaw The yaw of the camera.
/// @param {Real} _pitch The pitch of the camera.
/// @param {Real} _roll The roll of the camera.
/// @param {Real} _fov The field of view of the camera.
/// @param {Real} _znear The near clipping plane of the camera.
/// @param {Real} _zfar The far clipping plane of the camera.
/// @param {Function, Real} _script The script of the camera.
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
	// Note : Update event should be in the End Step event.
    static update = function()
    {
        if (script != undefined) script();
        if (custom != undefined) custom();
    };

    /// @desc Updates the position of the camera.
    /// @param {Real} _x The x position of the camera.
    /// @param {Real} _y The y position of the camera.
    /// @param {Real} _z The z position of the camera.
    static position = function(_x = 0, _y = 0, _z = 0)
    {
        x = _x;
        y = _y;
        z = _z;
    };

    /// @desc Updates the size of the camera.
    /// @param {Real} _width The width of the camera.
    /// @param {Real} _height The height of the camera.
    static size = function(_width = room_width, _height = room_height)
    {
        width = _width;
        height = _height;
    };

    /// @desc Updates the axes of the camera.
    /// @param {Real} _yaw The yaw of the camera.
    /// @param {Real} _pitch The pitch of the camera.
    /// @param {Real} _roll The roll of the camera.
    static axes = function(_yaw = 0, _pitch = 0, _roll = 0)
    {
        yaw = _yaw;
        pitch = _pitch;
        roll = _roll;
    };

    /// @desc Resizes the camera to fit the window.
    /// @param {Real} _base_width The base width of the camera.
    /// @param {Real} _base_height The base height of the camera.
    static resize = function(_base_width = room_width, _base_height = room_height)
    {
        // Get the window size
        var _width = window_get_width();
        var _height = window_get_height();

        // Calculate the aspect ratio
        var _aspect = _width / _height;

        // Portrait
        if (_aspect < 1)
        {
            height = min(_height, _base_height);
            width = height * _aspect;
        }
        // Landscape
        else
        {
            width = min(_width, _base_width);
            height = width / _aspect;
        }

        // Update the camera
        camera_set_view_size(id, floor(width), floor(height));
    };
}

/// @desc Updates the camera
function camera_update_default()
{
    with (obj_game)
    {
        // Update the position
        if (camera.target >= 0)
        {
            camera.x = lerp(camera.x, camera.target.x - camera.width * 0.5, camera.speed * time.delta);
            camera.y = lerp(camera.y, camera.target.y - camera.height * 0.5, camera.speed * time.delta);
        }

        // Update the camera
        camera_set_view_pos(camera.id, camera.x, camera.y);
        camera_set_view_size(camera.id, camera.width, camera.height);
        camera_apply(camera.id);
    }
}

/// @desc Updates the camera with boundary checking.
function camera_update_bound()
{
    with (obj_game)
    {
        // Update the position
        if (camera.target >= 0)
        {
            camera.x = lerp(camera.x, camera.target.x - camera.width * 0.5, camera.speed * time.delta);
            camera.y = lerp(camera.y, camera.target.y - camera.height * 0.5, camera.speed * time.delta);
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

/// @desc Updates the camera for FPS game.
// Note: This function is not complete.
function camera_update_fps()
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
