// Local variables
var _font = -1;

// Draw the input instances
with (obj_button)
{
    // Draw the input instance
    draw_self();

    // Draw the input instances' icon
    if (icon.sprite != -1)
    {
        draw_sprite_ext(icon.sprite, icon.subimg, icon.x, icon.y, icon.xscale, icon.yscale, icon.rot, icon.color, icon.alpha);
    }

    // Draw the input instances' text
    if (text.string != "")
    {
        if (text.font != -1)
        {
            _font = draw_get_font();
            draw_set_font(text.font);
        }
        draw_text_ext_transformed_color(text.x, text.y, text.string, text.sep, text.w, text.xscale, text.yscale, text.angle, text.c1, text.c2, text.c3, text.c4, text.alpha);
    }
}

// Draw the input instances' cursor
with (obj_button)
{
    if (cursor.display)
    {
        if (cursor.sprite != -1)
        {
            draw_sprite_stretched_ext(cursor.sprite, cursor.subimg, cursor.x, cursor.y, cursor.w, cursor.h, cursor.color, cursor.alpha);
        }
    }
}

// Draw the input instances' tooltip
with (obj_button)
{
    if (tooltip.display)
    {
        if (tooltip.box.sprite != -1)
        {
            draw_sprite_stretched_ext(tooltip.box.sprite, tooltip.box.subimg, tooltip.box.x, tooltip.box.y, tooltip.box.w, tooltip.box.h, tooltip.box.color, tooltip.box.alpha);
        }
        if (tooltip.header.string != "")
        {
            if (tooltip.header.font != -1)
            {
                if (_font == -1)
                {
                    _font = draw_get_font();
                }
                draw_set_font(tooltip.header.font);
            }
            draw_text_ext_transformed_color(tooltip.header.x, tooltip.header.y, tooltip.header.string, tooltip.header.sep, tooltip.header.w, tooltip.header.xscale, tooltip.header.yscale, tooltip.header.angle, tooltip.header.c1, tooltip.header.c2, tooltip.header.c3, tooltip.header.c4, tooltip.header.alpha);
            tooltip.box.w = string_width(tooltip.header.string);
            tooltip.box.h = string_height(tooltip.header.string);
        }
        if (tooltip.body.string != "")
        {
            if (tooltip.body.font != -1)
            {
                if (_font == -1)
                {
                    _font = draw_get_font();
                }
                draw_set_font(tooltip.body.font);
            }
            draw_text_ext_transformed_color(tooltip.body.x, tooltip.body.y, tooltip.body.string, tooltip.body.sep, tooltip.body.w, tooltip.body.xscale, tooltip.body.yscale, tooltip.body.angle, tooltip.body.c1, tooltip.body.c2, tooltip.body.c3, tooltip.body.c4, tooltip.body.alpha);
            tooltip.box.w = max(tooltip.box.w, string_width(tooltip.body.string));
            tooltip.box.h += string_height(tooltip.body.string);
        }
        tooltip.box.w += tooltip.box.margin_width;
        tooltip.box.h += tooltip.box.margin_height;
    }
}

// Draw visual effects for the input instances
with (obj_button)
{
    if (vfx[state] != undefined)
    {
        vfx[state]();
    }
}

// Reset font
if (_font != -1)
{
    draw_set_font(_font);
}
