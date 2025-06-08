class_name ValueChange
enum ChangeOperator { SET, ADD, SUB, MUL, DIV }

var _operation: ChangeOperator = ChangeOperator.SET
var _value: float


func _init(operator: ChangeOperator, value: float) -> void:
	_operation = operator
	_value = value


func apply(value_to_modify: float) -> float:
	match _operation:
		ChangeOperator.SET:
			return _value
		ChangeOperator.ADD:
			return value_to_modify + _value
		ChangeOperator.SUB:
			return value_to_modify - _value
		ChangeOperator.MUL:
			return value_to_modify * _value
		ChangeOperator.DIV:
			return value_to_modify / _value
		_:
			return _value


func _to_string() -> String:
	match _operation:
		ChangeOperator.SET:
			return "= %d" % _value
		ChangeOperator.ADD:
			return "+ %d" % _value
		ChangeOperator.SUB:
			return "- %d" % _value
		ChangeOperator.MUL:
			return "* %d" % _value
		ChangeOperator.DIV:
			return "/ %d" % _value
		_:
			return "unknown %d" % _value
