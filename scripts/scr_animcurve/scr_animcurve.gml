new Animcurve();

function Animcurve() constructor {
    static evaluate = function(_curve_struct_or_id, _channel_name_or_index, _posx) {
        var _channel_struct = animcurve_get_channel(_curve_struct_or_id, _channel_name_or_index);
        return animcurve_channel_evaluate(_channel_struct, _posx);
    }
}
