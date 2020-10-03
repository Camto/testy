extends Area2D

func _on_Right_Dasher_body_entered(body):
	if body.name == "Player":
		body.dash_right()