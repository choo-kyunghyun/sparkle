new Settings();
call_later(1, time_source_units_frames, function() {
    Settings.load().apply().refresh().save();
});

/**
 * Settings class for managing game settings.
 * @returns {Struct.Settings}
 */
function Settings() constructor {
    static fname = "settings.json";
    static data = {
        version: {
            game: GM_version,
            runtime: GM_runtime_version,
        },
        window: {
            width: display_get_width() * 0.75,
            height: display_get_height() * 0.75,
            x: window_get_x(),
            y: window_get_y(),
            fullscreen: false,
            borderless_fullscreen: true,
            border: true,
        },
        display: {
            vsync: false,
            aa: display_get_aa()[0],
            fps: display_get_frequency(),
        },
        gpu : {
            ztest: true,
            alphatest: true,
            cullmode: cull_noculling,
        },
        draw: {
            circle_precision: 64,
            font: fnt_sparkle,
        },
    };

    /**
     * Saves the current settings to a JSON file.
     * @returns {Struct.Settings}
     */
    static save = function() {
        Struct.export(self.data, self.fname);
        return self;
    }

    /**
     * Loads settings from a JSON file.
     * @returns {Struct.Settings}
     */
    static load = function() {
        var _settings = Struct.import(self.fname);
        if (is_struct(_settings)) {
            Struct.overwrite(_settings, self.data);
        }
        return self;
    }

    /**
     * Applies the current settings to the game.
     * This function should be called after loading settings to ensure they take effect.
     * @returns {Struct.Settings}
     */
    static apply = function() {
        // Window and Display settings
        window_set_size(self.data.window.width, self.data.window.height);
        window_set_position(self.data.window.x, self.data.window.y);
        window_set_fullscreen(self.data.window.fullscreen);
        window_enable_borderless_fullscreen(self.data.window.borderless_fullscreen);
        window_set_showborder(self.data.window.border);
        surface_resize(application_surface, self.data.window.width, self.data.window.height);
        display_set_gui_maximise();
        display_reset(self.data.display.aa, self.data.display.vsync);
        game_set_speed(self.data.display.fps, gamespeed_fps);

        // GPU settings
        gpu_set_ztestenable(self.data.gpu.ztest);
        gpu_set_alphatestenable(self.data.gpu.alphatest);
        gpu_set_cullmode(self.data.gpu.cullmode);

        // Draw settings
        draw_set_circle_precision(self.data.draw.circle_precision);
        draw_set_font(self.data.draw.font);
        draw_enable_svg_aa(true);
        draw_set_svg_aa_level(1.0);
        
        return self;
    }

    /**
     * Refreshes the settings data with the current game state.
     * @returns {Struct.Settings}
     */
    static refresh = function() {
        // Window and Display settings
        self.data.window.width = window_get_width();
        self.data.window.height = window_get_height();
        self.data.window.x = window_get_x();
        self.data.window.y = window_get_y();
        self.data.window.fullscreen = window_get_fullscreen();
        self.data.window.borderless_fullscreen = window_get_borderless_fullscreen();
        self.data.window.border = window_get_showborder();
        self.data.display.fps = game_get_speed(gamespeed_fps);

        // GPU settings
        self.data.gpu.ztest = gpu_get_ztestenable();
        self.data.gpu.alphatest = gpu_get_alphatestenable();
        self.data.gpu.cullmode = gpu_get_cullmode();

        // Draw settings
        self.data.draw.font = draw_get_font();

        return self;
    }
}
