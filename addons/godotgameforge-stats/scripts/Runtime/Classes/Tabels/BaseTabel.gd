abstract class_name BaseTable
extends StatsHelperResource

@export_storage var min_level: int = 1
@export_storage var max_level: int = 99


func _level_from_comulative(comulative: int) -> int:
	return 0


func _comulative_from_level(level: int) -> int:
	return 0


func get_level_for_comulative_experience(comulative: int) -> int:
	return _level_from_comulative(comulative)


func get_comulative_experience_for_level(level: int) -> int:
	level = clampi(level, min_level, max_level + 1)
	return _comulative_from_level(level)


func get_level_experience_for_level(level: int) -> int:
	var curr_level = clampi(level + 0, min_level, max_level + 1)
	var next_level = clampi(level + 1, min_level, max_level + 1)

	var comulative_current = _comulative_from_level(curr_level)
	var comulative_next = _comulative_from_level(next_level)

	return comulative_next - comulative_current


func get_level_experience_at_current_level(comulative: int) -> int:
	var current_level = get_level_for_comulative_experience(comulative)
	return comulative - _comulative_from_level(current_level)


func get_level_experience_to_next_level(comulative: int) -> int:
	var next_level = get_next_level(comulative)
	return _comulative_from_level(next_level) - comulative


func get_ratio_at_current_level(comulative: int) -> float:
	var experience_from = get_level_experience_at_current_level(comulative)
	var experience_to = get_level_experience_to_next_level(comulative)
	return float(experience_from) / (experience_from + experience_to)


func get_ratio_for_next_level(comulative: int) -> float:
	return 1.0 - get_ratio_at_current_level(comulative)


func get_previous_level(comulative: int) -> int:
	var current_level = _level_from_comulative(comulative)
	return max(1, current_level - 1)


func get_next_level(comulative: int) -> int:
	var current_level = _level_from_comulative(comulative)
	return min(max_level, current_level + 1)
