// State
state = BUTTON_STATE.IDLE;
cursor_display = false;

// Alpha
icon_alpha = ((real(icon_color) & 0xFF000000) >> 24) / 255;
cursor_alpha = ((real(cursor_color) & 0xFF000000) >> 24) / 255;

// String
text = new String(text);
tooltip = new String(tooltip);
