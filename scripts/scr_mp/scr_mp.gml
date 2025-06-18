new MotionPlanning();

/**
 * MotionPlanning class for custom A* pathfinding and grid management.
 * @returns {Struct.MotionPlanning}
 */
function MotionPlanning() constructor {
    static x = 0;
    static y = 0;
    static width = 0;
    static height = 0;
    static cell_width = 16;
    static cell_height = 16;
    static sqrt2 = sqrt(2);

    static obstacles = [obj_wall];
    static grid = -1;

    /**
     * Calculates the distance between two points using the Manhattan distance formula.
     * @returns {Real}
     * @param {Real} x1 - The x-coordinate of the first point.
     * @param {Real} y1 - The y-coordinate of the first point.
     * @param {Real} x2 - The x-coordinate of the second point.
     * @param {Real} y2 - The y-coordinate of the second point.
     */
    static manhattan_distance = function(_x1, _y1, _x2, _y2) {
        return abs(_x1 - _x2) + abs(_y1 - _y2);
    }

    /**
     * Calculates the distance between two points using the Euclidean distance formula.
     * @returns {Real}
     * @param {Real} x1 - The x-coordinate of the first point.
     * @param {Real} y1 - The y-coordinate of the first point.
     * @param {Real} x2 - The x-coordinate of the second point.
     * @param {Real} y2 - The y-coordinate of the second point.
     */
    static euclidean_distance = function(_x1, _y1, _x2, _y2) {
        return point_distance(_x1, _y1, _x2, _y2);
    }

    /**
     * Calculates the diagonal distance between two points.
     * @returns {Real}
     * @param {Real} x1 - The x-coordinate of the first point.
     * @param {Real} y1 - The y-coordinate of the first point.
     * @param {Real} x2 - The x-coordinate of the second point.
     * @param {Real} y2 - The y-coordinate of the second point.
     */
    static diagonal_distance = function(_x1, _y1, _x2, _y2) {
        var _dx = abs(_x1 - _x2);
        var _dy = abs(_y1 - _y2);
        return max(_dx, _dy) + (self.sqrt2 - 1) * min(_dx, _dy);
    }

    /**
     * Initializes the MotionPlanning grid with specified dimensions.
     * @returns {Struct.MotionPlanning}
     * @param {Real} x - The x-coordinate of the grid's top-left corner.
     * @param {Real} y - The y-coordinate of the grid's top-left corner.
     * @param {Real} width - The width of the room.
     * @param {Real} height - The height of the room.
     */
    static init = function(_x, _y, _width, _height) {
        self.x = _x;
        self.y = _y;
        self.width = _width;
        self.height = _height;

        var _rows = _height div self.cell_height;
        var _columns = _width div self.cell_width;
        self.grid = Grid.create(_rows, _columns);

        for (var _r = 0; _r < _rows; _r++) {
            for (var _c = 0; _c < _columns; _c++) {
                self.grid.set(_r, _c, {
                    g_cost: infinity,
                    h_cost: infinity,
                    f_cost: infinity,
                    parent: undefined,
                    blocked: false,
                    cost: 1,
                });
            }
        }
        return self;
    }

    /**
     * Clears the cost values in the grid.
     * @returns {Struct.MotionPlanning}
     */
    static clear_cost = function() {
        if (self.grid != -1) {
            for (var _r = 0; _r < self.grid.rows; _r++) {
                for (var _c = 0; _c < self.grid.columns; _c++) {
                    var _node = self.grid.get(_r, _c);
                    _node.g_cost = infinity;
                    _node.h_cost = infinity;
                    _node.f_cost = infinity;
                    _node.parent = undefined;
                }
            }
        }
        return self;
    }

    /**
     * Destroys the grid and frees up memory.
     * @returns {Struct.MotionPlanning}
     */
    static destroy = function() {
        if (self.grid != -1) {
            self.grid.destroy();
            self.grid = -1;
        }
        return self;
    }

    /**
     * Converts world coordinates to grid coordinates.
     * This function calculates the row and column indices based on the world coordinates.
     * Returns a struct containing the row and column indices.
     * @returns {Struct}
     * @param {Real} x - The x-coordinate in world space.
     * @param {Real} y - The y-coordinate in world space.
     */
    static world_to_grid = function(_x, _y) {
        var _row = floor((_y - self.y) / self.cell_height);
        var _column = floor((_x - self.x) / self.cell_width);
        return {row: _row, column: _column};
    }

    /**
     * Converts grid coordinates to world coordinates.
     * This function calculates the world position based on the row and column indices.
     * Returns a struct containing the x and y coordinates in world space.
     * @returns {Struct}
     * @param {Real} row - The row index in the grid.
     * @param {Real} column - The column index in the grid.
     */
    static grid_to_world = function(_row, _column) {
        var _x = self.x + _column * self.cell_width;
        var _y = self.y + _row * self.cell_height;
        return {x: _x, y: _y};
    }

    /**
     * Converts grid coordinates to the center of the cell in world coordinates.
     * This function calculates the center position of the cell based on the row and column indices.
     * Returns a struct containing the x and y coordinates of the cell center in world space.
     * @returns {Struct}
     * @param {Real} row - The row index in the grid.
     * @param {Real} column - The column index in the grid.
     */
    static grid_to_world_center = function(_row, _column) {
        var _world_pos = self.grid_to_world(_row, _column);
        _world_pos.x += self.cell_width / 2;
        _world_pos.y += self.cell_height / 2;
        return _world_pos;
    }

    /**
     * Finds a path from a start point to an end point using the A* algorithm.
     * returns {Array<Struct>}
     * @param {Real} xstart - The x-coordinate of the starting point.
     * @param {Real} ystart - The y-coordinate of the starting point.
     * @param {Real} xgoal - The x-coordinate of the ending point.
     * @param {Real} ygoal - The y-coordinate of the ending point.
     * @param {Bool} allowdiag - Indicates whether diagonal moves are allowed instead of just horizontal or vertical.
     * @param {Bool} centered - Indicates whether the path should be centered on the grid cells.
     */
    static path = function(_xstart, _ystart, _xgoal, _ygoal, _allowdiag, _centered) {
        // BUG: Sometimes the path is not shortest. Something is wrong with the cost calculation. We need to implement own priority queue and not use ds_priority.
        var _start = self.world_to_grid(_xstart, _ystart);
        var _end = self.world_to_grid(_xgoal, _ygoal);

        if (_start.row < 0 || _start.row >= self.grid.rows || _start.column < 0 || _start.column >= self.grid.columns ||
            _end.row < 0 || _end.row >= self.grid.rows || _end.column < 0 || _end.column >= self.grid.columns) {
            return [];
        }

        self.clear_cost();
        var _open_set = ds_priority_create();
        var _closed_set = Grid.create(self.grid.rows, self.grid.columns).fill(false);

        var _start_node = self.grid.get(_start.row, _start.column);
        _start_node.g_cost = 0;
        if (_allowdiag) {
            _start_node.h_cost = self.diagonal_distance(_xstart, _ystart, _xgoal, _ygoal);
        } else {
            _start_node.h_cost = self.manhattan_distance(_xstart, _ystart, _xgoal, _ygoal);
        }
        _start_node.f_cost = _start_node.g_cost + _start_node.h_cost;
        ds_priority_add(_open_set, _start, _start_node.f_cost);

        var _found = false;
        while (!ds_priority_empty(_open_set)) {
            var _current = ds_priority_delete_min(_open_set);
            var _current_node = self.grid.get(_current.row, _current.column);
            
            if (_closed_set.get(_current.row, _current.column)) {
                continue;
            }
            _closed_set.set(_current.row, _current.column, true);

            if (_current.row == _end.row && _current.column == _end.column) {
                _found = true;
                break;
            }

            for (var _r = -1; _r <= 1; _r++) {
                for (var _c = -1; _c <= 1; _c++) {
                    if (_r == 0 && _c == 0) continue;
                    if (!_allowdiag && _r != 0 && _c != 0) continue;

                    var _neighbor_row = _current.row + _r;
                    var _neighbor_column = _current.column + _c;

                    if (_neighbor_row < 0 || _neighbor_row >= self.grid.rows || 
                        _neighbor_column < 0 || _neighbor_column >= self.grid.columns) {
                        continue;
                    }

                    var _neighbor_node = self.grid.get(_neighbor_row, _neighbor_column);
                    if (_neighbor_node.blocked || _closed_set.get(_neighbor_row, _neighbor_column)) {
                        continue;
                    }

                    var _move_cost = _neighbor_node.cost;
                    if (_allowdiag && _r != 0 && _c != 0) {
                        _move_cost *= self.sqrt2;
                    }

                    var _tentative_g_cost = _current_node.g_cost + _move_cost;
                    if (_tentative_g_cost < _neighbor_node.g_cost) {
                        _neighbor_node.parent = {row: _current.row, column: _current.column};
                        _neighbor_node.g_cost = _tentative_g_cost;
                        
                        var _neighbor_world_pos = self.grid_to_world(_neighbor_row, _neighbor_column);
                        if (_allowdiag) {
                            _neighbor_node.h_cost = self.diagonal_distance(_neighbor_world_pos.x, _neighbor_world_pos.y, _xgoal, _ygoal);
                        } else {
                            _neighbor_node.h_cost = self.manhattan_distance(_neighbor_world_pos.x, _neighbor_world_pos.y, _xgoal, _ygoal);
                        }
                        _neighbor_node.f_cost = _neighbor_node.g_cost + _neighbor_node.h_cost;
                        ds_priority_add(_open_set, {row: _neighbor_row, column: _neighbor_column}, _neighbor_node.f_cost);
                    }
                }
            }
        }
        ds_priority_destroy(_open_set);
        _closed_set.destroy();

        if (!_found) {
            return [];
        }
        var _path = [];
        var _current = {row: _end.row, column: _end.column};
        while (_current != undefined) {
            var _world_pos;
            if (_centered) {
                _world_pos = self.grid_to_world_center(_current.row, _current.column);
            } else {
                _world_pos = self.grid_to_world(_current.row, _current.column);
            }
            array_push(_path, _world_pos);
            _current = self.grid.get(_current.row, _current.column).parent;
        }
        array_reverse(_path);
        return _path;
    }
}
