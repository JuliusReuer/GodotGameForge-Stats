@icon("res://icon.svg")
class_name Trait
extends Node

signal event_change

@export var entity_class: Class
@export_storage var override_attributes: Dictionary[String,OverrideAttributeData] = {}
@export_storage var override_stats: Dictionary[String,OverrideStatData] = {}

var runtime_stats: RuntimeStats
var runtime_attributes: RuntimeAttributes


func _ready() -> void:
	runtime_init_stats()
	runtime_init_attributes()


func _process(delta: float) -> void:
	pass
	#runtime_status_effects.update()


func emit_changed(stat_id: String):
	event_change.emit()


func runtime_init_stats():
	if runtime_stats:
		return
	if entity_class == null:
		runtime_stats = RuntimeStats.new(self)
		print_debug("Traits Node has no Class reference")
		return
	runtime_stats = RuntimeStats.new(self, override_stats)
	runtime_stats.event_change.connect(emit_changed)


func runtime_init_attributes():
	if runtime_attributes:
		return
	if entity_class == null:
		runtime_attributes = RuntimeAttributes.new(self)
		print_debug("Traits Node has no Class reference")
		return
	runtime_attributes = RuntimeAttributes.new(self, override_attributes)
	runtime_attributes.event_change.connect(emit_changed)

static func sync_attributes_with_class(trait_node:Trait)->Dictionary[String,OverrideAttributeData]:
	var traits_class: Class = trait_node.entity_class
	var data: Dictionary[String,OverrideAttributeData] = {}

	for i in len(traits_class.Attributes):
		var attribute = traits_class.Attributes[i]
		if !attribute or !attribute.attribute or attribute.is_hidden:
			continue
		var entry: OverrideAttributeData
		if trait_node.override_attributes.has(attribute.attribute.ID):
			entry = trait_node.override_attributes[attribute.attribute.ID]

		data[attribute.attribute.ID] = entry if entry else OverrideAttributeData.new()

	return data 

static func sync_stats_with_class(trait_node:Trait)->Dictionary[String,OverrideStatData]:
	var traits_class: Class = trait_node.entity_class
	var data: Dictionary[String,OverrideStatData] = {}

	for i in len(traits_class.Stats):
		var stat = traits_class.Stats[i]
		if !stat or !stat.stat or stat.is_hidden:
			continue
		var entry: OverrideStatData
		if trait_node.override_stats.has(stat.stat.ID):
			entry = trait_node.override_stats[stat.stat.ID]

		data[stat.stat.ID] = entry if entry else OverrideStatData.new()

	return data
