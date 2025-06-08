class_name StatsUIElementEditorContextMenuPlugin
extends EditorContextMenuPlugin

const stat: CompressedTexture2D = preload("res://addons/godotgameforge-stats/Icons/Stat.png")
const attr: CompressedTexture2D = preload("res://addons/godotgameforge-stats/Icons/Attr.png")
const formula: CompressedTexture2D = preload("res://addons/godotgameforge-stats/Icons/Formula.png")
const trait_img: CompressedTexture2D = preload("res://addons/godotgameforge-stats/Icons/Traits.png")

func _popup_menu(paths: PackedStringArray) -> void:
	if len(paths) != 1:
		return
	var popup = PopupMenu.new()
	var sub_menu = PopupMenu.new()
	popup.add_icon_item(trait_img,"Stat UI")
	popup.add_submenu_node_item("Stat UI",sub_menu)
	
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
	
	add_context_submenu_item("Godot Game Forge",popup)
	var popup_p = PopupMenu.new()
	popup_p.add_item("test")
	add_context_submenu_item("Godot Game Forge",popup_p)
	print(EditorInterface.get_edited_scene_root().get_node(paths[0]))
