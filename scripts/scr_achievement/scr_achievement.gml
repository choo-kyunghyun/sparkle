new Achievement();

/**
 * Achievement class for managing game achievements.
 * @returns {Struct.Achievement}
 */
function Achievement() constructor {
	static achievements = {};
	id = "";
	name = "";
	desc = "";
	icon = noone;
	hidden = false;
	stat = undefined;
	callback = noop;
	achieved = false;
	grand = false; // Special attribute for grand achievements(endings of this game). Does not compatible with Steamworks and other platforms.

	/**
	 * This function adds a new achievement to the achievements struct.
	 * @returns {Struct.Achievement}
	 * @param {String} id - The unique identifier for the achievement.
	 * @param {String} name - The name of the achievement.
	 * @param {String} desc - The description of the achievement.
	 * @param {Asset.GMSprite} icon - The sprite for the achievement icon. image_index 0 for locked, 1 for unlocked.
	 * @param {Bool} hidden - Whether the achievement is hidden or not.
	 * @param {Struct.Stat} stat - The statistic to track for the achievement, if any.
	 * @param {Function} callback - The callback function to execute when the achievement is set.
	 */
	static add = function(_id, _name, _desc, _icon, _hidden, _stat, _callback = noop) {
		var _achievement = new Achievement();
		_achievement.id = _id;
		_achievement.name = _name;
		_achievement.desc = _desc;
		_achievement.icon = _icon;
		_achievement.hidden = _hidden;
		_achievement.stat = _stat; // TODO: scr_stat.gml
		_achievement.callback = _callback;
		// _achievement.achieved = false;
		// if (self.achievements[$ _id] != undefined) {}
		self.achievements[$ _id] = _achievement;
		return _achievement;
	}

	/**
	 * This function removes an achievement from the achievements struct.
	 * @returns {Struct.Achievement}
	 * @param {String} id - The unique identifier of the achievement to remove.
	 */
	static remove = function(_id) {
		struct_remove(self.achievements, _id);
		return self;
	}

	/**
	 * This function returns true if the achievement is achieved, false otherwise.
	 * @returns {Bool}
	 * @param {String} id - The unique identifier of the achievement to check.
	 */
	static get = function(_id) {
		var _achievement = self.achievements[$ _id];
		if (_achievement == undefined) {
			throw new Error("Achievement not found: " + _id);
		}
		return _achievement.achieved;
	}

	/**
	 * This function sets the achievement as achieved and executes the callback.
	 * @returns {Struct.Achievement}
	 * @param {String} id - The unique identifier of the achievement to set.
	 */
	static set = function(_id) {
		var _achievement = self.achievements[$ _id];
		if (_achievement == undefined) {
			throw new Error("Achievement not found: " + _id);
		}
		if (_achievement.achieved) {
			return;
		}
		_achievement.achieved = true;
		// TODO: Queue the notification
		script_execute(_achievement.callback);
		return _achievement;
	}

	/**
	 * This function clears the achievement, setting it back to not achieved.
	 * @returns {Struct.Achievement}
	 * @param {String} id - The unique identifier of the achievement to clear.
	 */
	static clear = function(_id) {
		var _achievement = self.achievements[$ _id];
		if (_achievement == undefined) {
			throw new Error("Achievement not found: " + _id);
		}
		if (!_achievement.achieved) {
			return;
		}
		_achievement.achieved = false;
		return _achievement;
	}

	/**
	 * This function sets all achievements as achieved. Debugging purposes only.
	 * @returns {Struct.Achievement}
	 */
	static set_all = function() {
		var _id_array = struct_get_names(self.achievements);
		array_foreach(_id_array, function(_element, _index) {
			self.set(_element);
		});
		return self;
	}

	/**
	 * This function clears all achievements. Debugging purposes only.
	 * @returns {Struct.Achievement}
	 */
	static clear_all = function() {
		var _id_array = struct_get_names(self.achievements);
		array_foreach(_id_array, function(_element, _index) {
			self.clear(_element);
		});
		return self;
	}

	/**
	 * This function imports the achievements struct from a file in JSON format.
	 * @returns {Struct.Achievement}
	 * @param {String} fname - The filename to import from.
	 */
	static import = function(_fname) {
		var _struct = Struct.import(_fname);
		Struct.overwrite(_struct, achievements);
		delete _struct;
		return self;
	}

	/**
	 * This function exports the achievements struct to a file in JSON format.
	 * @returns {Struct.Achievement}
	 * @param {String} fname - The filename to export to.
	 */
	static export = function(_fname) {
		Struct.export(self.achievements, _fname);
		return self;
	}
}
