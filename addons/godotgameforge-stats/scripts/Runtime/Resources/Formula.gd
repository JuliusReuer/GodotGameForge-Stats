class_name Formula
extends StatsResource


class FindParameterResult:
	var result: bool
	var parameter_match: RegExMatch
	var index: int


var inputs = {
	"source\\.base\\[[a-zA-Z0-9_\\-]+\\]": _base_source_name,
	"source\\.stat\\[[a-zA-Z0-9_\\-]+\\]": _stat_source_name,
	"source\\.attr\\[[a-zA-Z0-9_\\-]+\\]": _attr_source_name,
	"target\\.base\\[[a-zA-Z0-9_\\-]+\\]": _base_target_name,
	"target\\.stat\\[[a-zA-Z0-9_\\-]+\\]": _stat_target_name,
	"target\\.attr\\[[a-zA-Z0-9_\\-]+\\]": _attr_target_name,
	"source\\.var\\[[a-zA-Z0-9_\\-]+\\]": _variable_source_name,
	"target\\.var\\[[a-zA-Z0-9_\\-]+\\]": _variable_target_name
}
const RX_EXTRACT_NAME = "\\[(?:\\[??([^\\[]*?)\\])"
@export var formula: String
@export var table: Table

var exp: FormulaExpression
var formula_hash: String
var domain: Domain
var parameters: Array[Parameter] = []
var _inputs: Array[float]


func calculate(source: Trait, target: Trait):
	if exp == null:
		initialize()
	domain = Domain.new(table, source, target)
	_set_inputs()
	var result = exp.evaluate(domain, _inputs)
	if result["success"]:
		return result["value"]
	else:
		printerr(result["error"])
	return null


func initialize():
	var form = formula
	var res: FindParameterResult = _find_parameter(form)
	while res.result:
		form = form.erase(
			res.parameter_match.get_start(),
			res.parameter_match.get_end() - res.parameter_match.get_start()
		)
		form = form.insert(res.parameter_match.get_start(), "#")

		var variable = Parameter.new(
			_clause_name(res.parameter_match.get_string()), inputs[inputs.keys()[res.index]]
		)
		parameters.append(variable)

		res = _find_parameter(form)

	exp = FormulaExpression.new(form)


func _find_parameter(formula: String) -> FindParameterResult:
	var parameter_match: RegExMatch = null
	var index: int = -1
	var min_index: int = -1
	for i in len(inputs.keys()):
		var input = inputs.keys()[i]
		var reg = RegEx.create_from_string(input)
		var candidat = reg.search(formula)
		if candidat and (candidat.get_start() < min_index or min_index == -1):
			index = i
			parameter_match = candidat
			min_index = candidat.get_start()
	var result = FindParameterResult.new()
	result.result = min_index != -1
	result.parameter_match = parameter_match
	result.index = index
	return result


func _set_inputs():
	_inputs.clear()
	for i in len(parameters):
		_inputs.append(parameters[i].function.call(domain, parameters[i].name))


func _clause_name(clause: String) -> String:
	var stri = RX_EXTRACT_NAME
	var reg = RegEx.create_from_string(stri)
	var reg_match = reg.search(clause)
	if reg_match and reg_match.get_group_count() == 1:
		return reg_match.get_string(1)
	return ""


#region functions
func _base_source_name(data: Domain, name: String) -> float:
	if data.source != null:
		var statdata: RuntimeStatData = data.source.runtime_stats.get_stat_data(name)
		if statdata:
			return statdata.base
		return 0
	else:
		return 0


func _stat_source_name(data: Domain, name: String) -> float:
	if data.source != null:
		var statdata: RuntimeStatData = data.source.runtime_stats.get_stat_data(name)
		if statdata:
			return statdata.value
		return 0
	else:
		return 0


func _attr_source_name(data: Domain, name: String) -> float:
	if data.source != null:
		var statdata: RuntimeAttributeData = data.source.runtime_attributes.get_attribute_data(name)
		if statdata:
			return statdata.value
		return 0
	else:
		return 0


func _base_target_name(data: Domain, name: String) -> float:
	if data.target != null:
		var statdata: RuntimeStatData = data.target.runtime_stats.get_stat_data(name)
		if statdata:
			return statdata.base
		return 0
	else:
		return 0


func _stat_target_name(data: Domain, name: String) -> float:
	if data.target != null:
		var statdata: RuntimeStatData = data.target.runtime_stats.get_stat_data(name)
		if statdata:
			return statdata.value
		return 0
	else:
		return 0


func _attr_target_name(data: Domain, name: String) -> float:
	if data.source != null:
		var statdata: RuntimeAttributeData = data.target.runtime_attributes.get_attribute_data(name)
		if statdata:
			return statdata.value
		return 0
	else:
		return 0


func _variable_source_name(data: Domain, name: String) -> float:
	if !data.source:
		return 0

	printerr("Currentyl not Programmed ... Formula._variable_source_name")
	#get data from object(source)
	return 0


func _variable_target_name(data: Domain, name: String) -> float:
	if !data.target:
		return 0

	printerr("Currentyl not Programmed ... Formula._variable_target_name")
	#get data from object(target)
	return 0
#endregion
