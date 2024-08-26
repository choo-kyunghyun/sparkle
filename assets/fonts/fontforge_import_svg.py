# Import SVG files into a font file using FontForge
import fontforge
import os

# Set the paths and the range of characters to import
sdf_file_path = ""
svg_folder_path = ""
start_char = 33
end_char = 126

# Open the font file
font = fontforge.open(sdf_file_path)

# Import the SVG files
for i in range(start_char, end_char + 1):
    svg_file = os.path.join(svg_folder_path, f'{i}.svg')
    if os.path.exists(svg_file):
        glyph = font.createChar(i)
        glyph.importOutlines(svg_file)
    else:
        print(f'{svg_file} not found')

# Save the font file
font.save(sdf_file_path)
