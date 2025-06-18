new Log();

/**
 * Logging utility for the game.
 * This script provides a simple logging mechanism to write messages to a log file.
 * It supports different log levels such as INFO, WARN, and ERROR.
 * @returns {Struct.Log}
 */
function Log() constructor {
    static file = File.open("logs/latest.log", "write");
    self.file.autosave = true;
    
    /**
     * Closes the log file.
     * @returns {Undefined}
     */
    static close = function() {
        self.file.save();
        self.file.close();
        delete self.file;
    }

    /**
     * Logs a message to the log file and outputs it to the debug console.
     * @returns {Undefined}
     * @param {String} msg - The message to log.
     */
    static log = function(_msg) {
        self.file.write(_msg + "\n");
        show_debug_message(_msg);
    }

    /**
     * Formats the log message with a timestamp and log level.
     * @returns {String}
     * @param {String} msg - The message to format.
     * @param {String} level - The log level (INFO, WARN, ERROR).
     */
    static log_format = function(_msg, _level) {
        var _formatted_msg = $"[{date_datetime_string(date_current_datetime())}] [{_level}] {_msg}";
        self.log(_formatted_msg);
    }

    /**
     * Logs an informational message.
     * @returns {Undefined}
     * @param {String} msg - The message to log.
     */
    static info = function(_msg) {
        self.log_format(_msg, "INFO");
    }

    /**
     * Logs a warning message.
     * @returns {Undefined}
     * @param {String} msg - The message to log.
     */
    static warn = function(_msg) {
        self.log_format(_msg, "WARN");
    }

    /**
     * Logs an error message.
     * @returns {Undefined}
     * @param {String} msg - The message to log.
     */
    static error = function(_msg) {
        self.log_format(_msg, "ERROR");
    }
}
