class_name TraitGroup
extends Node
## Assigens a Trait to each child Node that needs a Trait.[br][br]
## Whitch are: [StatsUI], [AttributeUI], [FormulaUI], [StatusEffectUI][br]
## and of course a sub [TraitGroup]

## The signal you should emit if you updated the [member group_trait]
signal update

## The Trait that is assigned to the child Nodes
@export var group_trait: Trait:
	set(val):
		group_trait = val
		update_configuration_warnings()


func _ready() -> void:
	if group_trait:
		if !group_trait.is_node_ready():
			await group_trait.ready
		update.emit()


func _get_configuration_warnings() -> PackedStringArray:
	if !group_trait:
		return ["No Group Trait Configured"]
	return []
