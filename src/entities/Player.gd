extends Node2D

# Signals which the player can emmit
signal playDialog (name)
signal modifyBackgroundColor(percentage)
signal startBossFight

# Constants which controll how fast the player can move.
const MAX_SPEED = Vector2(2000, 2000)
const GRAVITY = 1000
const SPEED = Vector2(500, 700)

var numPellets: int = 0

var playedEnemyTrigger: bool = false
var playedEndLevel1Trigger: bool = false

var playedEndLevel2Trigger: bool = false
var playedEnemySightTrigger: bool = false

var playedBossTrigger: bool = false

# How far the player is allowed to travel to the left or right before hitting an invisible wall.
export var BOUNDS = Vector2(0, 1024)

# A variable which contains the player's current velocity.
var velocity = Vector2.ZERO

# When true the player will not be able to input any events
var stopInput = false;

# Called every frame.
func _physics_process(delta: float) -> void:

	self.processTriggers()
	
	# Accounting for gravity.
	velocity.y += GRAVITY * delta;
	
	# Accounting for the player input.
	if !stopInput:
		velocity = processInput(velocity)
	else:
		velocity.x = 0
		velocity.y = 0
	
	# Moving the player based on the given velocity.
	self.capVelocity(MAX_SPEED)
	$PlayerBody.move_and_slide(velocity, Vector2(0, -1))
	
	# Making the 'invisible walls' at the edge of the game world.
	self.keepInBounds(BOUNDS);

# Will limit the player's velocity based on the provided maxSpeed variable.
func capVelocity(maxSpeed: Vector2) -> void:
	velocity.y = min(velocity.y, maxSpeed.y)
	velocity.y = max(velocity.y, -maxSpeed.y)
	
	velocity.x = min(velocity.x, maxSpeed.x)
	velocity.x = max(velocity.x, -maxSpeed.x)

# Will keep the player's global position within the given bounds.
func keepInBounds(bounds: Vector2) -> void:
	$PlayerBody.global_position.x = min($PlayerBody.global_position.x, bounds.y)
	$PlayerBody.global_position.x = max($PlayerBody.global_position.x, bounds.x)

# Based on the player's key input, will change the player's motion.
func processInput(currentVelocity: Vector2) -> Vector2:
	
	# Controlling the player's left-right inputs.
	currentVelocity.x = 0
	if Input.is_action_pressed("key_left"):
		currentVelocity.x -= SPEED.x
	if Input.is_action_pressed("key_right"):
		currentVelocity.x += SPEED.x
	
	if ($PlayerBody.is_on_floor()):
		currentVelocity.y = 0
	
	# Controlling the player's jump input.
	if (Input.is_action_pressed("key_jump") && $PlayerBody.is_on_floor()):
		currentVelocity.y = -SPEED.y
	elif (Input.is_action_just_released("key_jump") && currentVelocity.y < 0):
		currentVelocity.y = 0
	
	#Returning the newly modified velocity vector.
	return currentVelocity

# Called whenever a new dialog starts or ends.
func _on_DialogHandler_dialog_playing(isPlaying, _name) -> void:
	stopInput = isPlaying

# Called whenever the player touches a pellet object.
func _on_pellet_collected(weight: float) -> void:
	
	if(Globals.currentLevel != 2):
		$PlayerBody.scale.x += weight;
		$PlayerBody.scale.y += weight;
	
	numPellets += 1
	Globals.pelletsThisLevel += 1
	
	if(Globals.currentLevel == 1):
		if(numPellets == 3):
			if(has_node("../../DialogHandler")):
				get_node("../../DialogHandler").playDialogOption("FirstGrowth")
	if(Globals.currentLevel == 2):
		if(numPellets == 1):
			if(has_node("../../DialogHandler")):
				get_node("../../DialogHandler").playDialogOption("TooMany")
		
		emit_signal("modifyBackgroundColor", 0.98)

# If the player hits an enemy this method is called.
func _on_enemy_hit() -> void:
	if(Globals.currentLevel != 2):
		Globals.currentLevel = -1
		var _return = get_tree().change_scene("res://src/menus/ScoreScreen.tscn")
	else:
		$PlayerBody/ExplodeParticles.emitting = true
		$ParticleTimer.start(2)
		emit_signal("playDialog", "Mitosis")

func processTriggers() -> void:
	if (Globals.currentLevel == 1):
		# Determining if the enemy dialog should be played
		if(!playedEnemyTrigger):
			if self.has_node("../../DialogHandler/EnemyTrigger"):
				if $PlayerBody.global_position.x > self.get_node("../../DialogHandler/EnemyTrigger").global_position.x:
					emit_signal("playDialog", "EnemyEncounter")
					playedEnemyTrigger = true
		
		# Determining if the end level dialog should be played
		if(!playedEndLevel1Trigger):
			if self.has_node("../../DialogHandler/Level1Trigger"):
				if $PlayerBody.global_position.x > self.get_node("../../DialogHandler/Level1Trigger").global_position.x:
					emit_signal("playDialog", "EndLevel1")
					playedEndLevel1Trigger = true

	if (Globals.currentLevel == 2):
		if(!playedEndLevel2Trigger):
			if self.has_node("../../DialogHandler/Level2Trigger"):
				if $PlayerBody.global_position.x > self.get_node("../../DialogHandler/Level2Trigger").global_position.x:
					emit_signal("playDialog", "EndLevel2")
					playedEndLevel2Trigger = true
		
		if(!playedEnemySightTrigger):
			if self.has_node("../../DialogHandler/EnemySightTrigger"):
				if $PlayerBody.global_position.x > self.get_node("../../DialogHandler/EnemySightTrigger").global_position.x:
					if(abs($PlayerBody.global_position.y-self.get_node("../../DialogHandler/EnemySightTrigger").global_position.y) <= 50):
						emit_signal("playDialog", "EnemySight")
						playedEnemySightTrigger = true
	
	if (Globals.currentLevel == 3):
		if(!playedBossTrigger):
			if self.has_node("../../DialogHandler/BossTrigger"):
				if $PlayerBody.global_position.x > self.get_node("../../DialogHandler/BossTrigger").global_position.x:
					if $PlayerBody.is_on_floor():
						emit_signal("playDialog", "BossFight")
						emit_signal("startBossFight")
						playedBossTrigger = true
						if self.has_node("../../BossTimer"):
							self.get_node("../../BossTimer").start(30)

func _on_ParticleTimer_timeout():
	$PlayerBody.scale.x = 1;
	$PlayerBody.scale.y = 1;
	$PlayerBody/ExplodeParticles.scale.x = 5;
	$PlayerBody/ExplodeParticles.scale.y = 5;
	
	if self.has_node("../Pellets"):
		for pellet in self.get_node("../Pellets").get_children():
			pellet.queue_free()

func _on_BossTimer_timeout():
	if self.has_node("../../Objects/Heart"):
		get_node("../../Objects/Heart/AnimationPlayer").play("Explode")
	
	if self.has_node("../../Entities/Enemies"):
		for enemy in get_node("../../Entities/Enemies").get_children():
			enemy.queue_free()
