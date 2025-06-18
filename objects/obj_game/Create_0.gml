#macro RELEASE_MODE false
#macro GAME obj_game

#region Initialization
gml_release_mode(RELEASE_MODE);
font_replace_sprite(fnt_sparkle, spr_fnt_sparkle, ord("!"), false, 1);
call_later(1, time_source_units_frames, function(){
    UILayer.show_only("uily_title");
    room_goto_next();
});
#endregion

#region Input
Input.bind("up", function() { return keyboard_check(ord("W")); });
Input.bind("down", function() { return keyboard_check(ord("S")); });
Input.bind("left", function() { return keyboard_check(ord("A")); });
Input.bind("right", function() { return keyboard_check(ord("D")); });
Input.bind("attack", function() { return mouse_check_button(mb_left); });
Input.bind("interact", function() { return mouse_check_button(mb_right); });
Input.bind("screenshot", function() { return keyboard_check_pressed(vk_f5); });
Input.bind("pause", function() { return keyboard_check_pressed(vk_escape); });
Input.bind("jump", function() { return keyboard_check(vk_space); });
Input.bind("sneak", function() { return keyboard_check(vk_control); });
Input.bind("sprint", function() { return keyboard_check(vk_shift); });
Input.bind("scan", function() { return keyboard_check(ord("F")); });
Input.bind("favorite_0",function() { return keyboard_check(ord("1")); });
Input.bind("favorite_1", function() { return keyboard_check(ord("2")); });
Input.bind("favorite_2", function() { return keyboard_check(ord("3")); });
Input.bind("favorite_3", function() { return keyboard_check(ord("4")); });
Input.bind("favorite_4", function() { return keyboard_check(ord("5")); });
Input.bind("favorite_5", function() { return keyboard_check(ord("6")); });
Input.bind("favorite_6", function() { return keyboard_check(ord("7")); });
Input.bind("favorite_7", function() { return keyboard_check(ord("8")); });
Input.bind("favorite_8", function() { return keyboard_check(ord("9")); });
Input.bind("favorite_9", function() { return keyboard_check(ord("0")); });
Input.bind("favorite_10", function() { return keyboard_check(ord("-")); });
Input.bind("favorite_11", function() { return keyboard_check(ord("=")); });
Input.bind("lean_left", function() { return keyboard_check(ord("Q")); });
Input.bind("lean_right", function() { return keyboard_check(ord("E")); });
Input.bind("debug", function() { return keyboard_check_pressed(vk_f10); });
Input.bind("enter", function() { return keyboard_check_pressed(vk_enter); });
Input.bind("back", function() { return keyboard_check_pressed(vk_escape); });
#endregion

#region Achievement
Achievement.add("ACH_THE_BURNING_YOU_FEEL", "The burning you feel? It is shame.", "Blow yourself up.", spr_unit, false, -1);
Achievement.add("ACH_A_GOOD_JOB", "Snipin's a good job, mate!", "Snipe enemies with a sniper rifle.", spr_unit, false, -1);
Achievement.add("ACH_PROFESSIONALS_HAVE_STANDARDS", "Professionals have standards.", "Eliminate all witnesses.", spr_unit, false, -1);
Achievement.add("ACH_BETTER_HARDER_FASTER_STRONGER", "Harder, Better, Faster, Stronger", "Strengthen your weapons.", spr_unit, false, -1);
Achievement.add("ACH_A_LOTTA_DAMAGE", "That's A Lotta Damage", "Deal 1000 or more damage with one shot.", spr_unit, false, -1);
Achievement.add("ACH_SHUTTING_DOWN", "Shutting down.", "Escape from the lab.", spr_unit, false, -1);
Achievement.add("ACH_OIIA_OIIA", "Spinning Cat", "Take catnip at the club and become a cat.", spr_unit, false, -1);
#endregion

#region Presets
preset = {
	object : {
		destroy : function() {
			instance_destroy(self);
		}
	},
	actor : {
        state : {
            walk : function() {
                var _dx = 0;
                var _dy = 0;
                var _dz = 0;
    
                if (target_instance != noone) {
                    
                }
    
                move_and_collide(_dx, _dy, obj_wall);
            },
            playable : function() {
                var _input = {
                    x : GAME.input.check("right") - GAME.input.check("left"),
                    y : GAME.input.check("down") - GAME.input.check("up"),
                    jump : GAME.input.check("jump"),
                    attack : GAME.input.check("attack")
                };
                var _dx = 0;
                var _dy = 0;
                var _dz = 0;
                
                if (_input.x != 0 || _input.y != 0) {
                    var _len = agility * TIME.delta;
                    var _dir = point_direction(0, 0, _input.x, _input.y);
                    _dx = lengthdir_x(_len, _dir);
                    _dy = lengthdir_y(_len, _dir);
                } else {
                    image_index = 0;
                }
    
                if (_input.attack && cooldown <= 0) {
                    var _proj = instance_create_depth(x, y, depth, obj_bullet);
                    _proj.dir = point_direction(x, y, mouse_x, mouse_y) + random_range(-5, 5);
                    _proj.spd = agility * 4;
                    _proj.owner = self;
                    cooldown = 0.1;
                }
    
                image_xscale = (x - mouse_x) > 0 ? 1 : -1;
                move_and_collide(_dx, _dy, obj_wall);
    
                audio_listener_position(x, y, depth);
                audio_listener_velocity(x - xprevious, y - yprevious, depth - zprevious);
                audio_listener_orientation(0, 0, 1, 0, -1, 0);
            },
            playable_controller : function() {
                
            },
            turrent : function() {
                var _target = noone;
                var _nearest_dist = range;
                var _list = ds_list_create();
                var _count = collision_circle_list(x, y, range, obj_enemy, false, true, _list, true);
                
                for (var _i = 0; _i < _count; _i++) {
                	var _id = ds_list_find_value(_list, _i);
                	var _dist = point_distance(x, y, _id.x, _id.y);
                	if (_dist < _nearest_dist && !collision_line(x, y, _id.x, _id.y, obj_wall, false, true)) {
                		_nearest_dist = _dist;
                		_target = _id;
                	}
                }
                
                ds_list_destroy(_list);
                
                if (_target != noone && cooldown <= 0) {
                    var _dir = point_direction(x, y, _target.x, _target.y);
                    var _spd = 128;
                
                    var _bullet = instance_create_layer(x, y, layer, obj_bullet);
                    _bullet.dir = _dir;
                    _bullet.spd = _spd * random_range(0.5, 2);
                	_bullet.owner = self;
                	// audio_play_sound_at(snd_shoot, x, y, depth, 64, 256, 1, false, 1);
                
                    cooldown = 0.05;
                }
                
                if (cooldown > 0) {
                    cooldown -= obj_game.time.delta;
                }
            }
        }
	}
};
#endregion
