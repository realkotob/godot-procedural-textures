extends Control


@onready var projects = $Projects
@onready var preview_2d_background = $BackgroundPreviews/Preview2D
@onready var preview_2d_background_button = $PreviewUI/Preview2DButton
@onready var preview_3d_background = $BackgroundPreviews/Preview3D
@onready var preview_3d_background_button = $PreviewUI/Preview3DButton
@onready var preview_3d_background_panel = $PreviewUI/Panel


func _notification(what: int) -> void:
	if what == NOTIFICATION_THEME_CHANGED:
		if not is_node_ready():
			await ready
		preview_2d_background_button.icon = get_theme_icon("2D_preview", "MM_Icons")
		preview_3d_background_button.icon = get_theme_icon("3D_preview", "MM_Icons")
		%ControlView.texture = get_theme_icon("3D_preview_control", "MM_Icons")

func get_projects():
	return projects

func _on_projects_panel_resized():
	var preview_position : Vector2 = Vector2(0.0, 0.0)
	var preview_size : Vector2 = size
	preview_position.y += $Projects/TabBar.size.y
	preview_size.y -= $Projects/TabBar.size.y
	$BackgroundPreviews.position = preview_position
	$BackgroundPreviews.size = preview_size

func show_background_preview_2d(button_pressed):
	preview_2d_background.visible = button_pressed
	if button_pressed:
		preview_3d_background_button.button_pressed = false

func show_background_preview_3d(button_pressed):
	preview_3d_background.visible = button_pressed
	preview_3d_background_panel.visible = button_pressed
	if button_pressed:
		preview_2d_background_button.button_pressed = false

func _on_projects_no_more_tabs():
	mm_globals.main_window.new_material()
	await get_tree().process_frame
	_on_projects_panel_resized()

func _on_projects_tab_changed(tab : int):
	mm_globals.main_window._on_Projects_tab_changed(tab)
	await get_tree().process_frame
	_on_projects_panel_resized()
