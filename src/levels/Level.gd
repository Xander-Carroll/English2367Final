extends Node2D

export var SCORE_PREFIX : String

# Called when the node enters the scene tree for the first time.
func _ready():
	connectPellets()
	connectEnemies()

# If pellets exist, and there is a player to connect them too, the signals are connected.
func connectPellets():
	if self.has_node("Entities/Player") && self.has_node("Entities/Pellets"):
		for pellet in $Entities/Pellets.get_children():
			pellet.connect("collected", $Entities/Player, "_on_pellet_collected")

# If pellets exist, and there is a player to connect them too, the signals are connected.
func connectEnemies():
	if self.has_node("Entities/Player") && self.has_node("Entities/Enemies"):
		for enemy in $Entities/Enemies.get_children():
			enemy.connect("playerHit", $Entities/Player, "_on_enemy_hit")
