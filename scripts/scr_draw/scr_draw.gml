/// @desc Draw a string including tags
function draw_text_format(_x, _y, _string)
{
    // Save the current font
    var _font = draw_get_font();

    // Save the current color and alpha
    var _color = draw_get_color();
    var _alpha = draw_get_alpha();

    // Save the current alignment
    var _halign = draw_get_halign();
    var _valign = draw_get_valign();

    // Store the current position
    var _x_pos = _x;
    var _y_pos = _y;

    // Replace < with a special character
    _string = string_replace_all(_string, "\\<", "\u9647");

    // Split the string into tokens
    var _tokens = string_split(_string, "<");

    // Restore the < character
    for (var _i = 0; _i < array_length(_tokens); _i++)
    {
        _tokens[_i] = string_replace_all(_tokens[_i], "\u9647", "<");
    }

    // Draw each token
    for (var _i = 0; _i < array_length(_tokens); _i++)
    {
        // Check the number of newlines
        var _newlines = string_count(_tokens[_i], "\n") + string_count(_tokens[_i], "\r");

        // Get the tag
        var _substr = string_split(_tokens[_i], ">", false, 1);

        // Set the color
        if (string_starts_with(_substr[0], "c="))
        {
            // Lowercase the string
            _substr[0] = string_lower(_substr[0]);

            // Split #rrggbb into RGB
            var _red = real("0x" + string_copy(_substr[0], 4, 2));
            var _green = real("0x" + string_copy(_substr[0], 6, 2));
            var _blue = real("0x" + string_copy(_substr[0], 8, 2));

            // Set the color
            draw_set_color(make_color_rgb(_red, _green, _blue));
        }
        // Set the alpha
        else if (string_starts_with(_substr[0], "a="))
        {
            draw_set_alpha(real(string_copy(_substr[0], 3, string_length(_substr[0]))));
        }
        // Set the font
        else if (string_starts_with(_substr[0], "f="))
        {
            draw_set_font(asset_get_index(string_copy(_substr[0], 3, string_length(_substr[0]))));
        }
        // Set the horizontal alignment
        else if (string_starts_with(_substr[0], "halign="))
        {
            switch(string_lower(string_copy(_substr[0], 8, string_length(_substr[0]))))
            {
                case "fa_left":   draw_set_halign(fa_left);   break;
                case "fa_center": draw_set_halign(fa_center); break;
                case "fa_right":  draw_set_halign(fa_right);  break;
            }
        }
        // Set the vertical alignment
        else if (string_starts_with(_substr[0], "valign="))
        {
            switch (string_lower(string_copy(_substr[0], 8, string_length(_substr[0]))))
            {
                case "fa_top":    draw_set_valign(fa_top);    break;
                case "fa_middle": draw_set_valign(fa_middle); break;
                case "fa_bottom": draw_set_valign(fa_bottom); break;
            }
        }
        // No tag
        else
        {
            draw_text(_x_pos, _y_pos, _tokens[_i]);
            if (_newlines > 0)
            {
                _x_pos = _x;
                _y_pos += string_height(_tokens[_i]) * _newlines;
            }
            else
            {
                _x_pos += string_width(_tokens[_i]);
            }
            continue;
        }

        // Draw the token
        draw_text(_x_pos, _y_pos, _substr[1]);
        if (_newlines > 0)
        {
            _x_pos = _x;
            _y_pos += string_height(_substr[1]) * _newlines;
        }
        else
        {
            _x_pos += string_width(_substr[1]);
        }
    }

    // Restore the font
    draw_set_font(_font);

    // Restore the color and alpha
    draw_set_color(_color);
    draw_set_alpha(_alpha);

    // Restore the alignment
    draw_set_halign(_halign);
    draw_set_valign(_valign);

    // Return the width of the string
    return _x_pos - _x;
}
