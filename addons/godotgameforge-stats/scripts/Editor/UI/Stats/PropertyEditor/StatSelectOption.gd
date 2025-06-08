extends EditorProperty
class_name StatSelectOption

var options = OptionButton.new()
var updating: bool = false


func _init() -> void:
	add_child(options)
	options.item_selected.connect(_item_selected)
	refresh_options()


func _item_selected(index: int):
	if updating:
		return
	var object = get_edited_object() as StatsUI
	if object.target:
		var item = object.target.entity_class.Stats[index]
		emit_changed(get_edited_property(), item)


func _update_property() -> void:
	updating = true
	refresh_options()
	options.select(-1)
	var object = get_edited_object() as StatsUI
	var value = get_edited_object()[get_edited_property()]
	if value:
		if object.target:
			var item = object.target.entity_class.Stats.find(value)
			options.select(item)
	updating = false


func refresh_options():
	options.clear()
	var object = get_edited_object()
	if object is StatsUI:
		if object.target:
			for option: StatItem in object.target.entity_class.Stats:
				var stat = option.stat
				var tex = null
				if stat.icon:
					var img = stat.icon.get_image()
					img.resize(16, 16)
					tex = ColorTheme.color_image_texture(img, stat.color)
				options.add_icon_item(tex, stat.Acronym)
