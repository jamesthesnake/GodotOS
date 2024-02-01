extends Panel

## A start menu option. Currently only used to spawn game windows and nothing else.

@export var game_scene: String
@export var title_text: String
@export var description_text: String
@export var use_generic_pause_menu: bool

var is_mouse_over: bool

func _ready() -> void:
	$"Background Panel".visible = false
	%"Menu Title".text = "[center]%s" % title_text
	%"Menu Description".text = "[center]%s" % description_text

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		spawn_window()

func _on_mouse_entered() -> void:
	is_mouse_over = true
	$"Background Panel".visible = true
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($"Background Panel", "modulate:a", 1, 0.2)

func _on_mouse_exited() -> void:
	is_mouse_over = false
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.tween_property($"Background Panel", "modulate:a", 0, 0.2).finished
	if !is_mouse_over:
		$"Background Panel".visible = false

# WARNING WARNING WARNING
# TODO find a better way than copying this from desktop_folder.gd
func spawn_window() -> void:
	var window: FakeWindow
	window = load("res://Scenes/Window/Game Window/game_window.tscn").instantiate()
	window.get_node("%Game Window").add_child(load(game_scene).instantiate())
	
	if use_generic_pause_menu:
		window.get_node("%GamePauseManager").process_mode = Node.PROCESS_MODE_INHERIT
	
	window.title_text = %"Menu Title".text
	get_tree().current_scene.add_child(window)
	
	var taskbar_button: Control = load("res://Scenes/Taskbar/taskbar_button.tscn").instantiate()
	taskbar_button.target_window = window
	taskbar_button.get_node("TextureMargin/TextureRect").texture = $"HBoxContainer/MarginContainer/TextureRect".texture
	taskbar_button.active_color = $"HBoxContainer/MarginContainer/TextureRect".modulate
	get_tree().get_first_node_in_group("taskbar_buttons").add_child(taskbar_button)
