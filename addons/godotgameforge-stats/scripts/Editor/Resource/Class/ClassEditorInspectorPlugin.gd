@tool
class_name ClassEditorInspectorPlugin
extends EditorInspectorPlugin


func _can_handle(object: Object):
	return object is Class


func _parse_property(
	object: Object,
	type: Variant.Type,
	name: String,
	hint_type: PropertyHint,
	hint_string: String,
	usage_flags: int,
	wide: bool
) -> bool:
	if name == "Attributes":
		var attributes = ClassAttributes.new()
		attributes.class_resource = object
		add_custom_control(attributes)
		attributes.update()
		return true
	if name == "Stats":
		var attributes = ClassStats.new()
		attributes.class_resource = object
		add_custom_control(attributes)
		attributes.update()
		return true
	return false
