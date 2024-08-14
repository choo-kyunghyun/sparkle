var _num = 0;
for (var _x = 0; _x < display_get_gui_width() / 16; _x++)
{
	for (var _y = 0; _y < display_get_gui_height() / 16; _y++)
	{
		arr[_x][_y].draw(_x * 16, _y * 16);
		// draw_text(_x * 16, _y * 16, arr[_x][_y].str);
		_num++;
	}
}
show_debug_message(_num);
