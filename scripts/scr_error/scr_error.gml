/**
 * Error class for handling exceptions in the game.
 * @returns {Struct.Error}
 * @param {String} message - The error message.
 */
function Error(_message) constructor {
    message = _message;
    longMessage = _message;
    script = "";
    line = -1;
    stacktrace = debug_get_callstack();
}

/**
 * Logs the exception to the log file.
 * @param {Struct.Error} error - The exception to log.
 */
function error_log(_e) {
    Log.error($"{_e.stacktrace}: {_e.message}");
}
