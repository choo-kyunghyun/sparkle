if (keyboard_check_pressed(vk_escape)) {
    event_button_benchmark_back();
}

if (keyboard_check_pressed(ord("R"))) {
    roll(density, allowdiag);
}
