function Tile() constructor {
    // Rotate
    // Mirror
    // Flip
    // Index
}

function Tilemap() constructor {
    tileset = -1;
    width = 0;
    height = 0;
    x = 0;
    y = 0;

    static create = function() {}

    static destroy = function() {}

    static fill = function() {}

    static autotile = function() {}

	static convert_to_vertex = function() {
		// TODO: Single layer function and all layers function.
        var _layers = layer_get_all();
        // TODO: Assign separate vertex buffers to each layer.
        array_foreach(_layers, function(_layer, _index) {
            var _depth = layer_get_depth(_layer);
            var _elements = layer_get_all_elements(_layer);
            var _pitch = 45; // TODO: Make this a parameter.
            for (var _i = 0, _len = array_length(_elements); _i < _len; _i++) {
                var _element = _elements[_i];
                if (layer_get_element_type(_element) == layerelementtype_tilemap) {
					var _tileset = tilemap_get_tileset(_element);
					var _tile_width = tilemap_get_tile_width(_element);
					var _tile_height = tilemap_get_tile_height(_element);
					var _width = tilemap_get_width(_element);
					var _height = tilemap_get_height(_element);
                    var _x = tilemap_get_x(_element);
					var _y = tilemap_get_y(_element);
					var _frame = tilemap_get_frame(_element);

					for (var _j = 0; _j < _width; _j++) {
						var _tile_y = _y + _j * _tile_height;
						for (var _k = 0; _k < _height; _k++) {
							var _tile = tilemap_get(_element, _j, _k);
							if (_tile == -1) continue;
							var _empty = tile_get_empty(_tile);
							if (_empty) continue;

							var _tile_x = _x + _k * _tile_width;

							var _image = tile_get_index(_tile);
							var _flip = tile_get_flip(_tile);
							var _mirror = tile_get_mirror(_tile);
							var _rotate = tile_get_rotate(_tile);


							// Vertex.sprite_ext(_sprite, _image, _x, _y, _depth, _xscale, _yscale, 0, _pitch, _angle, _blend, _alpha);
						}
					}

                    
					layer_tilemap_destroy(_element);
                }
            }
        });
	}
}

function Tileset() constructor {
    // Sprite
    // Index
    // Tile Width and Height
    // Autotile
    // Collision
}
