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
function Camera(_x = 0, _y = 0, _z = 0, _width = room_width, _height = room_height, _target = noone, _dist = 256, _speed = 5, _yaw = 270, _pitch = 45, _roll = 0, _fov = 60, _znear = 1, _zfar = 32000) constructor
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
    script = update_default;
    custom = -1;

    // Camera's position cannot be out of bounds by default
    bound = false;
    
    /// @desc Destroys the camera.
    static destroy = function()
    {
        // Unassign the update script
        script = -1;
        custom = -1;

        // Destroy the camera
        camera_destroy(id);
    };

    /// @desc Updates the camera.
    static update = function()
    {
        if (event_number != ev_step_end) debug_event("Camera: Update event should be in the Step End event.");
        if (script != -1) script();
        if (custom != -1) custom();
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

    /// @desc Updates the camera
    static update_default = function()
    {
        // Delta time
        var _speed = speed * GAME.time.delta;

        // Update the position
        if (target != noone)
        {
            x = lerp(x, target.x - width * 0.5, _speed);
            y = lerp(y, target.y - height * 0.5, _speed);
        }

        // Update the camera
        camera_set_view_pos(id, x, y);
        camera_set_view_size(id, width, height);
        camera_apply(id);
    };

    /// @desc Updates the camera with boundary checking.
    // TODO: Remove this method and use bound property instead.
    static update_bound = function()
    {
        // Delta time
        var _speed = speed * GAME.time.delta;

        // Update the position
        if (target != noone)
        {
            x = lerp(x, target.x - width * 0.5, _speed);
            y = lerp(y, target.y - height * 0.5, _speed);
        }

        // Check the bounds
        x = clamp(x, 0, room_width - width);
        y = clamp(y, 0, room_height - height);

        // Update the camera
        camera_set_view_pos(id, x, y);
        camera_set_view_size(id, width, height);
        camera_apply(id);
    };

    /// @desc Updates the camera for an RPG game.
    static update_rpg = function()
    {
        // Camera speed
        var _speed = speed * GAME.time.delta;

        // Calculate the distances of the camera from the target
        var _dist_x = dist * dcos(-yaw) * dcos(-pitch);
        var _dist_y = dist * dsin(-yaw) * dcos(-pitch);
        var _dist_z = dist * dsin(-pitch);
        
        // Update the position
        if (target != noone)
        {
            x = lerp(x, target.x + _dist_x, _speed);
            y = lerp(y, target.y + _dist_y, _speed);
            z = lerp(z, target.depth + _dist_z, _speed);
        }

        // Update the camera
        camera_set_view_mat(id, matrix_build_lookat(x, y, z, x - _dist_x, y - _dist_y, z - _dist_z, dsin(roll), 0, dcos(roll)));
        camera_set_proj_mat(id, matrix_build_projection_perspective_fov(fov, width / height, znear, zfar));
        camera_apply(id);
    };

    /// @desc Updates the camera for an FPS game.
    // Note: This method is not working properly.
    static update_fps = function()
    {
        // Calculate the distances of the camera from the target
        var _dist_x = dist * dcos(-yaw) * dcos(-pitch);
        var _dist_y = dist * dsin(-yaw) * dcos(-pitch);
        var _dist_z = dist * dsin(-pitch);
        
        // Update the position
        if (target != noone)
        {
            x = lerp(x, target.x + _dist_x, speed * GAME.time.delta);
            y = lerp(y, target.y + _dist_y, speed * GAME.time.delta);
            z = lerp(z, target.depth + _dist_z, speed * GAME.time.delta);
        }

        // Update the camera
        camera_set_view_mat(id, matrix_build_lookat(x, y, z, x - _dist_x, y - _dist_y, z - _dist_z, dsin(roll), 0, dcos(roll)));
        camera_set_proj_mat(id, matrix_build_projection_perspective_fov(fov, width / height, znear, zfar));
        camera_apply(id);
    };
}
