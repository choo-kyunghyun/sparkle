new Vertex();

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_color();
vertex_format_add_texcoord();
Vertex.format = vertex_format_end();

/**
 * Vertex buffer class
 * @returns {Struct.VertexBuffer}
 */
function VertexBuffer() constructor {
	buffer = -1;
	texture = -1;
	primitive = pr_trianglelist;
	zfunc = cmpfunc_lessequal;
	active = false;
	frozen = false;

	/**
	 * This function is used to delete the vertex buffer.
	 * @returns {Undefined}
	 */
	static destroy = function() {
		vertex_delete_buffer(self.buffer);
		self.buffer = -1;
	}

	/**
	 * This function is used to begin the vertex buffer.
	 * @returns {Struct.VertexBuffer}
	 * @param {Id.VertexFormat} format - The format of the vertex buffer.
	 */
	static start = function(_format) {
		vertex_begin(self.buffer, _format);
		self.active = true;
		return self;
	}

	/**
	 * This function is used to end the vertex buffer.
	 * @returns {Struct.VertexBuffer}
	 */
	static finish = function() {
		if (self.active) {
			vertex_end(self.buffer);
			self.active = false;
		}
		return self;
	}

	/**
	 * This function will submit the vertex buffer to the GPU.
	 * @returns {Struct.VertexBuffer}
	 */
	static submit = function() {
		self.finish();
		gpu_set_zfunc(self.zfunc);
		vertex_submit(self.buffer, self.primitive, self.texture);
		return self;
	}

	/**
	 * This function is used to freeze the vertex buffer.
	 * @returns {Struct.VertexBuffer}
	 */
	static freeze = function() {
		if (self.frozen) {
			return self;
		}
		if (vertex_get_number(self.buffer) == 0) {
			return self;
		}
		if (self.active) {
			self.finish();
		}
		if (vertex_freeze(self.buffer) == -1) {
			return self;
		}
		self.frozen = true;
		return self;
	}

	/**
	 * This function will return vertex buffer as a normal buffer. It will allow you to export the vertex buffer to a file.
	 * @returns {Id.Buffer}
	 */
	static export = function() {

	}
}

/**
 * Vertex class for handling vertex operations.
 * @returns {Struct.Vertex}
 */
function Vertex() constructor {
	static format = -1;
	static buffers = [];
	static primitive = pr_trianglelist;
	static inspector = {
		buffer_num: 0,
	}

	static inspector_update = function() {
		self.inspector.buffer_num = array_length(self.buffers);
	}

	/**
	 * This function is used to delete the vertex format and buffers.
	 * @returns {Undefined}
	 */
	static destroy = function() {
		vertex_format_delete(self.format);
		array_foreach(self.buffers, function(_buffer, _index) {
			_buffer.destroy();
			delete _buffer;
		});
	}

	/**
	 * This function is used to get a vertex buffer with the specified texture and z-function.
	 * If a buffer with the same texture and z-function already exists, it will return that buffer.
	 * If not, it will create a new buffer and return it.
	 * @returns {Struct.VertexBuffer}
	 * @param {Pointer.Texture} texture - The texture to use for the buffer.
	 * @param {Constant.ZFunction} zfunc - The z-function to use for the buffer.
	 * @param {Bool} include_frozen - If true, it will include frozen buffers in the search.
	 */
	static buffer_get = function(_texture, _zfunc = cmpfunc_lessequal, _include_frozen = false) {
		for (var _i = 0, _len = array_length(self.buffers); _i < _len; _i++) {
			if (self.buffers[_i].texture == _texture && self.buffers[_i].zfunc == _zfunc) {
				if (!_include_frozen && self.buffers[_i].frozen) {
					continue;
				}
				return self.buffers[_i];
			}
		}
		var _buffer = new VertexBuffer();
		_buffer.buffer = vertex_create_buffer();
		_buffer.primitive = self.primitive;
		_buffer.texture = _texture;
		_buffer.zfunc = _zfunc;
		array_push(self.buffers, _buffer);
		return _buffer;
	}
	
	/**
	 * This function will submit all vertex buffers to the GPU.
	 * @returns {Struct.Vertex}
	 */
	static buffer_submit_all = function() {
		var _zfunc = gpu_get_zfunc();
		array_foreach(self.buffers, function(_buffer, _index) {
			_buffer.submit();
		});
		gpu_set_zfunc(_zfunc);
		return self;
	}

	/**
	 * This function will freeze all vertex buffers.
	 * @returns {Struct.Vertex}
	 */
	static buffer_freeze_all = function() {
		array_foreach(self.buffers, function(_buffer, _index) {
			_buffer.freeze();
		});
		return self;
	}

	/**
	 * This function will remove all vertex buffers and destroy them.
	 * @returns {Struct.Vertex}
	 */
	static buffer_remove_all = function() {
		array_foreach(self.buffers, function(_buffer, _index) {
			_buffer.destroy();
			delete _buffer;
		});
		self.buffers = [];
		return self;
	}

	/**
	 * This function will return the index of the specified buffer in the buffers array.
	 * If the buffer is not found, it will return undefined.
	 * @returns {Real|Undefined}
	 */
	static buffer_get_index = function(_buffer) {
		// TODO: Use array_find_index() instead of this loop.
		for (var _i = 0, _len = array_length(self.buffers); _i < _len; _i++) {
			if (self.buffers[_i] == _buffer) {
				return _i;
			}
		}
		return undefined;
	}

	/**
	 * This function will remove the specified buffer from the buffers array and destroy it.
	 * @returns {Struct.Vertex}
	 * @param {Struct.VertexBuffer} buffer - The buffer to remove.
	 */
	static buffer_remove = function(_buffer) {
		var _index = self.buffer_get_index(_buffer);
		if (_index != undefined) {
			array_delete(self.buffers, _index, 1);
			_buffer.destroy();
			delete _buffer;
		}
		return self;
	}

	/**
	 * This function is used to rotate a vertex around the specified point.
	 * This one rotates around the Y-axis.
	 * @returns {Struct.Vertex}
	 * @param {Real} rot - The rotation in degrees.
	 * @param {Real} x - The X coordinate of the point to rotate around.
	 * @param {Real} z - The Z coordinate of the point to rotate around.
	 */
	static rotate_y = function(_rot, _x, _z) {
		var _sin = dsin(_rot);
		var _cos = dcos(_rot);
		var _dx = self.x - _x;
		var _dz = self.z - _z;
		self.x = _x + _dx * _cos - _dz * _sin;
		self.z = _z + _dx * _sin + _dz * _cos;
		return self;
	}

	/**
	 * This function is used to rotate a vertex around the specified point.
	 * This one rotates around the X-axis.
	 * @returns {Struct.Vertex}
	 * @param {Real} rot - The rotation in degrees.
	 * @param {Real} y - The Y coordinate of the point to rotate around.
	 * @param {Real} z - The Z coordinate of the point to rotate around.
	 */
	static rotate_x = function(_rot, _y, _z) {
		var _sin = dsin(_rot);
		var _cos = dcos(_rot);
		var _dy = self.y - _y;
		var _dz = self.z - _z;
		self.y = _y + _dy * _cos - _dz * _sin;
		self.z = _z + _dy * _sin + _dz * _cos;
		return self;
	}

	/**
	 * This function is used to rotate a vertex around the specified point.
	 * This one rotates around the Z-axis.
	 * @returns {Struct.Vertex}
	 * @param {Real} rot - The rotation in degrees.
	 * @param {Real} x - The X coordinate of the point to rotate around.
	 * @param {Real} y - The Y coordinate of the point to rotate around.
	 */
	static rotate_z = function(_rot, _x, _y) {
		var _sin = -dsin(_rot);
		var _cos = dcos(_rot);
		var _dx = self.x - _x;
		var _dy = self.y - _y;
		self.x = _x + _dx * _cos - _dy * _sin;
		self.y = _y + _dx * _sin + _dy * _cos;
		return self;
	}

	/**
	 * This function is used to rotate a vertex around the specified point.
	 * It rotates around all three axes in the order of yaw, pitch, and roll.
	 * @returns {Struct.Vertex}
	 * @param {Real} yaw - The yaw rotation in degrees.
	 * @param {Real} pitch - The pitch rotation in degrees.
	 * @param {Real} roll - The roll rotation in degrees.
	 * @param {Real} x - The X coordinate of the point to rotate around.
	 * @param {Real} y - The Y coordinate of the point to rotate around.
	 * @param {Real} z - The Z coordinate of the point to rotate around.
	 */
	static rotate = function(_yaw, _pitch, _roll, _x, _y, _z) {
		if (_yaw != 0) self.rotate_y(_yaw, _x, _z);
		if (_pitch != 0) self.rotate_x(_pitch, _y, _z);
		if (_roll != 0) self.rotate_z(_roll, _x, _y);
		return self;
	}

	/**
	 * This function is used to create a new vertex with the specified parameters.
	 * @returns {Struct.Vertex}
	 * @param {Real} x - The X coordinate of the vertex.
	 * @param {Real} y - The Y coordinate of the vertex.
	 * @param {Real} z - The Z coordinate of the vertex.
	 * @param {Real} nx - The X component of the normal vector.
	 * @param {Real} ny - The Y component of the normal vector.
	 * @param {Real} nz - The Z component of the normal vector.
	 * @param {Real} color - The color of the vertex.
	 * @param {Real} alpha - The alpha value of the vertex.
	 * @param {Real} u - The U texture coordinate of the vertex.
	 * @param {Real} v - The V texture coordinate of the vertex.
	 */
	static vertex = function(_x, _y, _z, _nx, _ny, _nz, _color, _alpha, _u, _v) {
		var _vertex = new Vertex();
		_vertex.x = _x;
		_vertex.y = _y;
		_vertex.z = _z;
		_vertex.nx = _nx;
		_vertex.ny = _ny;
		_vertex.nz = _nz;
		_vertex.color = _color;
		_vertex.alpha = _alpha;
		_vertex.u = _u;
		_vertex.v = _v;
		return _vertex;
	}

	static vertex2 = function(_x, _y, _z, _nx, _ny, _nz, _color, _alpha, _u, _v) {
		return [_x, _y, _z, _nx, _ny, _nz, _color, _alpha, _u, _v];
	}

	static rotate2 = function(_arr, _x, _y, _z, _yaw, _pitch, _roll) {
		if (_yaw != 0) {
			var _sin = dsin(_yaw);
			var _cos = dcos(_yaw);
			var _dx = _arr[0] - _x;
			var _dz = _arr[2] - _z;
			_arr[0] = _x + _dx * _cos - _dz * _sin;
			_arr[2] = _z + _dx * _sin + _dz * _cos;
		}
		if (_pitch != 0) {
			var _sin = dsin(_pitch);
			var _cos = dcos(_pitch);
			var _dy = _arr[1] - _y;
			var _dz = _arr[2] - _z;
			_arr[1] = _y + _dy * _cos - _dz * _sin;
			_arr[2] = _z + _dy * _sin + _dz * _cos;
		}
		if (_roll != 0) {
			var _sin = dsin(_roll);
			var _cos = dcos(_roll);
			var _dx = _arr[0] - _x;
			var _dy = _arr[1] - _y;
			_arr[0] = _x + _dx * _cos - _dy * _sin;
			_arr[1] = _y + _dx * _sin + _dy * _cos;
		}
		return _arr;
	}

	static add2 = function(_buffer, _arr) {
		if (!_buffer.active) {
			_buffer.start(self.format);
		}
		vertex_position_3d(_buffer.buffer, _arr[0], _arr[1], _arr[2]);
		vertex_normal(_buffer.buffer, _arr[3], _arr[4], _arr[5]);
		vertex_color(_buffer.buffer, _arr[6], _arr[7]);
		vertex_texcoord(_buffer.buffer, _arr[8], _arr[9]);
		return _buffer;
	}

	/**
	 * This function is used to add a vertex to the specified buffer.
	 * @returns {Struct.VertexBuffer}
	 * @param {Struct.VertexBuffer} buffer - The buffer to add the vertex to.
	 */
	static add = function(_buffer) {
		if (!_buffer.active) {
			_buffer.start(self.format);
		}
		vertex_position_3d(_buffer.buffer, self.x, self.y, self.z);
		vertex_normal(_buffer.buffer, self.nx, self.ny, self.nz);
		vertex_color(_buffer.buffer, self.color, self.alpha);
		vertex_texcoord(_buffer.buffer, self.u, self.v);
		return _buffer;
	}

	/**
	 * This function is replacement of draw_sprite_ext. It will add a sprite to the vertex buffer with the specified parameters.
	 * @returns {Struct.VertexBuffer}
	 * @param {Asset.GMSprite} sprite - The sprite to add.
	 * @param {Real} subimg - The subimage of the sprite to add.
	 * @param {Real} x - The X coordinate of the sprite.
	 * @param {Real} y - The Y coordinate of the sprite.
	 * @param {Real} z - The Z coordinate of the sprite.
	 * @param {Real} xscale - The X scale of the sprite.
	 * @param {Real} yscale - The Y scale of the sprite.
	 * @param {Real} yaw - The yaw rotation of the sprite.
	 * @param {Real} pitch - The pitch rotation of the sprite.
	 * @param {Real} roll - The roll rotation of the sprite.
	 * @param {Real} c1 - The color of the top-left vertex.
	 * @param {Real} c2 - The color of the top-right vertex.
	 * @param {Real} c3 - The color of the bottom-right vertex.
	 * @param {Real} c4 - The color of the bottom-left vertex.
	 * @param {Real} alpha - The alpha value of the sprite.
	 */
	static sprite_ext_color = function(_sprite, _subimg, _x, _y, _z, _xscale, _yscale, _yaw, _pitch, _roll, _c1, _c2, _c3, _c4, _alpha) {
		var _uvs = sprite_get_uvs(_sprite, _subimg);
		var _tex = sprite_get_texture(_sprite, _subimg);
		var _width = sprite_get_width(_sprite) * _uvs[6] * _xscale;
		var _height = sprite_get_height(_sprite) * _uvs[7] * _yscale;
		var _buffer = self.buffer_get(_tex);

		var _x1 = _x + (_uvs[4] - sprite_get_xoffset(_sprite)) * _xscale;
		var _y1 = _y + (_uvs[5] - sprite_get_yoffset(_sprite)) * _yscale;
		var _x2 = _x1 + _width;
		var _y2 = _y1 + _height;

		// var _vertex_top_left = self.vertex(_x1, _y1, _z, 0, 0, 1, _c1, _alpha, _uvs[0], _uvs[1]);
		// var _vertex_top_right = self.vertex(_x2, _y1, _z, 0, 0, 1, _c2, _alpha, _uvs[2], _uvs[1]);
		// var _vertex_bottom_right = self.vertex(_x2, _y2, _z, 0, 0, 1, _c3, _alpha, _uvs[2], _uvs[3]);
		// var _vertex_bottom_left = self.vertex(_x1, _y2, _z, 0, 0, 1, _c4, _alpha, _uvs[0], _uvs[3]);
		// var _vertex_top_left = self.vertex2(_x1, _y1, _z, 0, 0, 1, _c1, _alpha, _uvs[0], _uvs[1]);
		// var _vertex_top_right = self.vertex2(_x2, _y1, _z, 0, 0, 1, _c2, _alpha, _uvs[2], _uvs[1]);
		// var _vertex_bottom_right = self.vertex2(_x2, _y2, _z, 0, 0, 1, _c3, _alpha, _uvs[2], _uvs[3]);
		// var _vertex_bottom_left = self.vertex2(_x1, _y2, _z, 0, 0, 1, _c4, _alpha, _uvs[0], _uvs[3]);
		var _vertex_top_left = [_x1, _y1, _z, 0, 0, 1, _c1, _alpha, _uvs[0], _uvs[1]];
		var _vertex_top_right = [_x2, _y1, _z, 0, 0, 1, _c2, _alpha, _uvs[2], _uvs[1]];
		var _vertex_bottom_right = [_x2, _y2, _z, 0, 0, 1, _c3, _alpha, _uvs[2], _uvs[3]];
		var _vertex_bottom_left = [_x1, _y2, _z, 0, 0, 1, _c4, _alpha, _uvs[0], _uvs[3]];

		// _vertex_top_left.rotate(_yaw, _pitch, _roll, _x, _y, _z);
		// _vertex_top_right.rotate(_yaw, _pitch, _roll, _x, _y, _z);
		// _vertex_bottom_right.rotate(_yaw, _pitch, _roll, _x, _y, _z);
		// _vertex_bottom_left.rotate(_yaw, _pitch, _roll, _x, _y, _z);
		_vertex_top_left = self.rotate2(_vertex_top_left, _x, _y, _z, _yaw, _pitch, _roll);
		_vertex_top_right = self.rotate2(_vertex_top_right, _x, _y, _z, _yaw, _pitch, _roll);
		_vertex_bottom_right = self.rotate2(_vertex_bottom_right, _x, _y, _z, _yaw, _pitch, _roll);
		_vertex_bottom_left = self.rotate2(_vertex_bottom_left, _x, _y, _z, _yaw, _pitch, _roll);

		var _vertices = [_vertex_top_left, _vertex_top_right, _vertex_bottom_right, _vertex_top_left, _vertex_bottom_right, _vertex_bottom_left];
		for (var _i = 0, _len = array_length(_vertices); _i < _len; _i++) {
			// _vertices[_i].add(_buffer);
			self.add2(_buffer, _vertices[_i]);
		}
		return _buffer;
	}

	/**
	 * This function is replacement of draw_sprite_ext. It will add a sprite to the vertex buffer with the specified parameters.
	 * @returns {Struct.VertexBuffer}
	 * @param {Asset.GMSprite} sprite - The sprite to add.
	 * @param {Real} subimg - The subimage of the sprite to add.
	 * @param {Real} x - The X coordinate of the sprite.
	 * @param {Real} y - The Y coordinate of the sprite.
	 * @param {Real} z - The Z coordinate of the sprite.
	 * @param {Real} xscale - The X scale of the sprite.
	 * @param {Real} yscale - The Y scale of the sprite.
	 * @param {Real} yaw - The yaw rotation of the sprite.
	 * @param {Real} pitch - The pitch rotation of the sprite.
	 * @param {Real} roll - The roll rotation of the sprite.
	 * @param {Real} color - The color of the sprite.
	 * @param {Real} alpha - The alpha value of the sprite.
	 */
	static sprite_ext = function(_sprite, _subimg, _x, _y, _z, _xscale, _yscale, _yaw, _pitch, _roll, _color, _alpha) {
		return self.sprite_ext_color(_sprite, _subimg, _x, _y, _z, _xscale, _yscale, _yaw, _pitch, _roll, _color, _color, _color, _color, _alpha);
	}

	/**
	 * This function is replacement of draw_sprite. It will add a sprite to the vertex buffer with the specified parameters.
	 * @returns {Struct.VertexBuffer}
	 * @param {Asset.GMSprite} sprite - The sprite to add.
	 * @param {Real} subimg - The subimage of the sprite to add.
	 * @param {Real} x - The X coordinate of the sprite.
	 * @param {Real} y - The Y coordinate of the sprite.
	 * @param {Real} z - The Z coordinate of the sprite.
	 */
	static sprite = function(_sprite, _subimg, _x, _y, _z) {
		return self.sprite_ext(_sprite, _subimg, _x, _y, _z, 1, 1, 0, 0, 0, c_white, 1);
	}

	/**
	 * This function is replacement of draw_sprite_general. It will add a sprite to the vertex buffer with the specified parameters.
	 * @returns {Struct.VertexBuffer}
	 * @param {Asset.GMSprite} sprite - The sprite to add.
	 * @param {Real} subimg - The subimage of the sprite to add.
	 * @param {Real} left - The left offset of the sprite.
	 * @param {Real} top - The top offset of the sprite.
	 * @param {Real} width - The width of the sprite.
	 * @param {Real} height - The height of the sprite.
	 * @param {Real} x - The X coordinate of the sprite.
	 * @param {Real} y - The Y coordinate of the sprite.
	 * @param {Real} z - The Z coordinate of the sprite.
	 * @param {Real} xscale - The X scale of the sprite.
	 * @param {Real} yscale - The Y scale of the sprite.
	 * @param {Real} yaw - The yaw rotation of the sprite.
	 * @param {Real} pitch - The pitch rotation of the sprite.
	 * @param {Real} roll - The roll rotation of the sprite.
	 * @param {Real} c1 - The color of the top-left vertex.
	 * @param {Real} c2 - The color of the top-right vertex.
	 * @param {Real} c3 - The color of the bottom-right vertex.
	 * @param {Real} c4 - The color of the bottom-left vertex.
	 * @param {Real} alpha - The alpha value of the sprite.
	 */
	static sprite_general = function(_sprite, _subimg, _left, _top, _width, _height, _x, _y, _z, _xscale, _yscale, _yaw, _pitch, _roll, _c1, _c2, _c3, _c4, _alpha) {
		var _uvs = sprite_get_uvs(_sprite, _subimg);
		var _tex = sprite_get_texture(_sprite, _subimg);
		var _buffer = self.buffer_get(_tex);

		_width = min(_width, sprite_get_width(_sprite) - _left - _uvs[4]) * _xscale;
		_height = min(_height, sprite_get_height(_sprite) - _top - _uvs[5]) * _yscale;

		var _x1 = _x;
		var _y1 = _y;
		var _x2 = _x1 + _width;
		var _y2 = _y1 + _height;

		var _tex_width = texture_get_texel_width(_tex);
		var _tex_height = texture_get_texel_height(_tex);
		var _tex_left = clamp(_uvs[0] + (_left - _uvs[4]) * _tex_width, _uvs[0], _uvs[2]);
		var _tex_top = clamp(_uvs[1] + (_top - _uvs[5]) * _tex_height, _uvs[1], _uvs[3]);
		var _tex_right = clamp(_tex_left + _width * _tex_width, _uvs[0], _uvs[2]);
		var _tex_bottom = clamp(_tex_top + _height * _tex_height, _uvs[1], _uvs[3]);

		var _vertex_top_left = self.vertex(_x1, _y1, _z, 0, 0, 1, _c1, _alpha, _tex_left, _tex_top);
		var _vertex_top_right = self.vertex(_x2, _y1, _z, 0, 0, 1, _c2, _alpha, _tex_right, _tex_top);
		var _vertex_bottom_right = self.vertex(_x2, _y2, _z, 0, 0, 1, _c3, _alpha, _tex_right, _tex_bottom);
		var _vertex_bottom_left = self.vertex(_x1, _y2, _z, 0, 0, 1, _c4, _alpha, _tex_left, _tex_bottom);

		_vertex_top_left.rotate(_yaw, _pitch, _roll, _x, _y, _z);
		_vertex_top_right.rotate(_yaw, _pitch, _roll, _x, _y, _z);
		_vertex_bottom_right.rotate(_yaw, _pitch, _roll, _x, _y, _z);
		_vertex_bottom_left.rotate(_yaw, _pitch, _roll, _x, _y, _z);

		var _vertices = [_vertex_top_left, _vertex_top_right, _vertex_bottom_right, _vertex_top_left, _vertex_bottom_right, _vertex_bottom_left];
		for (var _i = 0, _len = array_length(_vertices); _i < _len; _i++) {
			_vertices[_i].add(_buffer);
		}
		return _buffer;
	}

	/**
	 * This function is replacement of draw_sprite_part_ext. It will add a sprite to the vertex buffer with the specified parameters.
	 * @returns {Struct.VertexBuffer}
	 * @param {Asset.GMSprite} sprite - The sprite to add.
	 * @param {Real} subimg - The subimage of the sprite to add.
	 * @param {Real} left - The left offset of the sprite.
	 * @param {Real} top - The top offset of the sprite.
	 * @param {Real} width - The width of the sprite.
	 * @param {Real} height - The height of the sprite.
	 * @param {Real} x - The X coordinate of the sprite.
	 * @param {Real} y - The Y coordinate of the sprite.
	 * @param {Real} z - The Z coordinate of the sprite.
	 * @param {Real} xscale - The X scale of the sprite.
	 * @param {Real} yscale - The Y scale of the sprite.
	 * @param {Real} color - The color of the sprite.
	 * @param {Real} alpha - The alpha value of the sprite.
	 */
	static sprite_part_ext = function(_sprite, _subimg, _left, _top, _width, _height, _x, _y, _z, _xscale, _yscale, _color, _alpha) {
		return self.sprite_general(_sprite, _subimg, _left, _top, _width, _height, _x, _y, _z, _xscale, _yscale, 0, 0, 0, _color, _color, _color, _color, _alpha);
	}
	
	/**
	 * This function is replacement of draw_sprite_part. It will add a sprite to the vertex buffer with the specified parameters.
	 * @returns {Struct.VertexBuffer}
	 * @param {Asset.GMSprite} sprite - The sprite to add.
	 * @param {Real} subimg - The subimage of the sprite to add.
	 * @param {Real} left - The left offset of the sprite.
	 * @param {Real} top - The top offset of the sprite.
	 * @param {Real} width - The width of the sprite.
	 * @param {Real} height - The height of the sprite.
	 * @param {Real} x - The X coordinate of the sprite.
	 * @param {Real} y - The Y coordinate of the sprite.
	 * @param {Real} z - The Z coordinate of the sprite.
	 */
	static sprite_part = function(_sprite, _subimg, _left, _top, _width, _height, _x, _y, _z) {
		return self.sprite_part_ext(_sprite, _subimg, _left, _top, _width, _height, _x, _y, _z, 1, 1, c_white, 1);
	}

	/**
	 * This function is replacement of draw_sprite_stretched_ext. It will add a sprite to the vertex buffer with the specified parameters.
	 * @returns {Struct.VertexBuffer}
	 * @param {Asset.GMSprite} sprite - The sprite to add.
	 * @param {Real} subimg - The subimage of the sprite to add.
	 * @param {Real} x - The X coordinate of the sprite.
	 * @param {Real} y - The Y coordinate of the sprite.
	 * @param {Real} z - The Z coordinate of the sprite.
	 * @param {Real} w - The width of the sprite.
	 * @param {Real} h - The height of the sprite.
	 * @param {Real} color - The color of the sprite.
	 * @param {Real} alpha - The alpha value of the sprite.
	 */
	static sprite_stretched_ext = function(_sprite, _subimg, _x, _y, _z, _w, _h, _color, _alpha) {
		var _uvs = sprite_get_uvs(_sprite, _subimg);
		var _tex = sprite_get_texture(_sprite, _subimg);
		var _buffer = self.buffer_get(_tex);

		var _x1 = _x;
		var _y1 = _y;
		var _x2 = _x1 + _w;
		var _y2 = _y1 + _h;

		var _vertex_top_left = self.vertex(_x1, _y1, _z, 0, 0, 1, _color, _alpha, _uvs[0], _uvs[1]);
		var _vertex_top_right = self.vertex(_x2, _y1, _z, 0, 0, 1, _color, _alpha, _uvs[2], _uvs[1]);
		var _vertex_bottom_right = self.vertex(_x2, _y2, _z, 0, 0, 1, _color, _alpha, _uvs[2], _uvs[3]);
		var _vertex_bottom_left = self.vertex(_x1, _y2, _z, 0, 0, 1, _color, _alpha, _uvs[0], _uvs[3]);

		var _vertices = [_vertex_top_left, _vertex_top_right, _vertex_bottom_right, _vertex_top_left, _vertex_bottom_right, _vertex_bottom_left];
		for (var _i = 0, _len = array_length(_vertices); _i < _len; _i++) {
			_vertices[_i].add(_buffer);
		}
		return _buffer;
	}
	
	/**
	 * This function is replacement of draw_sprite_stretched. It will add a sprite to the vertex buffer with the specified parameters.
	 * @returns {Struct.VertexBuffer}
	 * @param {Asset.GMSprite} sprite - The sprite to add.
	 * @param {Real} subimg - The subimage of the sprite to add.
	 * @param {Real} x - The X coordinate of the sprite.
	 * @param {Real} y - The Y coordinate of the sprite.
	 * @param {Real} z - The Z coordinate of the sprite.
	 * @param {Real} w - The width of the sprite.
	 * @param {Real} h - The height of the sprite.
	 */
    static sprite_stretched = function(_sprite, _subimg, _x, _y, _z, _w, _h) {
		return self.sprite_stretched_ext(_sprite, _subimg, _x, _y, _z, _w, _h, c_white, 1);
	}

	// TODO: sprite_pos_ext with color parameters
	
	/**
	 * This function is replacement of draw_sprite_pos. It will add a sprite to the vertex buffer with the specified parameters.
	 * @returns {Struct.VertexBuffer}
	 * @param {Asset.GMSprite} sprite - The sprite to add.
	 * @param {Real} subimg - The subimage of the sprite to add.
	 * @param {Real} x1 - The X coordinate of the top-left vertex.
	 * @param {Real} y1 - The Y coordinate of the top-left vertex.
	 * @param {Real} z1 - The Z coordinate of the top-left vertex.
	 * @param {Real} x2 - The X coordinate of the top-right vertex.
	 * @param {Real} y2 - The Y coordinate of the top-right vertex.
	 * @param {Real} z2 - The Z coordinate of the top-right vertex.
	 * @param {Real} x3 - The X coordinate of the bottom-right vertex.
	 * @param {Real} y3 - The Y coordinate of the bottom-right vertex.
	 * @param {Real} z3 - The Z coordinate of the bottom-right vertex.
	 * @param {Real} x4 - The X coordinate of the bottom-left vertex.
	 * @param {Real} y4 - The Y coordinate of the bottom-left vertex.
	 * @param {Real} z4 - The Z coordinate of the bottom-left vertex.
	 * @param {Real} alpha - The alpha value of the sprite.
	 */
	static sprite_pos = function(_sprite, _subimg, _x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3, _x4, _y4, _z4, _alpha) {
		var _uvs = sprite_get_uvs(_sprite, _subimg);
		var _tex = sprite_get_texture(_sprite, _subimg);
		var _buffer = self.buffer_get(_tex);
		
		var _vertex_top_left = self.vertex(_x1, _y1, _z1, 0, 0, 1, c_white, _alpha, _uvs[0], _uvs[1]);
		var _vertex_top_right = self.vertex(_x2, _y2, _z2, 0, 0, 1, c_white, _alpha, _uvs[2], _uvs[1]);
		var _vertex_bottom_right = self.vertex(_x3, _y3, _z3, 0, 0, 1, c_white, _alpha, _uvs[2], _uvs[3]);
		var _vertex_bottom_left = self.vertex(_x4, _y4, _z4, 0, 0, 1, c_white, _alpha, _uvs[0], _uvs[3]);

		var _vertices = [_vertex_top_left, _vertex_top_right, _vertex_bottom_right, _vertex_top_left, _vertex_bottom_right, _vertex_bottom_left];
		for (var _i = 0, _len = array_length(_vertices); _i < _len; _i++) {
			_vertices[_i].add(_buffer);
		}
		return _buffer;
	}
	
    // TODO: Add 3D Importer
    // TODO: Cube with sprite texture

    /*
    function vertex_add_cube(_buffer, _sprite, _subimg, _x, _y, _z, _xscale, _yscale, _yaw, _pitch, _roll, _color, _alpha)
    {
        // Get width and height of the sprite
        var _width = sprite_get_width(_sprite) * _xscale;
        var _height = sprite_get_height(_sprite) * _yscale;
    
        // Get offset of the sprite
        var _xoffset = sprite_get_xoffset(_sprite) * _xscale;
        var _yoffset = sprite_get_yoffset(_sprite) * _yscale;
    
        // Get center of the cube
        var _center_x = _x - _xoffset;
        var _center_y = _y - _yoffset;
        var _center_z = _z;
    
        // Get all x, y, and z positions of vertices as arrays
        _x = [_center_x, _center_x + _width, _center_x + _width, _center_x, _center_x, _center_x + _width, _center_x + _width, _center_x];
        _y = [_center_y, _center_y, _center_y + _height, _center_y + _height, _center_y, _center_y, _center_y + _height, _center_y + _height];
        _z = [_center_z, _center_z, _center_z, _center_z, _center_z + _height, _center_z + _height, _center_z + _height, _center_z + _height];
    
        // Rotate the cube
        var _cos_yaw = dcos(-_yaw);
        var _sin_yaw = dsin(-_yaw);
        var _cos_pitch = dcos(_pitch);
        var _sin_pitch = dsin(_pitch);
        var _cos_roll = dcos(_roll);
        var _sin_roll = dsin(_roll);
        for (var _i = 0; _i < 8; _i++)
        {
            // Rotate around the z-axis
            var _dx = _x[_i] - _center_x;
            var _dy = _y[_i] - _center_y;
            _x[_i] = _center_x + _dx * _cos_yaw - _dy * _sin_yaw;
            _y[_i] = _center_y + _dx * _sin_yaw + _dy * _cos_yaw;
    
            // Rotate around the x-axis
            _dy = _y[_i] - _center_y;
            var _dz = _z[_i] - _center_z;
            _y[_i] = _center_y + _dy * _cos_pitch - _dz * _sin_pitch;
            _z[_i] = _center_z + _dy * _sin_pitch + _dz * _cos_pitch;
    
            // Rotate around the y-axis
            _dx = _x[_i] - _center_x;
            _dz = _z[_i] - _center_z;
            _x[_i] = _center_x + _dx * _cos_roll - _dz * _sin_roll;
            _z[_i] = _center_z + _dx * _sin_roll + _dz * _cos_roll;
        }
    
        // Get UVs
        var _uvs = sprite_get_uvs(_sprite, _subimg);
    
        // Add the cube to the vertex buffer
        vertex_add_quadrilateral(_buffer, [_x[0], _x[1], _x[2], _x[3]], [_y[0], _y[1], _y[2], _y[3]], [_z[0], _z[1], _z[2], _z[3]], 0, 0, 1, _color, _alpha, _uvs);
        vertex_add_quadrilateral(_buffer, [_x[1], _x[5], _x[6], _x[2]], [_y[1], _y[5], _y[6], _y[2]], [_z[1], _z[5], _z[6], _z[2]], 0, 0, 1, _color, _alpha, _uvs);
        vertex_add_quadrilateral(_buffer, [_x[5], _x[4], _x[7], _x[6]], [_y[5], _y[4], _y[7], _y[6]], [_z[5], _z[4], _z[7], _z[6]], 0, 0, 1, _color, _alpha, _uvs);
        vertex_add_quadrilateral(_buffer, [_x[4], _x[0], _x[3], _x[7]], [_y[4], _y[0], _y[3], _y[7]], [_z[4], _z[0], _z[3], _z[7]], 0, 0, 1, _color, _alpha, _uvs);
        vertex_add_quadrilateral(_buffer, [_x[3], _x[2], _x[6], _x[7]], [_y[3], _y[2], _y[6], _y[7]], [_z[3], _z[2], _z[6], _z[7]], 0, 0, 1, _color, _alpha, _uvs);
        vertex_add_quadrilateral(_buffer, [_x[4], _x[5], _x[1], _x[0]], [_y[4], _y[5], _y[1], _y[0]], [_z[4], _z[5], _z[1], _z[0]], 0, 0, 1, _color, _alpha, _uvs);
    }

	*/
}
