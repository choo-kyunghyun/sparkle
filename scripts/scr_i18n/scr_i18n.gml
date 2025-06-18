new i18n();

/**
 * Internationalization (i18n) constructor.
 * This constructor is not fully met true i18n standards,
 * but serves as a placeholder for future i18n functionality.
 * Currently, it only provides basic language management.
 * Region is not supported yet.
 * Note: Datetime formatting is provided by engine(GameMaker) itself.
 * @returns {Struct.i18n}
 */
function i18n() constructor {
    static default_lang = "en";
    static current_lang = "en";
    static i18n_directory = "i18n/";

    static messages = {};


    // TODO: i18n should be able to load sprites and sounds based on language and region.
    
    call_later(1, time_source_units_frames, function() {
        self.load("i18n/en.json", "en");
    });


    /**
     * Loads messages from a file for the specified language.
     * @returns {Struct.i18n}
     * @param {String} fname - The name of the file containing messages.
     * @param {String} lang - The language code for the messages.
     */
    static load = function(_fname, _lang) {
        var _struct = Struct.import(_fname);
        self.messages[$ _lang] = _struct;
        return self;
    }

    /**
     * Retrieves a message by key for the current language.
     * @returns {String}
     * @param {String} key - The key for the message to retrieve.
     */
    static get = function(_key) {
        var _struct = self.messages[$ self.current_lang];
        if (_struct == undefined) {
            _struct = self.messages[$ self.default_lang];
            if (_struct == undefined) {
                return _key;
            }
        }
        var _msg = _struct[$ _key];
        if (_msg == undefined) {
            return _key;
        }
        return _msg;
    }

    /**
     * Sets the current language.
     * @returns {Struct.i18n}
     * @param {String} lang - The language code to set as current.
     */
    static set = function(_lang) {
        self.current_lang = _lang;
        return self;
    }
}
