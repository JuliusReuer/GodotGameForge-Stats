class_name FormulaEditorInspectorPlugin
extends EditorInspectorPlugin

func _can_handle(object: Object):
	return object is Formula


func _parse_property(
	object: Object,
	type: Variant.Type,
	name: String,
	hint_type: PropertyHint,
	hint_string: String,
	usage_flags: int,
	wide: bool
) -> bool:
	if name == "formula":
		var f_str = FormulaString.new()
		f_str.formula = object
		add_custom_control(f_str)
		f_str.update()
		return true
		
	return false
