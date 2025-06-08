class_name CustomNodeSelect
extends EditorProperty

signal update

var button: Button
var options: TextureButton
var editor_theme: Theme


func _init() -> void:
	editor_theme = EditorInterface.get_editor_theme()

	var h = HBoxContainer.new()
	h.add_theme_constant_override("separation", 0)
	add_child(h)

	button = build_button()
	h.add_child(button)

	options = build_options()
	h.add_child(options)


func build_button() -> Button:
	var b: Button = Button.new()
	b.text = "Assign..."
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return b


func build_options() -> TextureButton:
	var b: TextureButton = TextureButton.new()
	b.texture_normal = editor_theme.get_icon("GuiTabMenuHl", "EditorIcons")

	var pressed: Image = editor_theme.get_icon("GuiTabMenuHl", "EditorIcons").get_image().duplicate(
		true
	)
	for x in pressed.get_width():
		for y in pressed.get_height():
			var pixel = pressed.get_pixel(x, y)
			pressed.set_pixel(x, y, pixel * Color.LIGHT_SKY_BLUE)

	b.texture_pressed = ImageTexture.create_from_image(pressed)

	b.custom_minimum_size = Vector2(28, 28)
	b.stretch_mode = TextureButton.STRETCH_KEEP_CENTERED

	var pop_up: PopupMenu = PopupMenu.new()
	var delete_texture = editor_theme.get_icon("Clear", "EditorIcons")
	pop_up.add_icon_item(delete_texture, "Delete")
	var copy_texture = editor_theme.get_icon("ActionCopy", "EditorIcons")
	pop_up.add_icon_item(copy_texture, "Copy as Text")
	var edit_texture = editor_theme.get_icon("Edit", "EditorIcons")
	pop_up.add_icon_item(edit_texture, "Edit")
	var show_node_texture = editor_theme.get_icon("ExternalLink", "EditorIcons")
	pop_up.add_icon_item(show_node_texture, "Show Node in Tree")
	b.add_child(pop_up)

	var option_press = func():
		var node = get_edited_object()[get_edited_property()] as Node
		var obj = get_edited_object() as Node
		print(obj.get_path_to(node))
		var pos = b.get_global_rect().position + Vector2(0, 60)
		pop_up.popup(Rect2i(pos, Vector2(100, 100)))
	b.pressed.connect(option_press)
	return b


func _update_property() -> void:
	var node = get_edited_object()[get_edited_property()] as Node
	if !node:
		button.icon = null
		button.text = "Assign..."
		button.remove_theme_stylebox_override("normal")
		return

	var icon: Texture2D = AnyIcon.get_script_icon(node.get_script())
	var image: Image = icon.get_image().duplicate(true)
	image.resize(21, 21)
	button.icon = ImageTexture.create_from_image(image)

	button.text = node.name
	var obj = get_edited_object() as Node
	button.tooltip_text = obj.get_path_to(node)

	button.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	button.add_theme_stylebox_override("hover", StyleBoxEmpty.new())
