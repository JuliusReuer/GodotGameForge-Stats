class_name ColorTheme
const colors_file: String = "res://addons/godotgameforge-stats/Icons/colors.json"
const theme: int = 1


static func map_color(color: Color, val_theme: int = -1) -> Color:
	var name: String
	match color:
		Color.RED:
			name = "Red"
		Color.GREEN:
			name = "Green"
		Color.PURPLE:
			name = "Purple"
		Color.YELLOW:
			name = "Yellow"
		Color.BLUE:
			name = "Blue"
		Color.TEAL:
			name = "Teal"
		_:
			name = "Background"
	if val_theme == -1:
		val_theme = theme
	return Color.from_string(get_color_str(name, val_theme), Color.BLACK)


static func get_color_str(name: String, theme: int):
	var json_text = FileAccess.get_file_as_string(colors_file)
	var dict = JSON.parse_string(json_text)
	return dict[name][theme]


static func color_image(img: Image, color: Color) -> Image:
	var temp: Image = img.duplicate()
	for y in temp.get_height():
		for x in temp.get_width():
			var pixel_color = temp.get_pixel(x, y)
			var new_color = Color(color, pixel_color.a)
			temp.set_pixel(x, y, new_color)
	return temp


static func color_image_texture(img: Image, color: Color) -> ImageTexture:
	return ImageTexture.create_from_image(color_image(img, color))


static func map_color_image(img: Image, color: Color, val_theme: int = -1) -> Image:
	return color_image(img, map_color(color, val_theme))


static func map_color_image_texture(img: Image, color: Color, val_theme: int = -1) -> ImageTexture:
	return color_image_texture(img, map_color(color, val_theme))
