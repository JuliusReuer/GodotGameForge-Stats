class_name Stat
extends StatsResource
@export_placeholder("stat-id") var ID: String
@export var Base: int
@export var Formula: Formula

@export_group("UI")
@export_placeholder("Stat Name") var Name: String
@export_placeholder("STA") var Acronym: String
@export_multiline() var Description: String
@export var icon: Texture2D
@export var color: Color
