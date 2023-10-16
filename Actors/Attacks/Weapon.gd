extends Node3D

@onready var anim_player = $AnimationPlayer
@onready var projectile_emitter : Node3D = $ProjectileEmitter

@export var automatic = false

var fire_point : Node3D
var bodies_to_exclude : Array = []

@export var damage = 5
@export var ammo = 30
@export var shotcost = 1

@export var attack_rate = 0.2
var attack_timer : Timer
var can_attack = true

signal fired
signal out_of_ammo

func _ready():
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_rate
	attack_timer.connect("timeout",finish_attack)
	attack_timer.one_shot = true
	add_child(attack_timer)
	

func init(_fire_point: Node3D,_bodies_to_exclude:Array):
	fire_point = _fire_point
	bodies_to_exclude = _bodies_to_exclude
	

func attack(attack_input_just_pressed:bool,attack_input_held:bool):
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
	
	#TODO: Do day/nighttime
	#projectile_emitter.fireProjectile()
	
	anim_player.stop()
	anim_player.play("attack")
	emit_signal("fired")
	can_attack = false
	attack_timer.start()

func finish_attack():
	can_attack = true

func set_active():
	show()
	$Crosshair.show()

func set_inactive():
	anim_player.play("idle")
	hide()
	$Crosshair.hide()

func is_idle():
	return !anim_player.is_playing() or anim_player.current_animation == "idle"
