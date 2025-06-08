class_name TraitStats
extends VBoxContainer

var trait_node: Trait
var body: VBoxContainer = VBoxContainer.new()


func _init() -> void:
	var header: Label = Label.new()
	header.text = "Stats:"
	add_child(header)
	var magrin_body = MarginContainer.new()
	magrin_body.add_theme_constant_override("margin_left", 10)
	magrin_body.add_theme_constant_override("margin_right", 10)
	add_child(magrin_body)
	magrin_body.add_child(body)


func update():
	for child in body.get_children():
		body.remove_child(child)
	for stat_item: StatItem in trait_node.entity_class.Stats:
		if stat_item.is_hidden:
			continue

		var id = stat_item.stat.ID
		var data: OverrideStatData = trait_node.override_stats[id]

		#region Create Foldable
		var foldable = FoldableContainer.new()
		body.add_child(foldable)
		foldable.title = TextHelper.to_human(stat_item.stat.ID)
		if !data.change_base_enabled:
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
		#endregion

		var v = VBoxContainer.new()
		foldable.add_child(v)

		#region Create Enabled
		var check: CheckBox = CheckBox.new()
		v.add_child(check)

		check.text = "Change Base"
		check.button_pressed = data.change_base_enabled

		check.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		#endregion
		#region Create Base
		var base: SpinBox = SpinBox.new()
		v.add_child(base)

		base.visible = data.change_base_enabled
		base.value = data.change_base
		#endregion

		#region Update Callbacks
		var update_enabled = func():
			data.change_base_enabled = check.button_pressed
			base.visible = data.change_base_enabled
		check.pressed.connect(update_enabled)

		var change_base = func(value: float): data.change_base = value
		base.value_changed.connect(change_base)
		#endregion
