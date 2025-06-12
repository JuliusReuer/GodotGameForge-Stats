class_name TableConstantProgression
extends BaseTable

@export var increment: int = 50


func _level_from_comulative(comulative: int) -> int:
	var level: float = float(comulative + increment) / increment
	return clamp(level, 0, max_level + 1)


func _comulative_from_level(level: int) -> int:
	return level * increment - increment
