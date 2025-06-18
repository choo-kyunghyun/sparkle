new Camera();

/**
 * Camera class for managing cameras in the game.
 * @returns {Struct.Camera}
 */
function Camera() constructor {
    static inspector = {
        id: noone,
        camera: noone,
        x: 0,
        y: 0,
        depth: 0,
        width: 0,
        height: 0,
        fov: 0,
        znear: 0,
        zfar: 0,
        yaw: 0,
        pitch: 0,
        roll: 0,
        distance: 0,
        interp: 0,
        camera_speed: 0,
        bound: false,
        target: noone,
    };
    static upvector = {
        x: 0,
        y: 0,
        z: 1,
    };

    /**
     * Update the inspector with the current camera instance properties.
     * @returns {Undefined}
     * @param {Id.Instance} inst - The camera instance to inspect.
     */
    static update_inspector = function(_inst) {
        self.inspector.id = _inst.id;
        self.inspector.camera = _inst.camera;
        self.inspector.x = _inst.x;
        self.inspector.y = _inst.y;
        self.inspector.depth = _inst.depth;
        self.inspector.width = _inst.width;
        self.inspector.height = _inst.height;
        self.inspector.fov = _inst.fov;
        self.inspector.znear = _inst.znear;
        self.inspector.zfar = _inst.zfar;
        self.inspector.yaw = _inst.yaw;
        self.inspector.pitch = _inst.pitch;
        self.inspector.roll = _inst.roll;
        self.inspector.distance = _inst.distance;
        self.inspector.interp = _inst.interp;
        self.inspector.camera_speed = _inst.camera_speed;
        self.inspector.bound = _inst.bound;
        self.inspector.target = _inst.target;
    }

    /**
     * Update camera objects.
     * @returns {Undefined}
     */
    static update = function() {
        var _default_camera = noone;
        with (obj_camera) {
			if (self.default_camera) {
				view_camera[0] = self.camera;
                _default_camera = self;
			}
            if (self.bound) {
                var _size = Camera.size(self.width, self.height);
                self.x = clamp(self.x, 0, room_width);
                self.y = clamp(self.y, 0, room_height);
            }
            self.update();
        }
        if (_default_camera != noone) {
            self.update_inspector(_default_camera);
        }
    }

    /**
     * Calculate the size of the camera based on the window size.
     * @returns {Struct}
     * @param {Real} width - The desired width of the camera.
     * @param {Real} height - The desired height of the camera.
     */
    static size = function(_width, _height) {
        var _window_width = window_get_width();
        var _window_height = window_get_height();
        var _window_aspect = _window_width / _window_height;

        if (_window_aspect < 1) {
            _height = min(_window_height, _height);
            _width = _height * _window_aspect;
        } else {
            _width = min(_window_width, _width);
            _height = _width / _window_aspect;
        }

        _width = floor(_width);
        _height = floor(_height);

        return { width: _width, height: _height };
    }

    /**
     * Update the camera's position and size.
     * @returns {Undefined}
     * @param {Id.Instance} inst - The camera instance to update.
     */
    static camera_update = function(_inst) {
        with (_inst) {
            var _size = Camera.size(self.width, self.height);
            camera_set_view_size(self.camera, _size.width, _size.height);
            camera_set_view_pos(self.camera, self.x, self.y);
            camera_set_view_angle(self.camera, self.roll);
            camera_apply(self.camera);
        }
    }
    
    /**
     * Update the camera's 3D view based on its properties.
     * @returns {Undefined}
     * @param {Id.Instance} inst - The camera instance to update.
     */
    static camera_update_3d = function(_inst) {
        with (_inst) {
            // Target point the camera is looking at
            var _xto = self.x;
            var _yto = self.y;
            var _zto = self.depth;

            // Calculate camera's position (eye) based on target, distance, yaw, and pitch
            var _cos_yaw = dcos(-self.yaw);
            var _sin_yaw = dsin(-self.yaw);
            var _cos_pitch = dcos(-self.pitch);
            var _sin_pitch = dsin(-self.pitch);

            // Offset from target to eye
            var _offset_x = self.distance * _cos_yaw * _cos_pitch;
            var _offset_y = self.distance * _sin_yaw * _cos_pitch;
            var _offset_z = self.distance * _sin_pitch;
            
            var _xfrom = _xto - _offset_x;
            var _yfrom = _yto - _offset_y;
            var _zfrom = _zto - _offset_z;

            // Forward vector (from eye to target), normalized
            var _forward_x = _offset_x;
            var _forward_y = _offset_y;
            var _forward_z = _offset_z;

            if (self.distance == 0) { // Avoid division by zero if distance is 0
                // Default forward if eye and target are the same (e.g., looking along positive Z)
                _forward_x = 0; _forward_y = 0; _forward_z = 1; 
            } else {
                _forward_x /= self.distance;
                _forward_y /= self.distance;
                _forward_z /= self.distance;
            }

            // Temporary world up vector
            var _world_up_x = Camera.upvector.x;
            var _world_up_y = Camera.upvector.y;
            var _world_up_z = Camera.upvector.z;

            // Handle case where forward vector is (almost) parallel to world_up_ref
            // (e.g., looking straight up or down along the Z axis)
            if (abs(_forward_z) > 0.999) {
                _world_up_x = 0; // Use world Y-axis as temporary up
                _world_up_y = 1;
                _world_up_z = 0;
            }

            // Calculate camera's right vector: Right = normalize(cross(WorldUpRef, Forward))
            var _right_x = _world_up_y * _forward_z - _world_up_z * _forward_y;
            var _right_y = _world_up_z * _forward_x - _world_up_x * _forward_z;
            var _right_z = _world_up_x * _forward_y - _world_up_y * _forward_x;
            
            var _right_len = sqrt(sqr(_right_x) + sqr(_right_y) + sqr(_right_z));
            if (_right_len < 0.0001) { // Should be rare if world_up_ref adjustment is correct
                _right_x = 1; _right_y = 0; _right_z = 0; // Default right
            } else {
                _right_x /= _right_len;
                _right_y /= _right_len;
                _right_z /= _right_len;
            }

            // Calculate camera's up vector (before roll): Up_no_roll = normalize(cross(Forward, Right))
            // This vector is already normalized as Forward and Right are normalized and orthogonal.
            var _up_no_roll_x = _forward_y * _right_z - _forward_z * _right_y;
            var _up_no_roll_y = _forward_z * _right_x - _forward_x * _right_z;
            var _up_no_roll_z = _forward_x * _right_y - _forward_y * _right_x;

            // Apply roll to get the final up vector for matrix_build_lookat
            var _cos_roll = dcos(self.roll);
            var _sin_roll = dsin(self.roll);

            var _xup = _up_no_roll_x * _cos_roll + _right_x * _sin_roll;
            var _yup = _up_no_roll_y * _cos_roll + _right_y * _sin_roll;
            var _zup = _up_no_roll_z * _cos_roll + _right_z * _sin_roll;

            var _size = Camera.size(self.width, self.height);
            var _lookat_matrix = matrix_build_lookat(_xfrom, _yfrom, _zfrom, _xto, _yto, _zto, _xup, _yup, _zup);
            var _proj = matrix_build_projection_perspective_fov(self.fov, _size.width / _size.height, self.znear, self.zfar);
            
            camera_set_view_mat(self.camera, _lookat_matrix);
            camera_set_proj_mat(self.camera, _proj);
            camera_apply(self.camera);
        }
    }
}
