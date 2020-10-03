extends Area2D

var text_shown = false

func _on_Refresher_Tip_body_entered(body):
	if body.name == "Player":
		if not text_shown:
			text_shown = true
			$Text.show()