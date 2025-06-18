self.update = function() {
    if (!window_mouse_lock()) {
        return;
    }
    
    if (self.target != noone) {
        self.yaw -= window_mouse_get_delta_x() * Input.sensitivity * Time.delta;
        self.pitch = clamp(pitch - window_mouse_get_delta_y() * Input.sensitivity * Time.delta, -89.99, 89.99);
        
        var _interp = self.interp * Time.delta;
        self.x = lerp(self.x, self.target.x, _interp);
        self.y = lerp(self.y, self.target.y, _interp);
        self.depth = lerp(self.depth, self.target.depth, _interp);
    }
    
    Camera.camera_update_3d(self);
}
