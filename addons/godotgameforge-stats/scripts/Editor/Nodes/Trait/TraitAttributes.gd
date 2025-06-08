class_name TraitAttributes
extends VBoxContainer

var trait_node: Trait
var body: VBoxContainer = VBoxContainer.new()


func _init() -> void:
	var header: Label = Label.new()
	header.text = "Atributes:"
	add_child(header)
	var magrin_body = MarginContainer.new()
	magrin_body.add_theme_constant_override("margin_left", 10)
	magrin_body.add_theme_constant_override("margin_right", 10)
	add_child(magrin_body)
	magrin_body.add_child(body)


func update():
	for child in body.get_children():
		body.remove_child(child)
	for attribute_item: AttributeItem in trait_node.entity_class.Attributes:
		if attribute_item.is_hidden:
			continue
		
		var id = attribute_item.attribute.ID
		var data: OverrideAttributeData = trait_node.override_attributes[id]

		var foldable = FoldableContainer.new()
		body.add_child(foldable)
		foldable.title = TextHelper.to_human(attribute_item.attribute.ID)
		if !data.is_expand:
			foldable.fold()
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

		var v = VBoxContainer.new()
		foldable.add_child(v)

		var check: CheckBox = CheckBox.new()
		v.add_child(check)
		check.text = "Change Start Percent"
		check.button_pressed = data.change_start_percent_enabled

		#region Create Percent
		var percent = HBoxContainer.new()
		v.add_child(percent)
		percent.size_flags_vertical = Control.SIZE_EXPAND_FILL
		percent.visible = data.change_start_percent_enabled

		var slider: HSlider = HSlider.new()
		percent.add_child(slider)
		slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		slider.value = data.change_start_percent * (attribute_item.change_start_percent * 100)
		slider.step = 0.01

		var number: Label = Label.new()
		percent.add_child(number)
		number.text = "%3.1f %%" % data.change_start_percent
		#endregion

		#region Update Callbacks
		var change_expand = func(is_folded:bool):
			data.is_expand = !is_folded
		foldable.folding_changed.connect(change_expand)
		
		var update_enabled = func():
			data.change_start_percent_enabled = check.button_pressed
			percent.visible = data.change_start_percent_enabled
		check.pressed.connect(update_enabled)

		var change_slider = func(value: float):
			data.change_start_percent = value
			number.text = "%3.1f %%" % value
		slider.value_changed.connect(change_slider)
		#endregion
