extends CharacterBody3D

@onready var movementManager = $MovementManager
@onready var camera = $Camera
@onready var graphics = $Graphics
@onready var healthManager = $HealthManager
@onready var inventoryManager = $InventoryManager
var mouseSensitivity =0.25
var alive =true

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	movementManager.setBody(self)
	healthManager.init()
	healthManager.connect("signalDead",die)
	inventoryManager.init([])
	
	
	var sun = get_tree().get_nodes_in_group("Sun")[0]
	if(sun.currentState==0):#day
		pass
	else:
		pass

func _process(_delta):
	if(!alive):
		return
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
	
	inventoryManager.attack(Input.is_action_just_pressed("attack"),Input.is_action_pressed("attack"))

func setDayTime():
	pass

func setNightTime():
	pass

func switchDayNight():
	get_tree().call_group("Sun", "flip")

func _input(event):
	if(!alive):
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouseSensitivity * event.relative.x
		camera.rotation_degrees.x -= mouseSensitivity * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x,-90,90)
		rotateMesh()
		rotateInventoryManager()
	

func rotateMesh():
	graphics.rotation_degrees.y = camera.rotation_degrees.y 

func rotateInventoryManager():
	inventoryManager.rotation_degrees=camera.rotation_degrees
	

func die():
	alive=false
	movementManager.setMovementVector(Vector3.ZERO)

func hurt(damage):
	healthManager.hurt(damage)

func heal(amount):
	healthManager.heal(amount)
