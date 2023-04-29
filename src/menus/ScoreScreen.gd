extends Control

func _ready():
	if (Globals.currentLevel < 3):
		Globals.currentPoints += Globals.pelletsThisLevel*100
		$VBoxContainer/ScoreSpacer/ScoreText.text = "Pellets Eaten: %d * 100 = %d\nTotal Score: %d" % [Globals.pelletsThisLevel, Globals.pelletsThisLevel*100, Globals.currentPoints]
	elif (Globals.currentLevel == 3):
		Globals.currentPoints += Globals.pelletsThisLevel*-100
		$VBoxContainer/ScoreSpacer/ScoreText.text = "Pellets Eaten: %d * -100 = %d\nTotal Score: %d" % [Globals.pelletsThisLevel, Globals.pelletsThisLevel*-100, Globals.currentPoints]
	elif (Globals.currentLevel == 4):
		if(Globals.killHost):
			$VBoxContainer/ScoreSpacer/ScoreText.text = "Killing Host: 0\nTotal Score: %d" % [Globals.currentPoints]
		else:
			$VBoxContainer/ScoreSpacer/ScoreText.text = "Saving Host: 1000\nTotal Score: %d" % [Globals.currentPoints+1000]
	
	Globals.pelletsThisLevel = 0

func _process(_delta):
	$VBoxContainer/ScoreSpacer/ScoreText.percent_visible = (1-$VBoxContainer/ScoreSpacer/ScoreText/Timer.time_left)

func _on_Button_pressed() -> void:
	$Fade.start(true)

func _on_Fade_finished() -> void:
	if(Globals.currentLevel == -1):
		Globals.gameOver()
	elif(Globals.currentLevel >= 1):
		var _return = get_tree().change_scene("res://src/menus/LevelSummary.tscn")
