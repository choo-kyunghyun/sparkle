self.update = function() {
    var _input_x = Input.check("right") - Input.check("left");
    var _input_y = Input.check("down") - Input.check("up");
    var _input_z = Input.check("sneak") - Input.check("jump");
    var _hold = mouse_check_button(mb_left);
    var _dx = window_mouse_get_delta_x();
    var _dy = window_mouse_get_delta_y();
    var _dz = mouse_wheel_down() - mouse_wheel_up();

    self.yaw = 90;
    self.pitch = -89.99;
    
    if (self.target == noone) {
        var _speed = self.camera_speed * Time.delta;
        self.x += _hold ? -_dx * _speed : _input_x * _speed;
        self.y += _hold ? -_dy * _speed : _input_y * _speed;
        self.depth += _input_z * _speed;
    } else {
        var _interp = self.interp * Time.delta;
        self.x = lerp(self.x, self.target.x, _interp);
        self.y = lerp(self.y, self.target.y, _interp);
        self.depth = lerp(self.depth, self.target.depth, _interp);
    }
    self.distance = max(self.distance + _dz * 32 * self.camera_speed * Time.delta, 16);

    Camera.camera_update_3d(self);
}
