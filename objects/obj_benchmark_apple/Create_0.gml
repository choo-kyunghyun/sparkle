shader = sh_apple;
sprite = spr_apple;
subimg = 0;
num = 5000;
max_depth = 16000;
vbuff = event_benchmark_apple(sprite, subimg, num, max_depth);

input_guide = "Press 1 - sh_apple | Press 2 - sh_grayscale | Press 3 - sh_outline\n";
input_guide += "Press 4 - sh_depth | Press 5 - -1 | Press R - Shuffle\n";
input_guide += "Press Q - zparam = 320 | Press W - zparam = 3200 | Press E - zparam = 32000\n\n";

var _tex = sprite_get_texture(sprite, 0);
texel_w = texture_get_texel_width(_tex);
texel_h = texture_get_texel_height(_tex);
u_outline_colour = shader_get_uniform(sh_outline, "u_vOutlineColour");
u_texel_size = shader_get_uniform(sh_outline, "u_vTexelSize");
outline_colour = [1.0, 1.0, 1.0, 1.0];

zparam = 320;
u_zparam = shader_get_uniform(sh_depth, "u_fZParam");
