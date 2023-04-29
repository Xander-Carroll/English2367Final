extends Control

const SPEED = 50

func _process(delta) -> void:
	$MainBackground.scroll_offset.x -= SPEED*delta

func _on_Button_pressed() -> void:
	$Fade.start(true)

func _on_Fade_finished() -> void:
	var _return = get_tree().change_scene("res://src/levels/FirstLevel.tscn")
