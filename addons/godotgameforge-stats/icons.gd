extends EditorResourcePreviewGenerator

var stat: CompressedTexture2D = preload("res://addons/godotgameforge-stats/Icons/Stat.png")
var attr: CompressedTexture2D = preload("res://addons/godotgameforge-stats/Icons/Attr.png")
var formula: CompressedTexture2D = preload("res://addons/godotgameforge-stats/Icons/Formula.png")
var table: CompressedTexture2D = preload("res://addons/godotgameforge-stats/Icons/Table.png")
var class_img: CompressedTexture2D = preload("res://addons/godotgameforge-stats/Icons/Class.png")
var trait_img: CompressedTexture2D = preload("res://addons/godotgameforge-stats/Icons/Traits.png")

func _can_generate_small_preview():
	return true


func _handles(type):
	return type == "Resource"


func _generate(resource, size, metadata):
	var img: Image = Image.new()
	var color = Color.BLACK
	if resource is Stat:
		color = ColorTheme.map_color(Color.RED)
		img = stat.get_image()

	if resource is Attribute:
		color = ColorTheme.map_color(Color.BLUE)
		img = attr.get_image()

	if resource is Formula:
		color = ColorTheme.map_color(Color.PURPLE)
		img = formula.get_image()

	if resource is Table:
		match resource.table:
			0:
				color = ColorTheme.map_color(Color.BLUE)
			1:
				color = ColorTheme.map_color(Color.RED)
			2:
				color = ColorTheme.map_color(Color.GREEN)
			3:
				color = ColorTheme.map_color(Color.YELLOW)
		img = table.get_image()

	if resource is Class:
		color = ColorTheme.map_color(Color.TEAL)
		img = class_img.get_image()

	if not img.is_empty():
		return ColorTheme.color_image_texture(img, color)
