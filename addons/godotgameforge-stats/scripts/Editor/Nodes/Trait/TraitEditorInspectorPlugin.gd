@tool
class_name TraitEditorInspectorPlugin
extends EditorInspectorPlugin


func _can_handle(object: Object):
	return object is Trait


func _parse_property(
	object: Object,
	type: Variant.Type,
	name: String,
	hint_type: PropertyHint,
	hint_string: String,
	usage_flags: int,
	wide: bool
) -> bool:
	if type == TYPE_OBJECT:
		if name == "entity_class":
			var picker = CustomResourceSelect.new()
			picker.base_type = "Class"
			add_property_editor(name, picker)

			var attr = TraitAttributes.new()
			add_custom_control(attr)

			var stats = TraitStats.new()
			add_custom_control(stats)

			var update_data = func():
				var trait_node = object as Trait
				var has_class = !!trait_node.entity_class
				if has_class:
					trait_node.override_attributes = Trait.sync_attributes_with_class(trait_node)

					trait_node.override_stats = Trait.sync_stats_with_class(trait_node)

					attr.trait_node = object
					attr.update()
					attr.visible = true

					stats.trait_node = object
					stats.update()
					stats.visible = true
				else:
					attr.visible = false
					stats.visible = false
			picker.update.connect(update_data)
			return false
	return false
