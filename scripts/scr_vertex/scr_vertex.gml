/// @desc Manager class for vertex buffers and textures
function VertexManager() constructor
{
    // Vertex buffers
    buffers = [];

    // Vertex format
    vertex_format_begin();
    vertex_format_add_position_3d();
    vertex_format_add_normal();
    vertex_format_add_color();
    vertex_format_add_texcoord();
    format = vertex_format_end();

    /// @desc Adds a vertex buffer to the manager
    /// @arg {Pointer.Texture} _texture The texture to add.
    /// @arg {Constant.ZFunction} _zfunc The z function to use.
    /// @arg {Boolean} _begin Whether to begin the buffer.
    /// @return {Id.VertexBuffer} The vertex buffer.
    static add = function(_texture, _zfunc = cmpfunc_lessequal, _begin = true)
    {
        // If the buffer already exists, return it
        var _buffer = find(_texture, _zfunc);
        if (_buffer != undefined)
        {
            return _buffer;
        }
        // Otherwise, create a new buffer
        var _data =
        {
            buffer : vertex_create_buffer(),
            texture : _texture,
            zfunc : _zfunc,
            frozen : false
        };
        // Add the buffer to the list
        array_push(buffers, _data);
        array_sort(buffers, function(_a, _b)
        {
            return _a.zfunc - _b.zfunc;
        });
        // Begin the buffer
        if (_begin)
        {
            vertex_begin(_data.buffer, format);
        }
        return _data.buffer;
    }

    /// @desc Finds a vertex buffer in the manager
    /// @arg {Pointer.Texture} _texture The texture to find.
    /// @arg {Constant.ZFunction} _zfunc The z function to use.
    /// @arg {Boolean} _frozen Whether the buffer is frozen.
    /// @return {Id.VertexBuffer} The vertex buffer.
    /// @pure
    static find = function(_texture, _zfunc = cmpfunc_lessequal, _frozen = false)
    {
        for (var _i = 0; _i < array_length(buffers); _i++)
        {
            if (buffers[_i].texture == _texture && buffers[_i].zfunc == _zfunc && buffers[_i].frozen == _frozen)
            {
                return buffers[_i].buffer;
            }
        }
        return undefined;
    }

    /// @desc Deletes all vertex buffers in the manager
    static delete_all = function()
    {
        for (var _i = 0; _i < array_length(buffers); _i++)
        {
            vertex_delete_buffer(buffers[_i].buffer);
        }
        buffers = [];
    }

    /// @desc Freeze a vertex buffer in the manager
    /// @arg {Id.VertexBuffer} _buffer The vertex buffer to freeze.
    static freeze = function(_buffer)
    {
        for (var _i = 0; _i < array_length(buffers); _i++)
        {
            if (buffers[_i].buffer == _buffer)
            {
                vertex_freeze(_buffer);
                buffers[_i].frozen = true;
                break;
            }
        }
    }

    /// @desc Freeze all vertex buffers in the manager
    static freeze_all = function()
    {
        for (var _i = 0; _i < array_length(buffers); _i++)
        {
            vertex_freeze(buffers[_i].buffer);
            buffers[_i].frozen = true;
        }
    }

    /// @desc Submits all vertex buffers in the manager
    static submit = function()
    {
        // Save current zfunc
        var _zfunc = gpu_get_zfunc();

        // Submit all vertex buffers
        for (var _i = 0; _i < array_length(buffers); _i++)
        {
            if (buffers[_i].texture != -1)
            {
                gpu_set_zfunc(buffers[_i].zfunc);
                vertex_submit(buffers[_i].buffer, pr_trianglelist, buffers[_i].texture);
            }
        }

        // Restore zfunc
        gpu_set_zfunc(_zfunc);
    }

    /// @desc Begins all vertex buffers in the manager
    static begin_all = function()
    {
        for (var _i = 0; _i < array_length(buffers); _i++)
        {
            if (!buffers[_i].frozen)
            {
                vertex_begin(buffers[_i].buffer, format);
            }
        }
    }

    /// @desc Ends all vertex buffers in the manager
    static end_all = function()
    {
        for (var _i = 0; _i < array_length(buffers); _i++)
        {
            if (!buffers[_i].frozen)
            {
                vertex_end(buffers[_i].buffer);
            }
        }
    }
}

/// @desc Adds a vertex to the vertex buffer
/// @arg {Id.VertexBuffer} _buffer The vertex buffer to add the vertex to.
/// @arg {Real} _x The x position of the vertex.
/// @arg {Real} _y The y position of the vertex.
/// @arg {Real} _z The z position of the vertex.
/// @arg {Real} _nx The x normal of the vertex.
/// @arg {Real} _ny The y normal of the vertex.
/// @arg {Real} _nz The z normal of the vertex.
/// @arg {Constant.Color} _color The color of the vertex.
/// @arg {Real} _alpha The alpha of the vertex.
function vertex_add(_buffer, _x, _y, _z, _nx, _ny, _nz, _color, _alpha, _u, _v)
{
    vertex_position_3d(_buffer, _x, _y, _z);
    vertex_normal(_buffer, _nx, _ny, _nz);
    vertex_color(_buffer, _color, _alpha);
    vertex_texcoord(_buffer, _u, _v);
}

/// @desc Adds a quadrilateral to the vertex buffer
/// @arg {Id.VertexBuffer} _buffer The vertex buffer to add the quadrilateral to.
/// @arg {Array} _x The x positions of the quadrilateral.
/// @arg {Array} _y The y positions of the quadrilateral.
/// @arg {Array} _z The z positions of the quadrilateral.
/// @arg {Real} _nx The x normal of the quadrilateral.
/// @arg {Real} _ny The y normal of the quadrilateral.
/// @arg {Real} _nz The z normal of the quadrilateral.
/// @arg {Constant.Color} _color The color of the quadrilateral.
/// @arg {Real} _alpha The alpha of the quadrilateral.
/// @arg {Array} _uvs The uvs of the quadrilateral.
function vertex_add_quadrilateral(_buffer, _x, _y, _z, _nx, _ny, _nz, _color, _alpha, _uvs)
{
    vertex_add(_buffer, _x[0], _y[0], _z[0], _nx, _ny, _nz, _color, _alpha, _uvs[0], _uvs[1]);
    vertex_add(_buffer, _x[1], _y[1], _z[1], _nx, _ny, _nz, _color, _alpha, _uvs[2], _uvs[1]);
    vertex_add(_buffer, _x[3], _y[3], _z[3], _nx, _ny, _nz, _color, _alpha, _uvs[0], _uvs[3]);
    vertex_add(_buffer, _x[1], _y[1], _z[1], _nx, _ny, _nz, _color, _alpha, _uvs[2], _uvs[1]);
    vertex_add(_buffer, _x[2], _y[2], _z[2], _nx, _ny, _nz, _color, _alpha, _uvs[2], _uvs[3]);
    vertex_add(_buffer, _x[3], _y[3], _z[3], _nx, _ny, _nz, _color, _alpha, _uvs[0], _uvs[3]);
}

/// @desc Adds a sprite to the vertex buffer
/// @arg {Id.VertexBuffer} _buffer The vertex buffer to add the sprite to.
/// @arg {Asset.GMSprite} _sprite The sprite to add.
/// @arg {Real} _subimg The subimage of the sprite to add.
/// @arg {Real} _x The x position of the sprite.
/// @arg {Real} _y The y position of the sprite.
/// @arg {Real} _z The z position of the sprite.
function vertex_add_sprite(_buffer, _sprite, _subimg, _x, _y, _z)
{
    // Get UVs
    var _uvs = sprite_get_uvs(_sprite, _subimg);

    // Get sprite width and height
    var _width = sprite_get_width(_sprite) * _uvs[6];
    var _height = sprite_get_height(_sprite) * _uvs[7];

    // Calculate the sprite position
    var _x1 = _x + _uvs[4] - sprite_get_xoffset(_sprite);
    var _y1 = _y + _uvs[5] - sprite_get_yoffset(_sprite);
    var _x2 = _x1 + _width;
    var _y2 = _y1 + _height;

    // Add the sprite to the vertex buffer
    vertex_add_quadrilateral(_buffer, [_x1, _x2, _x2, _x1], [_y1, _y1, _y2, _y2], [_z, _z, _z, _z], 0, 0, 1, c_white, 1, _uvs);
}

/// @desc Adds a sprite to the vertex buffer
/// @arg {Id.VertexBuffer} _buffer The vertex buffer to add the sprite to.
/// @arg {Asset.GMSprite} _sprite The sprite to add.
/// @arg {Real} _subimg The subimage of the sprite to add.
/// @arg {Real} _x The x position of the sprite.
/// @arg {Real} _y The y position of the sprite.
/// @arg {Real} _z The z position of the sprite.
/// @arg {Real} _xscale The x scale of the sprite.
/// @arg {Real} _yscale The y scale of the sprite.
/// @arg {Real} _yaw The yaw of the sprite.
/// @arg {Real} _pitch The pitch of the sprite.
/// @arg {Real} _roll The roll of the sprite.
/// @arg {Constant.Color} _color The color of the sprite.
/// @arg {Real} _alpha The alpha of the sprite.
function vertex_add_sprite_ext(_buffer, _sprite, _subimg, _x, _y, _z, _xscale, _yscale, _yaw, _pitch, _roll, _color, _alpha)
{
    // Get UVs
    var _uvs = sprite_get_uvs(_sprite, _subimg);

    // Get sprite width and height
    var _width = sprite_get_width(_sprite) * _uvs[6] * _xscale;
    var _height = sprite_get_height(_sprite) * _uvs[7] * _yscale;

    // Calculate the sprite position
    var _x1 = _x + (_uvs[4] - sprite_get_xoffset(_sprite)) * _xscale;
    var _y1 = _y + (_uvs[5] - sprite_get_yoffset(_sprite)) * _yscale;
    var _x2 = _x1 + _width;
    var _y2 = _y1 + _height;

    // Calculate the sprite vertices
    var _xx = [_x1, _x2, _x2, _x1];
    var _yy = [_y1, _y1, _y2, _y2];
    var _zz = [_z, _z, _z, _z];

    // Calculate the sprite yaw
    var _cos = dcos(_yaw);
    var _sin = dsin(_yaw);
    for (var _i = 0; _i < 4; _i++)
    {
        var _dx = _xx[_i] - _x;
        var _dy = _yy[_i] - _y;
        _xx[_i] = _x + _dx * _cos + _dy * _sin;
        _yy[_i] = _y - _dx * _sin + _dy * _cos;
    }

    // Calculate the sprite pitch
    _cos = dcos(_pitch);
    _sin = dsin(_pitch);
    for (var _i = 0; _i < 4; _i++)
    {
        var _dy = _yy[_i] - _y;
        var _dz = _zz[_i] - _z;
        _yy[_i] = _y + _dy * _cos + _dz * _sin;
        _zz[_i] = _z - _dy * _sin + _dz * _cos;
    }

    // Calculate the sprite roll
    _cos = dcos(_roll);
    _sin = dsin(_roll);
    for (var _i = 0; _i < 4; _i++)
    {
        var _dx = _xx[_i] - _x;
        var _dz = _zz[_i] - _z;
        _xx[_i] = _x + _dx * _cos + _dz * _sin;
        _zz[_i] = _z - _dx * _sin + _dz * _cos;
    }

    // Add the sprite to the vertex buffer
    vertex_add_quadrilateral(_buffer, _xx, _yy, _zz, 0, 0, 1, _color, _alpha, _uvs);
}

/// @desc Adds a self sprite to the vertex buffer
/// @arg {Id.VertexBuffer} _buffer The vertex buffer to add the sprite to.
/// @arg {Real} _pitch The pitch of the sprite.
/// @arg {Real} _roll The roll of the sprite.
function vertex_add_self(_buffer, _pitch, _roll)
{
    vertex_add_sprite_ext(_buffer, sprite_index, image_index, x, y, depth, image_xscale, image_yscale, image_angle, _pitch, _roll, image_blend, image_alpha);
}

/// @desc Adds a cube to the vertex buffer with a sprite
/// @arg {Id.VertexBuffer} _buffer The vertex buffer to add the cube to.
/// @arg {Asset.GMSprite} _sprite The sprite to add.
/// @arg {Real} _subimg The subimage of the sprite to add.
/// @arg {Real} _x The x position of the cube.
/// @arg {Real} _y The y position of the cube.
/// @arg {Real} _z The z position of the cube.
/// @arg {Real} _xscale The x scale of the cube.
/// @arg {Real} _yscale The y scale of the cube.
/// @arg {Real} _yaw The yaw of the cube.
/// @arg {Real} _pitch The pitch of the cube.
/// @arg {Real} _roll The roll of the cube.
/// @arg {Constant.Color} _color The color of the cube.
/// @arg {Real} _alpha The alpha of the cube.
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
        var _dy = _y[_i] - _center_y;
        var _dz = _z[_i] - _center_z;
        _y[_i] = _center_y + _dy * _cos_pitch - _dz * _sin_pitch;
        _z[_i] = _center_z + _dy * _sin_pitch + _dz * _cos_pitch;

        // Rotate around the y-axis
        var _dx = _x[_i] - _center_x;
        var _dz = _z[_i] - _center_z;
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
