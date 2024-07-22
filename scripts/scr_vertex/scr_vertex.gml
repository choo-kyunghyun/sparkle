/// @desc Adds a vertex to the vertex buffer
/// @arg {Id.VertexBuffer} _buffer The vertex buffer to add the vertex to.
/// @arg {Array} _x The x position of the vertex.
/// @arg {Array} _y The y position of the vertex.
/// @arg {Array} _z The z position of the vertex.
/// @arg {Real} _nx The x normal of the vertex.
/// @arg {Real} _ny The y normal of the vertex.
/// @arg {Real} _nz The z normal of the vertex.
/// @arg {Constant.Color} _c1 The color of the vertex.
/// @arg {Constant.Color} _c2 The color of the vertex.
/// @arg {Constant.Color} _c3 The color of the vertex.
/// @arg {Constant.Color} _c4 The color of the vertex.
/// @arg {Real} _alpha The alpha of the vertex.
/// @arg {Array} _uvs The uvs of the vertex.
function vertex_add(_buffer, _x, _y, _z, _nx, _ny, _nz, _c1, _c2, _c3, _c4, _alpha, _uvs)
{
    // Top-left
    vertex_position_3d(_buffer, _x[0], _y[0], _z[0]);
    vertex_normal(_buffer, _nx, _ny, _nz);
    vertex_color(_buffer, _c1, _alpha);
    vertex_texcoord(_buffer, _uvs[0], _uvs[1]);
    // Top-right
    vertex_position_3d(_buffer, _x[1], _y[1], _z[1]);
    vertex_normal(_buffer, _nx, _ny, _nz);
    vertex_color(_buffer, _c2, _alpha);
    vertex_texcoord(_buffer, _uvs[2], _uvs[1]);
    // Bottom-left
    vertex_position_3d(_buffer, _x[3], _y[3], _z[3]);
    vertex_normal(_buffer, _nx, _ny, _nz);
    vertex_color(_buffer, _c4, _alpha);
    vertex_texcoord(_buffer, _uvs[0], _uvs[3]);
    // Top-right
    vertex_position_3d(_buffer, _x[1], _y[1], _z[1]);
    vertex_normal(_buffer, _nx, _ny, _nz);
    vertex_color(_buffer, _c2, _alpha);
    vertex_texcoord(_buffer, _uvs[2], _uvs[1]);
    // Bottom-right
    vertex_position_3d(_buffer, _x[2], _y[2], _z[2]);
    vertex_normal(_buffer, _nx, _ny, _nz);
    vertex_color(_buffer, _c3, _alpha);
    vertex_texcoord(_buffer, _uvs[2], _uvs[3]);
    // Bottom-left
    vertex_position_3d(_buffer, _x[3], _y[3], _z[3]);
    vertex_normal(_buffer, _nx, _ny, _nz);
    vertex_color(_buffer, _c4, _alpha);
    vertex_texcoord(_buffer, _uvs[0], _uvs[3]);
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
/// @return {Pointer.Texture} The texture of the sprite.
function vertex_add_sprite_ext(_buffer, _sprite, _subimg, _x, _y, _z, _xscale, _yscale, _yaw, _pitch, _roll, _color, _alpha)
{
    // Get UVs
    var _uvs = sprite_get_uvs(_sprite, _subimg);
    // Get sprite width and height
    var _width = sprite_get_width(_sprite);
    var _height = sprite_get_height(_sprite);
    // Get sprite origin
    var _origin_x = sprite_get_xoffset(_sprite);
    var _origin_y = sprite_get_yoffset(_sprite);
    // Get x and y position
    _x -= _origin_x * _xscale;
    _y -= _origin_y * _yscale;
    // Calculate the sprite position
    var _x1 = _x + _uvs[4] * _xscale;
    var _y1 = _y + _uvs[5] * _yscale;
    var _x2 = _x1 + _width * _uvs[6] * _xscale;
    var _y2 = _y1 + _height * _uvs[7] * _yscale;
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
        var _dy = _yy[_i] - _y - _height * _yscale;
        var _dz = _zz[_i] - _z;
        _yy[_i] = _y + _dy * _cos + _dz * _sin + _height * _yscale;
        _zz[_i] = _z - _dy * _sin + _dz * _cos;
    }
    // Calculate the sprite roll
    _cos = dcos(_roll);
    _sin = dsin(_roll);
    for (var _i = 0; _i < 4; _i++)
    {
        var _dx = _xx[_i] - _x - _width * _xscale;
        var _dz = _zz[_i] - _z;
        _xx[_i] = _x + _dx * _cos + _dz * _sin + _width * _xscale;
        _zz[_i] = _z - _dx * _sin + _dz * _cos;
    }
    // Add the sprite to the vertex buffer
    vertex_add(_buffer, _xx, _yy, _zz, 0, 0, 1, _color, _color, _color, _color, _alpha, _uvs);
    // Return the sprite texture
    return sprite_get_texture(_sprite, _subimg);
}

/// @desc Adds a self sprite to the vertex buffer
/// @arg {Id.VertexBuffer} _buffer The vertex buffer to add the sprite to.
/// @arg {Real} _pitch The pitch of the sprite.
/// @arg {Real} _roll The roll of the sprite.
function vertex_add_self(_buffer, _pitch, _roll)
{
    return vertex_add_sprite_ext(_buffer, sprite_index, image_index, x, y, depth, image_xscale, image_yscale, image_angle, _pitch, _roll, image_blend, image_alpha);
}
