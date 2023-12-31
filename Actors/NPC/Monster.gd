extends CharacterBody3D

@onready var movementManager = $MovementManager
@onready var healthManager = $HealthManager
@onready var navigationAgent:NavigationAgent3D = $NavigationAgent3D
@onready var attackTimer = $AttackTimer
@onready var graphics = $Graphics
@onready var projectileSpawner = $ProjectileSpawner
enum STATES {IDLE,CHASE,ATTACK,DEAD}
var currentState = STATES.IDLE
enum ATTACKTYPE {DAYATTACK,NIGHTATTACK}
var currentAttackType
var currentAttackTime
var canAttack = true

var player = null

@export var attackRangeDay = 2.5#day
@export var attackRangeNight = 100#night
@export var attackTimeDay = 0.5
@export var attackTimeNight = 0.5
var attackRange
var dead = false
var startTimer
var intialized = false
var jumpThreshold = 5
var currentJump=0
var previousPosition=Vector3(0,0,0)
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	var sun = get_tree().get_nodes_in_group("Sun")[0]
	if(sun.currentState==0):#day
		attackRange=attackRangeDay
		currentAttackType=ATTACKTYPE.DAYATTACK
		currentAttackTime=attackTimeDay
	else:
		attackRange=attackRangeNight
		currentAttackType=ATTACKTYPE.NIGHTATTACK
		currentAttackTime=attackTimeNight
	attackTimer.set_wait_time(currentAttackTime)
	movementManager.setBody(self)
	healthManager.connect("signalDead",setStateDead)
	startTimer = Timer.new()
	startTimer.wait_time=5
	startTimer.one_shot=true
	startTimer.connect("timeout",timerInit)
	add_child(startTimer)
	startTimer.start()

func timerInit():
	intialized=true
	setStateIdle()
	startTimer.queue_free()
	

func _on_attack_timer_timeout():
	canAttack=true

func checkIfPlayerInSight():
	var ourPosition = global_transform.origin+Vector3.UP
	var playerPosition = player.global_transform.origin
	var parameters = PhysicsRayQueryParameters3D.create(ourPosition,playerPosition,4294967295,[self])
	var spaceState = get_world_3d().get_direct_space_state()
	var result = spaceState.intersect_ray(parameters)
	if result.has("collider") and result.collider == player:
		return true
	return false

func inAttackRange():
	return global_transform.origin.distance_to(player.global_transform.origin) < attackRange

func faceDirection(direction):
	graphics.rotation.y = atan2(direction.x,direction.z)
	projectileSpawner.look_at(player.global_transform.origin,Vector3.UP)


func startAttack():
	canAttack=false
	attackTimer.start()
	if(currentAttackType==ATTACKTYPE.DAYATTACK):
		projectileSpawner.spawnDayTimeProjectile()
	else:
		projectileSpawner.spawnNightTimeProjectile()
	

#DayNight
func setDayTime():
	attackRange=attackRangeDay
	currentAttackType=ATTACKTYPE.DAYATTACK
	currentAttackTime=attackTimeDay
	attackTimer.set_wait_time(currentAttackTime)

func setNightTime():
	attackRange=attackRangeNight
	currentAttackType=ATTACKTYPE.NIGHTATTACK
	currentAttackTime=attackTimeNight
	attackTimer.set_wait_time(currentAttackTime)

#Process
func _physics_process(delta):
	if(dead || !intialized):
		return
	match currentState:
		STATES.IDLE:
			processStatIdle(delta)
		STATES.CHASE:
			ProcessStateChase(delta)
		STATES.ATTACK:
			ProcessStateAttack(delta)
		STATES.DEAD:
			ProcessStateDead(delta)

#States processes
func processStatIdle(delta):
	if checkIfPlayerInSight():
		setStateChase()
	graphics.playIdleAnimation()
func ProcessStateChase(delta):
	if inAttackRange() and checkIfPlayerInSight():
		setStateAttack()
	var playerPosition = player.global_transform.origin
	var ourPosition = global_transform.origin
	var facedirection = ourPosition.direction_to(playerPosition)
	navigationAgent.set_target_position(playerPosition)
	var goalPosition = navigationAgent.get_next_path_position()
	var direction = goalPosition - ourPosition
	direction.y = 0
	movementManager.setMovementVector(direction)
	faceDirection(facedirection)
	if(previousPosition==position):
		currentJump=currentJump+1
	else:
		currentJump=0
		previousPosition=position
	if(currentJump==jumpThreshold):
		movementManager.jump()
	graphics.playMoveAnimation()

func ProcessStateAttack(delta):
	graphics.playAttackAnimation()
	movementManager.setMovementVector(Vector3.ZERO)
	if canAttack:
		if !inAttackRange() or !checkIfPlayerInSight():
			setStateChase()
		else:
			startAttack()
	var playerPosition = player.global_transform.origin
	var ourPosition = global_transform.origin
	var facedirection = ourPosition.direction_to(playerPosition)
	faceDirection(facedirection)


func ProcessStateDead(delta):
	movementManager.setMovementVector(Vector3.ZERO)

#States setters
func setStateIdle():
	currentState=STATES.IDLE
func setStateChase():
	currentState=STATES.CHASE
func setStateAttack():
	currentState=STATES.ATTACK
func setStateDead():
	currentState=STATES.DEAD

func hurt(damage):
	healthManager.hurt(damage)

func _on_health_manager_signal_dead():
	movementManager.setMovementVector(Vector3.ZERO)
	dead=true
	setStateDead()
	get_tree().call_group("ReactToDeath","reportEnemyKilled")
	graphics.playDieAnimation()
