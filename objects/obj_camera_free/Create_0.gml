self.update = function() {
    if (!window_mouse_lock()) {
        return;
    }
    var _input_x = Input.check("right") - Input.check("left");
    var _input_y = Input.check("down") - Input.check("up");
    var _input_z = Input.check("sneak") - Input.check("jump");
    var _input_r = Input.check("lean_left") - Input.check("lean_right");

    var _speed = self.camera_speed * Time.delta;
    self.yaw -= window_mouse_get_delta_x() * Input.sensitivity * Time.delta;
    self.pitch = clamp(pitch - window_mouse_get_delta_y() * Input.sensitivity * Time.delta, -89.99, 89.99);
    self.roll += _input_r * _speed;
    
    self.x += (_input_x * dcos(-self.yaw + 90) - _input_y * dcos(-self.yaw)) * _speed;
    self.y += (_input_x * dsin(-self.yaw + 90) - _input_y * dsin(-self.yaw)) * _speed;
    self.depth += _input_z * _speed;
    Camera.camera_update_3d(self);
}
