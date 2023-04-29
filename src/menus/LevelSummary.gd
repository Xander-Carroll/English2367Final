extends Control

const LEVEL1_SUMMARY = ["Scoreboards in video games have been popular since the early days of arcade cabinets, and now they see continued usage in modern internet-based games. Scoreboards are usually used to add to the replayability of games, because players are encouraged to compete for a better score (Nebel et al).",
						"Some researchers have noticed the appreciation that consumers have for competition in video games, and they even hope to utilize it by making competitive games that are also educational (Nebel et al)."
						]

const LEVEL2_SUMMARY = ["Death is also a feature that has been present since the early days of arcade cabinets. While the mechanic used to be a way to get kids to keep paying for extra lives, now-days very few games make you pay per life (Wenz). This brings up the question - why is such a violent mechanic still included in games - what purpose does it serve?"]

const LEVEL3_SUMMARY = ["Roleplaying involves the player putting themselves in the position of another. When a storyteller is able to accomplish this well, the player may even start to feel the same emotions as their character. A small team, including Dr. Rene Weber, a professor of Media Neuroscience at the University of California, Santa Barbra, stated that there is no physical connection between the player and their character in a video game, but there is a tangible connection (Lewis et al).", 
						"Video Games also provide a chance to prompt their player’s with ethical decisions, like the one presented here. However, the decision to ‘kill’ or ‘not kill’ may be too simple, meaning that it is trivially easy, so it ceases to even be a decision (Malcolm et al)."]

var currentIndex = 0

func _ready():
	$FadeIn.start(false)
	
	if(Globals.currentLevel == 2):
		$VBoxContainer/MiddleSpacer/ScoreText.text = LEVEL1_SUMMARY[0]
	elif(Globals.currentLevel == 3):
		$VBoxContainer/MiddleSpacer/ScoreText.text = LEVEL2_SUMMARY[0]
		$VBoxContainer/Title.text = "Death in Videogames"
	elif(Globals.currentLevel == 4):
		$VBoxContainer/MiddleSpacer/ScoreText.text = LEVEL3_SUMMARY[0]
		$VBoxContainer/Title.text = "Ethics in Videogames"

func _on_Button_pressed():
	if(Globals.currentLevel == 2):
		currentIndex += 1
		if currentIndex < LEVEL1_SUMMARY.size():
			$VBoxContainer/MiddleSpacer/ScoreText.text = LEVEL1_SUMMARY[currentIndex]
		else:
			$FadeOut.start(true)
	elif(Globals.currentLevel == 3):
		currentIndex += 1
		if currentIndex < LEVEL2_SUMMARY.size():
			$VBoxContainer/MiddleSpacer/ScoreText.text = LEVEL2_SUMMARY[currentIndex]
		else:
			$FadeOut.start(true)
	elif(Globals.currentLevel == 4):
		currentIndex += 1
		if currentIndex < LEVEL3_SUMMARY.size():
			$VBoxContainer/MiddleSpacer/ScoreText.text = LEVEL3_SUMMARY[currentIndex]
		else:
			$FadeOut.start(true)
	else:
		$FadeOut.start(true)

func _on_FadeOut_finished():
	if(Globals.currentLevel == 2):
		var _return = get_tree().change_scene("res://src/levels/SecondLevel.tscn")
	elif(Globals.currentLevel == 3):
		var _return = get_tree().change_scene("res://src/levels/ThirdLevel.tscn")
	else:
		Globals.gameOver()
