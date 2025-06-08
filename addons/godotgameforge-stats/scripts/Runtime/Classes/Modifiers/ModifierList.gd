class_name ModifierList
var _stat_id: String
var _list: Array[Modifier]
var value: float
var count: int:
	get():
		return len(_list)


func _init(id: String, list: Array[Modifier] = []) -> void:
	_stat_id = id
	_list = []
	value = 0

	for modifier in list:
		value += modifier.value
		_list.append(modifier)


func add(value: float):
	self.value += value
	_list.append(Modifier.new(_stat_id, value))


func remove(value: float) -> bool:
	for i in range(len(_list) - 1, -1, -1):
		if abs(_list[i].value - value) != 0:
			continue
		self.value -= value
		_list.remove_at(i)
		return true
	return false


func clear():
	value = 0
	_list.clear()
