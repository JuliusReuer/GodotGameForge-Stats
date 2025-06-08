class_name Modifier

enum ModifierType { CONSTANT, PERCENT }

var stat_id: String
var value: float

var clone: Modifier:
	get():
		return Modifier.new(stat_id, value)


func _init(_stat_id: String, _value: float) -> void:
	stat_id = _stat_id
	value = _value
