extends Node2D

signal collected (weight)

export var weight = 0.2

func _on_PelletBody_body_entered(body: Node2D) -> void:
	if(body.name == "PlayerBody"):
		emit_signal("collected", weight)
		self.queue_free()
