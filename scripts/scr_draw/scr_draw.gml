/// @desc Apply a format tag
/// @param {String} _tag The tag to apply
/// @return {Bool} Returns true if the tag is valid and false otherwise
function draw_apply_format(_tag)
{
    // Get the position of the equal sign
    var _split_pos = string_pos("=", _tag);

    // Check if the tag is valid
    if (_split_pos == 0) return false;

    // Get the key and value
    var _key = string_copy(_tag, 1, _split_pos - 1);
    var _value = string_copy(_tag, _split_pos + 1, string_length(_tag) - _split_pos);

    // Set the color
    if (_key == "color")
    {
        // Hexadecimal values using the # symbol
        if (string_char_at(_value, 1) == "#")
        {
            // Check if the color is in #RRGGBB format
            if (string_length(_value) != 7) return false;

            // Split #RRGGBB into RGB
            var _red = real("0x" + string_copy(_value, 2, 2));
            var _green = real("0x" + string_copy(_value, 4, 2));
            var _blue = real("0x" + string_copy(_value, 6, 2));

            // Set the color
            draw_set_color(make_color_rgb(_red, _green, _blue));
        }
        // Hexadeciaml values using the $ symbol
        else if (string_char_at(_value, 1) == "$")
        {
            // Check if the color is in $BBGGRR format
            if (string_length(_value) == 7)
            {
                // Split $BBGGRR into RGB
                var _blue = real("0x" + string_copy(_value, 2, 2));
                var _green = real("0x" + string_copy(_value, 4, 2));
                var _red = real("0x" + string_copy(_value, 6, 2));

                // Set the color
                draw_set_color(make_color_rgb(_red, _green, _blue));
            }
            // Check if the color is in $AABBGGRR format
            else if (string_length(_value) == 9)
            {
                // Split $AABBGGRR into ARGB
                var _alpha = real("0x" + string_copy(_value, 2, 2));
                var _blue = real("0x" + string_copy(_value, 4, 2));
                var _green = real("0x" + string_copy(_value, 6, 2));
                var _red = real("0x" + string_copy(_value, 8, 2));

                // Set the color
                draw_set_color(make_color_rgb(_red, _green, _blue));

                // Set the alpha
                draw_set_alpha(_alpha / 255);
            }
            else
            {
                return false;
            }
        }
        // Color name
        else
        {
            // Set the color
            switch (_value)
            {
                case "c_aqua": draw_set_color(c_aqua); break;
                case "c_black": draw_set_color(c_black); break;
                case "c_blue": draw_set_color(c_blue); break;
                case "c_dkgray": draw_set_color(c_dkgray); break;
                case "c_dkgrey": draw_set_color(c_dkgrey); break;
                case "c_fuchsia": draw_set_color(c_fuchsia); break;
                case "c_gray": draw_set_color(c_gray); break;
                case "c_grey": draw_set_color(c_grey); break;
                case "c_green": draw_set_color(c_green); break;
                case "c_lime": draw_set_color(c_lime); break;
                case "c_ltgray": draw_set_color(c_ltgray); break;
                case "c_ltgrey": draw_set_color(c_ltgrey); break;
                case "c_maroon": draw_set_color(c_maroon); break;
                case "c_navy": draw_set_color(c_navy); break;
                case "c_olive": draw_set_color(c_olive); break;
                case "c_orange": draw_set_color(c_orange); break;
                case "c_purple": draw_set_color(c_purple); break;
                case "c_red": draw_set_color(c_red); break;
                case "c_silver": draw_set_color(c_silver); break;
                case "c_teal": draw_set_color(c_teal); break;
                case "c_white": draw_set_color(c_white); break;
                case "c_yellow": draw_set_color(c_yellow); break;
                default: return false;
            }
        }
    }
    // Set the alpha
    else if (_key == "alpha")
    {
        draw_set_alpha(real(_value));
    }
    // Set the font
    else if (_key == "font")
    {
        // Get the font index
        var _font = asset_get_index(_value);

        // Check if the font exists
        if (_font == -1) return false;

        // Set the font
        draw_set_font(_font);
    }
    // Set the horizontal alignment
    else if (_key == "halign")
    {
        switch(_value)
        {
            case "fa_left": draw_set_halign(fa_left); break;
            case "fa_center": draw_set_halign(fa_center); break;
            case "fa_right": draw_set_halign(fa_right); break;
            default: return false;
        }
    }
    // Set the vertical alignment
    else if (_key == "valign")
    {
        switch (_value)
        {
            case "fa_top": draw_set_valign(fa_top); break;
            case "fa_middle": draw_set_valign(fa_middle); break;
            case "fa_bottom": draw_set_valign(fa_bottom); break;
            default: return false;
        }
    }
    // No tag
    else
    {
        return false;
    }
    return true;
}

/// @desc Draw a string including tags
/// @param _x The x-coordinate
/// @param _y The y-coordinate
/// @param _string The string to draw
function draw_text_format(_x, _y, _string)
{
    // Save the current font, color, alpha, and alignment
    var _font = draw_get_font();
    var _color = draw_get_color();
    var _alpha = draw_get_alpha();
    var _halign = draw_get_halign();
    var _valign = draw_get_valign();

    // Store the current position
    var _x_pos = _x;
    var _y_pos = _y;

    // Replace \< with a special character
    _string = string_replace_all(_string, "\\<", "\u9647");

    // Replace \n with a special character
    _string = string_replace_all(_string, "\n", "<\n");

    // Split the string into tokens
    var _tokens = string_split(_string, "<");

    // Draw each token
    for (var _i = 0; _i < array_length(_tokens); _i++)
    {
        // Restore the < character
        _tokens[_i] = string_replace_all(_tokens[_i], "\u9647", "<");

        // Get the tag
        var _substr = string_split(_tokens[_i], ">", false, 1);

        // Apply the format tag
        if (array_length(_substr) == 1 || !draw_apply_format(_substr[0]))
        {
            _substr[1] = _tokens[_i];
        }

        // Change the position if a newline is found
        if (string_starts_with(_substr[1], "\n"))
        {
            _substr[1] = string_delete(_substr[1], 1, 1);
            _x_pos = _x;
            _y_pos += string_height(_substr[1] == "" ? "M" : _substr[1]);
        }

        // Draw the token
        draw_text(_x_pos, _y_pos, _substr[1]);

        // Update the position
        _x_pos += string_width(_substr[1]);
    }

    // Restore the font, color, alpha, and alignment
    draw_set_font(_font);
    draw_set_color(_color);
    draw_set_alpha(_alpha);
    draw_set_halign(_halign);
    draw_set_valign(_valign);
}

/// @desc Draw a string including tags
/// @param _x The x-coordinate
/// @param _y The y-coordinate
/// @param _string The string to draw
/// @param _sep The separation between lines
/// @param _w The maximum width of the text
function draw_text_ext_format(_x, _y, _string, _sep, _w)
{
    // Save the current font, color, alpha, and alignment
    var _font = draw_get_font();
    var _color = draw_get_color();
    var _alpha = draw_get_alpha();
    var _halign = draw_get_halign();
    var _valign = draw_get_valign();

    // Store the current position
    var _x_pos = _x;
    var _y_pos = _y;

    // Replace \< with a special character
    _string = string_replace_all(_string, "\\<", "\u9647");

    // Add a line break after each newline character
    _string = string_replace_all(_string, "\n", "<\n");

    // Split the string into tokens
    var _tokens = string_split(_string, "<");

    // Draw each token
    for (var _i = 0; _i < array_length(_tokens); _i++)
    {
        // Restore the < character
        _tokens[_i] = string_replace_all(_tokens[_i], "\u9647", "<");

        // Get the tag
        var _substr = string_split(_tokens[_i], ">", false, 1);

        // Apply the format tag
        if (array_length(_substr) == 1 || !draw_apply_format(_substr[0]))
        {
            _substr[1] = _tokens[_i];
        }

        // If _sep is -1, use default value
        var _current_sep = _sep == -1 ? string_height("M") : _sep;

        // Change newline character to a special character
        _substr[1] = string_replace_all(_substr[1], "\n", "\u9647");

        // Split the string into words
        var _words = string_split(_substr[1], " ");

        // Draw each word
        for (var _j = 0; _j < array_length(_words); _j++)
        {
            // Get the width of the word
            var _width = string_width(_words[_j]);

            // Check if the word contains a newline character
            if (string_starts_with(_words[_j], "\u9647"))
            {
                _x_pos = _x;
                _y_pos += _current_sep;
                _words[_j] = string_delete(_words[_j], 1, 1);
            }
            // Check if the word exceeds the width
            else if ((_w > 0 && _x_pos + _width > _x + _w))
            {
                _x_pos = _x;
                _y_pos += _current_sep;
            }

            // Draw the word
            draw_text(_x_pos, _y_pos, _words[_j]);

            // Update the position
            _x_pos += _width;

            // Draw a space
            if (_j < array_length(_words) - 1)
            {
                _x_pos += string_width(" ");
            }
        }
    }

    // Restore the font, color, alpha, and alignment
    draw_set_font(_font);
    draw_set_color(_color);
    draw_set_alpha(_alpha);
    draw_set_halign(_halign);
    draw_set_valign(_valign);
}
