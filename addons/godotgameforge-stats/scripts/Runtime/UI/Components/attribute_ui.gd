class_name AttributeUI
extends StatsUIElement

@export var target: Trait
@export var attribute: Attribute

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
@export var percentage: Label
@export var min_value: Label
@export var max_value: Label
@export_subgroup("")
@export var progress_bar: ProgressBar
@export_subgroup("Units")
@export_subgroup("Transitions")
@export var when_increment: bool
@export var when_decrement: bool
@export var stall_duration: float
@export var transition_duration: float

var cur_target: Trait

var _group: TraitGroup


func _ready() -> void:
	_group = GroupHelper.is_in_group(self,"TraitGroup")
	if _group:
		_group.update.connect(pull_from_group_and_refresh)
		return
	refresh_values()
	refresh_progress()


func pull_from_group_and_refresh():
	target = _group.group_trait
	refresh_values()
	refresh_progress()


func _on_change_attribute():
	refresh_values()
	refresh_progress()


var transition_tween: Tween


func update_progress(new_ratio: float):
	if !progress_bar:
		return
	var is_increment = new_ratio > (progress_bar.value / 100.0)
	var is_decrement = new_ratio < (progress_bar.value / 100.0)
	var should_tween = (is_increment and when_increment) or (is_decrement and when_decrement)
	if should_tween:
		if transition_tween and transition_tween.is_running():
			transition_tween.kill()
		transition_tween = create_tween()
		transition_tween.tween_property(progress_bar, "value", progress_bar.value, stall_duration)
		transition_tween.tween_property(progress_bar, "value", new_ratio * 100, transition_duration)
		return
	progress_bar.value = new_ratio * 100


func refresh_progress():
	if !cur_target:
		return
	if !attribute:
		return
	if !target:
		return

	var attribute_data = target.runtime_attributes._attributes[attribute.ID]

	update_progress(attribute_data.ratio)


func refresh_values():
	update_target_events()

	if attribute == null:
		return
	if cur_target == null:
		return

	if icon:
		icon.texture = attribute.icon
	if color:
		color.self_modulate = attribute.color

	if Name:
		Name.text = attribute.Name
	if Acronym:
		Acronym.text = attribute.Acronym
	if Description:
		Description.text = attribute.Description

	var r_attribute: RuntimeAttributeData = cur_target.runtime_attributes.get_attribute_data(
		attribute.ID
	)
	if r_attribute == null:
		return

	#TODO: Continiue
	if Value:
		Value.text = format % r_attribute.value


func update_target_events():
	if attribute == null:
		return
	if cur_target == target:
		return
	if cur_target != null:
		cur_target.event_change.disconnect(_on_change_attribute)
	cur_target = target
	if target == null:
		return
	target.event_change.connect(_on_change_attribute)
	refresh_values()
