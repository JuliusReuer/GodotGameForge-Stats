class_name RuntimeAttributeData

signal event_change(id: String, change: float)

var _traits: Trait
var _attribute: Attribute
var _modifiers: Modifiers
var _min_value: float
var _max_value: Stat
var _value: float

var min_value: float:
	get():
		return _min_value

var max_value: float:
	get():
		return _traits.runtime_stats._stats[_max_value.ID].value if _max_value else 0

var value:
	set(val):
		var old_value = value
		var new_value = clamp(val, min_value, max_value)
		if abs(_value - new_value) == 0:
			return
		_value = new_value
		event_change.emit(_attribute.ID, new_value - old_value)
	get():
		return _value

var ratio: float:
	get():
		return (value - min_value) / (max_value - min_value)


func _init(traits: Trait, attribute: AttributeItem) -> void:
	_traits = traits
	_attribute = attribute.attribute

	_min_value = attribute.min_value
	_max_value = attribute.max_value

	_value = lerp(min_value, max_value, attribute.start_percent)

	if _max_value:
		traits.runtime_stats.event_change.connect(recalculate_value)


func recalculate_value(id: String):
	var val = clamp(_value, min_value, max_value)
	if abs(_value - val) == 0:
		return
	value = _value


func set_value_without_notiffy(new_value: float):
	_value = new_value
