extends CharacterBody3D

@onready var movementManager = $MovementManager
@onready var camera = $Camera
@onready var graphics = $Graphics
@onready var healthManager = $HealthManager
var mouseSensitivity =0.25

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	movementManager.setBody(self)
	
	healthManager.init()
	healthManager.connect("signalDead",die)

func _process(_delta):
	var move_vec = Vector3()
	if Input.is_action_pressed("forwards"):
		move_vec += Vector3.FORWARD
	if Input.is_action_pressed("backwards"):
		move_vec += Vector3.BACK
	if Input.is_action_pressed("left"):
		move_vec += Vector3.LEFT
	if Input.is_action_pressed("right"):
		move_vec += Vector3.RIGHT
	movementManager.setMovementVector(move_vec)
	if Input.is_action_just_pressed("jump"):
		movementManager.jump()
	if Input.is_action_just_pressed("switch"):
		switchDayNight()


func switchDayNight():
	get_tree().call_group("Sun", "flip")

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouseSensitivity * event.relative.x
		camera.rotation_degrees.x -= mouseSensitivity * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x,-90,90)

func rotateMesh():
	graphics.rotation_degrees.y = camera.rotation_degrees.y 

func die():
	print("dead!")

func hurt(damage):
	healthManager.hurt(damage)

func heal(amount):
	healthManager.heal(amount)
