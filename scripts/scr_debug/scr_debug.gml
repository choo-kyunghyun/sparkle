new Debug();
if (!RELEASE_MODE) {
    call_later(1, time_source_units_frames, function() {
        Debug.init();
    });
}

/**
 * Debug class for handling debug operations in the game.
 * @returns {Struct.Debug}
 */
function Debug() constructor {
    /**
     * Initializes the debug system.
     * @returns {Undefined}
     */
    static init = function() {
        self.init_game();
        self.init_time();
        self.init_audio();
        self.init_level();
        self.init_camera();
        self.init_vertex();
        self.init_achievement();
    }

    /**
     * Initializes the game debug view.
     * @returns {Undefined}
     */
    static init_game = function() {
        dbg_view("Game", false);
        dbg_section("Game");
        dbg_button("End", game_end);
        dbg_same_line();
        dbg_button("Restart", game_restart);
        dbg_text($"Display name: {game_display_name}");
        dbg_text($"Project name: {game_project_name}");
        dbg_text($"Project filename: {GM_project_filename}");
        dbg_text($"Working directory: {working_directory}");
        dbg_text($"Version: {GM_version}");
        dbg_text($"Runtime: {GM_runtime_version}");
        dbg_text($"Build date: {date_time_string(GM_build_date)}");
        dbg_text($"Build type: {GM_build_type}");
        dbg_text($"OS: {os_type}");
        dbg_text($"OS version: {os_version}");
        dbg_text($"Locale: {os_get_language()}-{os_get_region()}");
        dbg_text($"Release mode: {RELEASE_MODE}");

        dbg_section("Settings");
        dbg_button("Save", function() { Settings.save(); });
        dbg_same_line();
        dbg_button("Load", function() { Settings.load(); });
        dbg_button("Apply", function() { Settings.apply(); });
        dbg_same_line();
        dbg_button("Refresh", function() { Settings.refresh(); });

        dbg_section("Window and Display");
        dbg_button("Fullscreen", function() { window_set_fullscreen(true); });
        dbg_same_line();
        dbg_button("Windowed", function() { window_set_fullscreen(false); });
        dbg_same_line();
        dbg_button("Center", window_center);
        
        dbg_text_input(ref_create(Settings.data.window, "width"), "width", "i");
        dbg_text_input(ref_create(Settings.data.window, "height"), "height", "i");
        dbg_text_input(ref_create(Settings.data.window, "x"), "x", "i");
        dbg_text_input(ref_create(Settings.data.window, "y"), "y", "i");
        dbg_checkbox(ref_create(Settings.data.window, "borderless_fullscreen"), "borderless_fullscreen");
        dbg_checkbox(ref_create(Settings.data.window, "border"), "border");
        dbg_text_input(ref_create(Settings.data.display, "fps"), "fps", "i");
        dbg_drop_down(ref_create(Settings.data.display, "aa"), "8:8,4:4,2:2,0:0", "aa");
        dbg_checkbox(ref_create(Settings.data.display, "vsync"), "vsync");

        dbg_section("GPU");
        dbg_checkbox(ref_create(Settings.data.gpu, "ztest"), "Z-Test");
        dbg_checkbox(ref_create(Settings.data.gpu, "alphatest"), "Alpha-Test");
        dbg_drop_down(ref_create(Settings.data.gpu, "cullmode"), $"cull_noculling:{cull_noculling},cull_clockwise:{cull_clockwise},cull_counterclockwise:{cull_counterclockwise}", "Cullmode");

        dbg_section("Draw");
        dbg_text_input(ref_create(Settings.data.draw, "circle_precision"), "Circle Precision", "i");
    }

    /**
     * Initializes the time debug view.
     * @returns {Undefined}
     */
    static init_time = function() {
        dbg_view("Time", false);
        dbg_section("Global");
        dbg_slider(ref_create(static_get(Time), "mult"), 0.0, 10.0, "Multiplier", 0.1);
    }

    static init_audio = function() {
        dbg_view("Audio", false);
    }

    static init_level = function() {
        dbg_view("Level", false);
        dbg_section("Room");
        dbg_button("Next", function() { if (room != room_last) { room_goto_next(); } });
        dbg_same_line();
        dbg_button("Previous", function() { if (room != room_first) { room_goto_previous(); } });
        dbg_same_line();
        dbg_button("Restart", room_restart);

        dbg_section("Inspector");
        dbg_text("id: ");
        dbg_same_line();
        dbg_text(ref_create(Level.inspector, "id"));
        dbg_sprite(ref_create(Level.inspector, "sprite_index"), ref_create(Level.inspector, "image_index"));
        dbg_text("hit: ");
        dbg_same_line();
        dbg_text(ref_create(Level.inspector, "hit"));
        dbg_text("invincible: ");
        dbg_same_line();
        dbg_text(ref_create(Level.inspector, "invincible"));
        dbg_text("x: ");
        dbg_same_line();
        dbg_text(ref_create(Level.inspector, "x"));
        dbg_text("y: ");
        dbg_same_line();
        dbg_text(ref_create(Level.inspector, "y"));
        dbg_text("depth: ");
        dbg_same_line();
        dbg_text(ref_create(Level.inspector, "depth"));
        dbg_text("yaw: ");
        dbg_same_line();
        dbg_text(ref_create(Level.inspector, "yaw"));
        dbg_text("pitch: ");
        dbg_same_line();
        dbg_text(ref_create(Level.inspector, "pitch"));
        dbg_text("image_angle: ");
        dbg_same_line();
        dbg_text(ref_create(Level.inspector, "image_angle"));
        dbg_text("image_blend: ");
        dbg_same_line();
        dbg_text(ref_create(Level.inspector, "image_blend"));
        dbg_text("image_alpha: ");
        dbg_same_line();
        dbg_text(ref_create(Level.inspector, "image_alpha"));
        dbg_text("image_xscale: ");
        dbg_same_line();
        dbg_text(ref_create(Level.inspector, "image_xscale"));
        dbg_text("image_yscale: ");
        dbg_same_line();
        dbg_text(ref_create(Level.inspector, "image_yscale"));
        dbg_text("vbuff: ");
        dbg_same_line();
        dbg_text(ref_create(Level.inspector, "vbuff"));
        dbg_text("actor_num: ");
        dbg_same_line();
        dbg_text(ref_create(Level.inspector, "actor_num"));

        dbg_section("Motion Planning");
        // TODO: Toggle debug grid

        dbg_section("Spawner");
    }

    /**
     * Initializes the camera debug view.
     * @returns {Undefined}
     */
    static init_camera = function() {
        dbg_view("Camera", false);
        dbg_section("Default Camera");
        dbg_text("id: ");
        dbg_same_line();
        dbg_text(ref_create(Camera.inspector, "id"));
        dbg_text("camera: ");
        dbg_same_line();
        dbg_text(ref_create(Camera.inspector, "camera"));
        dbg_text("x: ");
        dbg_same_line();
        dbg_text(ref_create(Camera.inspector, "x"));
        dbg_text("y: ");
        dbg_same_line();
        dbg_text(ref_create(Camera.inspector, "y"));
        dbg_text("depth: ");
        dbg_same_line();
        dbg_text(ref_create(Camera.inspector, "depth"));
        dbg_text("width: ");
        dbg_same_line();
        dbg_text(ref_create(Camera.inspector, "width"));
        dbg_text("height: ");
        dbg_same_line();
        dbg_text(ref_create(Camera.inspector, "height"));
        dbg_text("fov: ");
        dbg_same_line();
        dbg_text(ref_create(Camera.inspector, "fov"));
        dbg_text("znear: ");
        dbg_same_line();
        dbg_text(ref_create(Camera.inspector, "znear"));
        dbg_text("zfar: ");
        dbg_same_line();
        dbg_text(ref_create(Camera.inspector, "zfar"));
        dbg_text("yaw: ");
        dbg_same_line();
        dbg_text(ref_create(Camera.inspector, "yaw"));
        dbg_text("pitch: ");
        dbg_same_line();
        dbg_text(ref_create(Camera.inspector, "pitch"));
        dbg_text("roll: ");
        dbg_same_line();
        dbg_text(ref_create(Camera.inspector, "roll"));
        dbg_text("distance: ");
        dbg_same_line();
        dbg_text(ref_create(Camera.inspector, "distance"));
        dbg_text("interp: ");
        dbg_same_line();
        dbg_text(ref_create(Camera.inspector, "interp"));
        dbg_text("camera_speed: ");
        dbg_same_line();
        dbg_text(ref_create(Camera.inspector, "camera_speed"));
        dbg_text("bound: ");
        dbg_same_line();
        dbg_text(ref_create(Camera.inspector, "bound"));
        dbg_text("target: ");
        dbg_same_line();
        dbg_text(ref_create(Camera.inspector, "target"));
    }

    static init_vertex = function() {
        dbg_view("Vertex", false);
        dbg_section("Vertex Buffers");
        dbg_text("buffer_num: ");
        dbg_same_line();
        dbg_text(ref_create(Vertex.inspector, "buffer_num"));
    }

    /**
     * Initializes the achievement debug view.
     * @returns {Undefined}
     */
    static init_achievement = function() {
        dbg_view("Achievement", false);
        dbg_section("Achievements");
        dbg_button("Unlock All", function() {
            Achievement.set_all();
        });
        dbg_same_line();
        dbg_button("Reset All", function() {
            Achievement.clear_all();
        });
    }
}
