function event_spark_time_alt() {
    static original = 1;
    static active = false;
    
    if (keyboard_check(ord("Q"))) {
        if (!active) {
            original = TIME.mult;
            active = true;
        }
        TIME.mult = 0.25;
    } else {
        TIME.mult = original;
    }
}
