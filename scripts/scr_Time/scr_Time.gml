/// @desc Game time class.
function GameTime() constructor
{
    // Time variables
    delta = 0;
    speed = 1;

    // Note: Do not use this variable since it is not updated
    fools = (current_month == 4 && current_day == 1);

    /// @desc Update the time.
    static update = function()
    {
        if (event_number != ev_step_begin) debug_event("GameTime: update() must be called in the Step Begin event.");
        delta = delta_time / 1000000 * speed;
    }
}

/// @desc Time class.
function Time() constructor
{
    
}
