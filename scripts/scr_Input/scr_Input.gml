new Input();

/**
 * Input class for managing input bindings and actions.
 * @returns {Struct.Input}
 */
function Input() constructor {
    static binds = {};
    static sensitivity = 2.5;

    /**
     * Binds an action to an input ID.
     * @returns {Struct.Input}
     * @param {String} id - The identifier for the input action.
     * @param {Function} action - The function that returns true if the action is triggered.
     */
    static bind = function(_id, _action) {
        self.binds[$ _id] = _action;
        return self;
    }

    /**
     * Unbinds an action from an input ID.
     * @returns {Struct.Input}
     * @param {String} id - The identifier for the input action to unbind.
     */
    static unbind = function(_id) {
        struct_remove(self.binds, _id);
        return self;
    }

    /**
     * Checks an action by its ID.
     * @returns {Bool}
     * @param {String} id - The identifier for the input action to check.
     */
    static check = function(_id) {
        if (self.binds[$ _id] == undefined) {
            throw new Error("Action " + _id + " not bound.");
        }
        return self.binds[$ _id]();
    }

    /**
     * Imports input bindings from a file.
     * @returns {Struct.Input}
     * @param {String} fname - The name of the file to import bindings from.
     */
    static import = function(_fname) {
        var _struct = Struct.import(_fname);
        if (is_struct(_struct)) {
            delete self.binds;
            self.binds = _struct;
        } else {
            throw new Error("Import failed.");
        }
        return self;
    }

    /**
     * Exports input bindings to a file.
     * @returns {Struct.Input}
     * @param {String} fname - The name of the file to export bindings to.
     */
    static export = function(_fname) {
        Struct.export(self.binds, _fname);
        return self;
    }
}
