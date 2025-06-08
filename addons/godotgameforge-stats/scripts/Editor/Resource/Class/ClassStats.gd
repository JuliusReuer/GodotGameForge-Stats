class_name ClassStats
extends VBoxContainer

var class_resource: Class
var body: VBoxContainer = VBoxContainer.new()
var editor_theme: Theme
var stat: CompressedTexture2D = preload("res://addons/godotgameforge-stats/Icons/Stat.png")
var icon: Texture2D

func _init() -> void:
	editor_theme = EditorInterface.get_editor_theme()
	icon = ColorTheme.map_color_image_texture(stat.get_image(), Color.RED)
	icon.set_size_override(Vector2i(21, 21))

	var header: Label = Label.new()
	header.text = "Stats:"
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
	picker.text = "Add Stat..."
	picker.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	picker.icon = icon
	picker.pressed.connect(add_new_stat)
	picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var file_picker:Button = Button.new()
	footer.add_child(file_picker)
	file_picker.icon = editor_theme.get_icon("Load", "EditorIcons")
	file_picker.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	file_picker.pressed.connect(add_new_stat_file)


func update():
	for child in body.get_children():
		body.remove_child(child)
	for stat_item: StatItem in class_resource.Stats:
		var foldable = FoldableContainer.new()
		body.add_child(foldable)
		foldable.title = TextHelper.to_human(stat_item.stat.ID)
		if !stat_item.change_base_enabled and !stat_item.change_formula_enabled:
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
		is_hidden.button_pressed = stat_item.is_hidden

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
		var body = VBoxContainer.new()
		foldable.add_child(body)
		#region Base
		var v_b = VBoxContainer.new()
		body.add_child(v_b)

		var check_b: CheckBox = CheckBox.new()
		v_b.add_child(check_b)
		check_b.text = "Change Base"
		check_b.button_pressed = stat_item.change_base_enabled

		#region Create Base
		var base: SpinBox = SpinBox.new()
		v_b.add_child(base)

		base.visible = stat_item.change_base_enabled
		base.value = stat_item.change_base
		#endregion
		#endregion
		#region Formula
		var v_f = VBoxContainer.new()
		body.add_child(v_f)

		var check_f: CheckBox = CheckBox.new()
		v_f.add_child(check_f)
		check_f.text = "Change Formula"
		check_f.button_pressed = stat_item.change_formula_enabled
		
		var formula: EditorResourcePicker = EditorResourcePicker.new()
		v_f.add_child(formula)
		formula.visible = stat_item.change_formula_enabled
		formula.edited_resource = stat_item.change_formula
		formula.base_type = "Formula"
		#endregion
		#endregion

		#region Update Callbacks
		#region Header
		var update_is_hidden = func(): stat_item.is_hidden = is_hidden.button_pressed
		is_hidden.pressed.connect(update_is_hidden)

		var remove_pressed = func():
			class_resource.stats.erase(stat_item)
			update()
		remove.pressed.connect(remove_pressed)
		#endregion
		#region Body
		var update_base_enabled = func():
			stat_item.change_base_enabled = check_b.button_pressed
			base.visible = stat_item.change_base_enabled
		check_b.pressed.connect(update_base_enabled)
		
		var update_formula_enabled = func():
			stat_item.change_formula_enabled = check_f.button_pressed
			formula.visible = stat_item.change_formula_enabled
		check_f.pressed.connect(update_formula_enabled)

		var change_base = func(value: float):
			stat_item.change_base = value
		base.value_changed.connect(change_base)
		
		var change_formula = func(resource:Resource):
			stat_item.change_formula = resource as Formula
			ResourceSaver.save(class_resource)
		formula.resource_changed.connect(change_formula)
		#endregion
		#endregion


func add_new_stat():
	var q = func(path):
		if !path:
			return
		var stat:Stat = load(path)
		var filter = func(item:StatItem):
			return item.stat == stat
		var overlap = class_resource.Stats.filter(filter)
		if len(overlap) > 0:
			printerr("The Stat is already in this Class")
			return
		var item = StatItem.new()
		item.stat = stat
		class_resource.Stats.append(item)
		ResourceSaver.save(class_resource)
		update()
	EditorInterface.popup_quick_open(q,["Stat"])

func add_new_stat_file():
	print("I'm Realy Fucked")
