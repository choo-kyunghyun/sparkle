function event_button_title_new() {
    UILayer.show_only_ext(["uily_title", "uily_title_new"]);
}

function event_button_title_load() {
    UILayer.show_only_ext(["uily_title", "uily_title_load"]);
}

function event_button_title_settings() {
    UILayer.show_only_ext(["uily_title", "uily_title_settings"]);
}

function event_button_title_benchmark() {
    UILayer.show_only_ext(["uily_benchmark"]);
    room_goto(rm_benchmark);
}
