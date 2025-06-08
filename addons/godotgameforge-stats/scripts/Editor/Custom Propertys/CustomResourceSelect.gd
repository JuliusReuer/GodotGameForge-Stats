class_name CustomResourceSelect
extends EditorProperty

signal update

var base_type: String

var button: Button
var options: TextureButton
var editor_theme: Theme


func _get_minimum_size() -> Vector2:
	return Vector2(0, 30)


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
	b.text = "<empty>"
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	b.add_theme_stylebox_override("hover", StyleBoxEmpty.new())
	return b


func build_options() -> TextureButton:
	var b: TextureButton = TextureButton.new()
	b.texture_normal = editor_theme.get_icon("GuiOptionArrow", "EditorIcons")

	var pressed: Image = (
		editor_theme.get_icon("GuiOptionArrow", "EditorIcons").get_image().duplicate(true)
	)
	for x in pressed.get_width():
		for y in pressed.get_height():
			var pixel = pressed.get_pixel(x, y)
			pressed.set_pixel(x, y, pixel * Color.LIGHT_SKY_BLUE)

	b.texture_pressed = ImageTexture.create_from_image(pressed)

	b.custom_minimum_size = Vector2(28, 28)
	b.stretch_mode = TextureButton.STRETCH_KEEP_CENTERED

	var pop_up: PopupMenu = PopupMenu.new()
	var delete_texture = editor_theme.get_icon("Load", "EditorIcons")
	pop_up.add_icon_item(delete_texture, "Quick Load...")
	var copy_texture = editor_theme.get_icon("Load", "EditorIcons")
	pop_up.add_icon_item(copy_texture, "Load...")
	add_child(pop_up)

	var option_press = func():
		var node = get_edited_object()[get_edited_property()] as Node
		var obj = get_edited_object() as Node
		print(obj.get_path_to(node))
		var pos = b.get_global_rect().position + Vector2(-112, 60)
		pop_up.popup(Rect2i(pos, Vector2(100, 50)))
	b.pressed.connect(option_press)
	return b


func _update_property() -> void:
	var resource = get_edited_object()[get_edited_property()] as Resource
	if !resource:
		button.icon = null
		button.text = "<empty>"
		update.emit()
		return
	update_text(resource)
	update_icon(resource)
	update.emit()


func update_text(resource: Resource):
	button.text = resource.resource_name
	if "Name" in resource:
		button.text = resource.Name
	if button.text.is_empty():
		button.text = (resource.resource_path).get_file().get_basename()


func update_icon(resource: Resource):
	EditorInterface.get_resource_previewer().queue_resource_preview(
		resource.resource_path, self, "update_icon_callback", null
	)


func update_icon_callback(path, preview: Texture2D, thumbnail, data):
	var icon: Texture2D = preview
	var image: Image = icon.get_image().duplicate(true)
	image.resize(21, 21)
	button.icon = ImageTexture.create_from_image(image)
