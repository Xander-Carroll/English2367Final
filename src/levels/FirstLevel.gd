extends "res://src/levels/Level.gd"

func _ready() -> void:
	$Fades/First.start(false)
	Globals.currentLevel = 1

func _on_Fade_First_finished() -> void:
	$DialogHandler.playDialogOption("Opening")

func _on_Fade_Second_finished():
	Globals.currentLevel = 2
	var _return = get_tree().change_scene("res://src/menus/ScoreScreen.tscn")
	
func _on_DialogHandler_dialog_playing(isPlaying, name) -> void:
	if (name == "EndLevel1" && isPlaying == false):
		$Fades/Second.start(true)
