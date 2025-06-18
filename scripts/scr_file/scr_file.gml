new File();

/**
 * File class for handling file operations. Cannot handle files larger than 2GB.
 * @returns {Struct.File}
 * @param {String} fname - The name of the file.
 */
function File() constructor {
    fname = "";
    buffer = -1;
    autosave = false;
    
    /**
     * This function will return true if the specified file exists and false if it does not.
     * @returns {Bool}
     * @param {String} fname - The name of the file to check.
     */
    static exists = function(_fname) {
        return file_exists(_fname);
    }
    
    /**
     * This function is used to create a new file with the specified name. If the file already exists, it will overwrite it.
     * @returns {Struct.File}
     * @param {String} fname - The name of the file to create.
     */
    static create = function(_fname) {
        var _file = new File();
        _file.fname = _fname;
        _file.buffer = buffer_create(0, buffer_grow, 1);
        return _file;
    }

    /**
     * This function is used to load a file into a buffer. If the file does not exist, it will throw an exception.
     * @returns {Struct.File}
     * @param {String} fname - The name of the file to load.
     */
    static load = function(_fname) {
        if (self.exists(_fname)) {
            var _file = new File();
            _file.fname = _fname;
            _file.buffer = buffer_load(_fname);
            if (_file.buffer == -1) {
                delete _file;
                throw new Error("Failed to load file: " + _fname);
            }
            return _file;
        } else {
            throw new Error("File does not exist: " + _fname);
        }
    }

    /**
     * This function is used to open a file with the specified mode. If the file does not exist, it will create a new file.
     * @returns {Struct.File}
     * @param {String} fname - The name of the file to open.
     * @param {String} mode - The mode to open the file in. Can be "read", "write", or "append".
     */
    static open = function(_fname, _mode) {
        if (self.exists(_fname) && _mode != "write") {
            var _file = self.load(_fname);
            if (_mode == "append") {
                _file.seek(buffer_seek_end, 0);
            }
            return _file;
        } else if (_mode == "read") {
            throw new Error("File does not exist: " + _fname);
        } else {
            return self.create(_fname);
        }
    }
    
    /**
     * This function is used to close the file, save its contents, and free the buffer.
     * @returns {Struct.File}
     */
    static close = function() {
        self.save();
        buffer_delete(self.buffer);
        self.buffer = -1;
        return self;
    }

    /**
     * This function is used to scan a directory for files matching a specific mask and attribute.
     * @returns {Array<String>}
     * @param {String} mask - The mask to match files against, e.g., "temp/*.doc".
     * @param {Constant.FileAttribute} attr - The attribute to filter files by, e.g., fa_readonly.
     */
    static scan = function(_mask, _attr) {
        var _files = [];
        var _fname = file_find_first(_mask, _attr);
        while (_fname != "") {
            array_push(_files, _fname);
            _fname = file_find_next();
        }
        file_find_close();
        return _files;
    }

    /**
     * This function can be used to read data from a buffer. The function will return the data read from the buffer.
     * @returns {Real|Bool|String}
     */
    static read = function() {
        return buffer_read(self.buffer, buffer_text);
    }

    /**
     * This function can be used to write data to a buffer. This function will return its own instance for method chaining.
     * @returns {Struct.File}
     * @param {Any} value - The value to write to the buffer.
     */
    static write = function(_value) {
        var _return = buffer_write(self.buffer, buffer_text, _value);
        if (_return != 0) {
            throw new Error("Failed to write to buffer: " + _return);
        }
        if (self.autosave) self.save();
        return self;
    }

    /**
     * This function is used to seek to a specific position in the buffer. The function will return the new seek position.
     * @returns {Real}
     * @param {Constant.SeekOffset} base - The base position to seek.
     * @param {Real} offset - The data offset value in bytes. Can be positive or negative.
     */
    static seek = function(_base, _offset) {
        return buffer_seek(self.buffer, _base, _offset);
    }

    /**
     * With this function you can save the contents of a buffer to a file.
     * @returns {Struct.File}
     */
    static save = function() {
        buffer_save(self.buffer, self.fname);
        return self;
    }

    /**
     * With this function you can compress the buffer using zlib compression.
     * @returns {Struct.File}
     */
    static compress = function() {
        var _buffer = buffer_compress(self.buffer, 0, buffer_get_size(self.buffer));
        if (_buffer == -1) {
            throw new Error("Failed to compress buffer.");
        }
        self.close();
        self.buffer = _buffer;
        return self;
    }

    /**
     * With this function you can decompress a previously compressed buffer using zlib compression.
     * @returns {Struct.File}
     */
    static decompress = function() {
        var _buffer = buffer_decompress(self.buffer);
        if (_buffer == -1) {
            throw new Error("Failed to decompress buffer.");
        }
        self.close();
        self.buffer = _buffer;
        return self;
    }
}
