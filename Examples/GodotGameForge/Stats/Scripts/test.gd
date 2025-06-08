extends Button

@export var target:Trait

func _pressed() -> void:
	Stats.change_attribute_str(target,"hp","-",20)
