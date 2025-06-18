new Struct();

/**
 * Struct class for handling struct operations in the game.
 * @returns {Struct.Struct}
 */
function Struct() constructor {
    /**
     * This function is used to overwrite the contents of one struct with another.
     * @returns {Undefined}
     * @param {Struct} src - The source struct to merge from.
     * @param {Struct} dest - The destination struct to merge into.
     */
    static overwrite = function(_src, _dest) {
        var _names = struct_get_names(_src);
        for (var _i = 0, _len = array_length(_names); _i < _len; _i++) {
            var _name = _names[_i];
            var _value = struct_get(_src, _name);
            if (struct_exists(_dest, _name)) {
                var _src_sub = struct_get(_src, _name);
                var _dest_sub = struct_get(_dest, _name);
                if (is_struct(_src_sub) && is_struct(_dest_sub)) {
                    self.overwrite(_src_sub, _dest_sub);
                } else {
                    struct_set(_dest, _name, _value);
                }
            } else {
                struct_set(_dest, _name, _value);
            }
        }
    }

    /**
     * This function will make a new struct with the contents of the source struct.
     * Deep copying is performed, meaning that nested structs are also copied.
     * @returns {Struct}
     * @param {Struct} struct - The struct to duplicate.
     */
    static duplicate = function(_struct) {
        var _copy = {};
        var _names = struct_get_names(_struct);
        for (var _i = 0, _len = array_length(_names); _i < _len; _i++) {
            var _name = _names[_i];
            var _value = struct_get(_struct, _name);
            if (is_struct(_value)) {
                struct_set(_copy, _name, self.duplicate(_value));
            } else if (is_array(_value)) {
                var _arr = [];
                for (var _j = 0; _j < array_length(_value); _j++) {
                    var _elem = _value[_j];
                    if (is_struct(_elem)) {
                        array_push(_arr, self.duplicate(_elem));
                    } else {
                        array_push(_arr, _elem);
                    }
                }
                struct_set(_copy, _name, _arr);
            } else {
                struct_set(_copy, _name, _value);
            }
        }
        return _copy;
    }

    /**
     * This function exports a struct to a file in JSON format.
     * @returns {Undefined}
     * @param {Struct} struct - The struct to export.
     * @param {String} fname - The filename to export to.
     */
    static export = function(_struct, _fname) {
        var _file = File.open(_fname, "write").write(json_stringify(_struct)).close();
        delete _file;
    }

    /**
     * This function exports a struct to a compressed file in JSON format.
     * @returns {Undefined}
     * @param {Struct} struct - The struct to export.
     * @param {String} fname - The filename to export to.
     */
    static export_compressed = function(_struct, _fname) {
        var _file = File.open(_fname, "write").write(json_stringify(_struct)).compress().close();
        delete _file;
    }

    /**
     * This function imports a struct from a file in JSON format.
     * @returns {Struct}
     * @param {String} fname - The filename to import from.
     */
    static import = function(_fname) {
        var _file = File.open(_fname, "read");
        var _data = json_parse(_file.read());
        _file.close();
        delete _file;
        return _data;
    }

    /**
     * This function imports a struct from a compressed file in JSON format.
     * @returns {Struct}
     * @param {String} fname - The filename to import from.
     */
    static import_compressed = function(_fname) {
        var _file = File.open(_fname, "read");
        var _data = json_parse(_file.decompress().read());
        _file.close();
        delete _file;
        return _data;
    }
}
