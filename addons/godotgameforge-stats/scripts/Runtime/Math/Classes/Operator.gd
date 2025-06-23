class_name Operator

var type: int
var precedence: int
var inputs: int
var associativity: int


func _init(_type: int, _precedence: int, _inputs: int, _associativity: int) -> void:
	type = _type
	precedence = _precedence
	inputs = _inputs
	associativity = _associativity

func _to_string() -> String:
	return "Operator "+str({"type":type,"precedence":precedence,"inputs":inputs,"associativity":associativity})
