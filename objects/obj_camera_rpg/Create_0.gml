update = function() {
    if (self.target != noone) {
        var _interp = self.interp * Time.delta;
        self.x = lerp(self.x, self.target.x, _interp);
        self.y = lerp(self.y, self.target.y, _interp);
        self.depth = lerp(self.depth, self.target.depth, _interp);
    }
    
    // TODO: Screenshake

    Camera.camera_update_3d(self);
}
