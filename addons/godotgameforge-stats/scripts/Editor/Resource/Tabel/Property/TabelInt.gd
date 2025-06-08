class_name TableInt
extends TableEditorProperty

var box = SpinBox.new()
var updating: bool = false
var subpath: String


func _init(subpath: String) -> void:
	self.subpath = subpath
	add_child(box)
	box.value_changed.connect(_value_changed)


func _value_changed(index: int):
	if updating:
		return
	var base = get_edited_object()[get_edited_property()]
	if base:
		base[subpath] = index
	emit_changed(get_edited_property(), base)


func _update_property() -> void:
	updating = true
	var base = get_edited_object()[get_edited_property()]
	if base:
		box.value = base[subpath]
	updating = false
