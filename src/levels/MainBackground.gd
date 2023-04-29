extends ParallaxBackground

# The main image texture.
var blockTexture = preload("res://res/images/pixel.svg")

# The y-height where the blocks should be placed
const Y_HEIGHT = 600

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Randomizes the seed.
	randomize()
	
	# Creates the farground blocks.
	var current = 0
	while (current < 10000):
		current = createBackgroundSprite($Farground, false, current, Y_HEIGHT, 100, 250, 300, 400)
	
	# Creates the nearground blocks.
	current = 0
	while (current < 10000):
		current = createBackgroundSprite($Nearground, true, current, Y_HEIGHT, 50, 100, 100, 200)
		
		if(randi() % 5 == 1):
			current += (randi()%100) + 100
	

# Creates a randomly sized sprite with the given parameters and returns the rightMost position of the sprite.
func createBackgroundSprite(parent: Node2D, variableColor: bool, xPos: float, yPos: float, minWidth: int, maxWidth: int, minHeight: int, maxHeight: int) -> int:
	# Creating a new sprite node.
	var sprite = Sprite.new()
	
	# Sets the color of the blocks to be a random red color.
	if (variableColor):
		var colorMode = randi() % 3
		
		if(colorMode == 0):
			sprite.self_modulate = Color(0.7, 0.36, 0.36)
		elif(colorMode == 1):
			sprite.self_modulate = Color(0.65, 0.3, 0.3)
		elif(colorMode == 2):
			sprite.self_modulate = Color(0.6, 0.26, 0.26)
	
	# Setting the texture and color of the node.
	sprite.texture = blockTexture

	# Giving the sprite a random width and height.
	sprite.scale.x = (randi() % (maxWidth-minWidth)) + minWidth
	sprite.scale.y = (randi() % (maxHeight-minHeight)) + minHeight
	
	# Setting the position of the sprite
	sprite.position.y = yPos - sprite.scale.y/2
	sprite.position.x = xPos + sprite.scale.x/2
	
	# Adding the sprite to the correct node.
	parent.add_child(sprite)
	
	return xPos + sprite.scale.x

# Will make the background darker
func changeBackgroundColor(percentage: float) -> void:
	$Farground.modulate.r = $Farground.modulate.r * percentage
	$Farground.modulate.g = $Farground.modulate.g * percentage
	$Farground.modulate.b = $Farground.modulate.b * percentage
	
	for child in $Nearground.get_children():
		child.modulate.r = child.modulate.r * percentage
		child.modulate.g = child.modulate.g * percentage
		child.modulate.b = child.modulate.b * percentage

# The player can call this function to change the brightness of the level.
func _on_Player_modifyBackgroundColor(percentage):
	changeBackgroundColor(percentage)
