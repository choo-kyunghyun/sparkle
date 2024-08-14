arr = [[]];
for (var _x = 0; _x < display_get_gui_width() / 16; _x++)
{
	for (var _y = 0; _y < display_get_gui_height() / 16; _y++)
	{
		arr[_x][_y] = new String("<color=" + string(make_color_rgb(irandom(255), irandom(255), irandom(255))) + ">x: " + string(_x) + ",y: " + string(_y));
	}
}
