class_name TableEditorProperty
extends HBoxContainer

signal property_changed(property: String, value)
signal changed

var editing_property: String
var editing_object


func set_property_data(property: String, object):
	editing_property = property
	editing_object = object


func get_edited_object() -> Object:
	return editing_object


func get_edited_property():
	return editing_property


func emit_changed(property: String, newValue):
	property_changed.emit(property, newValue)
	_update_property()
	changed.emit()


func _update_property():
	pass
