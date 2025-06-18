new Item();
new Weapon();
new Consumable();
new Inventory();
// new Armor();

// TODO: Implement container object. Each container has owner(=Actor) variable.

/**
 * Inventory class for managing an array of items for an instance.
 * @returns {Struct.Inventory}
 */
function Inventory() constructor {
    /**
     * Find the index of an item by its id.
     * @returns {Real}
     * @param {Id.Instance} _inst - The instance whose inventory to search.
     * @param {String} _id - The id of the item to find.
     */
    static get_index = function(_inst, _id) {
        var _inv = _inst.inventory;
        return array_find_index(_inv, function(_elem) { return _elem.item.id == _id; });
    };

    /**
     * Get an inventory entry struct by id.
     * @returns {Struct|Undefined} {item, quantity, owner}
     * @param {String} _id
     * @param {Id.Instance} _inst - The instance whose inventory to search.
     */
    static get_entry = function(_inst, _id) {
        var _index = self.get_index(_inst, _id);
        if (_index != -1) return _inst.inventory[_index];
        return undefined;
    };

    /**
     * Get only the item struct by id.
     * @returns {Struct.Item|undefined}
     * @param {String} _id - The id of the item to retrieve.
     * @param {Id.Instance} _inst - The instance whose inventory to search.
     */
    static get_item = function(_inst, _id) {
        var _entry = self.get_entry(_inst, _id);
        if (_entry != undefined) return _entry.item;
        return undefined;
    };

    /**
     * Add an item to the inventory.
     * If stackable and already exists, increase quantity.
     * Otherwise, add as new.
     * @returns {Struct.Inventory}
     * @param {Id.Instance} _inst - The instance whose inventory to modify.
     * @param {Struct.Item} _item - The item to add.
     * @param {Real} [_quantity=1] - The quantity to add (default is 1).
     */
    static push = function(_inst, _item, _quantity = 1) {
        var _entry = self.get_entry(_inst, _item.id);
        if (_item.stackable && _entry != undefined) {
            _entry.quantity += _quantity;
        } else if (_item.stackable) {
            var _new_entry = { item: _item, quantity: _quantity };
            array_push(_inst.inventory, _new_entry);
        } else {
            for (var i = 0; i < _quantity; ++i) {
                var _new_entry = { item: _item, quantity: 1 };
                array_push(_inst.inventory, _new_entry);
            }
        }
        return self;
    };

    /**
     * Remove an item from the inventory by id and return it as an array.
     * If stackable, removes the specified quantity.
     * If not stackable, removes one instance at a time.
     * @returns {Array}
     * @param {Id.Instance} _inst - The instance whose inventory to modify.
     * @param {String} _id - The id of the item to remove.
     * @param {Real} [_quantity=1] - The quantity to remove (default is 1).
     */
    static pop = function(_inst, _id, _quantity = 1) {
        var _result = [];
        var _index = self.get_index(_inst, _id);
        if (_index == -1 || _quantity <= 0) return _result;
        var _entry = _inst.inventory[_index];
        if (_entry.item.stackable) {
            var _remove_qty = min(_quantity, _entry.quantity);
            var _removed = { item: _entry.item, quantity: _remove_qty };
            _entry.quantity -= _remove_qty;
            if (_entry.quantity <= 0) array_delete(_inst.inventory, _index, 1);
            array_push(_result, _removed);
        } else {
            for (var i = 0; i < _quantity; ++i) {
                var _idx = self.get_index(_inst, _id);
                if (_idx == -1) break;
                var _removed = _inst.inventory[_idx];
                array_push(_result, _removed);
                array_delete(_inst.inventory, _idx, 1);
            }
        }
        return _result;
    };

    /**
     * Returns the total quantity of an item by id. If not present, returns 0.
     * @returns {Real}
     * @param {Id.Instance} _inst - The instance whose inventory to search.
     * @param {String} _id - The id of the item to count.
     */
    static get_quantity = function(_inst, _id) {
        var _total = 0;
        var _inv = _inst.inventory;
        for (var i = 0; i < array_length(_inv); ++i) {
            var _entry = _inv[i];
            if (_entry.item.id == _id) {
                _total += _entry.item.stackable ? _entry.quantity : 1;
            }
        }
        return _total;
    };

    /**
     * Remove all items from inventory.
     * @returns {Struct.Inventory}
     * @param {Id.Instance} _inst - The instance whose inventory to clear.
     */
    static clear = function(_inst) {
        _inst.inventory = [];
        return self;
    };

    /**
     * Checks if the given item is of a specific type (constructor chain).
     * @param {Struct.Item} _item - The item instance to check.
     * @param {Function} _constructor - The constructor function to check against (e.g. Weapon, Consumable).
     * @returns {Boolean} True if the item is of the given type or inherits from it.
     */
    static is_type = function(_item, _constructor) {
        return is_instanceof(_item, _constructor);
    };
}

/**
 * Items class for managing items in the game.
 * This class provides static methods to get and set items by their ID.
 * All items are stored in a static dictionary for easy access.
 * @returns {Struct.Items}
 */
function Items() constructor {
    static items = {};
    
    /**
     * Retrieves an item by its ID.
     * @returns {Struct.Item}
     * @param {String} id - The ID of the item to retrieve.
     */
    static get = function(_id) {
        return self.items[$ _id];
    }

    /**
     * Registers a new item in the items dictionary.
     * @returns {Undefined}
     * @param {String} id - The ID of the item to register.
     * @param {Struct.Item} struct - The item structure to register.
     */
    static set = function(_id, _struct) {
        self.items[$ _id] = _struct;
    }
}

/**
 * Top-level item template class.
 * This class serves as a base for all items in the game.
 * @returns {Struct.Item}
 */
function Item() constructor {
    id = "";
    name = "";
    desc = "";
    value = 0;
    mass = 0;
    stackable = false;
    rarity = 0; // Enumeration for item rarity, where 0 is common and higher values are rarer
    // effects = []; // Array of effects that the item has, used to apply effects to the actor when the item is used
    // tags = []; // Array of tags that the item has, used for categorization and filtering
    // equippable = false; // Whether the item can be equipped by the actor, used to check if the item can be equipped
    // TODO: Merge equippable and use into a single property that defines the item's behavior when used.
    use = noop; // Function to call when the item is used, can be overridden by subclasses
    icon = {
        sprite: -1,
        index: 0,
    };
}

/**
 * Consumable class for managing consumable items in the game.
 * Inherits from Item and provides additional properties and methods for consumables.
 * @returns {Struct.Consumable}
 */
function Consumable() : Item() constructor {
    // use = noop;
}

/**
 * Weapon class for managing weapons in the game.
 * Inherits from Item and provides additional properties and methods for weapons.
 * @returns {Struct.Weapon}
 */
function Weapon() : Item() constructor {}

/**
 * This class is used to manage gun attributes.
 * It contains various modifiers and multipliers for different gun properties.
 * GunPart and Gun classes will use this struct to manage their attributes.
 * @returns {Struct.GunAttributes}
 */
function GunAttributes() constructor {
    base = {
        bullet_mass: 0, // Base mass of the bullet in kg, used to calculate the speed and damage of the bullet. Mother of this value is the ammo struct. (0.004kg for 5.56mm bullet and 0.0075kg for 9mm bullet)
        velocity: 0, // Base velocity of the bullet when fired, used to calculate the speed of the bullet. Mother of this value is the ammo struct.
        penetration: 0, // Base penetration value of the bullet, used to calculate damage against armored targets. Mother of this value is the ammo struct.
        recoil: 0, // Base recoil value of the bullet, used to calculate the recoil effect when firing the bullet. Mother of this value is the ammo struct.
        range: 0, // Base range of the bullet, used to calculate the effective range of the bullet. Mother of this value is the ammo struct.
        damage: 0, // Base damage value of the bullet, used to calculate the damage dealt by the bullet. Since damage will determine by velocity and mass, default value is 0.
        firerate: 0, // Base fire rate of the gun, used to calculate the time between shots. Mother of this value is the gun struct.
        reload_time: 0, // Base reload time of the gun, used to calculate the time taken to reload the gun. Mother of this value is the gun struct.
        equip_time: 0, // Base equip time of the gun, used to calculate the time taken to equip the gun. Mother of this value is the gun struct.
        ammo_capacity: 0, // Base ammo capacity of the gun, used to calculate the maximum number of bullets that can be loaded into the gun. Mother of this value is the magazine attachment.
        falloff_coefficient: 0, // Base falloff coefficient of the bullet, used to calculate the damage falloff over distance. Positive value for falloff, higher means faster. 0 or less means no falloff.
    };
    mult = {
        bullet_mass: 1,
        velocity: 1,
        penetration: 1,
        recoil: 1,
        range: 1,
        damage: 1,
        firerate: 1,
        reload_time: 1,
        equip_time: 1,
        ammo_capacity: 1,
        falloff_coefficient: 1,
    };
}

/**
 * GunPart class for managing gun parts and attachments in the game.
 * Inherits from Weapon and provides additional properties and methods for gun parts.
 * @returns {Struct.GunPart}
 */
function GunPart() : Weapon() constructor {
    attributes = new GunAttributes();
}

/**
 * Gun body class for managing gun bodies in the game.
 * Inherits from GunPart and provides additional properties and methods for gun bodies.
 * This class serves as a base for all gun bodies in the game.
 * @returns {Struct.Gun}
 */
function Gun() : GunPart() constructor {
    static COMPLETE_PENETRATION_FACTOR = 2;

    compatibility = {
        ammo: [], // Array of ammo types that the gun can use, used to check if the gun can use the ammo type
        barrel: [], // Array of barrel attachments that the gun can use, used to check if the gun can use the attachment
        magazine: [], // Array of magazine attachments that the gun can use, used to check if the gun can use the attachment
        // sight(scope), trigger, foregrip, laser, flashlight, muzzle, gunstock, bayonet, handguard, toprail, bottomrail, leftrail, rightrail, etc.
    };

    // TODO: Move sfx and vfx to the GunPart class or GunAttr class, since they are not specific to the gun body.
    sfx = {
        equip: noone, // Sound played when equipping the gun
        fire: noone, // Sound played when firing the gun
        reload: noone, // Sound played when reloading the gun
        dryfire: noone, // Sound played when trying to fire an empty gun
    };
    vfx = {
        // muzzle_flash: noone, // Muzzle flash effect when shooting
    };

    final_attributes = new GunAttributes();
    // TODO: Implement complex magazine system, mixing different ammo types in the magazine. (e.g., mixing tracer and regular ammo in the same magazine)
    // magazine = ds_stack_create(); // Magazine stack, used to store the ammo in the magazine. This will be used for complex magazines.
    ammo_count = 0; // Current ammo count in the gun, used to check how many bullets are left in the gun. Excludes the bullet in the chamber.
    loaded = false; // Whether the gun has a bullet in the chamber. Used for tactical reloads and extra shots without reloading.
    parts = {
        ammo: -1,
        barrel: -1,
        magazine: -1,
    };

    /**
     * Attempts to equip an attachment to the specified slot.
     * If the slot is empty and the attachment is compatible, it equips the attachment.
     * If the slot is already occupied, it returns false.
     * @returns {Bool}
     * @param {String} _slot - The slot to equip the part to (e.g., "ammo", "barrel", "magazine").
     * @param {Struct.Part} _part - The gun part to equip.
     */
    static parts_equip = function(_slot, _part) {
        if (self.parts[$ _slot] == -1 && array_contains(self.compatible_parts, _part.id)) {
            self.parts[$ _slot] = _part;
            return true;
        }
        return false;
    }

    /**
     * Removes an gun part from the specified slot.
     * If the slot is occupied, it removes the part and returns it.
     * If the slot is empty or invalid, it returns undefined.
     * @returns {Struct.Part|Undefined}
     * @param {String} _slot - The slot from which to remove the part.
     */
    static part_remove = function(_slot) {
        if (self.parts[$ _slot] == undefined || self.parts[$ _slot] == -1) {
            return undefined;
        }
        var _part = self.parts[$ _slot];
        self.parts[$ _slot] = -1;
        return _part;
    }
    
    /**
     * Calculates the final attributes of the gun based on base attributes, ammo, and attachments.
     * Also, this function will return current mass of the gun.
     * @returns {Real}
     */
    static calculate_attributes = function() {
        delete self.final_attributes;
        self.final_attributes = Struct.duplicate(self.attributes);
        var _mass = self.mass;
        var _fields = struct_get_names(self.final_attributes.base);
        var _fields_len = array_length(_fields);
        var _parts = struct_get_names(self.parts);
        for (var _i = 0, _len = array_length(_parts); _i < _len; _i++) {
            var _part = self.parts[$ _parts[_i]];
            if (_part == -1) continue;
            if (_parts[_i] == "ammo") {
                _mass += _part.mass * (self.ammo_count + (self.loaded ? 1 : 0));
            } else {
                _mass += _part.mass;
            }
            for (var _j = 0; _j < _fields_len; _j++) {
                var _field = _fields[_j];
                var _modifier = _part.attributes.base[$ _field] ?? 0;
                var _multiplier = _part.attributes.mult[$ _field] ?? 1;
                self.final_attributes.base[$ _field] += _modifier;
                self.final_attributes.mult[$ _field] += _multiplier;
            }
        }
        for (var _i = 0; _i < _fields_len; _i++) {
            var _field = _fields[_i];
            self.final_attributes.base[$ _field] *= self.final_attributes.mult[$ _field];
        }
        return _mass;
    }

    /**
     * This function is used to reset the gun's state.
     * Feeds the gun with ammo, resets the loaded state, and decreases the ammo count.
     * @returns {Undefined}
     */
    static feed = function() {
        if (self.parts.ammo == -1 || self.ammo_count <= 0) {
            return;
        }
        self.ammo_count -= 1;
        self.loaded = true;
    }

    /**
     * This function is used to reload the gun's magazine.
     * It resets the loaded state and refills the ammo count.
     * @returns {Undefined}
     */
    static reload = function(_shooter) {
        // TODO: Implement swapping ammo types.
        var _ammo_prev = self.parts.ammo.id;
        var _ammo = Inventory.pop(_shooter, _ammo_prev, self.ammo_count);
        if (array_length(_ammo) == 0) {
            Audio.play(self.sfx.dryfire);
            return;
        }
        self.ammo = _ammo[0].item;
        self.ammo_count = _ammo[0].quantity;
        self.feed();
        self.calculate_attributes();
        Audio.play(self.sfx.reload);
    }

    static kinetic_energy = function(_mass, _velocity) {
        if (_mass <= 0 || _velocity <= 0) return 0;
        return 0.5 * _mass * power(_velocity, 2);
    }

    static falloff = function(_dist, _coeff) {
        if (_dist < 0 || _coeff < 0) return 1;
        if (_dist == 0) return 1;
        return exp(-_coeff * _dist);
    }

    static shoot = function(_shooter, _dir) {
        if (!self.loaded || self.ammo == -1 || self.final_attributes.base.bullet_mass <= 0) {
            Audio.play(self.sfx.dryfire);
            return [];
        }
        Audio.play(self.sfx.shoot);
        Timer.add(self.final_attributes.base.firerate, function() {
            self.feed();
        });
        self.loaded = false;

        var _hits_list = [];
        var _attr = self.final_attributes.base;
        var _shooter_x = _shooter.x;
        var _shooter_y = _shooter.y;
        var _current_kinetic_energy = self.kinetic_energy(_attr.bullet_mass, _attr.velocity);
        var _current_penetration_power = _attr.penetration;
        var _falloff_coeff = _attr.falloff_coefficient;
        var _last_flight_distance_cumulative = 0;
        var _x2 = _shooter_x + lengthdir_x(_attr.range, _dir);
        var _y2 = _shooter_y + lengthdir_y(_attr.range, _dir);
        var _targets = Hitscan.scan(_shooter_x, _shooter_y, _x2, _y2, obj_object, true, true);

        for (var _i = 0, _len = array_length(_targets); _i < _len; _i++) {
            if (_current_kinetic_energy <= 0 || _current_penetration_power <= 0) {
                break;
            }

            var _target_obj = _targets[_i];
            if (!instance_exists(_target_obj)) continue;

            var _target_pos_x = _target_obj.x;
            var _target_pos_y = _target_obj.y;
            var _target_distance_from_muzzle = point_distance(_shooter_x, _shooter_y, _target_pos_x, _target_pos_y);
            var _distance_of_current_flight_segment = _target_distance_from_muzzle - _last_flight_distance_cumulative;

            if (_falloff_coeff > 0 && _distance_of_current_flight_segment > 0) {
                var _velocity_falloff_multiplier = self.falloff(_distance_of_current_flight_segment, _falloff_coeff);
                _current_kinetic_energy *= power(_velocity_falloff_multiplier, 2);
            }

            if (_current_kinetic_energy <= 0) {
                break; 
            }

            // TODO: Implement double collsion check.
            //       Use built-in collision box for weather the target is hit or not.
            //       Use collsion_* functions to check which part of the target was hit.(head, torso, arms, legs, etc.)
            
            var _target_effective_armor = _target_obj.armor ?? 0;
            var _damage = 0;

            if (_current_penetration_power >= _target_effective_armor) {
                var _energy_cost_to_pass_armor = _target_effective_armor * COMPLETE_PENETRATION_FACTOR;
                if (_current_kinetic_energy > _energy_cost_to_pass_armor) {
                    _damage = _energy_cost_to_pass_armor;
                    _current_kinetic_energy -= _energy_cost_to_pass_armor;
                } else {
                    _damage = _current_kinetic_energy;
                    _current_kinetic_energy = 0;
                }
                _current_penetration_power -= _target_effective_armor;
            } else {
                var _effective_percentage = 1;
                if (_target_effective_armor > 0) {
                    _effective_percentage = _current_penetration_power / _target_effective_armor;
                    if (_effective_percentage < 0) _effective_percentage = 0;
                }
                _damage = _current_kinetic_energy * _effective_percentage;
                _current_kinetic_energy = 0;
                _current_penetration_power = 0;
            }

            if (_damage > 0) {
                _target_obj.hit -= _damage;
                
                array_push(_hits_list, { 
                    target_id: _target_obj, 
                    damage_inflicted: _damage, 
                    hit_x: _target_pos_x, 
                    hit_y: _target_pos_y  
                });
            }
            
            _last_flight_distance_cumulative = _target_distance_from_muzzle;
        }
        return _hits_list;
    }
}

/**
 * Ammo class for managing ammo in the game.
 * Inherits from Item and provides additional properties and methods for ammo.
 * @returns {Struct.Ammo}
 */
function Ammo() : GunPart() constructor {
    sfx = {
        hit: noone, // Sound played when the ammo hits a target
        ricochet: noone, // Sound played when the ammo ricochets off a surface
    };
    vfx = {
        hit: noone, // Effect played when the ammo hits a target
        ricochet: noone, // Effect played when the ammo ricochets off a surface
        trail: { // Bullet trail properties
            enabled: false, // Whether the bullet trail is enabled
            color: c_white, // Color of the bullet trail
            thickness: 0, // Thickness of the bullet trail in pixels
            lifetime: 0, // Lifetime of the bullet trail in seconds
        }
    };
}

function Scope() : GunPart() constructor {
    // Special attributes for scopes. Affects default_camera instance.
    zoom = 1; // Zoom level of the scope
    // ads_time = 0; // Time taken to aim down sights with the scope
    fov_modifier = 1; // Modifier for field of view while using the scope, 1 for normal FOV, 0.5 for zoomed in, 2 for zoomed out
}

function Magazine() : GunPart() constructor {
    // TODO: Why we need separate compatible_ammo array for both gun and magazine?
    // compatible_ammo = []; // Array of ammo types that the magazine can use, used to check if the magazine can use the ammo type
}

function Barrel() : GunPart() constructor {}

/**
 * Grenade class for managing grenades in the game.
 * Inherits from Weapon and provides additional properties and methods for grenades.
 * @returns {Struct.Grenade}
 */
function Grenade() : Weapon() constructor {
    explosion_radius = 5; // Radius of the explosion in meters
    damage = 100; // Damage dealt by the explosion
}

function Pistol() : Gun() constructor {}
function Rifle() : Gun() constructor {}
function Shotgun() : Gun() constructor {}

/**
 * ItemKit class for managing item kits in the game.
 * ItemKits are collections of items that can be used to make dynamic inventory for NPCs or other actors.
 * @returns {Struct.ItemKit}
 */
function ItemKit() constructor {
    // Example: Create a new item kit with a specific set of items
    items = [
        new Item("Health Potion", 10),
        new Item("Mana Potion", 5),
        new Item("Stamina Potion", 8),
        choose([
            new Pistol(),
            new Rifle(),
            new Shotgun(),
        ]),
    ];
}
