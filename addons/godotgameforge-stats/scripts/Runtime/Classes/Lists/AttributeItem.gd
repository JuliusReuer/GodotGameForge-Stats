class_name AttributeItem
extends StatsHelperResource

@export var is_hidden: bool
@export var attribute: Attribute
@export var change_start_percent_enabled: bool
@export_range(0, 1, 0.001) var change_start_percent: float = 1

var min_value: float:
	get():
		return attribute.min_value if attribute else 0

var max_value: Stat:
	get():
		return attribute.max_value if attribute else null

var start_percent: float:
	get():
		if !attribute:
			return 0
		return change_start_percent if change_start_percent_enabled else attribute.start_percent
