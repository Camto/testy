extends KinematicBody2D

onready var spawn = global_position

var motion = Vector2()
const UP = Vector2(0, -1)
const GRAVITY = 20
const WALL_SLIDE_SPEED = 40
const SPEED = 25
const MAX_SPEED = 180
const FRICTION = 1500
const JUMP_HEIGHT = -400
const WALL_JUMP_HEIGHT = -350
const WALL_JUMP_SPEED = 200
const DASH_UP_VEC = Vector2(0, -700)
const DASH_SIDE_VEC = Vector2(1500, 0)
const DASH_SIDE_FRICTION = 6000

const MAX_JUMPS = 2
var jumps = 2
var dash = DASH_NONE
enum {DASH_NONE, DASH_LEFT, DASH_RIGHT, DASH_UP}

func _physics_process(delta):
	var go_left = Input.is_action_pressed("ui_left")
	var go_right = Input.is_action_pressed("ui_right")
	var go_up = Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_select")
	
	if dash == DASH_UP and motion.y > -300:
		dash = DASH_NONE
	if dash == DASH_LEFT and motion.x > -300:
		dash = DASH_NONE
	if dash == DASH_RIGHT and motion.x < 300:
		dash = DASH_NONE
	
	if dash != DASH_LEFT and dash != DASH_RIGHT:
		if not is_on_wall():
			motion.y += GRAVITY
		else:
			motion.y = WALL_SLIDE_SPEED
	
	var stopping = true
	if dash == DASH_NONE:
		if go_left and not go_right:
			motion.x -= SPEED
			stopping = false
		elif go_right and not go_left:
			motion.x += SPEED
			stopping = false
		motion.x = max(motion.x, -MAX_SPEED)
		motion.x = min(motion.x, MAX_SPEED)
	
	if stopping:
		var vsign = sign(motion.x)
		var vlen = abs(motion.x)
		var friction = FRICTION if dash == DASH_NONE else DASH_SIDE_FRICTION
		vlen -= friction * delta
		if vlen < 0:
			vlen = 0
		motion.x = vlen * vsign
	
	if is_on_floor() or is_on_wall():
		refresh()
	
	if go_up and jumps > 0 and dash == DASH_NONE:
		jumps -= 1
		if not is_on_wall():
			motion.y = JUMP_HEIGHT
		else:
			motion.y = WALL_JUMP_HEIGHT
			if go_left and not go_right:
				motion.x = WALL_JUMP_SPEED
			elif go_right and not go_left:
				motion.x = -WALL_JUMP_SPEED
	
	motion = move_and_slide(motion, UP)

func checkpoint(touched_checkpoint):
	spawn = Vector2(
		touched_checkpoint.global_position.x,
		global_position.y
	)

func die():
	set_global_position(spawn)
	motion = Vector2(0, 0)
	jumps = MAX_JUMPS
	dash = DASH_NONE

func refresh():
	jumps = MAX_JUMPS

func dash_up():
	dash = DASH_UP
	motion = DASH_UP_VEC

func dash_left():
	dash = DASH_LEFT
	motion = -DASH_SIDE_VEC

func dash_right():
	dash = DASH_RIGHT
	motion = DASH_SIDE_VEC