// Draw UI and tooltip
ui_manager.draw();
ui_manager.draw_tooltip();

// Take a screenshot
// Note: Not tested
if (input.screenshot())
{
	var _filename = "Screenshot-" + string(current_year) + "-" + string(current_month) + "-" + string(current_day) + "-" + string(current_hour) + ":" + string(current_minute) + ":" + string(current_second) + "-" + string(current_time) + ".png";
	screen_save(directory.screenshot + _filename);
}
