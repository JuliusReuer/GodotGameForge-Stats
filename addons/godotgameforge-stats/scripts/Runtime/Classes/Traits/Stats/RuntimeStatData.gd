class_name RuntimeStatData

signal event_change(id: String, change: float)

var _traits: Trait
var _stat: Stat
var _modifiers: Modifiers
var _base: float
var _formula: Formula

var base: float:
	get():
		return _base
	set(val):
		if abs(_base - val) == 0:
			return
		var prev_value: float = value
		_base = val
		event_change.emit(_stat.ID, value - prev_value)

var value: float:
	get():
		var val: float = _base
		if _formula and !_formula.formula.is_empty():
			val = _formula.calculate(_traits, _traits)
		return _modifiers.calculate(val)

var modifiers_value: float:
	get():
		var val = _base
		if _formula and !_formula.Formula.is_empty():
			val = _formula.calculate(_traits, _traits)
		return _modifiers.calculate(val) - val

var has_modifier: bool:
	get():
		return _modifiers.count > 0


func _init(traits: Trait, stat: StatItem) -> void:
	_traits = traits
	_stat = stat.stat

	_modifiers = Modifiers.new(stat.stat.ID)

	_base = stat.base
	_formula = stat.formula


func add_modifier(type: Modifier.ModifierType, value: float):
	match type:
		Modifier.ModifierType.CONSTANT:
			_modifiers.add_constant(value)
		Modifier.ModifierType.PERCENT:
			_modifiers.add_percentage(value)
	event_change.emit(_stat.ID, 0)


func remove_modifier(type: Modifier.ModifierType, value: float) -> bool:
	var success: bool
	match type:
		Modifier.ModifierType.CONSTANT:
			success = _modifiers.remove_constant(value)
		Modifier.ModifierType.PERCENT:
			success = _modifiers.remove_percentage(value)
	if success:
		event_change.emit(_stat.ID, 0)
	return success


func clear_modifiers():
	if _modifiers.count > 0:
		_modifiers.clear()
		event_change.emit(_stat.ID, 0)


func set_base_without_notify(value: float):
	_base = value
