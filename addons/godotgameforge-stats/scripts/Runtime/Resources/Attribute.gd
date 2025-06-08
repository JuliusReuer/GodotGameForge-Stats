class_name Attribute
extends StatsResource

@export_placeholder("attribute-id") var ID: String
@export var min_value: int = 0
@export var max_value: Stat
@export_range(0, 1, 0.01) var start_percent: float = 1

@export_group("UI")
@export_placeholder("Attribute Name") var Name: String
@export_placeholder("ATT") var Acronym: String
@export_multiline() var Description: String
@export var icon: Texture2D
@export var color: Color
