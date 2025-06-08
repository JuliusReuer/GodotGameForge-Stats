class_name StatItem
extends StatsHelperResource
#TODO: REMOVE Resource and exports
@export var is_hidden: bool
@export var stat: Stat
@export var change_base_enabled: bool
@export var change_base: float = 100
@export var change_formula_enabled: bool
@export var change_formula: Formula

var base: int:
	get():
		if !stat:
			return 0
		return change_base if change_base_enabled else stat.Base

var formula: Formula:
	get():
		if !stat:
			return null
		return change_formula if change_formula_enabled else stat.Formula
