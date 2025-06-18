if (keyboard_check_pressed(vk_escape)) {
    event_button_benchmark_back();
}

if (keyboard_check_pressed(ord("R"))) {
    vbuff.destroy();
    vbuff = event_benchmark_apple(sprite, subimg, num, max_depth);
}

if (keyboard_check_pressed(ord("1"))) {
    shader = sh_apple;
} else if (keyboard_check_pressed(ord("2"))) {
    shader = sh_grayscale;
} else if (keyboard_check_pressed(ord("3"))) {
    shader = sh_outline;
} else if (keyboard_check_pressed(ord("4"))) {
    shader = sh_depth;
} else if (keyboard_check_pressed(ord("5"))) {
    shader = -1;
}

if (keyboard_check_pressed(ord("Q"))) {
    zparam = 320;
} else if (keyboard_check_pressed(ord("W"))) {
    zparam = 3200;
} else if (keyboard_check_pressed(ord("E"))) {
    zparam = 32000;
}

if (keyboard_check_pressed(ord("A")) && sprite != spr_apple) {
    sprite = spr_apple;
    vbuff.destroy();
    vbuff = event_benchmark_apple(sprite, subimg, num, max_depth);
} else if (keyboard_check_pressed(ord("S")) && sprite != spr_grass) {
    sprite = spr_grass;
    vbuff.destroy();
    vbuff = event_benchmark_apple(sprite, subimg, num, max_depth);
}
