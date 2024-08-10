// Submit vertex buffer
vertex_manager.submit();

// Draw level
if (level >= 0 && level.draw != undefined)
{
	level.draw();
}

// Draw UI
ui_manager.draw();
