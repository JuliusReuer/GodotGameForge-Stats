class_name ClassAttributes
extends VBoxContainer

var class_resource: Class
var body: VBoxContainer = VBoxContainer.new()
var editor_theme: Theme
var attr: CompressedTexture2D = preload("res://addons/godotgameforge-stats/Icons/Attr.png")
var icon: Texture2D

func _init() -> void:
	editor_theme = EditorInterface.get_editor_theme()
	icon = ColorTheme.map_color_image_texture(attr.get_image(), Color.BLUE)
	icon.set_size_override(Vector2i(21, 21))

	var header: Label = Label.new()
	header.text = "Atributes:"
	add_child(header)
	var magrin_body = MarginContainer.new()
	magrin_body.add_theme_constant_override("margin_left", 5)
	magrin_body.add_theme_constant_override("margin_right", 5)
	add_child(magrin_body)
	magrin_body.add_child(body)

	var footer:HBoxContainer = HBoxContainer.new()
	add_child(footer)
	
	var picker: Button = Button.new()
	footer.add_child(picker)
	picker.text = "Add Attribute..."
	picker.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	picker.icon = icon
	picker.pressed.connect(add_new_attribute)
	picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var file_picker:Button = Button.new()
	footer.add_child(file_picker)
	file_picker.icon = editor_theme.get_icon("Load", "EditorIcons")
	file_picker.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	file_picker.pressed.connect(add_new_attribute_file)


func update():
	for child in body.get_children():
		body.remove_child(child)
	for attribute_item: AttributeItem in class_resource.Attributes:
		var foldable = FoldableContainer.new()
		body.add_child(foldable)
		foldable.title = TextHelper.to_human(attribute_item.attribute.ID)
		if !attribute_item.change_start_percent_enabled:
			foldable.fold()

		#region Setup Foldable Header
		var is_hidden: CheckBox = CheckBox.new()
		foldable.add_title_bar_control(is_hidden)
		is_hidden.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		is_hidden.add_theme_icon_override(
			"unchecked", editor_theme.get_icon("GuiVisibilityVisible", "EditorIcons")
		)
		is_hidden.add_theme_icon_override(
			"checked", editor_theme.get_icon("GuiVisibilityHidden", "EditorIcons")
		)
		is_hidden.button_pressed = attribute_item.is_hidden

		var remove: TextureButton = TextureButton.new()
		foldable.add_title_bar_control(remove)
		remove.texture_normal = editor_theme.get_icon("Clear", "EditorIcons")
		#endregion

		#region Theme Foldable
		foldable.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
		foldable.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		foldable.add_theme_color_override("collapsed_font_color", Color.WHITE)

		var default = StyleBoxFlat.new()
		default.bg_color = Color("242a32ff")
		default.content_margin_left = 4
		default.content_margin_top = 4
		default.content_margin_right = 4
		default.content_margin_bottom = 4
		foldable.add_theme_stylebox_override("title_collapsed_panel", default)
		foldable.add_theme_stylebox_override("title_panel", default)

		var hover = StyleBoxFlat.new()
		hover.bg_color = Color("2d3139ff")
		hover.content_margin_left = 4
		hover.content_margin_top = 4
		hover.content_margin_right = 4
		hover.content_margin_bottom = 4
		foldable.add_theme_stylebox_override("title_collapsed_hover_panel", hover)
		foldable.add_theme_stylebox_override("title_hover_panel", hover)
		#endregion

		#region Setup Foldable Body
		var v = VBoxContainer.new()
		foldable.add_child(v)

		var check: CheckBox = CheckBox.new()
		v.add_child(check)
		check.text = "Change Start Percent"
		check.button_pressed = attribute_item.change_start_percent_enabled

		#region Create Percent
		var percent = HBoxContainer.new()
		v.add_child(percent)
		percent.size_flags_vertical = Control.SIZE_EXPAND_FILL
		percent.visible = attribute_item.change_start_percent_enabled

		var slider: HSlider = HSlider.new()
		percent.add_child(slider)
		slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		slider.value = attribute_item.change_start_percent
		slider.max_value = 1
		slider.step = 0.001

		var number: Label = Label.new()
		percent.add_child(number)
		number.text = "%3.1f %%" % (attribute_item.change_start_percent * 100)
		#endregion
		#endregion

		#region Update Callbacks
		#region Header
		var update_is_hidden = func(): attribute_item.is_hidden = is_hidden.button_pressed
		is_hidden.pressed.connect(update_is_hidden)

		var remove_pressed = func():
			class_resource.Attributes.erase(attribute_item)
			update()
		remove.pressed.connect(remove_pressed)
		#endregion
		#region Body
		var update_enabled = func():
			attribute_item.change_start_percent_enabled = check.button_pressed
			percent.visible = attribute_item.change_start_percent_enabled
		check.pressed.connect(update_enabled)

		var change_slider = func(value: float):
			attribute_item.change_start_percent = value
			number.text = "%3.1f %%" % (value * 100)
		slider.value_changed.connect(change_slider)
		#endregion
		#endregion


func add_new_attribute():
	var q = func(path):
		if !path:
			return
		var attribute:Attribute = load(path)
		var filter = func(item:AttributeItem):
			return item.attribute == attribute
		var overlap = class_resource.Attributes.filter(filter)
		if len(overlap) > 0:
			printerr("The Attribute is already in this Class")
			return
		var item = AttributeItem.new()
		item.attribute = attribute
		class_resource.Attributes.append(item)
		ResourceSaver.save(class_resource)
		update()
	EditorInterface.popup_quick_open(q,["Attribute"])

func add_new_attribute_file():
	print("I'm Realy Fucked")
