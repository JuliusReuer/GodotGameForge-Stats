@tool
extends EditorPlugin


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


var preview_gen = preload("icons.gd")
#region Nodes
var trait_inspector: TraitEditorInspectorPlugin
#endregion
#region Resources
var table_inspector: TableEditorInspectorPlugin
var class_inspector: ClassEditorInspectorPlugin
var formula_inspector: FormulaEditorInspectorPlugin
#endregion
#region UI
var stat_ui_inspector: StatUIEditorInspectorPlugin
#endregion


func _enter_tree():
	preview_gen = preview_gen.new()
	get_editor_interface().get_resource_previewer().add_preview_generator(preview_gen)
	#region Nodes
	var menu = StatsUIElementEditorContextMenuPlugin.new()
	add_context_menu_plugin(EditorContextMenuPlugin.CONTEXT_SLOT_SCENE_TREE,menu)
	
	if trait_inspector == null:
		trait_inspector = TraitEditorInspectorPlugin.new()
		add_inspector_plugin(trait_inspector)
	#endregion
	#region Resources
	if table_inspector == null:
		table_inspector = TableEditorInspectorPlugin.new()
		add_inspector_plugin(table_inspector)
	if class_inspector == null:
		class_inspector = ClassEditorInspectorPlugin.new()
		add_inspector_plugin(class_inspector)
	if formula_inspector == null:
		formula_inspector = FormulaEditorInspectorPlugin.new()
		add_inspector_plugin(formula_inspector)
	#endregion
	#region UI
	if stat_ui_inspector == null:
		stat_ui_inspector = StatUIEditorInspectorPlugin.new()
		add_inspector_plugin(stat_ui_inspector)
	#endregion


func _exit_tree():
	get_editor_interface().get_resource_previewer().remove_preview_generator(preview_gen)

	if trait_inspector != null:
		remove_inspector_plugin(trait_inspector)
		trait_inspector = null

	if table_inspector != null:
		remove_inspector_plugin(table_inspector)
		table_inspector = null

	if class_inspector != null:
		remove_inspector_plugin(class_inspector)
		class_inspector = null
	
	if formula_inspector != null:
		remove_inspector_plugin(formula_inspector)
		formula_inspector = null

	if stat_ui_inspector != null:
		remove_inspector_plugin(stat_ui_inspector)
		stat_ui_inspector = null
