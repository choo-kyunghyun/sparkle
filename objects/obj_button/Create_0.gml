// State
state = BUTTON_STATE.IDLE;

// Alpha
icon.alpha = ((real(icon.color) & 0xFF000000) >> 24) / 255;
cursor.alpha = ((real(cursor.color) & 0xFF000000) >> 24) / 255;

// String
text = new String(text);
tooltip = new String(tooltip);
