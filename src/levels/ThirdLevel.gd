extends "res://src/levels/Level.gd"

func _ready() -> void:
	$Fades/First.start(false)
	$Background.changeBackgroundColor(0.4)
	$Entities/Player/PlayerBody.scale = Vector2(2,2)
	Globals.currentLevel = 3

func _on_Fade_First_finished() -> void:
	$DialogHandler.playDialogOption("OpeningLevel3")

func _on_Fade_Second_finished():
	Globals.currentLevel = 4
	var _return = get_tree().change_scene("res://src/menus/ScoreScreen.tscn")

func _on_DialogHandler_dialog_playing(isPlaying, name) -> void:
	if (name == "EndLevel3" && isPlaying == false):
		$Fades/Second.start(true)

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "Explode"):
		$DialogHandler.playDialogOption("EndLevel3")
