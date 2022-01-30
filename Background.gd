extends Polygon2D

const TIME_TO_CHANGE = 2

export var COLORS = []

var from_color
var to_color

var time_left = 0

func _ready():
	to_color = COLORS[0]
	color = to_color

func _process(delta):
	if time_left > 0:
		color = lerp(from_color, to_color, 1 - time_left)
		time_left -= delta / TIME_TO_CHANGE

func to_background(background):
	from_color = to_color
	to_color = COLORS[background]
	time_left = 1