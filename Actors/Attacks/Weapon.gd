extends Node3D

@export var unlocked = false
@onready var projectile_spawner : Node3D = $ProjectileSpawner

@export var automatic = false
var bodies_to_exclude : Array = []

@export var ammo = 30
@export var shotcost = 1

@export var attack_rate_day = 0.2
@export var attack_rate_night = 0.2
@export var unlockedSouls = 0
var current_attack_rate=0.2
var attack_timer : Timer
var can_attack = true
@export var WeaponName = ""
signal fired
signal out_of_ammo

@export var nightTimeMelee=false

func _ready():
	attack_timer = Timer.new()
	attack_timer.wait_time = current_attack_rate
	attack_timer.connect("timeout",finish_attack)
	attack_timer.one_shot = true
	add_child(attack_timer)
	

func init(_bodies_to_exclude:Array):
	bodies_to_exclude = _bodies_to_exclude
	

func attack(attack_input_just_pressed:bool,attack_input_held:bool,is_day:bool):
	if !can_attack:
		return
	if automatic and !attack_input_held:
		return
	elif !automatic and !attack_input_just_pressed:
		return
	
	if ammo < shotcost:
		if attack_input_just_pressed:
			emit_signal("out_of_ammo")
		return
	
	if ammo >= shotcost:
		ammo -= shotcost
	
	if(is_day):
		projectile_spawner.spawnDayTimeProjectile()
	else:
		if(nightTimeMelee):
			$AnimationPlayer.play("melee")
		projectile_spawner.spawnNightTimeProjectile()
	
	#anim_player.stop()
	#anim_player.play("attack")
	emit_signal("fired")
	can_attack = false
	attack_timer.start()

func finish_attack():
	can_attack = true

func set_active():
	show()
	#$Crosshair.show()

func set_inactive():
	#anim_player.play("idle")
	hide()
	#$Crosshair.hide()

func is_idle():
	pass

func setDayTime():
	current_attack_rate=attack_rate_day
	attack_timer.wait_time = current_attack_rate

func setNightTime():
	current_attack_rate=attack_rate_night
	attack_timer.wait_time = current_attack_rate
