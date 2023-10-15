extends CharacterBody3D

@onready var movementManager = $MovementManager
@onready var healthManager = $HealthManager
@onready var navigationAgent:NavigationAgent3D = $NavigationAgent3D
@onready var attackTimer = $AttackTimer

enum STATES {IDLE,CHASE,ATTACK,DEAD}
var currentState = STATES.IDLE
enum ATTACKTYPE {MELEE,RANGED}
var currentAttackType
var canAttack = false

var player = null

var attackRangeMelee = 0.1#day
var attackRangeRanged = 2#night
var attackRange

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	var sun = get_tree().get_nodes_in_group("Sun")[0]
	if(sun.currentState==0):#day
		attackRange=attackRangeMelee
		currentAttackType=ATTACKTYPE.MELEE
	else:
		attackRange=attackRangeRanged
		currentAttackType=ATTACKTYPE.RANGED
	movementManager.setBody(self)
	setStateIdle()


func _on_attack_timer_timeout():
	canAttack=true

func checkIfPlayerInSight():
	var ourPosition = global_transform.origin+Vector3.UP
	var playerPosition = player.global_transform.origin
	var parameters = PhysicsRayQueryParameters3D.create(ourPosition,playerPosition,1,[self])
	var spaceState = get_world_3d().get_direct_space_state()
	var result = spaceState.intersect_ray(parameters)
	if result.collider == player:
		return true
	return false

func inAttackRange():
	return global_transform.origin.distance_to(player.global_transform.origin) < attackRange

#DayNight
func setDayTime():
	attackRange=attackRangeMelee
	currentAttackType=ATTACKTYPE.MELEE

func setNightTime():
	attackRange=attackRangeRanged
	currentAttackType=ATTACKTYPE.RANGED

#Process
func _physics_process(delta):
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
	pass
func ProcessStateChase(delta):
	if inAttackRange() and checkIfPlayerInSight():
		setStateAttack()
	var playerPosition = player.global_transform.origin
	var ourPosition = global_transform.origin
	var facedirection = ourPosition.direction_to(playerPosition)
	navigationAgent.set_target_position(playerPosition)
	var goalPosition = navigationAgent.get_target_position()
	var direction = goalPosition - ourPosition
	direction.y = 0
	movementManager.setMovementVector(direction)
	#FaceDirection(Facedir,delta)

func ProcessStateAttack(delta):
	pass
func ProcessStateDead(delta):
	pass

#States setters
func setStateIdle():
	currentState=STATES.IDLE
func setStateChase():
	currentState=STATES.CHASE
func setStateAttack():
	currentState=STATES.ATTACK
func setStateDead():
	currentState=STATES.DEAD

