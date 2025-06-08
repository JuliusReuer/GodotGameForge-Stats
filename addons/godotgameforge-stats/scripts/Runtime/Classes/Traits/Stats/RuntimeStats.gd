class_name RuntimeStats

signal event_change(id: String)

var _traits: Trait
var _stats: Dictionary[String,RuntimeStatData] = {}

var last_change: float


func _init(traits: Trait, override_stats: Dictionary[String,OverrideStatData] = {}) -> void:
	_traits = traits
	_stats = {}
	if override_stats.is_empty():
		return
	for i in len(_traits.entity_class.Stats):
		var stat: StatItem = _traits.entity_class.Stats[i]
		if !stat or !stat.stat:
			printerr("No Stat reference found")
			return

		if _stats.has(stat.stat.ID):
			printerr("Duplicate Stat '%s' has alerdy been defined" % [stat.stat.ID])
			return

		var data = RuntimeStatData.new(_traits, stat)
		if !stat.is_hidden and override_stats.has(stat.stat.ID):
			var overrideData: OverrideStatData = override_stats[stat.stat.ID]
			if overrideData.change_base_enabled:
				data.set_base_without_notify(overrideData.change_base)

		data.event_change.connect(emit_event_change)
		_stats.set(stat.stat.ID, data)


func emit_event_change(id: String, change: float):
	last_change = change
	event_change.emit(id)


func clear_modifiers():
	for id in _stats:
		_stats[id].clear_modifiers()


func get_stat_data(id: String) -> RuntimeStatData:
	if _stats == null:
		return null
	if _stats.has(id):
		return _stats[id]

	printerr("Cannot find Stat '%s' in Node '%s'" % [id, _traits.name])
	return null
