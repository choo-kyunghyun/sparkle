update = function() {
    if (self.target != noone) {
        var _interp = self.interp * Time.delta;
        self.x = lerp(self.x, self.target.x, _interp);
        self.y = lerp(self.y, self.target.y, _interp);
    }

    Camera.camera_update(self);
}
