class_name StatusEffect
extends StatsResource

@export_placeholder("effect-id") var ID: String

@export_enum("Positiv:1", "Negativ:2", "Neutral:4") var type: int = 1
@export var max_stack: int = 1
@export var is_hidden: bool
@export_group("Duration")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var has_duration: bool
@export var duration: float = 60

@export_group("UI")
@export_placeholder("Status Effect Name") var Name: String
@export_placeholder("SE") var Acronym: String
@export_multiline() var Description: String
@export var icon: Texture2D
@export var color: Color
