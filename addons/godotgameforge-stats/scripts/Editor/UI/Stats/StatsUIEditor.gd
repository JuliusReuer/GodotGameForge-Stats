@tool
class_name StatUIEditorInspectorPlugin
extends EditorInspectorPlugin

var _latest_window_ref: Window = null


func _can_handle(object: Object):
	return object is StatsUI


func _parse_property(
	object: Object,
	type: Variant.Type,
	name: String,
	hint_type: PropertyHint,
	hint_string: String,
	usage_flags: int,
	wide: bool
) -> bool:
	var ui = object as StatsUI

	if type == TYPE_OBJECT:
		if name == "target":
			if GroupHelper.is_in_group(ui,"TraitGroup"):
				return true
			var select = CustomNodeSelect.new()
			add_property_editor("target", select, true)
			return false
		if name == "stat":
			if GroupHelper.is_in_group(ui,"TraitGroup"):
				return false
			add_property_editor("stat", StatSelectOption.new())
			return true
	return false
