class_name TableSelect
extends TableEditorProperty

var options = OptionButton.new()
var updating: bool = false


func _init() -> void:
	add_child(options)
	options.item_selected.connect(_item_selected)
	refresh_options()


func _item_selected(index: int):
	if updating:
		return

	var base: BaseTable
	match index:
		0:
			base = TableConstantProgression.new()
		1:
			base = TableGeometricProgression.new()
		2:
			base = TableLinearProgression.new()
		3:
			base = TableManualProgression.new()
		_:
			return
	var table = get_edited_object() as Table
	table.base = base
	emit_changed(get_edited_property(), index)


func _update_property() -> void:
	updating = true
	refresh_options()
	var value = get_edited_object().get(get_edited_property())
	if value:
		options.select(value)
	updating = false


var items = [
	"Constant Progression", "Geometric Progression", "Linear Progression", "Manual Progression"
]


func refresh_options():
	options.clear()
	for item in items:
		options.add_item(item)
