class_name FormulaUI
extends StatsUIElement

@export var target: Trait
@export var source: Trait
@export var formula: Formula
@export var format: String = "%d"
@export var value: Label
@export var ratio_fill: ProgressBar

var last_target: Trait
var last_source: Trait


func _ready() -> void:
	refresh_values()


func _on_change_stat(id: String):
	refresh_values()


func refresh_values() -> void:
	update_target_events()
	if !formula:
		return
	var formula_value = formula.calculate(source, target)
	if value:
		value.text = format % (formula_value)
	if ratio_fill:
		ratio_fill.value = formula_value * 100


func update_target_events():
	if !formula:
		return

	if last_source == source and last_target == target:
		return

	if last_source:
		if last_source.runtime_stats.event_change.is_connected(_on_change_stat):
			last_source.runtime_stats.event_change.disconnect(_on_change_stat)

	if last_target:
		if last_target.runtime_stats.event_change.is_connected(_on_change_stat):
			last_target.runtime_stats.event_change.disconnect(_on_change_stat)

	last_source = source
	last_target = target

	if source:
		if !source.runtime_stats.event_change.is_connected(_on_change_stat):
			source.runtime_stats.event_change.connect(_on_change_stat)

	if target:
		if !target.runtime_stats.event_change.is_connected(_on_change_stat):
			target.runtime_stats.event_change.connect(_on_change_stat)
