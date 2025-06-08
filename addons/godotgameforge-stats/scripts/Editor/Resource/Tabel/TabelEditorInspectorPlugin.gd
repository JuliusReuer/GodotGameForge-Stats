@tool
class_name TableEditorInspectorPlugin
extends EditorInspectorPlugin

var plot: TablePlot
var t_select: TableSelect


func _can_handle(object: Object):
	return object is Table


func _parse_begin(object: Object) -> void:
	var table = object as Table
	if table.base == null:
		table.base = TableLinearProgression.new()
	var control = TableEditorControl.new(table)
	add_custom_control(control)
