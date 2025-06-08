class_name RuntimeAttributes

signal event_change

var _traits: Trait
var _attributes: Dictionary[String,RuntimeAttributeData] = {}

var last_change: float


func _init(traits: Trait, override_attributes: Dictionary[String,OverrideAttributeData] = {}):
	_traits = traits
	_attributes = {}

	if override_attributes.is_empty():
		return
	for i in len(_traits.entity_class.Attributes):
		var attribute: AttributeItem = _traits.entity_class.Attributes[i]
		if !attribute or !attribute.attribute:
			printerr("No Attribute reference found")
			return

		if _attributes.has(attribute.attribute.ID):
			printerr("Duplicate Attribute '%s' has alerdy been defined" % [attribute.attribute.ID])
			return

		var data = RuntimeAttributeData.new(_traits, attribute)
		if !attribute.is_hidden and override_attributes.has(attribute.attribute.ID):
			var overrideData: OverrideAttributeData = override_attributes[
				attribute.attribute.ID
			]
			if overrideData.change_start_percent_enabled:
				var value: float = lerp(
					data.min_value, data.max_value, overrideData.change_start_percent
				)
				data.set_value_without_notiffy(value)
		data.event_change.connect(emit_event_change)
		_attributes.set(attribute.attribute.ID, data)


func emit_event_change(id: String, change: float):
	last_change = change
	event_change.emit(id)


func get_attribute_data(id: String) -> RuntimeAttributeData:
	if _attributes == null:
		return null
	if _attributes.has(id):
		return _attributes[id]

	printerr("Cannot find Attribute '%s' in Node '%s'" % [id, _traits.name])
	return null
