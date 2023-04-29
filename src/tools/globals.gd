extends Node

var currentPoints = 0
var pelletsThisLevel = 0

var currentLevel = 1

var killHost: bool = false

func gameOver() -> void:
	currentPoints = 0
	pelletsThisLevel = 0
	currentLevel = 1
	var _return = get_tree().change_scene("res://src/menus/TitleScreen.tscn")
