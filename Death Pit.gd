extends Area2D

func _on_Death_Pit_body_entered(body):
	if body.name == "Player":
		body.die()