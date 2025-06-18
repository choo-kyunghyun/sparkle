new Grid();

/**
 * Grid class for managing a 2D grid structure.
 * @returns {Struct.Grid}
 */
function Grid() constructor {
    data = -1;
    rows = -1;
    columns = -1;

    /**
     * Creates a new Grid struct with the specified number of rows and columns.
     * @returns {Struct.Grid}
     * @param {Real} rows - The number of rows in the grid.
     * @param {Real} columns - The number of columns in the grid.
     */
    static create = function(_rows, _columns) {
        var _grid = new Grid();
        _grid.data = array_create(_rows);
        for (var _i = 0; _i < _rows; _i++) {
            _grid.data[_i] = array_create(_columns);
        }
        _grid.rows = _rows;
        _grid.columns = _columns;
        return _grid;
    }

    /**
     * This function will destroy the grid and free up memory.
     * @returns {Undefined}
     */
    static destroy = function() {
        for (var _i = 0, _len = array_length(self.data); _i < _len; _i++) {
            self.data[_i] = -1;
        }
        self.data = -1;
    }

    /**
     * This function is used to fill the grid with a specified value.
     * @returns {Struct.Grid}
     * @param {Any} value - The value to fill the grid with.
     */
    static fill = function(_value) {
        for (var _i = 0, _len = array_length(self.data); _i < _len; _i++) {
            var _row = self.data[_i];
            for (var _j = 0; _j < array_length(_row); _j++) {
                _row[_j] = _value;
            }
        }
        return self;
    }

    /**
     * This function will return the value at the specified row and column.
     * @returns {Any}
     * @param {Real} row - The row index of the value to retrieve.
     * @param {Real} column - The column index of the value to retrieve.
     */
    static get = function(_row, _column) {
        if (_row < 0 || _row >= self.rows || _column < 0 || _column >= self.columns) {
            throw new Error("Index out of bounds: (" + _row + ", " + _column + ")");
        }
        return self.data[_row][_column];
    }

    /**
     * This function will set the value at the specified row and column.
     * @returns {Struct.Grid}
     * @param {Real} row - The row index of the value to set.
     * @param {Real} column - The column index of the value to set.
     * @param {Any} value - The value to set at the specified row and column.
     */
    static set = function(_row, _column, _value) {
        if (_row < 0 || _row >= self.rows || _column < 0 || _column >= self.columns) {
            throw new Error("Index out of bounds: (" + _row + ", " + _column + ")");
        }
        self.data[_row][_column] = _value;
        return self;
    }

    /**
     * This function will convert the grid to a string representation.
     * @returns {String}
     */
    static toString = function() {
        var _output = "";
        for (var _i = 0, _len = array_length(self.data); _i < _len; _i++) {
            var _row = self.data[_i];
            _output += string(_row) + "\n";
        }
        return _output;
    }

    /**
     * This function will create a copy of the grid.
     * @returns {Struct.Grid}
     */
    static copy = function() {
        var _grid = new Grid();
        _grid.rows = self.rows;
        _grid.columns = self.columns;
        _grid.data = array_create(self.rows);
        for (var _i = 0; _i < self.rows; _i++) {
            _grid.data[_i] = array_create(self.columns);
            array_copy(_grid.data[_i], 0, self.data[_i], 0, self.columns);
        }
        return _grid;
    }
}
