class_name FormulaString
extends VBoxContainer

var formula:Formula
var string:LineEdit = LineEdit.new()

func _init() -> void:
	var header:Label = Label.new()
	add_child(header)
	header.text = "Formula"
	
	add_child(string)
	var form = func(text):
		formula.formula = text
		ResourceSaver.save(formula)
	string.text_changed.connect(form)

func update():
	string.text = formula.formula
