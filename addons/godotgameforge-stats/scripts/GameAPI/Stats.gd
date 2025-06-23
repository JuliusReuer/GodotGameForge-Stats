class_name Stats

static func _parse_operator(operation:String)->ValueChange.ChangeOperator:
	var operator: ValueChange.ChangeOperator
	match operation:
		"=":
			operator = ValueChange.ChangeOperator.SET
		"+":
			operator = ValueChange.ChangeOperator.ADD
		"-":
			operator = ValueChange.ChangeOperator.SUB
		"*":
			operator = ValueChange.ChangeOperator.MUL
		"/":
			operator = ValueChange.ChangeOperator.DIV
		_:
			printerr("Unknow operator \"%s\""%operator)
	return operator

static func add_stat_modifier():
	pass


static func add_status_effect():
	pass


## Easy Access Wrpper for change_attribute
static func change_attribute_str(
	target: Trait, attribute_id: String, operation: String, value: float
):
	change_attribute(target, attribute_id, ValueChange.new(_parse_operator(operation), value))


static func change_attribute(target: Trait, attribute_id: String, change: ValueChange):
	var data: RuntimeAttributeData = target.runtime_attributes.get_attribute_data(attribute_id)
	data.value = change.apply(data.value)


static func change_stat_str(target: Trait, stat_id: String, operation: String, value: float):
	change_stat(target, stat_id, ValueChange.new(_parse_operator(operation), value))


static func change_stat(target: Trait, stat_id: String, change: ValueChange):
	var data: RuntimeStatData = target.runtime_stats.get_stat_data(stat_id)
	data.base = change.apply(data.base)


static func clear_status_effects_type():
	pass


static func remove_stat_modifier():
	pass


static func remove_status_effect():
	pass


static func set_attribute():
	pass


static func set_formula():
	pass


static func set_stat():
	pass


static func set_status_effect():
	pass
