extends "res://src/levels/Level.gd"

func _ready() -> void:
	$Fades/First.start(false)
	$Background.changeBackgroundColor(0.4)
	$Entities/Player/PlayerBody.scale = Vector2(5,5)
	Globals.currentLevel = 2

func _on_Fade_First_finished() -> void:
	$DialogHandler.playDialogOption("OpeningLevel2")

func _on_Fade_Second_finished():
	Globals.currentLevel = 3
	var _return = get_tree().change_scene("res://src/menus/ScoreScreen.tscn")

func _on_DialogHandler_dialog_playing(isPlaying, name) -> void:
	if (name == "EndLevel2" && isPlaying == false):
		$Fades/Second.start(true)
