extends Sprite

signal finished

var started = false;
var fadingIn = false;

func _process(_delta):
	if started:
		var opacity
		if(fadingIn):
			opacity = (1 - $FadeTimer.time_left)
			
			if(opacity == 1):
				emit_signal("finished")
				queue_free()
		else:
			opacity = ($FadeTimer.time_left)
			
			if(opacity == 0):
				emit_signal("finished")
				queue_free()
		
		self.modulate.a = opacity
		

func start(fadeIn: bool):
	fadingIn = fadeIn
	started = true
	$FadeTimer.start(1)
