class_name TableLinearProgression
extends BaseTable

@export var increment_per_level: int = 50


func _level_from_comulative(comulative: int):
	var sqaureRoot = pow(1 + 8.0 * float(comulative) / float(increment_per_level), 0.5)
	var level = (1 + sqaureRoot) / 2.0
	return clamp(floori(level), 1, max_level)


func _comulative_from_level(level: int):
	var power = pow(level, 2)
	var result = (power - level) * increment_per_level / 2.0
	return floori(result)
