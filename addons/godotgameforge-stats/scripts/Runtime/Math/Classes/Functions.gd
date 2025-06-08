class_name Functions


static func table_level(domain: Domain, value: float) -> float:
	var input: int = floori(value)
	return TableAPI.current_level(domain.table.base, input)


static func table_value(domain: Domain, value: float) -> float:
	var input: int = floori(value)
	return TableAPI.comulative_experience_for_level(domain.table.base, input)


static func table_increment(domain: Domain, value: float) -> float:
	var input: int = floori(value)
	return TableAPI.experience_for_level(domain.table.base, input)


static func table_ratio_for_current_level(domain: Domain, value: float) -> float:
	var input: int = floori(value)
	return TableAPI.ratio_from_current_level(domain.table.base, value)


static func table_exp_for_current_level(domain: Domain, value: float) -> float:
	var input: int = floori(value)
	return TableAPI.experience_for_current_level(domain.table.base, input)


static func table_exp_to_next_level(domain: Domain, value: float) -> float:
	var input: int = floori(value)
	return TableAPI.experience_to_next_level(domain.table.base, input)
