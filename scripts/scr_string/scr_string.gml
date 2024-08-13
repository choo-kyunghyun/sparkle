/// @desc String is a class that allows you to draw strings with tags. You can use the following tags: color, alpha, font, halign, and valign. The color tag can be in #RRGGBB, $BBGGRR, or color name format. The alpha tag can be a value between 0 and 1. The font tag can be the name of the font. The halign tag can be fa_left, fa_center, or fa_right. The valign tag can be fa_top, fa_middle, or fa_bottom. The string can contain the following tags: <color=...>, <alpha=...>, <font=...>, <halign=...>, <valign=...>, and \< to escape the < character. The string can also contain the newline character \n. The draw function can only be called in the Draw Event.
function String(_str = "") constructor
{
    // The string
    str = _str;

    // Tokenized string
    tokens = [];

    // Hardcoded tag values
    tags =
    {
        string: 0,
        color: 1,
        alpha: 2,
        font: 3,
        halign: 4,
        valign: 5
    };

    // Tokenize the string
    tokenize();

    /// @desc toString function.
    /// @return {String} The string.
    toString = function()
    {
        return str;
    }

    /// @desc Tokenize the string.
    static tokenize = function()
    {
        // Empty the tokens array
        tokens = [];

        // Replace \< with a special character
        str = string_replace_all(str, "\\<", "\u9647");

        // Wrap the newline character
        str = string_replace_all(str, "\n", "<\n<");

        // Split the string into tokens
        var _tokens = string_split(str, "<");

        // Split the string into tokens
        for (var _i = 0; _i < array_length(_tokens); _i++)
        {
            // Restore the < character
            _tokens[_i] = string_replace_all(_tokens[_i], "\u9647", "<");

            // Handle the newline character
            if (_tokens[_i] == "\n")
            {
                array_push(tokens, { type: tags.string, value: "\n" });
                continue;
            }

            // Get the tag
            var _substr = string_split(_tokens[_i], ">", false, 1);

            // Get the position of the equal sign
            var _split_pos = string_pos("=", _substr[0]);

            // Check if the tag is valid
            if (array_length(_substr) == 1 || _split_pos == 0)
            {
                array_push(tokens, { type: tags.string, value: _tokens[_i] });
                continue;
            }

            // Split the key and value
            var _key = string_copy(_substr[0], 1, _split_pos - 1);
            var _value = string_copy(_substr[0], _split_pos + 1, string_length(_substr[0]) - _split_pos);

            // Determine the key
            switch (_key)
            {
                case "color": _key = tags.color; break;
                case "alpha": _key = tags.alpha; break;
                case "font": _key = tags.font; break;
                case "halign": _key = tags.halign; break;
                case "valign": _key = tags.valign; break;
                default: _key = tags.string; break;
            }

            // Convert the value
            if (_key == tags.color)
            {
                // Hexadecimal values using the # symbol
                if (string_char_at(_value, 1) == "#")
                {
                    // Check if the color is in #RRGGBB format
                    if (string_length(_value) == 7)
                    {
                        // Split #RRGGBB into RGB
                        var _red = real("0x" + string_copy(_value, 2, 2));
                        var _green = real("0x" + string_copy(_value, 4, 2));
                        var _blue = real("0x" + string_copy(_value, 6, 2));

                        // Change the value
                        _value = make_color_rgb(_red, _green, _blue);
                    }
                    else
                    {
                        // Invalid format
                        _key = tags.string;
                    }
                }
                // Hexadecimal values using the $ symbol
                else if (string_char_at(_value, 1) == "$")
                {
                    // Check if the color is in $BBGGRR format
                    if (string_length(_value) == 7)
                    {
                        // Split $BBGGRR into RGB
                        var _blue = real("0x" + string_copy(_value, 2, 2));
                        var _green = real("0x" + string_copy(_value, 4, 2));
                        var _red = real("0x" + string_copy(_value, 6, 2));

                        // Change the value
                        _value = make_color_rgb(_red, _green, _blue);
                    }
                    else
                    {
                        // Invalid format
                        _key = tags.string;
                    }
                }
                // Color name
                else
                {
                    switch (_value)
                    {
                        case "c_aqua": _value = c_aqua; break;
                        case "c_black": _value = c_black; break;
                        case "c_blue": _value = c_blue; break;
                        case "c_dkgray": _value = c_dkgray; break;
                        case "c_dkgrey": _value = c_dkgrey; break;
                        case "c_fuchsia": _value = c_fuchsia; break;
                        case "c_gray": _value = c_gray; break;
                        case "c_grey": _value = c_grey; break;
                        case "c_green": _value = c_green; break;
                        case "c_lime": _value = c_lime; break;
                        case "c_ltgray": _value = c_ltgray; break;
                        case "c_ltgrey": _value = c_ltgrey; break;
                        case "c_maroon": _value = c_maroon; break;
                        case "c_navy": _value = c_navy; break;
                        case "c_olive": _value = c_olive; break;
                        case "c_orange": _value = c_orange; break;
                        case "c_purple": _value = c_purple; break;
                        case "c_red": _value = c_red; break;
                        case "c_silver": _value = c_silver; break;
                        case "c_teal": _value = c_teal; break;
                        case "c_white": _value = c_white; break;
                        case "c_yellow": _value = c_yellow; break;
                        default: _key = tags.string; break;
                    }
                }
            }
            else if (_key == tags.alpha)
            {
                _value = real(_value);
            }
            else if (_key == tags.font)
            {
                // Get the font index
                var _font = asset_get_index(_value);

                // Check if the font exists
                if (_font == -1)
                {
                    _key = tags.string;
                }
                else
                {
                    _value = _font;
                }
            }
            else if (_key == tags.halign)
            {
                switch (_value)
                {
                    case "fa_left": _value = fa_left; break;
                    case "fa_center": _value = fa_center; break;
                    case "fa_right": _value = fa_right; break;
                    default: _key = tags.string; break;
                }
            }
            else if (_key == tags.valign)
            {
                switch (_value)
                {
                    case "fa_top": _value = fa_top; break;
                    case "fa_middle": _value = fa_middle; break;
                    case "fa_bottom": _value = fa_bottom; break;
                    default: _key = tags.string; break;
                }
            }

            // If the key is a string, save the token
            if (_key == tags.string)
            {
                array_push(tokens, { type: tags.string, value: _tokens[_i] });
                continue;
            }

            // Save the key-value pair
            array_push(tokens, { type: _key, value: _value });

            // Save the string
            array_push(tokens, { type: tags.string, value: _substr[1] });
        }
    }

    /// @desc Set the string.
    /// @param {String} _str The new string.
    static set = function(_str)
    {
        if (!is_string(_str)) debug_event("String: Invalid string.");
        str = _str;
        tokenize();
    }

    /// @desc Get the string.
    /// @param {Bool} _tokenize Use the tokenized string or not.
    /// @return {String} The string.
    static get = function(_tokenize = true)
    {
        if (!_tokenize) return str;
        var _str = "";
        for (var _i = 0; _i < array_length(tokens); _i++)
        {
            if (tokens[_i].type == tags.string) _str += tokens[_i].value;
        }
        return _str;
    }

    /// @desc Apply a tag while drawing the string.
    /// @param {Struct} _tag The tag to apply.
    static apply_tag = function(_tag)
    {
        switch (_tag.type)
        {
            case tags.color: draw_set_color(_tag.value); break;
            case tags.alpha: draw_set_alpha(_tag.value); break;
            case tags.font: draw_set_font(_tag.value); break;
            case tags.halign: draw_set_halign(_tag.value); break;
            case tags.valign: draw_set_valign(_tag.value); break;
            default: debug_event("String: Invalid tag type.");
        }
    }

    /// @desc Draw the tokenized string.
    /// @param {Real} _x The x-coordinate.
    /// @param {Real} _y The y-coordinate.
    /// @param {Bool} _tokenize Use the tokenized string or not.
    static draw = function(_x, _y, _tokenize = true)
    {
        // Check if the draw function is called in the Draw Event
        if (event_type != ev_draw) debug_event("String: draw function can only be called in the Draw Event.");

        // Use str if _tokenize is false
        if (!_tokenize)
        {
            // Draw the string
            draw_text(_x, _y, str);
            return;
        }

        // Save the current font, color, alpha, and alignment
        var _font = draw_get_font();
        var _color = draw_get_color();
        var _alpha = draw_get_alpha();
        var _halign = draw_get_halign();
        var _valign = draw_get_valign();

        // Store the current position
        var _x_pos = _x;
        var _y_pos = _y;

        // Store the heighest height
        var _max_height = 0;

        // Draw each token
        for (var _i = 0; _i < array_length(tokens); _i++)
        {
            // Get the token
            var _token = tokens[_i];

            // Apply the tag
            if (_token.type != tags.string)
            {
                apply_tag(_token);
            }
            else
            {
                // Store the heighest height
                _max_height = max(_max_height, string_height("M"));

                // Change the position if a newline is found
                if (_token.value == "\n")
                {
                    _x_pos = _x;
                    _y_pos += _max_height;
                    _max_height = 0;
                }
                else
                {
                    // Draw the token
                    draw_text(_x_pos, _y_pos, _token.value);

                    // Update the position
                    _x_pos += string_width(_token.value);
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

    /// @desc Draw the tokenized string with extended parameters.
    /// @param {Real} _x The x-coordinate.
    /// @param {Real} _y The y-coordinate.
    /// @param {Real} _w The maximum width.
    /// @param {Real} _sep The separation between lines.
    /// @param {Bool} _tokenize Use the tokenized string or not.
    static draw_ext = function(_x, _y, _w, _sep, _tokenize = true)
    {
        // Check if the draw function is called in the Draw Event
        if (event_type != ev_draw) debug_event("String: draw function can only be called in the Draw Event.");

        // Use str if _tokenize is false
        if (!_tokenize)
        {
            // Draw the string
            draw_text_ext(_x, _y, str, _sep, _w);
            return;
        }

        // Save the current font, color, alpha, and alignment
        var _font = draw_get_font();
        var _color = draw_get_color();
        var _alpha = draw_get_alpha();
        var _halign = draw_get_halign();
        var _valign = draw_get_valign();

        // Store the current position
        var _x_pos = _x;
        var _y_pos = _y;

        // Store the heighest height
        var _max_height = 0;

        // Draw each token
        for (var _i = 0; _i < array_length(tokens); _i++)
        {
            // Get the token
            var _token = tokens[_i];

            // Apply the tag
            if (_token.type != tags.string)
            {
                apply_tag(_token);
            }
            else
            {
                // Store the heighest height
                _max_height = _sep == -1 ? max(_max_height, string_height("M")) : _sep;

                // Change the position if a newline is found
                if (_token.value == "\n")
                {
                    _x_pos = _x;
                    _y_pos += _max_height;
                    _max_height = 0;
                }
                else
                {
                    // Split the string into words
                    var _words = string_split(_token.value, " ");

                    // Draw each word
                    for (var _j = 0; _j < array_length(_words); _j++)
                    {
                        // Get the width of the word
                        var _width = string_width(_words[_j]);

                        // Check if the word exceeds the width
                        if ((_w > 0 && _x_pos + _width > _x + _w))
                        {
                            _x_pos = _x;
                            _y_pos += _max_height;
                            _max_height = 0;
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
            }
        }

        // Restore the font, color, alpha, and alignment
        draw_set_font(_font);
        draw_set_color(_color);
        draw_set_alpha(_alpha);
        draw_set_halign(_halign);
        draw_set_valign(_valign);
    }

    /// @desc Get the width of the string.
    /// @param {Bool} _tokenize Use the tokenized string or not.
    /// @return {Real} The width of the string.
    /// @pure
    static width = function(_tokenize = true)
    {
        // Use str if _tokenize is false
        if (!_tokenize)
        {
            // Return the width of the string
            return string_width(str);
        }

        // Store the font
        var _font = draw_get_font();

        // Store the each line width
        var _width = [ 0 ];

        // Check each token
        for (var _i = 0; _i < array_length(tokens); _i++)
        {
            // Get the token
            var _token = tokens[_i];

            // Check if the token is a string
            if (_token.type == tags.string)
            {
                // Check if the token is a newline
                if (_token.value == "\n")
                {
                    // Add a new line
                    array_push(_width, 0);
                }
                else
                {
                    // Get the width of the token
                    var _token_width = string_width(_token.value);

                    // Update the width
                    _width[array_length(_width) - 1] += _token_width;
                }
            }
            // Check if the token is a font
            else if (_token.type == tags.font)
            {
                // Set the font
                draw_set_font(_token.value);
            }
        }

        // Restore the font
        draw_set_font(_font);

        // Sort the array
        array_sort(_width, false);

        // Return the largest width
        return _width[0];
    }

    /// @desc Get the height of the string.
    /// @param {Bool} _tokenize Use the tokenized string or not.
    /// @return {Real} The height of the string.
    /// @pure
    static height = function(_tokenize = true)
    {
        // Use str if _tokenize is false
        if (!_tokenize)
        {
            // Return the height of the string
            return string_height(str);
        }
        
        // Store the font
        var _font = draw_get_font();

        // Store the height
        var _height = 0;

        // Store the heighest height
        var _max_height = 0;

        // Check each token
        for (var _i = 0; _i < array_length(tokens); _i++)
        {
            // Get the token
            var _token = tokens[_i];

            // Check if the token is a string
            if (_token.type == tags.string)
            {
                // Check if the token is a newline
                if (_token.value == "\n")
                {
                    // Add heighest height to the total height
                    _height += _max_height;

                    // Reset the heighest height
                    _max_height = 0;
                }
                else
                {
                    // Get the height of the token
                    var _token_height = string_height(_token.value);

                    // Update the heighest height
                    _max_height = max(_max_height, _token_height);
                }
            }
            // Check if the token is a font
            else if (_token.type == tags.font)
            {
                // Set the font
                draw_set_font(_token.value);
            }
        }

        // Restore the font
        draw_set_font(_font);

        // Return the heighest height
        return _height;
    }

    /// @desc Get the width of the string with a maximum width.
    /// @param {Real} _w The maximum width.
    /// @param {Real} _sep The separation between lines.
    /// @param {Bool} _tokenize Use the tokenized string or not.
    /// @return {Real} The width of the string.
    /// @pure
    static width_ext = function(_w, _sep, _tokenize)
    {
        // Use str if _tokenize is false
        if (!_tokenize)
        {
            // Return the width of the string
            return string_width_ext(str, _w, _sep);
        }

        // Store the font
        var _font = draw_get_font();

        // Store the each line width
        var _width = [ 0 ];

        // Store the heighest height
        var _max_height = 0;

        // Check each token
        for (var _i = 0; _i < array_length(tokens); _i++)
        {
            // Get the token
            var _token = tokens[_i];

            // Check if the token is a string
            if (_token.type == tags.string)
            {
                // Check if the token is a newline
                if (_token.value == "\n")
                {
                    // Add a new line
                    array_push(_width, 0);
                }
                else
                {
                    // Split the string into words
                    var _words = string_split(_token.value, " ");

                    // Check each word
                    for (var _j = 0; _j < array_length(_words); _j++)
                    {
                        // Get the width of the word
                        var _word_width = string_width(_words[_j]);

                        // Check if the word exceeds the width
                        if ((_w > 0 && _width[array_length(_width) - 1] + _word_width > _w))
                        {
                            // Add a new line
                            array_push(_width, 0);
                        }

                        // Update the width
                        _width[array_length(_width) - 1] += _word_width;

                        // Add a space
                        if (_j < array_length(_words) - 1)
                        {
                            _width[array_length(_width) - 1] += string_width(" ");
                        }
                    }
                }
            }
            // Check if the token is a font
            else if (_token.type == tags.font)
            {
                // Set the font
                draw_set_font(_token.value);
            }
        }

        // Restore the font
        draw_set_font(_font);

        // Sort the array
        array_sort(_width, false);

        // Return the largest width
        return _width[0];
    }

    /// @desc Get the height of the string with a maximum width.
    /// @param {Real} _w The maximum width.
    /// @param {Real} _sep The separation between lines.
    /// @param {Bool} _tokenize Use the tokenized string or not.
    /// @return {Real} The height of the string.
    /// @pure
    static height_ext = function(_w, _sep, _tokenize)
    {
        // Use str if _tokenize is false
        if (!_tokenize)
        {
            // Return the height of the string
            return string_height_ext(str, _w, _sep);
        }

        // Store the font
        var _font = draw_get_font();

        // Store the width and height
        var _width = 0;
        var _height = 0;

        // Store the heighest height
        var _max_height = 0;

        // Check each token
        for (var _i = 0; _i < array_length(tokens); _i++)
        {
            // Get the token
            var _token = tokens[_i];

            // Check if the token is a string
            if (_token.type == tags.string)
            {
                // Store the heighest height
                _max_height = _sep == -1 ? max(_max_height, string_height("M")) : _sep;

                // Change the position if a newline is found
                if (_token.value == "\n")
                {
                    _height += _max_height;
                    _max_height = 0;
                }
                else
                {
                    // Split the string into words
                    var _words = string_split(_token.value, " ");

                    // Check each word
                    for (var _j = 0; _j < array_length(_words); _j++)
                    {
                        // Get the width of the word
                        var _word_width = string_width(_words[_j]);

                        // Check if the word exceeds the width
                        if ((_w > 0 && _width + _word_width > _w))
                        {
                            _width = 0;
                            _height += _max_height;
                            _max_height = 0;
                        }

                        // Update the width
                        _width += _word_width;

                        // Add a space
                        if (_j < array_length(_words) - 1)
                        {
                            _width += string_width(" ");
                        }
                    }
                }
            }
            // Check if the token is a font
            else if (_token.type == tags.font)
            {
                // Set the font
                draw_set_font(_token.value);
            }
        }

        // Restore the font
        draw_set_font(_font);

        // Return the height
        return _height;
    }

    /// @desc Get the character at the specified index.
    /// @param {Real} _index The index.
    /// @param {Bool} _tokenize Use the tokenized string or not.
    /// @return {String} The character.
    static char_at = function(_index, _tokenize = true)
    {
        var _str = get(_tokenize);
        return string_char_at(_str, _index);
    }

    
}
