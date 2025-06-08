class_name TableEditorControl
extends VBoxContainer

var table: Table
var plot: TablePlot
var select: TableSelect
var body: Array[TableEditorProperty] = []


func set_zoom(new_zoom: float):
	plot.zoom = new_zoom
	update_plot()


func update_plot():
	plot.table = table.base
	plot.redraw()


func set_property(property: String, object):
	table.set(property, object)
	ResourceSaver.save(table)


func add_property(property: String, control: TableEditorProperty, label: String):
	if !label.is_empty():
		var l = Label.new()
		l.text = label
		control.add_child(l)
		control.move_child(l, 0)
	for child in control.get_children():
		if child is Control:
			child.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	control.set_property_data(property, table)
	add_child(control)
	control._update_property()
	control.property_changed.connect(set_property)


func add_body_property(property: String, control: TableEditorProperty, label: String):
	body.append(control)
	add_property(property, control, label)


func _init(table: Table):
	self.table = table
	build_editor()


func build_editor():
	build_head()
	build_body()


func build_head():
	#region Plot
	plot = TablePlot.new()
	add_child(plot)
	set_zoom(3)
	#endregion

	#region Zoom
	var h: HBoxContainer = HBoxContainer.new()

	#Zoom Label
	var label: Label = Label.new()
	label.text = "Zoom"
	h.add_child(label)

	#Zoom Slider
	var slider: HSlider = HSlider.new()
	slider.min_value = 3
	slider.max_value = 50
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	slider.value_changed.connect(set_zoom)

	h.add_child(slider)
	h.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(h)
	move_child(h, 0)
	#endregion

	select = TableSelect.new()
	select.changed.connect(update_plot)
	select.changed.connect(refresh_body)
	add_property("table", select, "Table")


func build_body():
	var max_level = TableInt.new("max_level")
	max_level.changed.connect(update_plot)
	add_body_property("base", max_level, "Max Level")
	match table.table:
		0:
			var increment = TableInt.new("increment")
			increment.changed.connect(update_plot)
			add_body_property("base", increment, "Increment")
		1:
			var increment = TableInt.new("increment")
			increment.changed.connect(update_plot)
			add_body_property("base", increment, "Increment")

			var rate = TableFloat.new("rate")
			rate.changed.connect(update_plot)
			add_body_property("base", rate, "Rate")
		2:
			var increment_per_level = TableInt.new("increment_per_level")
			increment_per_level.changed.connect(update_plot)
			add_body_property("base", increment_per_level, "Increment Per Level")


func clean_body():
	for child in body:
		remove_child(child)
	body.clear()


func refresh_body():
	clean_body()
	build_body()
