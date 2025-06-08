class_name Modifiers

var _percentages: ModifierList
var _constants: ModifierList

var count: int:
	get():
		return _percentages.count + _constants.count


func _init(id: String, percentages: Array[Modifier] = [], constants: Array[Modifier] = []) -> void:
	_percentages = ModifierList.new(id, percentages)
	_constants = ModifierList.new(id, constants)


func calculate(value: float) -> float:
	value *= 1 + _percentages.value
	value += _constants.value
	return value


func add_percentage(percent: float):
	_percentages.add(percent)


func add_constant(value: float):
	_constants.add(value)


func remove_percentage(percent: float) -> bool:
	return _percentages.remove(percent)


func remove_constant(value: float) -> bool:
	return _constants.remove(value)


func clear():
	_percentages.clear()
	_constants.clear()
