new Time();
new Timer().cancel();

/**
 * Time class for managing time-related variables.
 * @returns {Struct.Time}
 */
function Time() constructor {
    static mult = 1;
    static raw = 0;
    static delta = 0;

    /**
     * Updates the time variables based on the delta_time.
     * This function should be called every frame to ensure accurate timing.
     * Use Begin Step event to call this function.
     * @returns {Undefined}
     */
    static update = function() {
        self.raw = delta_time / 1000000;
        self.delta = self.raw * self.mult;
    }
}

/**
 * Timer class for managing timed events.
 * This class allows you to create timers that execute a callback function after a specified period.
 * @returns {Struct.Timer}
 * @param {Real} period - The time period in seconds after which the timer should elapse.
 * @param {Function} callback - The function to be executed when the timer elapses.
 * @param {Bool} loop - If true, the timer will reset and continue running after each callback execution; if false, it will stop after the first execution.
 */
function Timer() constructor {
    static timers = [];
    elapsed = 0;
    active = true;
    period = infinity;
    callback = noop;
    loop = false;

    /**
     * Updates the timer state.
     * This function should be called every frame to ensure the timer works correctly.
     * @returns {Undefined}
     */
    static update = function() {
        for (var _i = 0, _len = array_length(self.timers); _i < _len; _i++) {
            var _timer = self.timers[_i];
            if (_timer.active) {
                _timer.elapsed += Time.delta;
                if (_timer.elapsed >= _timer.period) {
                    _timer.elapsed -= _timer.period;
                    script_execute(_timer.callback);
                    if (!_timer.loop) {
                        _timer.active = false;
                    }
                }
            } else {
                array_delete(self.timers, _i, 1);
                _i--;
                _len--;
                delete _timer;
            }
        }
    }

    /**
     * Adds a new timer to the global timer array.
     * @returns {Struct.Timer}
     * @param {Real} period - The time period in seconds after which the timer should elapse.
     * @param {Function} callback - The function to be executed when the timer elapses.
     * @param {Bool} loop - If true, the timer will reset and continue running after each callback execution; if false, it will stop after the first execution.
     */
    static add = function(_period, _callback, _loop = false) {
        var _timer = new Timer();
        _timer.period = _period;
        _timer.callback = _callback;
        _timer.loop = _loop;
        array_push(self.timers, _timer);
        return _timer;
    }

    /**
     * Cancels the timer, preventing it from executing its callback.
     * @returns {Struct.Timer}
     */
    static cancel = function() {
        self.active = false;
        return self;
    }
}
