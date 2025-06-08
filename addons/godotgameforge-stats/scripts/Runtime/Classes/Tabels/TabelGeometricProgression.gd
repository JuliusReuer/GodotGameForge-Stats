class_name TableGeometricProgression
extends BaseTable

@export_storage var increment: int = 50
@export_storage var rate: float = 1.05


func log_with_base(value: float, base: float) -> float:
	return log(value) / log(base)


func _level_from_comulative(comulative: int) -> int:
	var value: float = (float(comulative) + increment + 1) * (rate - 1)
	var result: float = log_with_base(value / increment + 1, rate)
	return floori(result)


func _comulative_from_level(level: int) -> int:
	var value: float = (pow(rate, level) - 1) * (rate - 1)
	return floori(level * increment) - increment
