extends CharacterBody3D

@export var hitPuff : Resource = null
@export var speed = 1
@export var damage = 1
@export var lifeTime = 1

@onready var LifeTimeTimer = $LifeTimeTimer
@onready var Graphics = $Graphics
@onready var collisionShape = $CollisionShape3D #will not exist in default projectile class
var puffSpawned = false

func _ready():
	LifeTimeTimer.wait_time=lifeTime
	LifeTimeTimer.start()
	hide()

func _physics_process(delta):
	var collision : KinematicCollision3D = move_and_collide(-global_transform.basis.z * speed * delta)
	if collision != null && collision.get_collider() != null:
		var collider = collision.get_collider()
		if collider.has_method("hurt"):
			print("hurting!")
			print(collider)
			collider.hurt(damage)
		if(hitPuff != null and !puffSpawned):
			spawnHitPuff()
		queue_free()

func _on_life_time_timer_timeout():
	queue_free()

func spawnHitPuff():
	if puffSpawned:
		return
	puffSpawned = true
	speed = 0
	collisionShape.disabled = true
	var instance = hitPuff.instantiate()
	get_tree().get_root().add_child(instance)
	instance.global_transform.origin = global_transform.origin
	$Graphics.hide()


func _on_show_timer_timeout():
	show()
