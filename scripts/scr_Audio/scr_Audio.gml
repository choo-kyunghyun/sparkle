
audio_falloff_set_model(audio_falloff_exponent_distance_clamped);
// audio_falloff_set_model(audio_falloff_exponent_distance_scaled);
// audio_listener_orientation(0, 0, 1, 0, -1, 0);

/**
 * Audio System
 * @returns {Struct.Audio}
 */
function Audio() constructor {
    // Audio group
    //     Don't forget to load audio groups
    // Volume and mute
    // Listener (audio_listener_position, audio_listener_velocity, audio_listener_orientation)
    // Emitter
    // Sound effects
    // Music

    static play = function(_index, _loop) {
        if (!audio_exists(_index)) {
            return -1;
        }
        // audio_play_sound(index, priority, loop, [gain], [offset], [pitch], [listener_mask]);
        return audio_play_sound(_index, 1, _loop);
    }
}
