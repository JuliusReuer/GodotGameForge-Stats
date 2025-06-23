class_name FormulaExpression


class FormulaExpressionResult:
	var success: bool
	var new_value: float
	var error: String

static var _operators: Dictionary[String,Operator] = {
	"-": Operator.new(Function.SUB, 2, 2, Associativity.L),
	"+": Operator.new(Function.ADD, 2, 2, Associativity.L),
	"/": Operator.new(Function.DIV, 3, 2, Associativity.L),
	"*": Operator.new(Function.MUL, 3, 2, Associativity.L),
	"%": Operator.new(Function.MOD, 3, 2, Associativity.L),
	"^": Operator.new(Function.POW, 5, 2, Associativity.R),
	"_": Operator.new(Function.NEG, 5, 1, Associativity.L),
	"sqrt": Operator.new(Function.SQRT, 4, 1, Associativity.L),
	"cos": Operator.new(Function.COS, 4, 1, Associativity.L),
	"sin": Operator.new(Function.SIN, 4, 1, Associativity.L),
	"tan": Operator.new(Function.TAN, 4, 1, Associativity.L),
	"floor": Operator.new(Function.FLOOR, 4, 1, Associativity.L),
	"ceil": Operator.new(Function.CEIL, 4, 1, Associativity.L),
	"min": Operator.new(Function.MIN, 4, 2, Associativity.L),
	"max": Operator.new(Function.MAX, 4, 2, Associativity.L),
	"round": Operator.new(Function.ROUND, 4, 1, Associativity.L),
	"random": Operator.new(Function.RANDOM, 4, 2, Associativity.L),
	"dice": Operator.new(Function.DICE, 4, 2, Associativity.L),
	"chance": Operator.new(Function.CHANCE, 4, 1, Associativity.L),
	"table.level": Operator.new(Function.TABLE_LEVEL, 4, 1, Associativity.L),
	"table.value": Operator.new(Function.TABLE_VALUE, 4, 1, Associativity.L),
	"table.increment": Operator.new(Function.TABLE_INCREMENT, 4, 1, Associativity.L),
	"table.current": Operator.new(Function.TABLE_CURRENT, 4, 1, Associativity.L),
	"table.next": Operator.new(Function.TABLE_NEXT, 4, 1, Associativity.L),
	"table.ratio": Operator.new(Function.TABLE_RATIO, 4, 1, Associativity.L)
}

var _RPNTokens: Array[String] = []
var _input_decoder: Dictionary[String,int]


func _init(input: String) -> void:
	input = _clean_input(input)
	var infixTokens: Array[String] = _input_to_tokens(input)
	infixTokens = _setup_variables(infixTokens)
	infixTokens = _fix_unary_operators(infixTokens)
	_RPNTokens = _format_to_rpn(infixTokens).duplicate()  #Has to Deepclone Otherwies would override RPN tokens of other Formulas
	_input_decoder = {}
	for token in _RPNTokens:
		if !_is_variable(token):
			continue

		var index = _variable_index(token)
		if index == -1:
			continue

		_input_decoder.set(token, index)


#region internal methods
func evaluate(domain: Domain, inputs: Array[float]):
	var result = _evaluate_tokens(_RPNTokens, domain, inputs)
	return {"success": result.success, "value": result.new_value, "error": result.error}


#endregion
#region private methods
static func _clean_input(input: String) -> String:
	var result: String = input.to_lower()
	result = result.strip_edges()
	if len(result) == 0:
		return result

	if _is_operator(result[len(result) - 1]):
		result = result.trim_suffix(result[len(result) - 1])

	return result


static func _input_to_tokens(input: String) -> Array[String]:
	var _create_tokens_list: Array[String] = []
	var current_string = ""
	for char in input:
		if _is_command(char):
			if len(current_string) > 0:
				_create_tokens_list.append(current_string)
			_create_tokens_list.append(char)
			current_string = ""
		else:
			if char != " ":
				current_string += char
			else:
				if len(current_string) > 0:
					_create_tokens_list.append(current_string)

				current_string = ""
	if len(current_string) > 0:
		_create_tokens_list.append(current_string)
	return _create_tokens_list


static func _setup_variables(tokens: Array[String]) -> Array[String]:
	var index = 0
	for i in len(tokens):
		if _is_variable(tokens[i]):
			tokens[i] = "#" + str(index)
			index += 1
	return tokens


static func _fix_unary_operators(tokens: Array[String]) -> Array[String]:
	if len(tokens) == 0:
		return tokens
	if tokens[0] == "-":
		tokens[0] = "_"

	for i in range(1, len(tokens)):
		var token = tokens[i]
		var prev = tokens[i - 1]
		if token == "-" && _is_command(prev) && !_is_close_bracket(prev):
			tokens[i] = "_"

	return tokens


static func _format_to_rpn(tokens: Array[String]) -> Array[String]:
	var _operator_stack: Array[String] = []
	var _output_queue: Array[String] = []
	for token in tokens:
		if _is_command(token):
			if _is_open_bracket(token):
				_operator_stack.push_back(token)
			elif _is_close_bracket(token):
				while (
					len(_operator_stack) > 0
					&& !_is_open_bracket(_operator_stack[len(_operator_stack) - 1])
				):
					_output_queue.append(_operator_stack.pop_back())
				if len(_operator_stack) > 0:
					_operator_stack.pop_back()
				if (
					len(_operator_stack) > 0
					&& _is_function(_operator_stack[len(_operator_stack) - 1])
				):
					_output_queue.append(_operator_stack.pop_back())
			elif token[0] == ",":
				while (
					len(_operator_stack) > 0
					&& !_is_open_bracket(_operator_stack[len(_operator_stack) - 1])
				):
					_output_queue.append(_operator_stack.pop_back())
			else:
				var token_operator = _token_to_operator(token)
				while _need_to_pop(_operator_stack, token_operator):
					_output_queue.append(_operator_stack.pop_back())
				_operator_stack.push_back(token)
		elif _is_function(token):
			_operator_stack.push_back(token)
		elif _is_variable(token):
			_output_queue.append(token)
		else:
			_output_queue.append(token)
	while len(_operator_stack) > 0:
		_output_queue.push_back(_operator_stack.pop_back())
	return _output_queue


#endregion
#region evaluation methods
func _evaluate_tokens(
	tokens: Array[String], domain: Domain, inputs: Array[float]
) -> FormulaExpressionResult:
	var _evaluation_stack: Array[String] = []
	for token in tokens:
		if _is_operator(token):
			var tokenOperator: Operator = _token_to_operator(token)
			var _evaluation_values: Array[float] = []
			var parsed = true
			
			while (
				len(_evaluation_stack) > 0
				&& !_is_command(_evaluation_stack[len(_evaluation_stack) - 1])
				&& len(_evaluation_values) < tokenOperator.inputs
			):
				var result: FormulaExpressionResult = _try_parse(
					_evaluation_stack.pop_back(), inputs
				)
				parsed = parsed && result.success
				_evaluation_values.append(result.new_value)
			_evaluation_values.reverse()

			if parsed && len(_evaluation_values) == tokenOperator.inputs:
				var result = _evaluate_op(domain, _evaluation_values, tokenOperator.type)
				_evaluation_stack.push_back(str(result))
			else:
				var res = FormulaExpressionResult.new()
				res.success = false
				res.new_value = 0
				res.error = " Parsing error (Parsed: %s,%d values != %d inputs)" % [parsed, len(_evaluation_values),tokenOperator.inputs]
				res.error += "\n Token: \"%s\"" % token
				res.error += "\n " + str(tokenOperator)
				res.error += "\n Values: " + str(_evaluation_values)
				res.error += "\n Formular tokens: " + str(_RPNTokens)
				res.error += "\n Current Input: "+str(inputs)
				return res

		elif _is_variable(token):
			_evaluation_stack.push_back(token)
		else:
			_evaluation_stack.push_back(token)

	if len(_evaluation_stack) == 1:
		return _try_parse(_evaluation_stack.pop_back(), inputs)

	var val = FormulaExpressionResult.new()
	val.success = false
	val.new_value = 0
	return val


func _try_parse(token: String, inputs: Array[float]) -> FormulaExpressionResult:
	var result: FormulaExpressionResult = FormulaExpressionResult.new()
	result.new_value = 0

	if len(token) > 1 && token[len(token) - 2].is_valid_int():
		token = token.trim_suffix("f").trim_suffix("d").trim_suffix("l")

	if len(token) == 0:
		result.success = true
		return result

	if _is_variable(token):
		var input_index = _input_decoder[token]
		result.new_value = inputs[input_index] if input_index < len(inputs) else 0
		result.success = true
		return result

	if token == "pi":
		result.new_value = PI
		result.success = true
		return result

	result.success = token.is_valid_float()
	result.new_value = float(token) if result.success else 0

	return result


static func _evaluate_op(domain: Domain, values: Array[float], function: int) -> float:
	var a = values[0] if len(values) >= 1 else 0
	var b = values[1] if len(values) >= 2 else 0

	match function:
		Function.NEG:
			return -a
		Function.ADD:
			return a + b
		Function.SUB:
			return a - b
		Function.MUL:
			return a * b
		Function.DIV:
			return a / b
		Function.MOD:
			return a % b
		Function.POW:
			return pow(a, b)
		Function.SQRT:
			return 0 if a <= 0 else sqrt(a)
		Function.FLOOR:
			return floor(a)
		Function.CEIL:
			return ceil(a)
		Function.ROUND:
			return round(a)
		Function.MIN:
			return min(a, b)
		Function.MAX:
			return max(a, b)
		Function.COS:
			return cos(a)
		Function.SIN:
			return sin(a)
		Function.TAN:
			return tan(a)
		Function.RANDOM:
			return randf_range(a, b)
		Function.DICE:
			var total = 0
			for i in a:
				var value = randi_range(1, b)
				total += min(value, b)
			return floori(total)
		Function.CHANCE:
			var percent = randf_range(0, 1)
			return 1 if a > percent else 0
		Function.TABLE_LEVEL:
			return Functions.table_level(domain, a)
		Function.TABLE_VALUE:
			return Functions.table_value(domain, a)
		Function.TABLE_INCREMENT:
			return Functions.table_value(domain, a)
		Function.TABLE_CURRENT:
			return Functions.table_exp_for_current_level(domain, a)
		Function.TABLE_NEXT:
			return Functions.table_exp_to_next_level(domain, a)
		Function.TABLE_RATIO:
			return Functions.table_ratio_for_current_level(domain, a)
	return 0


static func _need_to_pop(operator_stack: Array[String], new_operator: Operator) -> bool:
	if len(operator_stack) <= 0 || new_operator == null:
		return false
	var top_of_stack: Operator = _token_to_operator(operator_stack[len(operator_stack) - 1])
	if top_of_stack == null:
		return false
	match new_operator.associativity:
		Associativity.L:
			if new_operator.precedence <= top_of_stack.precedence:
				return true
		Associativity.R:
			if new_operator.precedence < top_of_stack.precedence:
				return true
	return false


#endregion
#region Private Helpers
static func _is_operator(token: String):
	return _operators.keys().has(token)


static func _is_command(token: String):
	if len(token) == 1:
		if _is_open_bracket(token[0]):
			return true
		if _is_close_bracket(token[0]):
			return true
		if token[0] == ",":
			return true
	return _is_operator(token)


static func _is_function(token: String):
	var symbol: Operator = _token_to_operator(token)
	if !symbol:
		return false
	return true


static func _is_variable(token: String):
	return len(token) != 0 && token[0] == "#"


static func _variable_index(token: String) -> int:
	return int(token.substr(1)) if len(token) > 1 else -1


static func _is_open_bracket(token: String) -> bool:
	match token[0]:
		"(", "[", "{":
			return true
		_:
			return false


static func _is_close_bracket(token: String) -> bool:
	match token[0]:
		")", "]", "}":
			return true
		_:
			return false


static func _token_to_operator(token: String) -> Operator:
	return _operators[token] if _operators.has(token) else null
#endregion
