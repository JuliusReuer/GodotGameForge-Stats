class_name StatsUIElementNodeMenuMaker
extends GodotGameForgeNodeMenuMaker

const stat: CompressedTexture2D = preload("res://addons/godotgameforge-stats/Icons/Stat.png")
const attr: CompressedTexture2D = preload("res://addons/godotgameforge-stats/Icons/Attr.png")
const formula: CompressedTexture2D = preload("res://addons/godotgameforge-stats/Icons/Formula.png")
const trait_img: CompressedTexture2D = preload("res://addons/godotgameforge-stats/Icons/Traits.png")

func _init():
	name = "Stat UI"

func show(nodes:Array[Node]):
	if len(nodes) != 1:
		return false
	if nodes[0] is StatsUIElement:
		return false
	return true

func get_icon():
	return trait_img

func get_menu(nodes:Array[Node]):
	var sub_menu = PopupMenu.new()
	
	#region Stats UI
	var stat_image = stat.get_image()
	stat_image.resize(21,21)
	var stat_texture = ColorTheme.map_color_image_texture(stat_image,Color.RED)
	sub_menu.add_icon_item(stat_texture,"Stats UI")
	#endregion
	#region Attributes UI
	var attributes_image = attr.get_image()
	attributes_image.resize(21,21)
	var attributes_texture = ColorTheme.map_color_image_texture(attributes_image,Color.BLUE)
	sub_menu.add_icon_item(attributes_texture,"Attributes UI")
	#endregion
	
	return sub_menu
