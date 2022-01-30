extends Area2D

export var background = 0

func _on_Background_Changer_body_entered(body):
	if body.name == "Player":
		$"../../CanvasLayer/Background".to_background(background)