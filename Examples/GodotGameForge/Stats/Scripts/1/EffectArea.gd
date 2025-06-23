extends Area2D

@export_enum("Positiv:1","Negative:-1") var damege_type:int = 1:
	set(value):
		damege_type = value
		match damege_type:
			1:
				type = "+"
			-1:
				type = "-"
## Damage dealed per Second
@export var damage:float 

var type = ""

func _ready() -> void:
	match damege_type:
		1:
			type = "+"
		-1:
			type = "-"

func _process(delta: float) -> void:
	var objects = get_overlapping_bodies()
	for object in objects:
		if object.has_meta("trait"):
			Stats.change_attribute_str(object.get_meta("trait"),"hp",type,damage*delta)
