// Macro
#macro GAME obj_game.game
#macro TIME GAME.time
#macro CAMERA GAME.camera
#macro INPUT GAME.input
#macro LEVEL GAME.level

/// @desc Game.
function Game() constructor
{
    /// @desc Initialize the game.
    /// @param {Id.Instance} _id Object ID of the game object.
    /// @param {Bool} _release Release mode.
    static init = function(_id, _release)
    {
        // Check if the function is called in the correct event.
        if (event_type != ev_create) debug_event("Game: init() must be called in the Create event.");

        // Set ID
        id = _id;

        // Set release settings
        show_debug_overlay(!_release);
        gml_release_mode(_release);

        // Game time
        time = new GameTime();

        // Actor manager
        actor_manager = new ActorManager();

        // Camera object
        // TODO: Edit constructor to resize to room size
        camera = new Camera();
        camera.resize(room_width, room_height);

        // Vertex manager
        vertex_manager = new VertexManager();

        // UI manager
        // TODO: Edit constructor to take scale as argument
        ui_manager = new UIManager();
        ui_manager.scale = 2;

        // Input manager
        input = new InputManager();

        // Level instance
        // TODO: Move to Level class
        level = noone;

        // Transition manager
        // TODO: Move to Level class
        transition = new Transition();

        // Dialogue manager
        dialogue_manager = -1;

        // Audio manager
        audio_manager = new AudioManager();

        // Network manager
        network_manager = -1;

        // OS
        // TODO: Move to OS class
        os =
        {
            language : os_get_language(),
            region : os_get_region()
        };
        
        // Set gpu settings
        gpu_set_ztestenable(true);
        gpu_set_alphatestenable(true);

        // Set display settings
        if (display_aa >= 8)        display_reset(8, false);
        else if (display_aa >= 4)   display_reset(4, false);
        else if (display_aa >= 2)   display_reset(2, false);
        else                        display_reset(0, false);

        // Set window size
        window_set_size(display_get_width() * 0.5, display_get_height() * 0.5);
        surface_resize(application_surface, window_get_width(), window_get_height());

        // Center window
        window_center();

        // Set framerate
        game_set_speed(display_get_frequency(), gamespeed_fps);

        // Set font
        draw_set_font(fnt_sparkle);

        // Randomize
        randomize();
    }

    /// @desc Update the game.
    static update = function()
    {
        // Check if the function is called in the correct event.
        if (event_type != ev_step) debug_event("Game: update() must be called in the Step event.");

        // Update the game time
        time.update();

        // Toggle fullscreen
        if (keyboard_check(vk_alt) && keyboard_check_pressed(vk_enter))
        {
            window_set_fullscreen(!window_get_fullscreen());
        }

        // Watermark
        if (string_ends_with(keyboard_string, "sparkle"))
        {
            url_open("https://github.com/Choo-Kyunghyun/Sparkle");
            keyboard_string = string_delete(keyboard_string, string_length(keyboard_string), -7);
        }

        // Perform the transition effect
        // TODO: Move to Level class
        transition.update();

        // Execute the update script of the current level
        // TODO: Move to Level class
        if (level >= 0 && level.update != undefined)
        {
            script_execute_ext(level.update, level.update_args);
        }

        // Update all actors
        actor_manager.update();

        // Update the vertex manager
        var _vm = vertex_manager;
        _vm.begin_all();

        // Add all actors to the vertex buffer
        with (obj_actor)
        {
            if (visible && sprite_index != -1 && layer_get_visible(layer))
            {
                // Get texture
                var _tex = sprite_get_texture(sprite_index, image_index);

                // Add the sprite
                var _buffer = _vm.add(_tex);
                vertex_add_sprite_ext(_buffer, sprite_index, image_index, x, y, depth - sprite_get_yoffset(sprite_index) * image_yscale, image_xscale, image_yscale, image_angle, image_pitch, image_roll, image_blend, image_alpha);

                // Add the silhouette
                if (silhouette)
                {
                    _buffer = _vm.add(_tex, cmpfunc_greater);
                    vertex_add_sprite_ext(_buffer, sprite_index, image_index, x, y, depth - sprite_get_yoffset(sprite_index) * image_yscale, image_xscale, image_yscale, image_angle, image_pitch, image_roll, c_black, image_alpha * 0.5);
                }
            }
        }

        // End the vertex buffer
        _vm.end_all();

        // Update GUI
        ui_manager.update();

        // Update the camera
        camera.update();
    }

    /// @desc Draw the game.
    static draw = function()
    {
        // Check if the function is called in the correct event.
        if (event_type != ev_draw) debug_event("Game: draw() must be called in the Draw event.");

        // Submit vertex buffer
        vertex_manager.submit();

        // Draw level
        if (level != noone && level.draw != undefined)
        {
            script_execute_ext(level.draw, level.draw_args);
        }        
    }

    /// @desc Draw the GUI.
    static gui = function()
    {
        // Check if the function is called in the correct event.
        if (event_number != ev_gui) debug_event("Game: gui() must be called in the Draw GUI event.");

        // Draw level GUI
        if (level != noone && level.draw_gui != undefined)
        {
            script_execute_ext(level.draw_gui, level.draw_gui_args);
        }

        // Draw UI
        ui_manager.draw();
    }

    /// @desc Draw the GUI.
    static gui_end = function()
    {
        // Check if the function is called in the correct event.
        if (event_number != ev_gui_end) debug_event("Game: gui_end() must be called in the Draw GUI End event.");

        // Screenshot
        if (input.check("screenshot"))
        {
            var _filename = "Screenshots\\" + string(current_year) + "-" + string(current_month) + "-" + string(current_day) + "-" + string(current_hour) + "-" + string(current_minute) + "-" + string(current_second) + "-" + string(current_time) + ".png";
            screen_save(_filename);
        }
    }
    
    /// @desc Room transition.
    static refresh = function()
    {
        // Check if the function is called in the correct event.
        if (event_number != ev_room_start) debug_event("Game: refresh() must be called in the Room Start event.");

        // Remove all vertex buffers
        vertex_manager.delete_all();

        // Change the room settings
        view_enabled = true;
        view_visible[0] = true;
        view_camera[0] = camera.id;

        // Check the number of level instances
        if (instance_number(obj_level) > 1)
        {
            debug_event("Game: Multiple level instances detected. Only one level instance is allowed.");
        }

        // Get the level instance
        level = instance_find(obj_level, 0);

        // If the level instance exists
        if (level != noone)
        {	
            // Update the camera size
            if (level.camera_width != 0) camera.width = level.camera_width;
            if (level.camera_height != 0) camera.height = level.camera_height;
            camera.resize(camera.width, camera.height);

            // Change the camera settings
            camera.script = level.camera_update_script;
            camera.target = level.camera_target;
            camera.bound = level.camera_bound;

            // Update the camera position
            if (camera.target == noone) camera.position(level.camera_x, level.camera_y, level.camera_z);
            else camera.position(camera.target.x - camera.width / 2, camera.target.y - camera.height / 2, camera.target.depth - camera.dist);

            // Start the transition effect
            // Note: This code isn't complete and should be modified to fit your needs
            if (level.transition)
            {
                transition.delta = transition.delta > 0 ? transition.delta : -transition.delta;
                transition.start();
            }
        }
        else
        {
            camera.target = noone;
        }

        // Add static objects to the vertex buffer
        var _vm = vertex_manager;

        // Begin the vertex buffer
        _vm.begin_all();

        // Add all walls to the vertex buffer
        with (obj_wall)
        {
            if (visible && sprite_index != -1)
            {
                var _buffer = _vm.add(sprite_get_texture(sprite_index, image_index));
                vertex_add_cube(_buffer, sprite_index, image_index, x, y, depth - sprite_height, image_xscale, image_yscale, image_angle, image_pitch, image_roll, image_blend, image_alpha);
            }
        }

        // Add all actors to the vertex buffer
        _vm.end_all();

        // Freeze the vertex buffer to improve performance
        _vm.freeze_all();
    }

    /// @desc Destroy the game.
    static destroy = function()
    {
        // Check if the function is called in the correct event.
        if (event_number != ev_destroy && event_number != ev_destroy && event_number != ev_game_end) debug_event("Game: destroy() must be called in the Destroy event.");

        // Destroy the camera
        camera.destroy();
    }

    /// @desc Asynchronous - System event.
    static async_system = function()
    {
        // Check if the function is called in the correct event.
        if (event_number != ev_async_system_event) debug_event("Game: async_system() must be called in the Asynchronous - System event.");

        // Gamepad index
        var _index = -1;

        // Update gamepad
        switch (async_load[? "event_type"])
        {
            case "gamepad discovered":
                _index = async_load[? "pad_index"];
                break;
            case "gamepad lost":
                _index = async_load[? "pad_index"];
                break;
        }
    }
}
