class_name TableManualProgression
extends BaseTable
@export var increments: Array[int]


func _level_from_comulative(comulative: int):
	var sum = 0
	for i in increments:
		if comulative < sum:
			return i
		sum += increments[i]
	return max_level


func _comulative_from_level(level: int):
	var sum = 0
	for i in level:
		sum += increments[i]
	return sum
