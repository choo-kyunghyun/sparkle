// Draw UI
ui_manager.draw();
ui_manager.draw_tooltip();

// Screenshot
if (input.screenshot())
{
	screen_save(working_directory + "Screenshots\Screenshot-" + string(current_year) + "-" + string(current_month) + "-" + string(current_day) + "-" + string(current_hour) + ":" + string(current_minute) + ":" + string(current_second) + "-" + string(current_time) + ".png");
}
