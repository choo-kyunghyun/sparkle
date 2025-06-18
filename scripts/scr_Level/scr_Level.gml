new Level();

/**
 * Level management class for handling game levels.
 * @returns {Struct.Level}
 */
function Level() constructor {
    static inspector = {
        id: noone,
        x: 0,
        y: 0,
        depth: 0,
        yaw: 0,
        pitch: 0,
        image_angle: 0,
        sprite_index: -1,
        image_index: 0,
        image_xscale: 1,
        image_yscale: 1,
        image_blend: c_white,
        image_alpha: 1,
        hit: 0,
        invincible: false,
        vbuff: noone,
    };

    static tick = 0;
    static tickrate = 1 / 30; // 30 TPS
    static collider = noone;
    static grid = -1;
    static obsolete_vbuffers = [];
    static gravity = {
        x: 0,
        y: 0,
        z: 0,
        strength: 9.81,
    };

    call_later(1, time_source_units_frames, function() {
        self.collider = instance_create_depth(0, 0, 0, obj_collider, {
            persistent : true,
            visible: false,
        });
    });

    /**
     * This function will update the inspector with the properties of the given instance.
     * @returns {Undefined}
     * @param {Id.Instance} inst - The instance to inspect.
     */
    static inspector_update = function(_inst) {
        self.inspector.id = _inst.id;
        self.inspector.x = _inst.x;
        self.inspector.y = _inst.y;
        self.inspector.depth = _inst.depth;
        self.inspector.yaw = _inst.yaw;
        self.inspector.pitch = _inst.pitch;
        self.inspector.image_angle = _inst.image_angle;
        self.inspector.sprite_index = _inst.sprite_index;
        self.inspector.image_index = _inst.image_index;
        self.inspector.image_xscale = _inst.image_xscale;
        self.inspector.image_yscale = _inst.image_yscale;
        self.inspector.image_blend = _inst.image_blend;
        self.inspector.image_alpha = _inst.image_alpha;
        self.inspector.hit = _inst.hit;
        self.inspector.invincible = _inst.invincible;
        self.inspector.vbuff = _inst.vbuff;
    }

    /**
     * Convert all sprites in the given layer to vertex elements.
     * @returns {Undefined}
     * @param {String|Id.Layer} layer - The layer to convert sprites from.
     */
    static convert_layer_sprite_to_vertex = function(_layer) {
        var _depth = layer_get_depth(_layer);
        var _elements = layer_get_all_elements(_layer);
        for (var _i = 0, _len = array_length(_elements); _i < _len; _i++) {
            var _element = _elements[_i];
            if (layer_get_element_type(_element) == layerelementtype_sprite) {
                var _sprite = layer_sprite_get_sprite(_element);
                var _image = layer_sprite_get_index(_element);
                var _speed = layer_sprite_get_speed(_element);
                var _xscale = layer_sprite_get_xscale(_element);
                var _yscale = layer_sprite_get_yscale(_element);
                var _angle = layer_sprite_get_angle(_element);
                var _blend = layer_sprite_get_blend(_element);
                var _alpha = layer_sprite_get_alpha(_element);
                var _x = layer_sprite_get_x(_element);
                var _y = layer_sprite_get_y(_element);
                Vertex.sprite_ext(_sprite, _image, _x, _y, _depth, _xscale, _yscale, 0, 0, _angle, _blend, _alpha);
                layer_sprite_destroy(_element);
            }
        }
    }

    /**
     * Convert all sprites in all layers to vertex elements.
     * @returns {Undefined}
     */
    static convert_all_layer_sprite_to_vertex = function() {
        var _layers = layer_get_all();
        array_foreach(_layers, function(_layer, _index) {
            self.convert_layer_sprite_to_vertex(_layer);
        });
    }

    static world_gen = function(_seed) {
        random_set_seed(_seed);
        // TODO: Implement world generation logic.
        // This could include terrain generation, object placement, etc.
    }

    static draw = function() {
        
    }

    static mark_for_redraw = function(_vbuff) {
        if (!array_contains(self.obsolete_vbuffers, _vbuff)) {
            array_push(self.obsolete_vbuffers, _vbuff);
        }
    }

    static update = function() {
        with (obj_projectile) {
            // Update logic for projectiles
        }

        // TODO: Abstracted event and detailed event system.
        // If player is close to event zone, trigger detailed event.
        // Otherwise, trigger abstracted event for optimization.

        // Update actor's finite state machine update logic.

        // Update the game objects.
        with (obj_object) {
            // TODO: Hitpoint
            if (self.hit <= 0 && !self.invincible) {
                // script_execute(self.on_death);
            }

            // Gravity handling.
            // self.airborne = !place_meeting(self.x, self.bbox_bottom, obj_wall);

            // Mark game objects for update if image_index is changed.
            if (self.image_index != self.image_index_previous || !self.updated) {
                Level.mark_for_redraw(self.vbuff);
            }
            self.image_index_previous = self.image_index;
        }

        // Remove obsolete vbuffers.
        array_foreach(obsolete_vbuffers, function(_buffer, _index) {
            Vertex.buffer_remove(_buffer);
        });

        // Submit game objects that marked for update.
        // TODO: Do not submit objects that are out of view.
        // TODO: Shadow and silhouette should be drawn in the same way as sprites.
        // TODO: Use cmpfunc_greater and alpha=0.25 to draw silhouette.
        // TODO: Check self.visible, self.sprite_index, and layer_get_visible(self.layer) before submitting.
        with (obj_object) {
            if (array_contains(obsolete_vbuffers, self.vbuff)) {
                var _id = Vertex.sprite_ext(
                    self.sprite_index, 
                    self.image_index, 
                    self.x, 
                    self.y, 
                    self.depth, 
                    self.image_xscale, 
                    self.image_yscale, 
                    self.yaw,
                    -self.pitch,
                    -self.image_angle,
                    self.image_blend, 
                    self.image_alpha
                );
                self.updated = true;
                self.vbuff = _id;
            }

            self.zprevious = self.depth;
        }

        Vertex.buffer_freeze_all();

        // Update the inspector if the mouse is over an object.
        var _inspector_inst = instance_position(mouse_x, mouse_y, obj_object);
        var _click = mouse_check_button_pressed(mb_left);
        if (_inspector_inst != noone && _click) {
            self.inspector_update(_inspector_inst);
        }
    }
}

function Projectile() constructor {
    

    static update = function() {
        with (obj_projectile) {
            // Update logic for projectiles

        }

        /*
        with (obj_projectile) {
            if (homing != noone) {
				dir = point_direction(x, y, homing.x, homing.y);
			}

			var _len = spd * obj_game.time.delta;
			x += lengthdir_x(_len, dir);
			y += lengthdir_y(_len, dir);
			image_angle = dir;

			var _target = instance_place(x, y, obj_actor);
			if (_target != noone && _target != owner && _target != self) {
				_target.hit -= velocity * mass * bullet_mass_ratio;
				audio_play_sound_at(hitsound, x, y, depth, 32, 128, 1, false, 1);
				instance_destroy(self);
			}
			
			var _oob = (x < 0) || (x > room_width) || (y < 0) || (y > room_height);
			if (_oob || place_meeting(x, y, obj_wall)) {
				instance_destroy(self);
			}
        }
        */
    }
}

function Hitscan() constructor {
    static scan = function(_x1, _y1, _x2, _y2, _obj, _prec, _notme) {
        var _list = ds_list_create();
        ds_list_clear(_list);
        var _num = collision_line_list(_x1, _y1, _x2, _y2, _obj, _prec, _notme, _list, true);
        if (_num <= 0) {
            ds_list_destroy(_list);
            return [];
        }
        var _arr = [];
        for (var _i = 0, _len = ds_list_size(_list); _i < _len; _i++) {
            array_push(_arr, _list[| _i]);
        }
        ds_list_destroy(_list);
        return _arr;
    }
}

// TODO: Actor's movement speed should be affected by the gun's weight(including attachments) and inventory weight.

function Actor() constructor {
    // Some core functionality for actors

    static update = function() {
        with (obj_actor) {
            // Update logic for actors
            script_execute(states[$ state]);
        }
    }
}

/// @deprecated
function Actor_TEMP() constructor {
    static update = function() {
        with (obj_actor) {
            // TODO: Remove cooldown from Actor and use Weapon constructor instead
            cooldown = max(cooldown - GAME.time.delta, 0);

            if (playable) {
                if (_input.attack && cooldown <= 0) {
                    var _proj = instance_create_depth(x, y, depth, obj_bullet);
                    _proj.dir = point_direction(x, y, mouse_x, mouse_y) + random_range(-5, 5);
                    _proj.spd = agility * 4;
                    _proj.owner = self;
                    cooldown = 0.1;
                    // audio_play_sound_at(snd_shoot, x, y, depth, 64, 256, 1, false, 1);
                }
            } else {
				if (instance_exists(target.instance)) {
                    if (array_length(path) != 0) {
                        var _len = agility * GAME.time.delta;
                        var _count = array_length(path);
                        while (_len > 0 && _count > 0) {
                            var _x = path[0].x;
                            var _y = path[0].y;
                            var _dir = point_direction(x, y, _x, _y);
                            var _spd = min(_len, point_distance(x, y, _x, _y));
                            _dx = lengthdir_x(_spd, _dir);
                            _dy = lengthdir_y(_spd, _dir);

                            move_and_collide(_dx, _dy, obj_wall);

                            _len -= _spd;
                            if (point_distance(x, y, _x, _y) < 1) {
                                array_delete(path, 0, 1);
                                _count--;
                            }
                        }
                    } else {
                        var _dir = point_direction(x, y, target.instance.x, target.instance.y);
                        var _spd = agility * GAME.time.delta;
                        _dx = lengthdir_x(_spd, _dir);
                        _dy = lengthdir_y(_spd, _dir);
                        move_and_collide(_dx, _dy, obj_wall);
                    }
                }
            }
        }
    }
}
