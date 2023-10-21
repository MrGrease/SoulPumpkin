extends CharacterBody3D

@onready var movementManager = $MovementManager
@onready var camera = $Camera
@onready var graphics = $Graphics
@onready var healthManager = $HealthManager
@onready var inventoryManager = $InventoryManager
@onready var situationText = $Hud/SituationText
@onready var HUD = $Hud
@onready var Pause = $Pause
@onready var graphicsManager = $Graphics
var paused =false
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
	if Input.is_action_just_pressed("pause"):
		if(paused):
			Pause.hide()
			HUD.show()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().paused = false
		else:
			Pause.show()
			HUD.hide()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().paused = true
		paused=!paused
	if(paused):
		return
	if(!alive):
		if Input.is_action_pressed("reload"):
			get_tree().change_scene_to_file("res://UI/main_menu.tscn")
			get_tree().paused = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_node("/root/World").free()
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
	if(move_vec!=Vector3.ZERO):
		graphicsManager.playMoveAnimation()
	else:
		graphicsManager.playIdleAnimation()
	movementManager.setMovementVector(move_vec)
	if Input.is_action_just_pressed("jump"):
		movementManager.jump()
	if Input.is_action_just_pressed("switch"):
		switchDayNight()
	if Input.is_action_just_released("DOWN"):
			inventoryManager.switch_to_next_weapon()
	if Input.is_action_just_released("UP"):
			inventoryManager.switch_to_last_weapon()
	
	inventoryManager.attack(Input.is_action_just_pressed("attack"),Input.is_action_pressed("attack"))

func setDayTime():
	pass

func setNightTime():
	pass

func switchDayNight():
	get_tree().call_group("Sun", "flip")

func _input(event):
	if(!alive or paused):
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
	$Camera/AnimationPlayer.play("die")
	graphicsManager.playDieAnimation()

func hurt(damage):
	healthManager.hurt(damage)

func heal(amount):
	healthManager.heal(amount)

func setSituationText(text):
	situationText.text = text


func _on_health_manager_health_changed():
	HUD.updateHUDHealth(healthManager.currentHealth)


func _on_inventory_manager_update_ammo_display():
	HUD.updateHudAmmo(inventoryManager.getCurrentWeaponAmmo())

func add_soul():
	inventoryManager.add_soul()
	$Hud/SoulsLabel.text = "SOULS:"+str(inventoryManager.currentSouls)

func add_ammo():
	inventoryManager.add_ammo()

func end_game():
	alive=false


func _on_animation_player_animation_finished(anim_name):
	if(anim_name=="intro"):
		$Graphics/Armature.hide()
