class_name StatsUI
extends StatsUIElement

@export var target: Trait
@export var stat: Stat

@export_group("UI")
@export_subgroup("Graphics")
@export var icon: TextureRect
@export var color: Control
@export_subgroup("Text")
@export var Name: Label
@export var Acronym: Label
@export var Description: Label
@export_subgroup("Values")
@export var format: String = "%d"
@export var Value: Label
@export var Base: Label
@export var modifier: Label
@export var ratio_fill: ProgressBar

@export var active_if_modifiers: Node
@export var active_if_no_modifiers: Node

var last_target: Trait

var _group: TraitGroup


func _ready() -> void:
	_group = GroupHelper.is_in_group(self,"TraitGroup")
	if _group:
		_group.update.connect(pull_from_group_and_refresh)
		return
	refresh_values()


func pull_from_group_and_refresh():
	target = _group.group_trait
	refresh_values()


func _on_change_stat(id: String):
	refresh_values()


func refresh_values():
	update_target_events()
	if !stat:
		return

	if icon:
		icon.texture = stat.icon
	if color:
		color.modulate = stat.color
	if Name:
		Name.text = stat.Name
	if Acronym:
		Acronym.text = stat.Acronym
	if Description:
		Description.text = stat.Description

	var r_stat: RuntimeStatData = target.runtime_stats.get_stat_data(stat.ID)
	if !r_stat:
		return

	if Value:
		Value.text = format % r_stat.value
	if Base:
		Base.text = format % r_stat.base
	if modifier:
		modifier.text = "+%d" % r_stat.modifiers_value

	if ratio_fill:
		ratio_fill.value = r_stat.value

	var has_modifier: bool = r_stat.has_modifier

	if active_if_modifiers:
		if "visible" in active_if_modifiers:
			active_if_modifiers.visible = has_modifier
		else:
			printerr("Active If Modifiers Node has no 'visible' Property")

	if active_if_no_modifiers:
		if "visible" in active_if_no_modifiers:
			active_if_no_modifiers.visible = !has_modifier
		else:
			printerr("Active If No Modifiers Node has no 'visible' Property")


func update_target_events():
	if !stat:
		return

	if last_target == target:
		return

	if last_target:
		last_target.runtime_stats.event_change.disconnect(_on_change_stat)

	last_target = target

	if target:
		target.runtime_stats.event_change.connect(_on_change_stat)
