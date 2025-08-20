extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/StartButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		get_viewport().gui_get_focus_owner().pressed.emit()

func _on_leaderboard_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/leaderboard.tscn")

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
