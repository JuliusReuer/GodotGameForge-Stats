class_name TableAPI


static func current_level(table: BaseTable, experience: int) -> int:
	if not table:
		return 0
	return table.get_comulative_experience_for_level(experience)


static func experience_for_level(table: BaseTable, level: int) -> int:
	if not table:
		return 0
	return table.get_level_experience_for_level(level)


static func comulative_experience_for_level(table: BaseTable, level: int) -> int:
	if not table:
		return 0
	return table.get_comulative_experience_for_level(level)


static func experience_for_current_level(table: BaseTable, comulative: int):
	if not table:
		return 0
	return table.get_level_experience_at_current_level(comulative)


static func experience_to_next_level(table: BaseTable, comulative: int):
	if not table:
		return 0
	return table.get_level_experience_to_next_level(comulative)


static func ratio_from_current_level(table: BaseTable, experience: int):
	if not table:
		return 0
	return table.get_ratio_at_current_level(experience)


static func ratio_for_next_level(table: BaseTable, experience: int):
	if not table:
		return 0
	return table.get_ratio_for_next_level(experience)
