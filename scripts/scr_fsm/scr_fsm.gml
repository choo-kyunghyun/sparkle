new FSM();

/**
 * State struct for finite state machines.
 * @returns {Struct.StateStruct}
 */
function StateStruct() constructor {
    enter = noop;
    update = noop;
    leave = noop;
}

/**
 * Finite state machine constructor for actors.
 * @returns {Struct.FSM}
 */
function FSM() constructor {
    static machines = [];
    owner = noone;
    current_state = -1;
    states = {};

    /**
     * Creates a new FSM instance for the specified owner and returns it.
     * @returns {Struct.FSM}
     * @param {Id.Instance} _owner - The owner of the FSM, typically an actor.
     */
    static create = function(_owner) {
        var _fsm = new FSM();
        _fsm.owner = _owner;
        array_push(self.machines, _fsm);
        return _fsm;
    }

    /**
     * Updates finite state machine.
     * @returns {Undefined}
     */
    static update = function() {
        array_foreach(self.machines, function(_fsm) {
            if (_fsm.current_state != -1) {
                with (_fsm.owner) {
                    _fsm.states[$ _fsm.current_state].update();
                }
            }
        });
    }

    /**
     * This function adds a new state to the FSM.
     * @returns {Undefined}
     * @param {String} name - The name of the state to add.
     * @param {Struct} state_struct - The struct containing the state methods (enter, update, leave).
     */
    static add = function(_name, _state_struct) {
        self.states[_name] = _state_struct;
    }

    /**
     * Sets the current state of the FSM.
     * @returns {Undefined}
     * @param {String} _name - The name of the state to switch to.
     */
    static set = function(_name) {
        if (self.current_state != -1) {
            var _method = self.states[$ self.current_state].leave;
            with (self.owner) {
                _method();
            }
        }
        self.current_state = _name;
        if (self.current_state != -1) {
            var _method = self.states[$ self.current_state].enter;
            with (self.owner) {
                _method();
            }
        }
    }

    /**
     * Returns the current state of the FSM.
     * @returns {String} - The name of the current state.
     */
    static get = function() {
        return self.current_state;
    }
}
