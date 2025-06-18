function event_button_benchmark_choose(_room) {
    var _uily_benchmark = layer_get_id("uily_benchmark");
    layer_set_visible(_uily_benchmark, false);
    room_goto(_room);
}

function event_button_benchmark_back() {
    var _uily_benchmark = layer_get_id("uily_benchmark");
    layer_set_visible(_uily_benchmark, true);
    room_goto(rm_benchmark);
    
    Vertex.buffer_remove_all();
}

function event_benchmark_grass(_num, _depth) {
    repeat(_num) {
        Vertex.sprite_ext(spr_grass, 0, random(room_width), random(room_height), _depth, 1, 1, 0, 45, 0, make_color_rgb(irandom(255), irandom(255), irandom(255)), 1);
    }
}

function event_benchmark_apple(_sprite, _subimg, _num, _max_depth) {
    var _uvs = sprite_get_uvs(_sprite, _subimg);
    var _width = sprite_get_width(_sprite) * _uvs[6];
    var _height = sprite_get_height(_sprite) * _uvs[7];
    var _buffer = new VertexBuffer();
    
    _buffer.buffer = vertex_create_buffer();
    _buffer.texture = sprite_get_texture(_sprite, _subimg);
    _buffer.start(Vertex.format);
    
    repeat (_num) {
        var _x1 = random(room_width) + (_uvs[4] - sprite_get_xoffset(_sprite));
        var _y1 = random(room_height) + (_uvs[5] - sprite_get_yoffset(_sprite));
        var _x2 = _x1 + _width;
        var _y2 = _y1 + _height;
        var _z = random(_max_depth);
        var _color = make_color_rgb(irandom(255), irandom(255), irandom(255));
        
        var _vertex_top_left = [_x1, _y1, _z, 0, 0, 1, _color, 1, _uvs[0], _uvs[1]];
        var _vertex_top_right = [_x2, _y1, _z, 0, 0, 1, _color, 1, _uvs[2], _uvs[1]];
        var _vertex_bottom_right = [_x2, _y2, _z, 0, 0, 1, _color, 1, _uvs[2], _uvs[3]];
        var _vertex_bottom_left = [_x1, _y2, _z, 0, 0, 1, _color, 1, _uvs[0], _uvs[3]];
        var _vertices = [_vertex_top_left, _vertex_top_right, _vertex_bottom_right, _vertex_top_left, _vertex_bottom_right, _vertex_bottom_left];
        
        for (var _i = 0, _len = array_length(_vertices); _i < _len; _i++) {
            var _arr = _vertices[_i];
            vertex_position_3d(_buffer.buffer, _arr[0], _arr[1], _arr[2]);
            vertex_normal(_buffer.buffer, _arr[3], _arr[4], _arr[5]);
            vertex_color(_buffer.buffer, _arr[6], _arr[7]);
            vertex_texcoord(_buffer.buffer, _arr[8], _arr[9]);
        }
    }
    
    _buffer.finish();
    _buffer.freeze();
    return _buffer;
}

function event_benchmark_maze(_density, _allowdiag) {
    MotionPlanning.init(0, 0, room_width, room_height);
    MotionPlanning.clear_cost();

    var _grid = MotionPlanning.grid;
    var _rows = _grid.rows;
    var _cols = _grid.columns;

    for (var _r = 0; _r < _rows; _r++) {
        for (var _c = 0; _c < _cols; _c++) {
            var _node = _grid.get(_r, _c);
            _node.blocked = (random(1) < _density);
            _node.cost = 1;
        }
    }

    var _start_r, _start_c, _end_r, _end_c;
    var _node_s, _node_e;

    do {
        _start_r = irandom_range(0, _rows - 1);
        _start_c = irandom_range(0, _cols - 1);
        _node_s = _grid.get(_start_r, _start_c);
    } until (!_node_s.blocked);

    do {
        _end_r = irandom_range(0, _rows - 1);
        _end_c = irandom_range(0, _cols - 1);
        _node_e = _grid.get(_end_r, _end_c);
    } until (!_node_e.blocked && (_start_r != _end_r || _start_c != _end_c));
    
    var _start_pos = MotionPlanning.grid_to_world(_start_r, _start_c);
    var _end_pos = MotionPlanning.grid_to_world(_end_r, _end_c);
    var _path = MotionPlanning.path(_start_pos.x, _start_pos.y, _end_pos.x, _end_pos.y, false, true);
    
    Vertex.buffer_remove_all();
    for (var _r = 0; _r < MotionPlanning.grid.rows; _r++) {
        for (var _c = 0; _c < MotionPlanning.grid.columns; _c++) {
            var _pos = MotionPlanning.grid_to_world(_r, _c);
            var _node = MotionPlanning.grid.get(_r, _c);
    
            var _color = ((_c + _r) % 2) ? #828282 : #969696;
            if (_node.blocked) {
                _color = #FEDCBA;
            }
            Vertex.sprite_ext(spr_unit, 0, _pos.x, _pos.y, 1, 1, 1, 0, 0, 0, _color, 0.25);
        }
    }

    return {
        xstart: _start_pos.x,
        ystart: _start_pos.y,
        xend: _end_pos.x,
        yend: _end_pos.y,
        path: _path,
    };
}
