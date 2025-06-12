class_name TablePlot
extends Control
#TODO:Make Scrollable
var zoom: float
var table: BaseTable
var cur_color: Color

var has_mouse: bool
var mous_pos: Vector2
var hover_level: int


func _ready() -> void:
	clip_contents = true


func _get_minimum_size() -> Vector2:
	return Vector2(200, 200)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mous_pos = event.position
		queue_redraw()


func _draw() -> void:
	if table is TableConstantProgression:
		cur_color = Color.BLUE
	elif table is TableGeometricProgression:
		cur_color = Color.RED
	elif table is TableLinearProgression:
		cur_color = Color.GREEN
	elif table is TableManualProgression:
		cur_color = Color.YELLOW
	make_plot_content()
	draw_data_rect()


func make_plot_content():
	draw_rect(Rect2(0, 0, size.x, size.y), ColorTheme.get_color_str("Dark", 0))
	for i in table.max_level + 1:
		make_plot_bar(i)


func make_plot_bar(index: int):
	var max_experience: float = table.get_comulative_experience_for_level(table.max_level)
	var experience: float = table.get_comulative_experience_for_level(index)

	var height = lerpf(0, size.y, experience / max_experience)
	var th = 0
	if mous_pos.x > (index - 1) * (zoom + 2) - 1 and mous_pos.x < (index) * (zoom + 2):
		hover_level = index
		th = 1
		draw_rect(
			Rect2((index - 1) * (zoom + 2) - 1, 0, zoom + 2, size.y),
			ColorTheme.get_color_str("Dark", 1)
		)
	draw_rect(
		Rect2((index - 1) * (zoom + 2), size.y - height, zoom, height),
		ColorTheme.map_color(cur_color, th)
	)


func draw_data_rect():
	var exp_range_a: float = table.get_comulative_experience_for_level(hover_level)
	var exp_range_b: float = table.get_comulative_experience_for_level(hover_level + 1) - 1
	var experience: float = table.get_level_experience_for_level(hover_level)
	var font = EditorInterface.get_editor_theme().default_font
	var str = (
		"Level:    %d\nStep:     %d\nRank:    %d - %d"
		% [hover_level, experience, exp_range_a, exp_range_b]
	)
	var font_size = 14
	var s = font.get_multiline_string_size(str, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	draw_rect(Rect2(10, 10, s.x, s.y).grow(5), Color8(0, 0, 0, 50))
	draw_multiline_string(
		font, Vector2(10, 10 + font_size), str, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size
	)


func redraw():
	queue_redraw()
