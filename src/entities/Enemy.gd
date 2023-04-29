extends Node2D

signal playerHit

const GRAVITY = 1000
const SPEED = Vector2(300, 0)

export var BOUNDS = Vector2(0,1024)
export var MOVE_TIME = Vector2(1, 3)

export var BOSS_ENEMY: bool = false

# A variable which contains the entities's current velocity.
var velocity = Vector2.ZERO

func _physics_process(delta):
	self.keepInBounds(BOUNDS)
	
	if($EnemyBody.is_on_floor()):
		velocity.y = 0
	
	# Accounting for gravity.
	velocity.y += GRAVITY * delta;
	
	if(BOSS_ENEMY):
		velocity = Vector2(0,0)
	
	$EnemyBody.move_and_slide(velocity, Vector2(0, -1))

# Will keep the entity's global position within the given bounds.
func keepInBounds(bounds: Vector2) -> void:
	$EnemyBody.global_position.x = min($EnemyBody.global_position.x, bounds.y)
	$EnemyBody.global_position.x = max($EnemyBody.global_position.x, bounds.x)

func _on_MoveTimer_timeout():
	$MoveTimer.start(rand_range(MOVE_TIME.x, MOVE_TIME.y))
	
	var mode = randi() % 5
	if(mode <= 1):
		velocity.x = SPEED.x
	elif(mode <= 3):
		velocity.x = - SPEED.x
	elif(mode == 4):
		velocity.x = 0

func _on_HitboxArea_body_entered(body):
	if(body.name == "PlayerBody"):
		emit_signal("playerHit")
		self.queue_free()

func on_start_boss_fight():
	BOSS_ENEMY = false
	$MoveTimer.start(5 + randi()%3)
	velocity.x = -SPEED.x
